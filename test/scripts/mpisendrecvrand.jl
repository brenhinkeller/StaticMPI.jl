using StaticCompiler, StaticTools, StaticMPI, MPICH_jll
libpath = joinpath(first(splitdir(MPICH_jll.PATH[])), "lib")

# Function to compile
function mpisendrecvrand(argc, argv)
    MPI_Init(argc, argv) == MPI_SUCCESS || error(c"MPI failed to initialize\n")

    comm = MPI_COMM_WORLD
    world_size, world_rank = MPI_Comm_size(comm), MPI_Comm_rank(comm)
    nworkers = world_size - 1

    if world_rank == 0
        buffer = mfill(0.0, nworkers)
        requests = mfill(MPI_REQUEST_NULL, nworkers)
        for i ∈ 1:nworkers
            MPI_Irecv(buffer[i:i], i, 10, MPI_COMM_WORLD, requests[i:i])
            # Note that this [i:i] syntax only works because contiguous indexing
            # of `StaticTools.MallocArray`s returns a view
        end
        MPI_Waitall(requests)
        printf((c"Rank 0 recieved:\n", buffer, c"\n"))
        printdlm(c"results.csv", buffer)
        free(requests), free(buffer)
    else
        rng = BoxMuller(world_rank)

        # Best to use malloc'd things when Sending (or esp. Isend-ing),
        # to ensure they won't get unwound before send happens
        x = mfill(randn(rng))
        printf((c"Rank ", world_rank, c", sending ", x[], c"\n"))
        MPI_Send(x, 0, 10, comm)
        free(x)
    end
    MPI_Finalize()
end

# Compile it to binary executable
compile_executable(mpisendrecvrand, (Int, Ptr{Ptr{UInt8}}), "./";
    cflags=`-lm -lmpi -L$libpath -Wl,-rpath,$libpath`
    # -lm is for the libc math library (which is automatically included on mac but not linux)
    # -lmpi is for libmpi
    # -L$libpath tells the compiler about the path to libmpi
    # -Wl,-rpath,$libpath tells the linker about the path to libmpi (not needed on all systems)
)
