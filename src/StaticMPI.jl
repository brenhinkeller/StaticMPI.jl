module StaticMPI

    using StaticTools
    const Buffer{T} = Union{AbstractArray{T}, Ref{T}}

    include("mpich.jl")
    export Mpich
    using .Mpich
    export MPI_COMM_WORLD, MPI_COMM_SELF, MPI_COMM_NULL, MPI_REQUEST_NULL,
    MPI_STATUS_NULL, MPI_MESSAGE_NULL, MPI_FILE_NULL, MPI_DATATYPE_NULL,
    MPI_OP_NULL, MPI_MAX, MPI_MIN, MPI_SUM, MPI_PROD, MPI_LAND, MPI_BAND,
    MPI_LOR, MPI_BOR, MPI_LXOR, MPI_BXOR, MPI_MINLOC, MPI_MAXLOC,
    MPI_REPLACE, MPI_NO_OP
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
    @inline function MPI_Init()
        c,v = Base.RefValue(0), Base.RefValue(C_NULL)
        Mpich.MPI_Init(⅋(c), ⅋(v))::Int
    end
    @inline function MPI_Init(argc::Int, argv::Ptr{Ptr{UInt8}})
        c,v = Base.RefValue(argc), Base.RefValue(argv)
        Mpich.MPI_Init(⅋(c), ⅋(v))::Int32
    end
    export MPI_Init

    """
    ```julia
    MPI_Finalize()
    ```
    Conclude the execution of the calling mpi task.
    """
    @inline MPI_Finalize() = Mpich.MPI_Finalize()::Int32
    export MPI_Finalize

    # """
    # ```julia
    # mpi_comm_world(implementation=OpenMPI())
    # ```
    # Obtain an MPI communicator that includes all available MPI tasks. Since the
    # format of MPI communicators is implementation-dependent, you should specify
    # which MPI implementation you are using (either `:MPICH` or `:OpenMPI`)
    # """
    # @inline mpi_comm_world() = MPI_COMM_WORLD
    # @inline mpi_comm_world(x::Symbol) = Val(x)
    # @inline mpi_comm_world(::Val{:MPICH}) = MPI_COMM_WORLD
    # @inline mpi_comm_world(::Val{:OpenMPI}) = @externptr ompi_mpi_comm_world::Ptr{UInt8}
    # export mpi_comm_world

    """
    ```julia
    MPI_Comm_size(comm)
    ```
    Obtain the number of tasks in the specified MPI communicator `comm`.
    """
    # @inline function MPI_Comm_size(comm::Ptr{Ptr{UInt8}}) #OpenMPI
    #     _comm_size = Base.RefValue(0)
    #     @symbolcall MPI_Comm_size(comm::Ptr{Ptr{UInt8}}, ⅋(_comm_size)::Ptr{Int64})::Int32
    #     return _comm_size[]::Int
    # end
    @inline function MPI_Comm_size(comm::Mpich.MPI_Comm) #MPICH
        _comm_size = Base.RefValue(Int32(0))
        Mpich.MPI_Comm_size(comm, ⅋(_comm_size))
        return _comm_size[]::Int32
    end
    export MPI_Comm_size

    """
    ```julia
    MPI_Comm_size(comm)
    ```
    Obtain the rank of the calling MPI task within the specified MPI
    communicator `comm`
    """
    # @inline function MPI_Comm_rank(comm::Ptr{Ptr{UInt8}}) #OpenMPI
    #     _comm_rank = Base.RefValue(0)
    #     @symbolcall MPI_Comm_rank(comm::Ptr{Ptr{UInt8}}, ⅋(_comm_rank)::Ptr{Int64})::Int32
    #     return _comm_rank[]::Int
    # end
    @inline function MPI_Comm_rank(comm::Mpich.MPI_Comm) #MPICH
        _comm_rank = Base.RefValue(Int32(0))
        Mpich.MPI_Comm_rank(comm, ⅋(_comm_rank))
        return _comm_rank[]::Int32
    end
    export MPI_Comm_rank


    @inline function MPI_Recv(buffer::Buffer{T}, source, tag, comm::Mpich.MPI_Comm) where T
        _status = Base.RefValue(MPI_STATUS_NULL)
        bufptr = Ptr{Nothing}(⅋(buffer))
        Mpich.MPI_Recv(bufptr, length(buffer)%Int32, Mpich.mpitype(T), source, tag, comm, ⅋(_status))
        _status[]::Mpich.MPI_Status
    end
    export MPI_Recv

    @inline function MPI_Irecv(buffer::Buffer{T}, source, tag, comm::Mpich.MPI_Comm) where T
        _request = Base.RefValue(MPI_REQUEST_NULL)
        bufptr = Ptr{Nothing}(⅋(buffer))
        Mpich.MPI_Irecv(bufptr, length(buffer)%Int32, Mpich.mpitype(T), source, tag, comm, ⅋(_request))::Int32
    end
    @inline function MPI_Irecv(buffer::Buffer{T}, source, tag, comm::Mpich.MPI_Comm, request::Buffer{Mpich.MPI_Request}) where T
        bufptr = Ptr{Nothing}(⅋(buffer))
        Mpich.MPI_Irecv(bufptr, length(buffer)%Int32, Mpich.mpitype(T), source, tag, comm, ⅋(request))::Int32
    end
    export MPI_Irecv

    @inline function MPI_Send(buffer::Buffer{T}, dest, tag, comm::Mpich.MPI_Comm) where T
        bufptr = Ptr{Nothing}(⅋(buffer))
        Mpich.MPI_Send(bufptr, length(buffer)%Int32, Mpich.mpitype(T), dest, tag, comm)::Int32
    end
    export MPI_Send

    @inline function MPI_Isend(buffer::Buffer{T}, dest, tag, comm::Mpich.MPI_Comm) where T
        _request = Base.RefValue(MPI_REQUEST_NULL)
        bufptr = Ptr{Nothing}(⅋(buffer))
        Mpich.MPI_Isend(bufptr, length(buffer)%Int32, Mpich.mpitype(T), dest, tag, comm, ⅋(_request))::Int32
    end
    @inline function MPI_Isend(buffer::Buffer{T}, dest, tag, comm::Mpich.MPI_Comm, request::Buffer{Mpich.MPI_Request}) where T
        bufptr = Ptr{Nothing}(⅋(buffer))
        Mpich.MPI_Isend(bufptr, length(buffer)%Int32, Mpich.mpitype(T), dest, tag, comm, ⅋(request))::Int32
    end
    export MPI_Isend

    @inline MPI_Barrier(comm::Mpich.MPI_Comm) = Mpich.MPI_Barrier(comm::Mpich.MPI_Comm)
    export MPI_Barrier

    @inline function MPI_Wait(request::Mpich.MPI_Request)
        _request, _status = Base.RefValue(request), Base.RefValue(MPI_STATUS_NULL)
        MPI_Wait(⅋(_request), ⅋(_status))
        _status[]::Mpich.MPI_Status
    end
    export MPI_Wait

    @inline function MPI_Waitany(requests::Buffer{Mpich.MPI_Request})
        _index, _status = Base.RefValue(zero(Int32)), Base.RefValue(MPI_STATUS_NULL)
        MPI_Waitany(length(requests)%Int32, ⅋(requests), ⅋(_index), ⅋(_status))
        _index[]::Int32
    end
    @inline function MPI_Waitany(requests::Buffer{Mpich.MPI_Request}, status)
        _index = Base.RefValue(zero(Int32))
        MPI_Waitany(length(requests)%Int32, ⅋(requests), ⅋(_index), ⅋(status))
        _index[]::Int32
    end
    export MPI_Waitany

    @inline function MPI_Waitall(requests::Buffer{Mpich.MPI_Request})
        statuses = mfill(MPI_STATUS_NULL, length(requests))
        MPI_Waitall(length(requests)%Int32, ⅋(requests), ⅋(statuses))
        free(statuses)::Int32
    end
    @inline function MPI_Waitall(requests::Buffer{Mpich.MPI_Request}, statuses)
        MPI_Waitall(length(requests)%Int32, ⅋(requests), ⅋(statuses))::Int32
    end
    export MPI_Waitall

end # module
