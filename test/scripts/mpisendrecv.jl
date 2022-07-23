using StaticCompiler, StaticTools, StaticMPI, MPICH_jll
libpath = joinpath(first(splitdir(MPICH_jll.PATH[])), "lib")

function mpisendrecv(argc, argv)
 	status = MPI_Init(argc, argv)
	if status != MPI_SUCCESS
		printf(c"ERROR: MPI failed to initialize")
	end

    comm = MPI_COMM_WORLD
    world_size, world_rank = MPI_Comm_size(comm), MPI_Comm_rank(comm)
    nworkers = world_size - 1

    if world_rank == 0
		buffer = mfill(0.0, nworkers)
		requests = mfill(MPI_REQUEST_NULL, nworkers)
		for i ∈ 1:nworkers
			MPI_Irecv(buffer[i:i], i, 10, MPI_COMM_WORLD, requests[i:i])
		end
		MPI_Waitall(requests)

		printf((c"Rank 0 recieved:\n", buffer, c"\n"))
		fp = fopen(c"results.csv", c"w")
		printf(fp, buffer)
		fclose(fp)

		free(requests), free(buffer)
    else
		rng = BoxMuller(world_rank)

		# Best to use malloc'd things when Sending (or esp. Isend-ing),
		# to ensure they won't get unwound before send happens
		x = mfill(randn(rng))
		printf((c"rank ", world_rank, c", generated, ", x[], c"\n"))
		MPI_Send(x, 0, 10, comm)
		free(x)
    end
    MPI_Finalize()
end

## ---
compile_executable(mpisendrecv, (Int, Ptr{Ptr{UInt8}}), "./";
    cflags=`-lm -lmpi -L$libpath -Wl,-rpath,$libpath`
)
