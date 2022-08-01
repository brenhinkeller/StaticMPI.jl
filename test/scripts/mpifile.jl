using StaticCompiler, StaticTools, StaticMPI, MPICH_jll
libpath = joinpath(first(splitdir(MPICH_jll.PATH[])), "lib")

# Function to compile
function mpifile(argc, argv)
    MPI_Init(argc, argv) == MPI_SUCCESS || error(c"MPI failed to initialize\n")

    comm = MPI_COMM_WORLD
    world_size, world_rank = MPI_Comm_size(comm), MPI_Comm_rank(comm)

    printf((c"About to write from ", world_rank, c" of ", world_size, c" processors!\n"))

    # Ensure file(s) exist
    world_rank == 0 && fclose(fopen(c"./results0.b", c"w"))
    world_rank == 1 && fclose(fopen(c"./results1.b", c"w"))
    world_rank == 2 && fclose(fopen(c"./results2.b", c"w"))
    MPI_Barrier(comm)

    # Write from each process (blocking, collective)
    fp = MPI_File_open(comm, c"./results0.b", MPI_MODE_RDWR)
    mfill(0x30+(world_rank % UInt8), 4) do data
        MPI_File_write_at_all(fp, world_rank*sizeof(data), data)
        MPI_Barrier(comm)
    end

    # Read what we've written (blocking, collective)
    buf = mzeros(UInt8, 4)
    MPI_File_read_at_all(fp, world_rank*sizeof(buf), buf)
    MPI_File_close(fp)

    # Write to second file (nonblocking)
    fp1 = MPI_File_open(comm, c"./results1.b", MPI_MODE_RDWR)
    request = MPI_File_iwrite_at(fp1, world_rank*sizeof(buf), buf)
    # Read what we've written (nonblocking)
    buf2 = mzeros(UInt8, 4)
    MPI_File_iread_at(fp1, world_rank*sizeof(buf2), buf2)
    MPI_File_close(fp1)
    usleep(10*world_rank)
    printf(buf2')
    free(buf2)

    MPI_Barrier(comm)
    MPI_Finalize()
end

# Compile it to binary executable
compile_executable(mpifile, (Int, Ptr{Ptr{UInt8}}), "./";
    cflags=`-lm -lmpi -L$libpath -Wl,-rpath,$libpath`
    # -lmpi is for libmpi
    # -L$libpath tells the compiler about the path to libmpi
    # -Wl,-rpath,$libpath tells the linker about the path to libmpi (not needed on all systems)
)
