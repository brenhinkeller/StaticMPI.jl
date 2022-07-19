using StaticCompiler, StaticTools, StaticMPI, OpenMPI_jll
libpath = joinpath(first(splitdir(OpenMPI_jll.PATH[])), "lib")

function mpihello_openmpi(argc, argv)
    MPI_Init(argc, argv)

    comm = mpi_comm_world(OpenMPI)
    world_size, world_rank = MPI_Comm_size(comm), MPI_Comm_rank(comm)

    printf((c"Hello from ", world_rank, c" of ", world_size, c" processors!\n"))
    MPI_Finalize()
end

compile_executable(mpihello_openmpi, (Int, Ptr{Ptr{UInt8}}), "./";
    cflags=`-lmpi -L$libpath -Wl,-rpath,$libpath`
)
