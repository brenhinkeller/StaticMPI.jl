using StaticCompiler, StaticTools, StaticMPI, MPICH_jll
libpath = joinpath(first(splitdir(MPICH_jll.PATH[])), "lib")

function mpisendrecv(argc, argv)
 	status = MPI_Init(argc, argv)
	if status != MPI_SUCCESS
		printf(c"ERROR: MPI failed to initialize")::Int32
	end

    comm = MPI_COMM_WORLD
    world_size = MPI_Comm_size(comm)
	world_rank = MPI_Comm_rank(comm)
	nworkers = world_size-1

    if world_rank == zero(Int32)
		buffer = mfill(0.0, nworkers)
		requests = mfill(MPI_REQUEST_NULL, nworkers)
		i = 0
		while i < nworkers
			i += 1
			MPI_Irecv(buffer[i:i], i, 0, MPI_COMM_WORLD, requests[i:i])
		end
		statuses = MallocArray{StaticMPI.Mpich.MPI_Status,1}(undef, nworkers)
		index = MPI_Waitall(requests, statuses)
		printf((c"Rank 0 recieved", buffer, c"\n"))
		free(statuses)
		free(requests)
		free(buffer)
    else
		rng = BoxMuller(world_rank % Int64)
		x = randn(rng)
		MPI_Isend(Ref(x), 0, 0, comm)
		printf((c"rank ", world_rank, c", generated, ", x, c"\n"))
    end
    MPI_Finalize()
	return 0
end

## ---
compile_executable(mpisendrecv, (Int, Ptr{Ptr{UInt8}}), "./";
    cflags=`-lmpi -L$libpath -Wl,-rpath,$libpath`
)
