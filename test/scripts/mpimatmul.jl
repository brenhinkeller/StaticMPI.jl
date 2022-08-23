using StaticCompiler, StaticTools, MPICH_jll
using StaticMPI
using LoopVectorization
libpath = joinpath(first(splitdir(MPICH_jll.PATH[])), "lib")

# This is not actually a practical/fast matmul,
# just a way to test inter-process communication
function mpimatmul(argc, argv)
	# Start MPI
	if MPI_Init(argc, argv) != MPI_SUCCESS
		printf(c"Error initializing MPI. Terminating.\n")
		# MPI_Abort(MPI_COMM_WORLD, rc)
	end

	# Get world size (number of MPI processes) and world rank (# of this process)
	world_size = MPI_Comm_size(MPI_COMM_WORLD)
	world_rank = MPI_Comm_rank(MPI_COMM_WORLD)
	nworkers = world_size - 1

	rows, cols = argparse(Int, argv, 2), argparse(Int, argv, 3)
	A, B, C = mones(rows,cols), mones(cols,rows), mzeros(rows,rows)
	ntasks = size(A, 1)

	if (world_rank == 0)
		# Some variables used only on the root node
		wrs = mfill(0, nworkers)
		statuses = mfill(MPI_STATUS_NULL, nworkers)
		requests = mfill(MPI_REQUEST_NULL, nworkers)

		# Listen for task requests from the worker nodes
		for i = 1:nworkers
			MPI_Irecv(wrs[i:i], i, 0, MPI_COMM_WORLD, requests[i:i])
		end

		nr = 0
		block = Ref(0)
		status = Ref(MPI_STATUS_NULL)
		# Once any worker asks for a new task, send next task to that worker and keep listening
		while block[] < ntasks
			block[] += 1
			nr = MPI_Waitany(requests, status) + 1 # Returns rank of next ready task
			# printf((c"block ", block[], c"just recieved, nr =", nr, c"\n"))
			MPI_Send(block, nr, 1, MPI_COMM_WORLD) # Tell them to work on `block`
			MPI_Irecv(C[:, block[]], nr, 0, MPI_COMM_WORLD, requests[nr:nr]) # Get results for column `block`
			# MPI_Irecv(wrs[nr:nr], nr, 0, MPI_COMM_WORLD, requests[nr:nr])
		end

		# Wait for all workers to complete, then send the stop signal
		MPI_Waitall(requests, statuses)
		block[]=-1
		for i = 1:nworkers
			MPI_Isend(block, i, 1, MPI_COMM_WORLD, requests[i:i])
		end

		printf(C)
		printdlm(c"results.csv", C, ',')
		MPI_Waitall(requests, statuses)

	else
		# Some variables used only on the worker nodes
		block = Ref(0)
		wr = Ref(world_rank)
		status = Ref(MPI_STATUS_NULL)
		request = Ref(MPI_REQUEST_NULL)
		MPI_Isend(wr, 0, 0, MPI_COMM_WORLD, request)

		buffer = MallocArray{eltype(A)}(undef, size(A,2))
		result = MallocArray{eltype(A)}(undef, size(B,2))

		while true
			# Ask root node for new task

			# printf((c"Sending request from rank ", wr[], c"\n"))
			MPI_Recv(block, 0, 1, MPI_COMM_WORLD, status)
			row = block[]
			# printf((c"Task recieved at rank ", wr[], c"\n"))

			# Exit loop if stop signal recieved
			(row < 0) && break

			# Do work
			@turbo for i ∈ 1:size(A, 2)
				buffer[i] = A[row, i]
			end
			@turbo for j = 1:size(B,2)
				Crowj = zero(eltype(A))
				for i = 1:size(A,2)
					Crowj += buffer[i] * B[i,j]
				end
				result[j] = Crowj
			end

			MPI_Isend(result, 0, 0, MPI_COMM_WORLD, request)
		end
		free(buffer), free(result)
		MPI_Wait(request, status)
	end
	free(A), free(B), free(C)
	MPI_Finalize()
end

compile_executable(mpimatmul, (Int, Ptr{Ptr{UInt8}}), "./",
	cflags = `-lm -lmpi -L$libpath -Wl,-rpath,$libpath`
)
