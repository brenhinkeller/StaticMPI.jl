using StaticCompiler, StaticTools, StaticMPI, MPICH_jll
libpath = joinpath(first(splitdir(MPICH_jll.PATH[])), "lib")

function mpisendrecv(argc::Int, argv::Ptr{Ptr{UInt8}})
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
		i = zero(Int32)
		while i < nworkers
			i += one(Int32)
			bview = buffer[i:i]
			rview = requests[i:i]
			MPI_Irecv(bview, i, zero(Int32), MPI_COMM_WORLD, rview)
		end
		statuses = mfill(MPI_STATUS_NULL, nworkers)
		MPI_Waitall(requests, statuses)
		printf((c"Rank 0 recieved:\n", buffer, c"\n"))
		free(statuses)
		free(requests)
		free(buffer)
    else
		rng = BoxMuller(world_rank % Int64)
		x = randn(rng)
		_x = Base.RefValue(x)
		MPI_Isend(_x, zero(Int32), zero(Int32), comm)
		printf((c"rank ", world_rank, c", generated, ", x, c"\n"))
    end
    return MPI_Finalize()
end

argc = 2
argv = pointer([pointer([0x35, 0x00]), pointer([0x35, 0x00])])

## ---
compile_executable(mpisendrecv, (Int, Ptr{Ptr{UInt8}}), "./";
    cflags=`-lmpi -L$libpath -Wl,-rpath,$libpath`
)
