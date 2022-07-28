using StaticCompiler, StaticTools, StaticMPI, MPICH_jll
libpath = joinpath(first(splitdir(MPICH_jll.PATH[])), "lib")

# Function to compile
function mpifile(argc, argv)
    MPI_Init(argc, argv) == MPI_SUCCESS || error(c"MPI failed to initialize\n")

    comm = MPI_COMM_WORLD
    world_size, world_rank = MPI_Comm_size(comm), MPI_Comm_rank(comm)

    printf((c"About to write from ", world_rank, c" of ", world_size, c" processors!\n"))

    world_rank == 0 && fclose(fopen(c"./results.b", c"w"))
    fp = MPI_File_open(comm, c"./results.b", MPI_MODE_RDWR)

    mfill(0x30+(world_rank % UInt8), 4) do data
        MPI_File_write_at_all(fp, world_rank*sizeof(data), data)
    end

    MPI_File_close(fp)
    MPI_Barrier(comm)
    MPI_Finalize()
end

# Compile it to binary executable
compile_executable(mpifile, (Int, Ptr{Ptr{UInt8}}), "./";
    cflags=`-lmpi -L$libpath -Wl,-rpath,$libpath`
    # -lmpi is for libmpi
    # -L$libpath tells the compiler about the path to libmpi
    # -Wl,-rpath,$libpath tells the linker about the path to libmpi (not needed on all systems)
)
