using StaticCompiler, StaticTools, StaticMPI, MPICH_jll
libpath = joinpath(first(splitdir(MPICH_jll.PATH[])), "lib")

# Function to compile
function scattergatherbcast(argc, argv)
    MPI_Init(argc, argv) == MPI_SUCCESS || error(c"MPI failed to initialize\n")

    comm = MPI_COMM_WORLD
    world_size, world_rank = MPI_Comm_size(comm), MPI_Comm_rank(comm)

    buf = mzeros(5)
    world_rank==0 && (buf .= 10.)
    MPI_Bcast(buf, 0, comm)
    # world_rank==1 && printdlm(c"results0.tsv", buf)
    name = c"results.1.0.b"
    name[11] += world_rank % UInt8
    write(name, buf)

    # recvbuf = mzeros(5)
    # world_rank==0 && (buf .= 100.)
    # rc = MPI_Scatter(buf, recvbuf, 0, comm)
    # printf(rc)
    # # MPI_Wait(request)
    # name = c"results.2.0.tsv"
    # name[11] += world_rank % UInt8
    # printdlm(name, recvbuf)

    buf .= 11.
    gatherbuf = mzeros(5 * world_size)
    MPI_Gather(buf, gatherbuf, 0, comm)
    if world_rank == 0
        name = c"results.3.0.b"
        write(name, gatherbuf)
    end
    free(gatherbuf)
    # free(recvbuf)
    free(buf)

    MPI_Finalize()
end

# Compile it to binary executable
compile_executable(scattergatherbcast, (Int, Ptr{Ptr{UInt8}}), "./";
    cflags=`-lmpi -L$libpath -Wl,-rpath,$libpath`
    # -lmpi is for libmpi
    # -L$libpath tells the compiler about the path to libmpi
    # -Wl,-rpath,$libpath tells the linker about the path to libmpi (not needed on all systems)
)
