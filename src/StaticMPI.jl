module StaticMPI

    using StaticTools
    const Buffer{T} = Union{AbstractArray{T}, Ref{T}}

    include("mpich.jl")
    export Mpich
    using .Mpich
    # Defined instances of MPI types
    export MPI_COMM_WORLD, MPI_COMM_SELF, MPI_COMM_NULL, MPI_REQUEST_NULL,
    MPI_STATUS_NULL, MPI_MESSAGE_NULL, MPI_FILE_NULL, MPI_DATATYPE_NULL,
    MPI_OP_NULL, MPI_MAX, MPI_MIN, MPI_SUM, MPI_PROD, MPI_LAND, MPI_BAND,
    MPI_LOR, MPI_BOR, MPI_LXOR, MPI_BXOR, MPI_MINLOC, MPI_MAXLOC,
    MPI_REPLACE, MPI_NO_OP
    # Status codes and flags
    export MPI_THREAD_SINGLE, MPI_THREAD_FUNNELED, MPI_THREAD_SERIALIZED,
    MPI_THREAD_MULTIPLE, MPI_IDENT, MPI_CONGRUENT, MPI_SIMILAR, MPI_UNEQUAL,
    MPI_MODE_RDONLY, MPI_MODE_RDWR, MPI_MODE_WRONLY, MPI_MODE_CREATE, MPI_MODE_EXCL,
    MPI_MODE_DELETE_ON_CLOSE, MPI_MODE_UNIQUE_OPEN, MPI_MODE_APPEND,
    MPI_MODE_SEQUENTIAL, MPI_SEEK_SET, MPI_SEEK_CUR, MPI_SEEK_END, MPI_SUCCESS


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
    @inline MPI_Init() = MPI_Init(0, ⅋(Ref(Ptr{UInt8}(C_NULL))))
    @inline function MPI_Init(argc::Int, argv::Ptr{Ptr{UInt8}})
        c,v = Base.RefValue(argc), Base.RefValue(argv)
        Mpich.MPI_Init(⅋(c), ⅋(v))
    end
    export MPI_Init

    """
    ```julia
    MPI_Finalize()
    ```
    Conclude the execution of the calling MPI task.
    """
    @inline MPI_Finalize() = Mpich.MPI_Finalize()
    export MPI_Finalize

    """
    ```julia
    MPI_Comm_size(comm)
    ```
    Obtain the number of tasks in the specified MPI communicator `comm`.
    """
    @inline function MPI_Comm_size(comm::Mpich.MPI_Comm) #MPICH
        comm_size = Base.RefValue(0)
        Mpich.MPI_Comm_size(comm, ⅋(comm_size))
        return comm_size[]
    end
    export MPI_Comm_size

    """
    ```julia
    MPI_Comm_rank(comm)
    ```
    Obtain the rank of the calling MPI task within the specified MPI
    communicator `comm`
    """
    @inline function MPI_Comm_rank(comm::Mpich.MPI_Comm) #MPICH
        comm_rank = Base.RefValue(0)
        Mpich.MPI_Comm_rank(comm, ⅋(comm_rank))
        return comm_rank[]
    end
    export MPI_Comm_rank


    @inline function MPI_Recv(buffer, source, tag, comm::Mpich.MPI_Comm)
        status = Base.RefValue(MPI_STATUS_NULL)
        MPI_Recv(buffer, source, tag, comm, status)
    end
    @inline function MPI_Recv(buffer::Buffer{T}, source, tag, comm::Mpich.MPI_Comm, status) where T
        bufptr = Ptr{Nothing}(⅋(buffer))
        Mpich.MPI_Recv(bufptr, length(buffer), Mpich.mpitype(T), source, tag, comm, ⅋(status))
    end
    export MPI_Recv

    @inline function MPI_Irecv(buffer, source, tag, comm::Mpich.MPI_Comm)
        request = Base.RefValue(MPI_REQUEST_NULL)
        MPI_Irecv(buffer, source, tag, comm, request)
    end
    @inline function MPI_Irecv(buffer::Buffer{T}, source, tag, comm::Mpich.MPI_Comm, request::Buffer{Mpich.MPI_Request}) where T
        bufptr = Ptr{Nothing}(⅋(buffer))
        Mpich.MPI_Irecv(bufptr, length(buffer), Mpich.mpitype(T), source, tag, comm, ⅋(request))
    end
    export MPI_Irecv

    @inline function MPI_Send(buffer::Buffer{T}, dest, tag, comm::Mpich.MPI_Comm) where T
        bufptr = Ptr{Nothing}(⅋(buffer))
        Mpich.MPI_Send(bufptr, length(buffer), Mpich.mpitype(T), dest, tag, comm)
    end
    export MPI_Send

    @inline function MPI_Isend(buffer, dest, tag, comm::Mpich.MPI_Comm)
        request = Base.RefValue(MPI_REQUEST_NULL)
        Mpich.MPI_Isend(buffer, dest, tag, comm, request)
    end
    @inline function MPI_Isend(buffer::Buffer{T}, dest, tag, comm::Mpich.MPI_Comm, request::Buffer{Mpich.MPI_Request}) where T
        bufptr = Ptr{Nothing}(⅋(buffer))
        Mpich.MPI_Isend(bufptr, length(buffer), Mpich.mpitype(T), dest, tag, comm, ⅋(request))
    end
    export MPI_Isend


    @inline MPI_Barrier(comm::Mpich.MPI_Comm) = Mpich.MPI_Barrier(comm)
    export MPI_Barrier

    @inline MPI_Wait(request, status::Buffer{Mpich.MPI_Status}) = Mpich.MPI_Wait(⅋(request), ⅋(status))
    @inline function MPI_Wait(request::Mpich.MPI_Request)
        status = Base.RefValue(MPI_STATUS_NULL)
        MPI_Wait(Base.RefValue(request), status)
    end
    export MPI_Wait

    @inline function MPI_Waitany(requests)
        statuses = Base.RefValue(MPI_STATUS_NULL)
        MPI_Waitany(requests, statuses)
    end
    @inline function MPI_Waitany(requests, statuses)
        index = Base.RefValue(0)
        Mpich.MPI_Waitany(length(requests), ⅋(requests), ⅋(index), ⅋(statuses))
        index[]
    end
    export MPI_Waitany

    @inline function MPI_Waitall(requests)
        statuses = mfill(MPI_STATUS_NULL, length(requests))
        rc = MPI_Waitall(requests, statuses)
        free(statuses); rc
    end
    @inline MPI_Waitall(requests, statuses) = Mpich.MPI_Waitall(length(requests), ⅋(requests), ⅋(statuses))
    export MPI_Waitall

end # module
