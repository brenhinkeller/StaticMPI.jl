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
    export MPI_COMM_NULL, MPI_COMM_WORLD, MPI_COMM_SELF, MPI_GROUP_NULL, MPI_GROUP_EMPTY,
    MPI_WIN_NULL, MPI_FILE_NULL, MPI_REQUEST_NULL, MPI_MESSAGE_NULL, MPI_MESSAGE_NO_PROC,
    MPI_DATATYPE_NULL, MPI_CHAR, MPI_SIGNED_CHAR, MPI_UNSIGNED_CHAR, MPI_BYTE, MPI_WCHAR,
    MPI_SHORT, MPI_UNSIGNED_SHORT, MPI_INT, MPI_UNSIGNED, MPI_LONG, MPI_UNSIGNED_LONG,
    MPI_FLOAT, MPI_DOUBLE, MPI_LONG_DOUBLE, MPI_LONG_LONG_INT, MPI_UNSIGNED_LONG_LONG,
    MPI_LONG_LONG, MPI_PACKED, MPI_LB, MPI_UB, MPI_FLOAT_INT, MPI_DOUBLE_INT, MPI_LONG_INT,
    MPI_SHORT_INT, MPI_2INT, MPI_LONG_DOUBLE_INT, MPI_REAL4, MPI_REAL8, MPI_REAL16,
    MPI_COMPLEX8, MPI_COMPLEX16, MPI_COMPLEX32, MPI_INTEGER1, MPI_INTEGER2, MPI_INTEGER4,
    MPI_INTEGER8, MPI_INTEGER16, MPI_INT8_T, MPI_INT16_T, MPI_INT32_T, MPI_INT64_T,
    MPI_UINT8_T, MPI_UINT16_T, MPI_UINT32_T, MPI_UINT64_T, MPI_C_BOOL, MPI_C_FLOAT_COMPLEX,
    MPI_C_COMPLEX, MPI_C_DOUBLE_COMPLEX, MPI_C_LONG_DOUBLE_COMPLEX, MPIX_C_FLOAT16, 
    MPI_AINT, MPI_OFFSET, MPI_COUNT, MPI_OP_NULL, MPI_MAX, MPI_MIN, MPI_SUM, MPI_PROD,
    MPI_LAND, MPI_BAND, MPI_LOR, MPI_BOR, MPI_LXOR, MPI_BXOR, MPI_MINLOC, MPI_MAXLOC,
    MPI_REPLACE, MPI_NO_OP

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
        @symbolcall MPI_Init(⅋(c)::Ptr{Int}, ⅋(v)::Ptr{Ptr{Ptr{UInt8}}})::Int32
    end

    """
    ```julia
    MPI_Finalize()
    ```
    Conclude the execution of the calling mpi task.
    """
    @inline MPI_Finalize() = @symbolcall MPI_Finalize()::Int32

    """
    ```julia
    mpi_comm_world(implementation=OpenMPI())
    ```
    Obtain an MPI communicator that includes all available MPI tasks. Since the
    format of MPI communicators is implementation-dependent, you should specify
    which MPI implementation you are using (either `MPICH()` or `OpenMPI()`)
    """
    @inline mpi_comm_world() = mpi_comm_world(OpenMPI())
    @inline mpi_comm_world(::OpenMPI) = @externptr ompi_mpi_comm_world::Ptr{UInt8}
    @inline mpi_comm_world(::Type{OpenMPI}) = @externptr ompi_mpi_comm_world::Ptr{UInt8}
    @inline mpi_comm_world(::MPICH) = 1140850688 # AKA 0x44000000
    @inline mpi_comm_world(::Type{MPICH}) = 1140850688 # AKA 0x44000000
    const MPI_COMM_WORLD = mpi_comm_world

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
    @inline function MPI_Comm_size(comm::Int64) #MPICH
        comm_size = Ref(0)
        @symbolcall MPI_Comm_size(comm::Int64, ⅋(comm_size)::Ptr{Int64})::Int32
        return comm_size[]
    end

    """
    ```julia
    MPI_Comm_size(comm)
    ```
    Obtain the rank of the calling MPI task within the specified MPI
    communicator `COMM`
    """
    @inline function MPI_Comm_rank(comm::Ptr{Ptr{UInt8}}) #OpenMPI
        comm_rank = Ref(0)
        @symbolcall MPI_Comm_rank(comm::Ptr{Ptr{UInt8}}, ⅋(comm_rank)::Ptr{Int64})::Int32
        return comm_rank[]
    end
    @inline function MPI_Comm_rank(comm::Int64) #MPICH
        comm_rank = Ref(0)
        @symbolcall MPI_Comm_rank(comm::Int64, ⅋(comm_rank)::Ptr{Int64})::Int32
        return comm_rank[]
    end

end
