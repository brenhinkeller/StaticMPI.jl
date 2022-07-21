module StaticMPI

    using StaticTools

    export MPI_Init, MPI_Finalize
    export mpi_comm_world
    export MPI_Comm_size, MPI_Comm_rank
    export MPICH, OpenMPI

    struct MPICH end
    struct OpenMPI end

    include("mpich.jl")
    export Mpich
    using .Mpich
    export MPI_COMM_WORLD, MPI_COMM_SELF, MPI_FILE_NULL, MPI_REQUEST_NULL, MPI_MESSAGE_NULL,
    MPI_DATATYPE_NULL, MPI_CHAR, MPI_SIGNED_CHAR, MPI_UNSIGNED_CHAR, MPI_BYTE, MPI_SHORT,
    MPI_UNSIGNED_SHORT, MPI_INT, MPI_UNSIGNED, MPI_LONG, MPI_UNSIGNED_LONG,
    MPI_FLOAT, MPI_DOUBLE, MPI_LONG_DOUBLE, MPI_LONG_LONG_INT, MPI_UNSIGNED_LONG_LONG,
    MPI_LONG_LONG, MPI_PACKED, MPI_LB, MPI_UB, MPI_AINT, MPI_OFFSET, MPI_COUNT,
    MPI_OP_NULL, MPI_MAX, MPI_MIN, MPI_SUM, MPI_PROD, MPI_LAND, MPI_BAND, MPI_LOR,
    MPI_BOR, MPI_LXOR, MPI_BXOR, MPI_MINLOC, MPI_MAXLOC, MPI_REPLACE, MPI_NO_OP
    export MPI_THREAD_SINGLE, MPI_THREAD_FUNNELED, MPI_THREAD_SERIALIZED,
    MPI_THREAD_MULTIPLE, MPI_IDENT, MPI_CONGRUENT, MPI_SIMILAR, MPI_UNEQUAL,
    MPI_SUCCESS


    """
    ```julia
    MPI_Init()
    MPI_Init(argc::Int, argv::Ptr{Ptr{UInt8}})
    ```
    Initialize the execution environment of the calling MPI task for single-
    threaded execution. The optional arguments `argc` and `argv` are the
    traditional argument count and argument value pointer variables passed to a
    compiled executable by the operating system.

    Returns `MPI_SUCCESS` on success
    """
    @inline function MPI_Init(argc::Int=0, argv::Ptr{Ptr{UInt8}}=Ptr{Ptr{UInt8}}(C_NULL))
        c,v = Ref(argc), Ref(argv)
        Mpich.MPI_Init(⅋(c), ⅋(v))
    end

    """
    ```julia
    MPI_Finalize()
    ```
    Conclude the execution of the calling mpi task.
    """
    @inline MPI_Finalize() = Mpich.MPI_Finalize()

    """
    ```julia
    mpi_comm_world(implementation=OpenMPI())
    ```
    Obtain an MPI communicator that includes all available MPI tasks. Since the
    format of MPI communicators is implementation-dependent, you should specify
    which MPI implementation you are using (either `:MPICH` or `:OpenMPI`)
    """
    @inline mpi_comm_world() = MPI_COMM_WORLD
    @inline mpi_comm_world(x::Symbol) = Val(x)
    @inline mpi_comm_world(::Val{:MPICH}) = MPI_COMM_WORLD
    @inline mpi_comm_world(::Val{:OpenMPI}) = @externptr ompi_mpi_comm_world::Ptr{UInt8}

    """
    ```julia
    MPI_Comm_size(comm)
    ```
    Obtain the number of tasks in the specified MPI communicator `comm`.
    """
    @inline function MPI_Comm_size(comm::Ptr{Ptr{UInt8}}) #OpenMPI
        comm_size = Ref(0)
        @symbolcall MPI_Comm_size(comm::Ptr{Ptr{UInt8}}, ⅋(comm_size)::Ptr{Int64})::Int32
        return comm_size[]
    end
    @inline function MPI_Comm_size(comm::Mpich.MPI_Comm) #MPICH
        comm_size = Ref(Int32(0))
        Mpich.MPI_Comm_size(comm, ⅋(comm_size))
        return comm_size[]
    end

    """
    ```julia
    MPI_Comm_size(comm)
    ```
    Obtain the rank of the calling MPI task within the specified MPI
    communicator `comm`
    """
    @inline function MPI_Comm_rank(comm::Ptr{Ptr{UInt8}}) #OpenMPI
        comm_rank = Ref(0)
        @symbolcall MPI_Comm_rank(comm::Ptr{Ptr{UInt8}}, ⅋(comm_rank)::Ptr{Int64})::Int32
        return comm_rank[]
    end
    @inline function MPI_Comm_rank(comm::Mpich.MPI_Comm) #MPICH
        comm_rank = Ref(Int32(0))
        Mpich.MPI_Comm_rank(comm, ⅋(comm_rank))
        return comm_rank[]
    end

end
