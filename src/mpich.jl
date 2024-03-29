#=
   Interface to MPICH libmpi implemented by direct `llvmcall`
=#
module Mpich
using StaticTools

# Defined instances of MPI types
export MPI_COMM_NULL, MPI_COMM_WORLD, MPI_COMM_SELF, MPI_GROUP_NULL, MPI_GROUP_EMPTY,
MPI_WIN_NULL, MPI_FILE_NULL, MPI_REQUEST_NULL, MPI_MESSAGE_NULL, MPI_MESSAGE_NO_PROC,
MPI_INFO_NULL, MPI_INFO_ENV, MPI_STATUS_NULL, MPI_DATATYPE_NULL,
MPI_CHAR, MPI_SIGNED_CHAR, MPI_UNSIGNED_CHAR, MPI_BYTE, MPI_WCHAR, MPI_SHORT,
MPI_UNSIGNED_SHORT, MPI_INT, MPI_UNSIGNED, MPI_LONG, MPI_UNSIGNED_LONG,
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

# Status codes and flags
export MPI_THREAD_SINGLE, MPI_THREAD_FUNNELED, MPI_THREAD_SERIALIZED,
MPI_THREAD_MULTIPLE, MPI_IDENT, MPI_CONGRUENT, MPI_SIMILAR, MPI_UNEQUAL,
MPIX_GPU_SUPPORT_CUDA, MPIX_GPU_SUPPORT_ZE, MPIX_GPU_SUPPORT_HIP,
MPI_MODE_RDONLY, MPI_MODE_RDWR, MPI_MODE_WRONLY, MPI_MODE_CREATE, MPI_MODE_EXCL,
MPI_MODE_DELETE_ON_CLOSE, MPI_MODE_UNIQUE_OPEN, MPI_MODE_APPEND,
MPI_MODE_SEQUENTIAL, MPI_SEEK_SET, MPI_SEEK_CUR, MPI_SEEK_END, MPI_SUCCESS

# Types
# export MPI_Status, MPI_Comm, MPI_Group, MPI_Win, MPI_Win, MPI_File, MPI_Request,
# MPI_Message, MPI_Datatype, MPI_Op, MPI_Errhandler, MPI_Info, MPI_Aint, MPI_Fint,
# MPI_Count, MPIO_Request, MPI_Offset

abstract type AbstractMpichType end

# MPI_Status struct:
struct MPI_Status <: AbstractMpichType
    count_lo::UInt32
    count_hi_and_cancelled::UInt32
    MPI_SOURCE::UInt32
    MPI_TAG::UInt32
    MPI_ERROR::UInt32
end
@inline MPI_Status() = MPI_Status(0,0,0,0,0)
const MPI_STATUS_NULL = MPI_Status()

# Communicators:
struct MPI_Comm <: AbstractMpichType
   x::UInt32
end
const MPI_COMM_NULL  = MPI_Comm(0x04000000)
const MPI_COMM_WORLD = MPI_Comm(0x44000000)
const MPI_COMM_SELF  = MPI_Comm(0x44000001)

# Groups:
struct MPI_Group <: AbstractMpichType
   x::UInt32
end
const MPI_GROUP_NULL  = MPI_Group(0x08000000)
const MPI_GROUP_EMPTY = MPI_Group(0x48000000)

# RMA and Windows:
struct MPI_Win <: AbstractMpichType
   x::UInt32
end
const MPI_WIN_NULL = MPI_Win(0x20000000)

# File and IO:
struct MPI_File <: AbstractMpichType
   x::Ptr{UInt8}
end
const MPI_FILE_NULL = MPI_File(0)

# MPI request objects:
struct MPI_Request <: AbstractMpichType
   x::UInt32
end
const MPIO_Request = MPI_Request
const MPI_REQUEST_NULL   = MPI_Request(0x2c000000)

# MPI message objects for Mprobe and related functions:
struct MPI_Message <: AbstractMpichType
   x::UInt32
end
const MPI_MESSAGE_NULL    = MPI_Message(0x2c000000)
const MPI_MESSAGE_NO_PROC = MPI_Message(0x6c000000)

# Data types:
struct MPI_Datatype <: AbstractMpichType
   x::UInt32
end
const MPI_DATATYPE_NULL  = MPI_Datatype(0x0c000000)
const MPI_CHAR           = MPI_Datatype(0x4c000101)
const MPI_SIGNED_CHAR    = MPI_Datatype(0x4c000118)
const MPI_UNSIGNED_CHAR  = MPI_Datatype(0x4c000102)
const MPI_BYTE           = MPI_Datatype(0x4c00010d)
const MPI_WCHAR          = MPI_Datatype(0x4c00040e)
const MPI_SHORT          = MPI_Datatype(0x4c000203)
const MPI_UNSIGNED_SHORT = MPI_Datatype(0x4c000204)
const MPI_INT            = MPI_Datatype(0x4c000405)
const MPI_UNSIGNED       = MPI_Datatype(0x4c000406)
const MPI_LONG           = MPI_Datatype(0x4c000807)
const MPI_UNSIGNED_LONG  = MPI_Datatype(0x4c000808)
const MPI_FLOAT          = MPI_Datatype(0x4c00040a)
const MPI_DOUBLE         = MPI_Datatype(0x4c00080b)
const MPI_LONG_DOUBLE    = MPI_Datatype(0x4c00100c)
const MPI_LONG_LONG_INT  = MPI_Datatype(0x4c000809)
const MPI_UNSIGNED_LONG_LONG = MPI_Datatype(0x4c000819)
const MPI_LONG_LONG      = MPI_LONG_LONG_INT
const MPI_PACKED         = MPI_Datatype(0x4c00010f)
const MPI_LB             = MPI_Datatype(0x4c000010)
const MPI_UB             = MPI_Datatype(0x4c000011)
const MPI_FLOAT_INT         = MPI_Datatype(0x8c000000)
const MPI_DOUBLE_INT        = MPI_Datatype(0x8c000001)
const MPI_LONG_INT          = MPI_Datatype(0x8c000002)
const MPI_SHORT_INT         = MPI_Datatype(0x8c000003)
const MPI_2INT              = MPI_Datatype(0x4c000816)
const MPI_LONG_DOUBLE_INT   = MPI_Datatype(0x8c000004)
# Size-specific types (see MPI-2, 10.2.5):
const MPI_REAL4             = MPI_Datatype(0x4c000427)
const MPI_REAL8             = MPI_Datatype(0x4c000829)
const MPI_REAL16            = MPI_Datatype(0x4c00102b)
const MPI_COMPLEX8          = MPI_Datatype(0x4c000828)
const MPI_COMPLEX16         = MPI_Datatype(0x4c00102a)
const MPI_COMPLEX32         = MPI_Datatype(0x4c00202c)
const MPI_INTEGER1          = MPI_Datatype(0x4c00012d)
const MPI_INTEGER2          = MPI_Datatype(0x4c00022f)
const MPI_INTEGER4          = MPI_Datatype(0x4c000430)
const MPI_INTEGER8          = MPI_Datatype(0x4c000831)
const MPI_INTEGER16         = MPI_Datatype(MPI_DATATYPE_NULL.x)
# C99 fixed-width datatypes:
const MPI_INT8_T            = MPI_Datatype(0x4c000137)
const MPI_INT16_T           = MPI_Datatype(0x4c000238)
const MPI_INT32_T           = MPI_Datatype(0x4c000439)
const MPI_INT64_T           = MPI_Datatype(0x4c00083a)
const MPI_UINT8_T           = MPI_Datatype(0x4c00013b)
const MPI_UINT16_T          = MPI_Datatype(0x4c00023c)
const MPI_UINT32_T          = MPI_Datatype(0x4c00043d)
const MPI_UINT64_T          = MPI_Datatype(0x4c00083e)
# other C99 types:
const MPI_C_BOOL                 = MPI_Datatype(0x4c00013f)
const MPI_C_FLOAT_COMPLEX        = MPI_Datatype(0x4c000840)
const MPI_C_COMPLEX              = MPI_C_FLOAT_COMPLEX
const MPI_C_DOUBLE_COMPLEX       = MPI_Datatype(0x4c001041)
const MPI_C_LONG_DOUBLE_COMPLEX  = MPI_Datatype(0x4c002042)
const MPIX_C_FLOAT16             = MPI_Datatype(0x4c000246)
# address/offset types:
const MPI_AINT          = MPI_Datatype(0x4c000843)
const MPI_OFFSET        = MPI_Datatype(0x4c000844)
const MPI_COUNT         = MPI_Datatype(0x4c000845)

# Collective operations:
struct MPI_Op <: AbstractMpichType
   x::UInt32
end
const MPI_OP_NULL = MPI_Op(0x18000000)
const MPI_MAX     = MPI_Op(0x58000001)
const MPI_MIN     = MPI_Op(0x58000002)
const MPI_SUM     = MPI_Op(0x58000003)
const MPI_PROD    = MPI_Op(0x58000004)
const MPI_LAND    = MPI_Op(0x58000005)
const MPI_BAND    = MPI_Op(0x58000006)
const MPI_LOR     = MPI_Op(0x58000007)
const MPI_BOR     = MPI_Op(0x58000008)
const MPI_LXOR    = MPI_Op(0x58000009)
const MPI_BXOR    = MPI_Op(0x5800000a)
const MPI_MINLOC  = MPI_Op(0x5800000b)
const MPI_MAXLOC  = MPI_Op(0x5800000c)
const MPI_REPLACE = MPI_Op(0x5800000d)
const MPI_NO_OP   = MPI_Op(0x5800000e)

# Built-in error handler objects:
struct MPI_Errhandler <: AbstractMpichType
   x::UInt32
end
const MPI_ERRHANDLER_NULL = MPI_Errhandler(0x14000000)
const MPI_ERRORS_ARE_FATAL = MPI_Errhandler(0x54000000)
const MPI_ERRORS_RETURN    = MPI_Errhandler(0x54000001)
const MPIR_ERRORS_THROW_EXCEPTIONS = MPI_Errhandler(0x54000002)

# Info
struct MPI_Info <: AbstractMpichType
   x::UInt32
end
const MPI_INFO_NULL        = MPI_Info(0x1c000000)
const MPI_INFO_ENV         = MPI_Info(0x5c000001)
const MPI_MAX_INFO_KEY     =  255
const MPI_MAX_INFO_VAL     = 1024

# Other types
struct MPI_Aint <: AbstractMpichType
   x::UInt32
end
struct MPI_Fint <: AbstractMpichType
   x::UInt32
end
struct MPI_Count <: AbstractMpichType
   x::Int64
end
const MPI_Offset = Int64


# Various constants:
const MPI_TAG_UB           = 0x64400001
const MPI_HOST             = 0x64400003
const MPI_IO               = 0x64400005
const MPI_WTIME_IS_GLOBAL  = 0x64400007
const MPI_UNIVERSE_SIZE    = 0x64400009
const MPI_LASTUSEDCODE     = 0x6440000b
const MPI_APPNUM           = 0x6440000d
const MPI_UNDEFINED        = (-32766)
const MPI_KEYVAL_INVALID   = 0x24000000
# Window attributes:
const MPI_WIN_BASE          = 0x66000001
const MPI_WIN_SIZE          = 0x66000003
const MPI_WIN_DISP_UNIT     = 0x66000005
const MPI_WIN_CREATE_FLAVOR = 0x66000007
const MPI_WIN_MODEL         = 0x66000009

# Thread levels:
const MPI_THREAD_SINGLE     = 0
const MPI_THREAD_FUNNELED   = 1
const MPI_THREAD_SERIALIZED = 2
const MPI_THREAD_MULTIPLE   = 3

# Results of the compare operations:
const MPI_IDENT     = 0
const MPI_CONGRUENT = 1
const MPI_SIMILAR   = 2
const MPI_UNEQUAL   = 3

# Success and error codes:
const MPI_SUCCESS         =  0      #= Successful return code =#
const MPI_ERR_BUFFER      =  1      #= Invalid buffer pointer =#
const MPI_ERR_COUNT       =  2      #= Invalid count argument =#
const MPI_ERR_TYPE        =  3      #= Invalid datatype argument =#
const MPI_ERR_TAG         =  4      #= Invalid tag argument =#
const MPI_ERR_COMM        =  5      #= Invalid communicator =#
const MPI_ERR_RANK        =  6      #= Invalid rank =#
const MPI_ERR_ROOT        =  7      #= Invalid root =#
const MPI_ERR_GROUP       =  8      #= Invalid group =#
const MPI_ERR_OP          =  9      #= Invalid operation =#
const MPI_ERR_TOPOLOGY    = 10      #= Invalid topology =#
const MPI_ERR_DIMS        = 11      #= Invalid dimension argument =#
const MPI_ERR_ARG         = 12      #= Invalid argument =#
const MPI_ERR_UNKNOWN     = 13      #= Unknown error =#
const MPI_ERR_TRUNCATE    = 14      #= Message truncated on receive =#
const MPI_ERR_OTHER       = 15      #= Other error; use Error_string =#
const MPI_ERR_INTERN      = 16      #= internal error code    =#
const MPI_ERR_IN_STATUS   = 17      #= Look in status for error value =#
const MPI_ERR_PENDING     = 18      #= Pending request =#
const MPI_ERR_REQUEST     = 19      #= Invalid mpi_request handle =#

# File IO codes:
const MPI_MODE_RDONLY           =   2
const MPI_MODE_RDWR             =   8
const MPI_MODE_WRONLY           =   4
const MPI_MODE_CREATE           =   1
const MPI_MODE_EXCL             =  64
const MPI_MODE_DELETE_ON_CLOSE  =  16
const MPI_MODE_UNIQUE_OPEN      =  32
const MPI_MODE_APPEND           = 128
const MPI_MODE_SEQUENTIAL       = 256
const MPI_SEEK_SET	           = 600
const MPI_SEEK_CUR	           = 602
const MPI_SEEK_END	           = 604

# Convert Julia types to equivalent MPI types
# Can extend for custom datatypes
mpitype(::Type{Bool}) = MPI_C_BOOL
mpitype(::Type{Int8}) = MPI_INT8_T
mpitype(::Type{UInt8}) = MPI_UINT8_T
mpitype(::Type{Int16}) = MPI_INT16_T
mpitype(::Type{UInt16}) = MPI_UINT16_T
mpitype(::Type{Int32}) = MPI_INT32_T
mpitype(::Type{UInt32}) = MPI_UINT32_T
mpitype(::Type{Int64}) = MPI_INT64_T
mpitype(::Type{UInt64}) = MPI_UINT64_T
mpitype(::Type{Float16}) = MPI_UINT16_T
mpitype(::Type{Float32}) = MPI_FLOAT
mpitype(::Type{Float64}) = MPI_DOUBLE
export mpitype

# Functions
# Initialize and finalize
@inline MPI_Init(argc::Ptr{Int}, argv::Ptr{Ptr{Ptr{UInt8}}}) = @symbolcall MPI_Init(argc::Ptr{Int}, argv::Ptr{Ptr{Ptr{UInt8}}})::Int32
@inline MPI_Finalize() = @symbolcall MPI_Finalize()::Int32
@inline MPI_Initialized(flag::Ptr{Int32}) = @symbolcall MPI_Initialized(flag::Ptr{Int32})::Int32
@inline MPI_Abort(comm::MPI_Comm, errorcode::Int32) = @symbolcall MPI_Abort(comm.x::UInt32, errorcode::Int32)::Int32
@inline MPI_Finalized(flag::Ptr{Int32}) = @symbolcall MPI_Free_mem(ptr::Ptr{Nothing})::Int32

# MPI Communicators
@inline MPI_Comm_size(comm::MPI_Comm, size::Ptr{Int32}) = @symbolcall MPI_Comm_size(comm.x::UInt32, size::Ptr{Int32})::Int32
@inline MPI_Comm_rank(comm::MPI_Comm, size::Ptr{Int32}) = @symbolcall MPI_Comm_rank(comm.x::UInt32, size::Ptr{Int32})::Int32
@inline MPI_Comm_compare(comm1::MPI_Comm, comm2::MPI_Comm, result::Ptr{Int32}) = @symbolcall MPI_Comm_compare(comm1.x::UInt32, comm2.x::UInt32, result::Ptr{Int32})::Int32
@inline MPI_Comm_dup(comm::MPI_Comm, newcomm::Ptr{MPI_Comm}) = @symbolcall MPI_Comm_dup(comm.x::UInt32, newcomm::Ptr{MPI_Comm})::Int32
@inline MPI_Comm_dup_with_info(comm::MPI_Comm, info::MPI_Info, newcomm::Ptr{MPI_Comm}) = @symbolcall MPI_Comm_dup_with_info(comm.x::UInt32, info.x::UInt32, newcomm::Ptr{MPI_Comm})::Int32
@inline MPI_Comm_create(comm::MPI_Comm, group::MPI_Group, newcomm::Ptr{MPI_Comm}) = @symbolcall MPI_Comm_create(comm.x::UInt32, group.x::UInt32, newcomm::Ptr{MPI_Comm})::Int32
@inline MPI_Comm_split(comm::MPI_Comm, color::Int32, key::Int32, newcomm::Ptr{MPI_Comm}) = @symbolcall MPI_Comm_split(comm.x::UInt32, color::Int32, key::Int32, newcomm::Ptr{MPI_Comm})::Int32
@inline MPI_Comm_free(comm::Ptr{MPI_Comm}) = @symbolcall MPI_Comm_free(comm::Ptr{MPI_Comm})::Int32
@inline MPI_Comm_test_inter(comm::MPI_Comm, flag::Ptr{Int32}) = @symbolcall MPI_Comm_test_inter(comm.x::UInt32, flag::Ptr{Int32})::Int32
@inline MPI_Comm_remote_size(comm::MPI_Comm, size::Ptr{Int32}) = @symbolcall MPI_Comm_remote_size(comm.x::UInt32, size::Ptr{Int32})::Int32
@inline MPI_Comm_remote_group(comm::MPI_Comm, group::Ptr{MPI_Group}) = @symbolcall MPI_Comm_remote_group(comm.x::UInt32, group::Ptr{MPI_Group})::Int32
@inline MPI_Comm_split_type(comm::MPI_Comm, split_type::Int32, key::Int32, info::MPI_Info, newcomm::Ptr{MPI_Comm}) =
   @symbolcall MPI_Comm_split_type(comm.x::UInt32, split_type::Int32, key::Int32, info.x::UInt32, newcomm::Ptr{MPI_Comm})::Int32
@inline MPI_Intercomm_create(local_comm::MPI_Comm, local_leader::Int32, peer_comm::MPI_Comm, remote_leader::Int32, tag::Int32, newintercomm::Ptr{MPI_Comm}) =
   @symbolcall MPI_Intercomm_create(local_comm.x::UInt32, local_leader::Int32, peer_comm.x::UInt32, remote_leader::Int32, tag::Int32, newintercomm::Ptr{MPI_Comm})::Int32
@inline MPI_Intercomm_merge(intercomm::MPI_Comm, high::Int32, newintracomm::Ptr{MPI_Comm}) = @symbolcall MPI_Intercomm_merge(intercomm.x::UInt32, high::Int32, newintracomm::Ptr{MPI_Comm})::Int32

# MPI Groups
@inline MPI_Group_size(group::MPI_Group, size::Ptr{Int32}) = @symbolcall MPI_Group_size(group.x::UInt32, size::Ptr{Int32})::Int32
@inline MPI_Group_rank(group::MPI_Group, rank::Ptr{Int32}) = @symbolcall MPI_Group_rank(group.x::UInt32, rank::Ptr{Int32})::Int32
@inline MPI_Group_translate_ranks(group1::MPI_Group, n::Int32, ranks1::Ptr{Int32}, group2::MPI_Group, ranks2::Ptr{Int32}) =
   @symbolcall MPI_Group_translate_ranks(group1.x::UInt32, n::Int32, ranks1::Ptr{Int32}, group2.x::UInt32, ranks2::Ptr{Int32})::Int32
@inline MPI_Group_compare(group1::MPI_Group, group2::MPI_Group, result::Ptr{Int32}) = @symbolcall MPI_Group_compare(group1.x::UInt32, group2.x::UInt32, result::Ptr{Int32})::Int32
@inline MPI_Comm_group(comm::MPI_Comm, group::Ptr{MPI_Group}) = @symbolcall MPI_Group_compare(group1.x::UInt32, group2.x::UInt32, result::Ptr{Int32})::Int32
@inline MPI_Group_union(group1::MPI_Group, group2::MPI_Group, newgroup::Ptr{MPI_Group}) = @symbolcall MPI_Group_union(group1.x::UInt32, group2.x::UInt32, newgroup::Ptr{MPI_Group})::Int32
@inline MPI_Group_intersection(group1::MPI_Group, group2::MPI_Group, newgroup::Ptr{MPI_Group}) = @symbolcall MPI_Group_intersection(group1.x::UInt32, group2.x::UInt32, newgroup::Ptr{MPI_Group})::Int32
@inline MPI_Group_difference(group1::MPI_Group, group2::MPI_Group, newgroup::Ptr{MPI_Group}) = @symbolcall MPI_Group_difference(group1.x::UInt32, group2.x::UInt32, newgroup::Ptr{MPI_Group})::Int32
@inline MPI_Group_incl(group::MPI_Group, n::Int32, ranks::Ptr{Int32}, newgroup::Ptr{MPI_Group}) = @symbolcall MPI_Group_incl(group.x::UInt32, n::Int32, ranks::Ptr{Int32}, newgroup::Ptr{MPI_Group})::Int32
@inline MPI_Group_excl(group::MPI_Group, n::Int32, ranks::Ptr{Int32}, newgroup::Ptr{MPI_Group}) = @symbolcall MPI_Group_excl(group.x::UInt32, n::Int32, ranks::Ptr{Int32}, newgroup::Ptr{MPI_Group})::Int32
@inline MPI_Group_range_incl(group::MPI_Group, n::Int32, ranges::Ptr{Int32}, newgroup::Ptr{MPI_Group}) = @symbolcall MPI_Group_range_incl(group.x::UInt32, n::Int32, ranges::Ptr{Int32}, newgroup::Ptr{MPI_Group})::Int32
@inline MPI_Group_range_excl(group::MPI_Group, n::Int32, ranges::Ptr{Int32}, newgroup::Ptr{MPI_Group}) = @symbolcall MPI_Group_range_excl(group.x::UInt32, n::Int32, ranges::Ptr{Int32}, newgroup::Ptr{MPI_Group})::Int32
@inline MPI_Group_free(group::Ptr{MPI_Group}) = @symbolcall MPI_Group_free(group::Ptr{MPI_Group})::Int32

# Send and recieve
@inline MPI_Recv( buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, source::Int32, tag::Int32, comm::MPI_Comm, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Recv(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, source::Int32, tag::Int32, comm.x::UInt32, status::Ptr{MPI_Status})::Int32
@inline MPI_Irecv(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, source::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Irecv(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, source::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32

@inline MPI_Get_count(status::Ptr{MPI_Status}, datatype::MPI_Datatype, count::Ptr{Int32}) =
   @symbolcall MPI_Get_count(status::Ptr{MPI_Status}, datatype.x::UInt32, count::Ptr{Int32})::Int32

@inline MPI_Send( buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Send( buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32)::Int32
@inline MPI_Bsend(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Bsend(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32)::Int32
@inline MPI_Ssend(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Ssend(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32)::Int32
@inline MPI_Rsend(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Rsend(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32)::Int32
@inline MPI_Isend( buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Isend( buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ibsend(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ibsend(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Issend(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Issend(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Irsend(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Irsend(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32

@inline MPI_Sendrecv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype, dest::Int32,
   sendtag::Int32, recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, source::Int32,
   recvtag::Int32, comm::MPI_Comm, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Sendrecv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32, dest::Int32,
      sendtag::Int32, recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, source::Int32,
      recvtag::Int32, comm.x::UInt32, status::Ptr{MPI_Status})::Int32
@inline MPI_Sendrecv_replace(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype,
   dest::Int32, sendtag::Int32, source::Int32, recvtag::Int32, comm::MPI_Comm,
   status::Ptr{MPI_Status}) =
   @symbolcall MPI_Sendrecv_replace(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32,
      dest::Int32, sendtag::Int32, source::Int32, recvtag::Int32, comm.x::UInt32,
      status::Ptr{MPI_Status})::Int32

@inline MPI_Send_init(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Send_init(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Bsend_init(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Bsend_init(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ssend_init(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ssend_init(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Rsend_init(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, dest::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Rsend_init(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, dest::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Recv_init(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, source::Int32, tag::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Recv_init(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, source::Int32, tag::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32

@inline MPI_Start(request::Ptr{MPI_Request}) =
   @symbolcall MPI_Start(request::Ptr{MPI_Request})::Int32
@inline MPI_Startall(count::Int32, array_of_requests::Ptr{MPI_Request}) =
   @symbolcall MPI_Startall(count::Int32, array_of_requests::Ptr{MPI_Request})::Int32

@inline MPI_Scan(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm) =
   @symbolcall MPI_Scan(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, op.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Exscan(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm) =
   @symbolcall MPI_Exscan(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, op.x::UInt32, comm.x::UInt32)::Int32

@inline MPI_Reduce(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, op::MPI_Op, root::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Reduce(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, op.x::UInt32, root::Int32, comm.x::UInt32)::Int32
@inline MPI_Allreduce(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm) =
   @symbolcall MPI_Allreduce(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, op.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Reduce_scatter(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm) =
   @symbolcall MPI_Reduce_scatter(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, datatype.x::UInt32, op.x::UInt32, comm.x::UInt32)::Int32

@inline MPI_Bcast(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, root::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Bcast(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, root::Int32, comm.x::UInt32)::Int32

@inline MPI_Scatter(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, root::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Scatter(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, root::Int32, comm.x::UInt32)::Int32
@inline MPI_Scatterv(sendbuf::Ptr{Nothing}, sendcounts::Ptr{Int32}, displs::Ptr{Int32}, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, root::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Scatterv(sendbuf::Ptr{Nothing}, sendcounts::Ptr{Int32}, displs::Ptr{Int32},sendtype.x::UInt32,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, root::Int32, comm.x::UInt32)::Int32

@inline MPI_Gather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, root::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Gather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, root::Int32, comm.x::UInt32)::Int32
@inline MPI_Gatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcounts::Ptr{Int32}, displs::Ptr{Int32}, recvtype::MPI_Datatype,
   root::Int32, comm::MPI_Comm) =
   @symbolcall MPI_Gatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcounts::Ptr{Int32}, displs::Ptr{Int32}, recvtype.x::UInt32,
      root::Int32, comm.x::UInt32)::Int32

@inline MPI_Allgather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, comm::MPI_Comm) =
   @symbolcall MPI_Allgather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Allgatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcounts::Ptr{Int32}, displs::Ptr{Int32}, recvtype::MPI_Datatype, comm::MPI_Comm) =
   @symbolcall MPI_Allgatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcounts::Ptr{Int32}, displs::Ptr{Int32}, recvtype.x::UInt32, comm.x::UInt32)::Int32

@inline MPI_Alltoall(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing},recvcount::Int32, recvtype::MPI_Datatype, comm::MPI_Comm) =
   @symbolcall MPI_Alltoall(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing},recvcount::Int32, recvtype.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Alltoallv(sendbuf::Ptr{Nothing}, sendcounts::Ptr{Int32}, sdispls::Ptr{Int32}, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcounts::Ptr{Int32}, rdispls::Ptr{Int32}, recvtype::MPI_Datatype, comm::MPI_Comm) =
   @symbolcall MPI_Alltoallv(sendbuf::Ptr{Nothing}, sendcounts::Ptr{Int32}, sdispls::Ptr{Int32}, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcounts::Ptr{Int32}, rdispls::Ptr{Int32}, recvtype.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Alltoallw(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtypes::Ptr{MPI_Datatype},
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtypes::Ptr{MPI_Datatype}, comm::MPI_Comm) =
   @symbolcall MPI_Alltoallw(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtypes::Ptr{MPI_Datatype},
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtypes::Ptr{MPI_Datatype}, comm.x::UInt32)::Int32

@inline MPI_Reduce_local(inbuf::Ptr{Nothing}, inoutbuf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, op::MPI_Op) =
   @symbolcall  MPI_Reduce_local(inbuf::Ptr{Nothing}, inoutbuf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, op.x::UInt32)::Int32
@inline MPI_Op_commutative(op::MPI_Op, commute::Ptr{Int32}) = @symbolcall MPI_Op_commutative(op.x::UInt32, commute::Ptr{Int32})::Int32
@inline MPI_Reduce_scatter_block(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, recvcount::Int32, datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm) =
   @symbolcall MPI_Reduce_scatter_block(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, recvcount::Int32, datatype.x::UInt32, op.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Dist_graph_create_adjacent(comm_old::MPI_Comm, indegree::Int32, sources::Ptr{Int32}, sourceweights::Ptr{Int32},
   outdegree::Int32, destinations::Ptr{Int32}, destweights::Ptr{Int32}, info::MPI_Info, reorder::Int32, comm_dist_graph::Ptr{MPI_Comm}) =
   @symbolcall  MPI_Dist_graph_create_adjacent(comm_old.x::UInt32, indegree::Int32, sources::Ptr{Int32}, sourceweights::Ptr{Int32},
      outdegree::Int32, destinations::Ptr{Int32}, destweights::Ptr{Int32}, info.x::UInt32, reorder::Int32, comm_dist_graph::Ptr{MPI_Comm})::Int32
@inline MPI_Dist_graph_create(comm_old::MPI_Comm, n::Int32, sources::Ptr{Int32}, degrees::Ptr{Int32},
   destinations::Ptr{Int32}, weights::Ptr{Int32}, info::MPI_Info, reorder::Int32, comm_dist_graph::Ptr{MPI_Comm}) =
   @symbolcall  MPI_Dist_graph_create(comm_old.x::UInt32, n::Int32, sources::Ptr{Int32}, degrees::Ptr{Int32},
      destinations::Ptr{Int32}, weights::Ptr{Int32}, info.x::UInt32, reorder::Int32, comm_dist_graph::Ptr{MPI_Comm})::Int32
@inline MPI_Dist_graph_neighbors_count(comm::MPI_Comm, indegree::Ptr{Int32}, outdegree::Ptr{Int32}, weighted::Ptr{Int32}) =
   @symbolcall MPI_Dist_graph_neighbors_count(comm.x::UInt32, indegree::Ptr{Int32}, outdegree::Ptr{Int32}, weighted::Ptr{Int32})::Int32
@inline MPI_Dist_graph_neighbors(comm::MPI_Comm, maxindegree::Int32, sources::Ptr{Int32},
   sourceweights::Ptr{Int32}, maxoutdegree::Int32, destinations::Ptr{Int32}, destweights::Ptr{Int32}) =
   @symbolcall @inline MPI_Dist_graph_neighbors(comm::MPI_Comm, maxindegree::Int32, sources::Ptr{Int32},
      sourceweights::Ptr{Int32}, maxoutdegree::Int32, destinations::Ptr{Int32}, destweights::Ptr{Int32})::Int32

# Synchronization: wait until request[s] completed
@inline MPI_Barrier(comm::MPI_Comm) = @symbolcall MPI_Barrier(comm.x::UInt32)::Int32
@inline MPI_Wait(request::Ptr{MPI_Request}, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Wait(request::Ptr{MPI_Request}, status::Ptr{MPI_Status})::Int32
@inline MPI_Waitany(count::Int32, array_of_requests::Ptr{MPI_Request}, index::Ptr{Int32}, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Waitany(count::Int32, array_of_requests::Ptr{MPI_Request}, index::Ptr{Int32}, status::Ptr{MPI_Status})::Int32
@inline MPI_Waitall(count::Int32, array_of_requests::Ptr{MPI_Request}, array_of_statuses::Ptr{MPI_Status}) =
   @symbolcall MPI_Waitall(count::Int32, array_of_requests::Ptr{MPI_Request}, array_of_statuses::Ptr{MPI_Status})::Int32
@inline MPI_Waitsome(incount::Int32, array_of_requests::Ptr{MPI_Request}, outcount::Ptr{Int32}, array_of_indices::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status}) =
   @symbolcall MPI_Waitsome(incount::Int32, array_of_requests::Ptr{MPI_Request}, outcount::Ptr{Int32}, array_of_indices::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status})::Int32
# @inline MPIO_Wait(request::Ptr{MPIO_Request}, status::Ptr{MPI_Status}) =
#    @symbolcall MPIO_Wait(request::Ptr{MPIO_Request}, status::Ptr{MPI_Status})::Int32
# @inline MPIO_Waitany(count::Int32, array_of_requests::Ptr{MPIO_Request}, index::Ptr{Int32}, status::Ptr{MPI_Status}) =
#    @symbolcall MPIO_Waitany(count::Int32, array_of_requests::Ptr{MPIO_Request}, index::Ptr{Int32}, status::Ptr{MPI_Status})::Int32
# @inline MPIO_Waitall(count::Int32, array_of_requests::Ptr{MPIO_Request}, array_of_statuses::Ptr{MPI_Status}) =
#    @symbolcall MPIO_Waitall(count::Int32, array_of_requests::Ptr{MPIO_Request}, array_of_statuses::Ptr{MPI_Status})::Int32
# @inline MPIO_Waitsome(incount::Int32, array_of_requests::Ptr{MPIO_Request}, outcount::Ptr{Int32}, array_of_indices::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status}) =
#    @symbolcall MPIO_Waitsome(incount::Int32, array_of_requests::Ptr{MPIO_Request}, outcount::Ptr{Int32}, array_of_indices::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status})::Int32

# Test whether execution of a request[s] completed
@inline MPI_Test(request::Ptr{MPI_Request}, flag::Ptr{Int32}, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Test(request::Ptr{MPI_Request}, flag::Ptr{Int32}, status::Ptr{MPI_Status})::Int32
@inline MPI_Testany(count::Int32, array_of_requests::Ptr{MPI_Request}, index::Ptr{Int32}, flag::Ptr{Int32}, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Testany(count::Int32, array_of_requests::Ptr{MPI_Request}, index::Ptr{Int32}, flag::Ptr{Int32}, status::Ptr{MPI_Status})::Int32
@inline MPI_Testall(count::Int32, array_of_requests::Ptr{MPI_Request}, flag::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status}) =
   @symbolcall MPI_Testall(count::Int32, array_of_requests::Ptr{MPI_Request}, flag::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status})::Int32
@inline MPI_Testsome(incount::Int32, array_of_requests::Ptr{MPI_Request}, outcount::Ptr{Int32}, array_of_indices::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status}) =
   @symbolcall MPI_Testsome(incount::Int32, array_of_requests::Ptr{MPI_Request}, outcount::Ptr{Int32}, array_of_indices::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status})::Int32
@inline MPI_Test_cancelled(status::Ptr{MPI_Status}, flag::Ptr{Int32}) =
   @symbolcall MPI_Test_cancelled(status::Ptr{MPI_Status}, flag::Ptr{Int32})::Int32
# @inline MPIO_Test(request::Ptr{MPIO_Request}, flag::Ptr{Int32}, status::Ptr{MPI_Status}) =
#    @symbolcall MPIO_Test(request::Ptr{MPIO_Request}, flag::Ptr{Int32}, status::Ptr{MPI_Status})::Int32
# @inline MPIO_Testany(count::Int32, array_of_requests::Ptr{MPIO_Request}, index::Ptr{Int32}, flag::Ptr{Int32}, status::Ptr{MPI_Status}) =
#    @symbolcall MPIO_Testany(count::Int32, array_of_requests::Ptr{MPIO_Request}, index::Ptr{Int32}, flag::Ptr{Int32}, status::Ptr{MPI_Status})::Int32
# @inline MPIO_Testall(count::Int32, array_of_requests::Ptr{MPIO_Request}, flag::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status}) =
#    @symbolcall MPIO_Testall(count::Int32, array_of_requests::Ptr{MPIO_Request}, flag::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status})::Int32
# @inline MPIO_Testsome(incount::Int32, array_of_requests::Ptr{MPIO_Request}, outcount::Ptr{Int32}, array_of_indices::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status}) =
#    @symbolcall MPIO_Testsome(incount::Int32, array_of_requests::Ptr{MPIO_Request}, outcount::Ptr{Int32}, array_of_indices::Ptr{Int32}, array_of_statuses::Ptr{MPI_Status})::Int32


@inline MPI_Cancel(request::Ptr{MPI_Request}) =
   @symbolcall MPI_Cancel(request::Ptr{MPI_Request})::Int32
@inline MPI_Request_free(request::Ptr{MPI_Request}) =
   @symbolcall MPI_Request_free(request::Ptr{MPI_Request})::Int32
@inline MPI_Buffer_attach(buffer::Ptr{Nothing}, size::Int32) =
   @symbolcall MPI_Buffer_attach(buffer::Ptr{Nothing}, size::Int32)::Int32
@inline MPI_Buffer_detach(buffer_addr::Ptr{Nothing}, size::Ptr{Int32}) =
   @symbolcall MPI_Buffer_attach(buffer::Ptr{Nothing}, size::Int32)::Int32


# Probes:
@inline MPI_Probe(source::Int32, tag::Int32, comm::MPI_Comm, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Probe(source::Int32, tag::Int32, comm.x::UInt32, status::Ptr{MPI_Status})::Int32
@inline MPI_Iprobe(source::Int32, tag::Int32, comm::MPI_Comm, flag::Ptr{Int32}, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Iprobe(source::Int32, tag::Int32, comm.x::UInt32, flag::Ptr{Int32}, status::Ptr{MPI_Status})::Int32
@inline MPI_Improbe(source::Int32, tag::Int32, comm::MPI_Comm, flag::Ptr{Int32}, message::Ptr{MPI_Message}, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Improbe(source::Int32, tag::Int32, comm.x::UInt32, flag::Ptr{Int32}, message::Ptr{MPI_Message}, status::Ptr{MPI_Status})::Int32
@inline MPI_Imrecv(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, message::Ptr{MPI_Message}, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Imrecv(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, message::Ptr{MPI_Message}, request::Ptr{MPI_Request})
@inline MPI_Mprobe(source::Int32, tag::Int32, comm::MPI_Comm, message::Ptr{MPI_Message}, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Mprobe(source::Int32, tag::Int32, comm.x::UInt32, message::Ptr{MPI_Message}, status::Ptr{MPI_Status})::Int32
@inline MPI_Mrecv(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, message::Ptr{MPI_Message}, status::Ptr{MPI_Status}) =
   @symbolcall MPI_Mrecv(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, message::Ptr{MPI_Message}, status::Ptr{MPI_Status})::Int32

# Nonblocking collectives:
@inline MPI_Comm_idup(comm::MPI_Comm, newcomm::Ptr{MPI_Comm}, request::Ptr{MPI_Request}) = @symbolcall MPI_Comm_idup(comm.x::UInt32, newcomm::Ptr{MPI_Comm}, request::Ptr{MPI_Request})::Int32
@inline MPI_Ibarrier(comm::MPI_Comm, request::Ptr{MPI_Request}) = @symbolcall MPI_Ibarrier(comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ibcast(buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, root::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ibcast(buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, root::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Igather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype, recvbuf::Ptr{Nothing},
   recvcount::Int32, recvtype::MPI_Datatype, root::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Igather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32, recvbuf::Ptr{Nothing},
      recvcount::Int32, recvtype.x::UInt32, root::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Igatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype, recvbuf::Ptr{Nothing},
   recvcount::Ptr{Int32}, displs::Ptr{Int32}, recvtype::MPI_Datatype, root::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall  MPI_Igatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32, recvbuf::Ptr{Nothing},
      recvcount::Ptr{Int32}, displs::Ptr{Int32}, recvtype.x::UInt32, root::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Iscatter(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype, recvbuf::Ptr{Nothing},
   recvcount::Int32, recvtype::MPI_Datatype, root::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Iscatter(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32, recvbuf::Ptr{Nothing},
      recvcount::Int32, recvtype.x::UInt32, root::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Iscatterv(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, displs::Ptr{Int32}, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, root::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Iscatterv(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, displs::Ptr{Int32}, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, root::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Iallgather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Iallgather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Iallgatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, displs::Ptr{Int32}, recvtype::MPI_Datatype, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Iallgatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, displs::Ptr{Int32}, recvtype.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ialltoall(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ialltoall(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ialltoallv(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtype::MPI_Datatype, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall  MPI_Ialltoallv(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtype.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ialltoallw(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtypes::Ptr{MPI_Datatype},
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtypes::Ptr{MPI_Datatype}, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ialltoallw(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtypes::Ptr{MPI_Datatype},
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtypes::Ptr{MPI_Datatype}, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ireduce(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32,
   datatype::MPI_Datatype, op::MPI_Op, root::Int32, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ireduce(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32,
      datatype.x::UInt32, op.x::UInt32, root::Int32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Iallreduce(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32,
   datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Iallreduce(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32,
      datatype.x::UInt32, op.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ireduce_scatter(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32},
   datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ireduce_scatter(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32},
      datatype.x::UInt32, op.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ireduce_scatter_block(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, recvcount::Int32,
   datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ireduce_scatter_block(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, recvcount::Int32,
      datatype.x::UInt32, op.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Iscan(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32,
   datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Iscan(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32,
      datatype.x::UInt32, op.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Iexscan(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32,
   datatype::MPI_Datatype, op::MPI_Op, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Iexscan(sendbuf::Ptr{Nothing}, recvbuf::Ptr{Nothing}, count::Int32,
      datatype.x::UInt32, op.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32

# Neighborhood collectives:
@inline MPI_Ineighbor_allgather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ineighbor_allgather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ineighbor_allgatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, displs::Ptr{Int32}, recvtype::MPI_Datatype, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ineighbor_allgatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, displs::Ptr{Int32}, recvtype.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ineighbor_alltoall(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall  MPI_Ineighbor_alltoall(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ineighbor_alltoallv(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtype::MPI_Datatype, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ineighbor_alltoallv(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtype.x::UInt32, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Ineighbor_alltoallw(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{MPI_Aint}, sendtypes::Ptr{MPI_Datatype},
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{MPI_Aint}, recvtypes::Ptr{MPI_Datatype}, comm::MPI_Comm, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Ineighbor_alltoallw(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{MPI_Aint}, sendtypes::Ptr{MPI_Datatype},
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{MPI_Aint}, recvtypes::Ptr{MPI_Datatype}, comm.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Neighbor_allgather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, comm::MPI_Comm) =
   @symbolcall MPI_Neighbor_allgather(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Neighbor_allgatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, displs::Ptr{Int32}, recvtype::MPI_Datatype, comm::MPI_Comm) =
   @symbolcall MPI_Neighbor_allgatherv(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, displs::Ptr{Int32}, recvtype.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Neighbor_alltoall(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype::MPI_Datatype, comm::MPI_Comm) =
   @symbolcall MPI_Neighbor_alltoall(sendbuf::Ptr{Nothing}, sendcount::Int32, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Int32, recvtype.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Neighbor_alltoallv(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32},sendtype::MPI_Datatype,
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtype::MPI_Datatype, comm::MPI_Comm) =
   @symbolcall MPI_Neighbor_alltoallv(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{Int32}, sendtype.x::UInt32,
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{Int32}, recvtype.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Neighbor_alltoallw(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{MPI_Aint},sendtypes::Ptr{MPI_Datatype},
   recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{MPI_Aint}, recvtypes::Ptr{MPI_Datatype}, comm::MPI_Comm) =
   @symbolcall MPI_Neighbor_alltoallw(sendbuf::Ptr{Nothing}, sendcount::Ptr{Int32}, sdispls::Ptr{MPI_Aint},sendtypes::Ptr{MPI_Datatype},
      recvbuf::Ptr{Nothing}, recvcount::Ptr{Int32}, rdispls::Ptr{MPI_Aint}, recvtypes::Ptr{MPI_Datatype}, comm.x::UInt32)::Int32

# Noncollective communicator creation:
@inline MPI_Comm_create_group(comm::MPI_Comm, group::MPI_Group, tag::Int32, newcomm::Ptr{MPI_Comm}) =
   @symbolcall MPI_Comm_create_group(comm.x::UInt32, group.x::UInt32, tag::Int32, newcomm::Ptr{MPI_Comm})::Int32

# MPI_Aint addressing arithmetic:
@inline MPI_Aint_add(base::MPI_Aint, disp::MPI_Aint) = @symbolcall MPI_Aint_add(base.x::UInt32, disp.x::UInt32)::Int32
@inline MPI_Aint_diff(addr1::MPI_Aint, addr2::MPI_Aint) = @symbolcall MPI_Aint_diff(addr1.x::UInt32, addr2.x::UInt32)::Int32

# Type-related functions
@inline MPI_Type_contiguous(count::Int32, oldtype::MPI_Datatype, newtype::Ptr{MPI_Datatype}) =
   @symbolcall MPI_Type_contiguous(count::Int32, oldtype.x::UInt32, newtype::Ptr{MPI_Datatype})::Int32
@inline MPI_Type_vector(count::Int32, blocklength::Int32, stride::Int32, oldtype::MPI_Datatype, newtype::Ptr{MPI_Datatype}) =
   @symbolcall MPI_Type_vector(count::Int32, blocklength::Int32, stride::Int32, oldtype.x::UInt32, newtype::Ptr{MPI_Datatype})::Int32
@inline MPI_Type_hvector(count::Int32, blocklength::Int32, stride::MPI_Aint, oldtype::MPI_Datatype, newtype::Ptr{MPI_Datatype}) =
   @symbolcall MPI_Type_hvector(count::Int32, blocklength::Int32, stride.x::UInt32, oldtype.x::UInt32, newtype::Ptr{MPI_Datatype})::Int32
@inline MPI_Type_indexed(count::Int32, array_of_blocklengths::Ptr{Int32}, array_of_displacements::Ptr{Int32}, oldtype::MPI_Datatype, newtype::Ptr{MPI_Datatype}) =
   @symbolcall MPI_Type_indexed(count::Int32, array_of_blocklengths::Ptr{Int32}, array_of_displacements::Ptr{Int32}, oldtype.x::UInt32, newtype::Ptr{MPI_Datatype})::Int32
@inline MPI_Type_hindexed(count::Int32, array_of_blocklengths::Ptr{Int32}, array_of_displacements::Ptr{MPI_Aint}, oldtype::MPI_Datatype, newtype::Ptr{MPI_Datatype}) =
   @symbolcall MPI_Type_hindexed(count::Int32, array_of_blocklengths::Ptr{Int32}, array_of_displacements::Ptr{MPI_Aint}, oldtype.x::UInt32, newtype::Ptr{MPI_Datatype})::Int32
@inline MPI_Type_struct(count::Int32, array_of_blocklengths::Ptr{Int32}, array_of_displacements::Ptr{MPI_Aint}, array_of_types::Ptr{MPI_Datatype}, newtype::Ptr{MPI_Datatype}) =
   @symbolcall MPI_Type_struct(count::Int32, array_of_blocklengths::Ptr{Int32}, array_of_displacements::Ptr{MPI_Aint}, array_of_types::Ptr{MPI_Datatype}, newtype::Ptr{MPI_Datatype})::Int32
@inline MPI_Address(location::Ptr{Nothing}, address::Ptr{MPI_Aint}) =
   @symbolcall MPI_Address(location::Ptr{Nothing}, address::Ptr{MPI_Aint})::Int32
@inline MPI_Type_extent(datatype::MPI_Datatype, extent::Ptr{MPI_Aint}) =
   @symbolcall MPI_Type_extent(datatype.x::UInt32, extent::Ptr{MPI_Aint})::Int32
@inline MPI_Type_size(datatype::MPI_Datatype, size::Ptr{Int32}) =
   @symbolcall MPI_Type_size(datatype.x::UInt32, size::Ptr{Int32})::Int32
@inline MPI_Type_lb(datatype::MPI_Datatype, displacement::Ptr{MPI_Aint}) =
   @symbolcall MPI_Type_lb(datatype.x::UInt32, displacement::Ptr{MPI_Aint})::Int32
@inline MPI_Type_ub(datatype::MPI_Datatype, displacement::Ptr{MPI_Aint}) =
   @symbolcall MPI_Type_ub(datatype.x::UInt32, displacement::Ptr{MPI_Aint})::Int32
@inline MPI_Type_commit(datatype::Ptr{MPI_Datatype}) =
   @symbolcall MPI_Type_commit(datatype::Ptr{MPI_Datatype})::Int32
@inline MPI_Type_free(datatype::Ptr{MPI_Datatype}) =
   @symbolcall MPI_Type_free(datatype::Ptr{MPI_Datatype})::Int32
@inline MPI_Get_elements(status::Ptr{MPI_Status}, datatype::MPI_Datatype, count::Ptr{Int32}) =
   @symbolcall MPI_Get_elements(status::Ptr{MPI_Status}, datatype.x::UInt32, count::Ptr{Int32})::Int32
@inline MPI_Pack(inbuf::Ptr{Nothing}, incount::Int32, datatype::MPI_Datatype, outbuf::Ptr{Nothing}, outsize::Int32, position::Ptr{Int32}, comm::MPI_Comm) =
   @symbolcall MPI_Pack(inbuf::Ptr{Nothing}, incount::Int32, datatype.x::UInt32, outbuf::Ptr{Nothing}, outsize::Int32, position::Ptr{Int32}, comm.x::UInt32)::Int32
@inline MPI_Unpack(inbuf::Ptr{Nothing}, insize::Int32, position::Ptr{Int32}, outbuf::Ptr{Nothing}, outcount::Int32, datatype::MPI_Datatype, comm::MPI_Comm) =
   @symbolcall MPI_Unpack(inbuf::Ptr{Nothing}, insize::Int32, position::Ptr{Int32}, outbuf::Ptr{Nothing}, outcount::Int32, datatype.x::UInt32, comm.x::UInt32)::Int32
@inline MPI_Pack_size(incount::Int32, datatype::MPI_Datatype, comm::MPI_Comm, size::Ptr{Int32}) =
   @symbolcall MPI_Pack_size(incount::Int32, datatype.x::UInt32, comm.x::UInt32, size::Ptr{Int32})::Int32
@inline MPI_Type_create_darray(size::Int32, rank::Int32, ndims::Int32, array_of_gsizes::Ptr{Int32}, array_of_distribs::Ptr{Int32}, array_of_dargs::Ptr{Int32}, array_of_psizes::Ptr{Int32}, order::Int32, oldtype::MPI_Datatype, newtype::Ptr{MPI_Datatype}) =
   @symbolcall MPI_Type_create_darray(size::Int32, rank::Int32, ndims::Int32, array_of_gsizes::Ptr{Int32}, array_of_distribs::Ptr{Int32}, array_of_dargs::Ptr{Int32}, array_of_psizes::Ptr{Int32}, order::Int32, oldtype.x::UInt32, newtype::Ptr{MPI_Datatype})::Int32
@inline MPI_Type_create_hindexed(count::Int32, array_of_blocklengths::Ptr{Int32}, array_of_displacements::Ptr{MPI_Aint}, oldtype::MPI_Datatype, newtype::Ptr{MPI_Datatype}) =
   @symbolcall MPI_Type_create_hindexed(count::Int32, array_of_blocklengths::Ptr{Int32}, array_of_displacements::Ptr{MPI_Aint}, oldtype.x::UInt32, newtype::Ptr{MPI_Datatype})::Int32
@inline MPI_Type_create_hvector(count::Int32, blocklength::Int32, stride::MPI_Aint, oldtype::MPI_Datatype, newtype::Ptr{MPI_Datatype}) =
   @symbolcall MPI_Type_create_hvector(count::Int32, blocklength::Int32, stride.x::UInt32, oldtype.x::UInt32, newtype::Ptr{MPI_Datatype})::Int32
@inline MPI_Type_create_indexed_block(count::Int32, blocklength::Int32, array_of_displacements::Ptr{Int32}, oldtype::MPI_Datatype, newtype::Ptr{MPI_Datatype}) =
   @symbolcall MPI_Type_create_indexed_block(count::Int32, blocklength::Int32, array_of_displacements::Ptr{Int32}, oldtype.x::UInt32, newtype::Ptr{MPI_Datatype})::Int32
@inline MPI_Type_create_hindexed_block(count::Int32, blocklength::Int32, array_of_displacements::Ptr{MPI_Aint}, oldtype::MPI_Datatype, newtype::Ptr{MPI_Datatype}) =
   @symbolcall MPI_Type_create_hindexed_block(count::Int32, blocklength::Int32, array_of_displacements::Ptr{MPI_Aint}, oldtype.x::UInt32, newtype::Ptr{MPI_Datatype})::Int32
@inline MPI_Type_create_resized(oldtype::MPI_Datatype, lb::MPI_Aint, extent::MPI_Aint, newtype::Ptr{MPI_Datatype}) =
   @symbolcall MPI_Type_create_resized(oldtype.x::UInt32, lb.x::UInt32, extent.x::UInt32, newtype::Ptr{MPI_Datatype})::Int32
@inline MPI_Type_create_struct(count::Int32, array_of_blocklengths::Ptr{Int32}, array_of_displacements::Ptr{MPI_Aint}, array_of_types::Ptr{MPI_Datatype}, newtype::Ptr{MPI_Datatype}) =
   @symbolcall MPI_Type_create_struct(count::Int32, array_of_blocklengths::Ptr{Int32}, array_of_displacements::Ptr{MPI_Aint}, array_of_types::Ptr{MPI_Datatype}, newtype::Ptr{MPI_Datatype})::Int32
@inline MPI_Type_create_subarray(ndims::Int32, array_of_sizes::Ptr{Int32}, array_of_subsizes::Ptr{Int32}, array_of_starts::Ptr{Int32}, order::Int32, oldtype::MPI_Datatype, newtype::Ptr{MPI_Datatype}) =
   @symbolcall MPI_Type_create_subarray(ndims::Int32, array_of_sizes::Ptr{Int32}, array_of_subsizes::Ptr{Int32}, array_of_starts::Ptr{Int32}, order::Int32, oldtype.x::UInt32, newtype::Ptr{MPI_Datatype})::Int32
@inline MPI_Type_get_extent(datatype::MPI_Datatype, lb::Ptr{MPI_Aint}, extent::Ptr{MPI_Aint}) =
   @symbolcall MPI_Type_get_extent(datatype.x::UInt32, lb::Ptr{MPI_Aint}, extent::Ptr{MPI_Aint})::Int32
@inline MPI_Type_get_true_extent(datatype::MPI_Datatype, true_lb::Ptr{MPI_Aint}, true_extent::Ptr{MPI_Aint}) =
   @symbolcall MPI_Type_get_true_extent(datatype.x::UInt32, true_lb::Ptr{MPI_Aint}, true_extent::Ptr{MPI_Aint})::Int32
@inline MPI_Pack_external(datarep::Ptr{UInt8}, inbuf::Ptr{Nothing}, incount::Int32, datatype::MPI_Datatype, outbuf::Ptr{Nothing}, outsize::MPI_Aint, position::Ptr{MPI_Aint}) =
   @symbolcall MPI_Pack_external(datarep::Ptr{UInt8}, inbuf::Ptr{Nothing}, incount::Int32, datatype.x::UInt32, outbuf::Ptr{Nothing}, outsize.x::UInt32, position::Ptr{MPI_Aint})::Int32
@inline MPI_Unpack_external(datarep::Ptr{UInt8}, inbuf::Ptr{Nothing}, insize::MPI_Aint, position::Ptr{MPI_Aint}, outbuf::Ptr{Nothing}, outcount::Int32, datatype::MPI_Datatype) =
   @symbolcall MPI_Unpack_external(datarep::Ptr{UInt8}, inbuf::Ptr{Nothing}, insize.x::UInt32, position::Ptr{MPI_Aint}, outbuf::Ptr{Nothing}, outcount::Int32, datatype.x::UInt32)::Int32


# Process Creation and Management:
@inline MPI_Close_port(port_name::Ptr{UInt8}) = @symbolcall MPI_Close_port(port_name::Ptr{UInt8})::Int32
@inline MPI_Comm_accept(port_name::Ptr{UInt8}, info::MPI_Info, root::Int32, comm::MPI_Comm, newcomm::Ptr{MPI_Comm}) =
   @symbolcall MPI_Comm_accept(port_name::Ptr{UInt8}, info.x::UInt32, root::Int32, comm.x::UInt32, newcomm::Ptr{MPI_Comm})::Int32
@inline MPI_Comm_connect(port_name::Ptr{UInt8}, info::MPI_Info, root::Int32, comm::MPI_Comm, newcomm::Ptr{MPI_Comm}) =
   @symbolcall MPI_Comm_connect(port_name::Ptr{UInt8}, info.x::UInt32, root::Int32, comm.x::UInt32, newcomm::Ptr{MPI_Comm})::Int32
@inline MPI_Comm_disconnect(comm::Ptr{MPI_Comm}) = @symbolcall MPI_Comm_disconnect(comm::Ptr{MPI_Comm})::Int32
@inline MPI_Comm_get_parent(parent::Ptr{MPI_Comm}) = @symbolcall MPI_Comm_get_parent(parent::Ptr{MPI_Comm})::Int32
@inline MPI_Comm_join(fd::Int32, intercomm::Ptr{MPI_Comm}) = @symbolcall MPI_Comm_join(fd::Int32, intercomm::Ptr{MPI_Comm})::Int32
@inline MPI_Comm_spawn(command::Ptr{UInt8}, argv::Ptr{Ptr{UInt8}}, maxprocs::Int32, info::MPI_Info, root::Int32, comm::MPI_Comm, intercomm::Ptr{MPI_Comm}, array_of_errcodes::Ptr{Int32}) =
   @symbolcall MPI_Comm_spawn(command::Ptr{UInt8}, argv::Ptr{Ptr{UInt8}}, maxprocs::Int32, info.x::UInt32, root::Int32, comm.x::UInt32, intercomm::Ptr{MPI_Comm}, array_of_errcodes::Ptr{Int32})::Int32
@inline MPI_Comm_spawn_multiple(count::Int32, array_of_commands::Ptr{Ptr{UInt8}}, array_of_argv::Ptr{Ptr{Ptr{UInt8}}}, array_of_maxprocs::Ptr{Int32}, array_of_info::Ptr{MPI_Info}, root::Int32, comm::MPI_Comm, intercomm::Ptr{MPI_Comm}, array_of_errcodes::Ptr{Int32}) =
   @symbolcall MPI_Comm_spawn_multiple(count::Int32, array_of_commands::Ptr{Ptr{UInt8}}, array_of_argv::Ptr{Ptr{Ptr{UInt8}}}, array_of_maxprocs::Ptr{Int32}, array_of_info::Ptr{MPI_Info}, root::Int32, comm.x::UInt32, intercomm::Ptr{MPI_Comm}, array_of_errcodes::Ptr{Int32})::Int32
@inline MPI_Lookup_name(service_name::Ptr{UInt8}, info::MPI_Info, port_name::Ptr{UInt8}) =
   @symbolcall MPI_Lookup_name(service_name::Ptr{UInt8}, info.x::UInt32, port_name::Ptr{UInt8})::Int32
@inline MPI_Open_port(info::MPI_Info, port_name::Ptr{UInt8}) =
   @symbolcall MPI_Open_port(info.x::UInt32, port_name::Ptr{UInt8})::Int32
@inline MPI_Publish_name(service_name::Ptr{UInt8}, info::MPI_Info, port_name::Ptr{UInt8}) =
   @symbolcall MPI_Publish_name(service_name::Ptr{UInt8}, info.x::UInt32, port_name::Ptr{UInt8})::Int32
@inline MPI_Unpublish_name(service_name::Ptr{UInt8}, info::MPI_Info, port_name::Ptr{UInt8}) =
   @symbolcall MPI_Unpublish_name(service_name::Ptr{UInt8}, info.x::UInt32, port_name::Ptr{UInt8})::Int32
@inline MPI_Comm_set_info(comm::MPI_Comm, info::MPI_Info) = @symbolcall MPI_Comm_set_info(comm.x::UInt32, info.x::UInt32)::Int32
@inline MPI_Comm_get_info(comm::MPI_Comm, info::Ptr{MPI_Info}) = @symbolcall MPI_Comm_get_info(comm.x::UInt32, info::Ptr{MPI_Info})::Int32

# Non-standard but public extensions to MPI:
@inline MPIX_Comm_failure_ack(comm::MPI_Comm) = @symbolcall MPIX_Comm_failure_ack(comm.x::UInt32)::Int32
@inline MPIX_Comm_failure_get_acked(comm::MPI_Comm, failedgrp::Ptr{MPI_Count}) = @symbolcall MPIX_Comm_failure_get_acked(comm.x::UInt32, failedgrp::Ptr{MPI_Count})::Int32
@inline MPIX_Comm_revoke(comm::MPI_Comm) = @symbolcall MPIX_Comm_revoke(comm.x::UInt32)::Int32
@inline MPIX_Comm_shrink(comm::MPI_Comm, newcomm::Ptr{MPI_Comm}) = @symbolcall MPIX_Comm_shrink(comm.x::UInt32, newcomm::Ptr{MPI_Comm})::Int32
@inline MPIX_Comm_agree(comm::MPI_Comm, flag::Ptr{Int32}) = @symbolcall MPIX_Comm_agree(comm.x::UInt32, flag::Ptr{Int32})::Int32

# Memory management:
@inline MPI_Alloc_mem(size::MPI_Aint, info::MPI_Info, ptr::Ptr{Nothing}) =
   @symbolcall MPI_Alloc_mem(size.x::UInt32, info.x::UInt32, ptr::Ptr{Nothing})::Int32
@inline MPI_Free_mem(base::Ptr{Nothing}) = @symbolcall MPI_Free_mem(ptr::Ptr{Nothing})::Int32


# One-Sided Communications:
@inline MPI_Accumulate(origin_addr::Ptr{Nothing}, origin_count::Int32, origin_datatype::MPI_Datatype, target_rank::Int32, target_disp::MPI_Aint, target_count::Int32, target_datatype::MPI_Datatype, op::MPI_Op, win::MPI_Win) =
   @symbolcall MPI_Accumulate(origin_addr::Ptr{Nothing}, origin_count::Int32, origin_datatype.x::UInt32, target_rank::Int32, target_disp.x::UInt32, target_count::Int32, target_datatype.x::UInt32, op.x::UInt32, win.x::UInt32)::Int32
@inline MPI_Get(origin_addr::Ptr{Nothing}, origin_count::Int32, origin_datatype::MPI_Datatype, target_rank::Int32, target_disp::MPI_Aint, target_count::Int32, target_datatype::MPI_Datatype, win::MPI_Win) =
   @symbolcall MPI_Get(origin_addr::Ptr{Nothing}, origin_count::Int32, origin_datatype.x::UInt32, target_rank::Int32, target_disp.x::UInt32, target_count::Int32, target_datatype.x::UInt32, win.x::UInt32) =::Int32
@inline MPI_Put(origin_addr::Ptr{Nothing}, origin_count::Int32, origin_datatype::MPI_Datatype, target_rank::Int32, target_disp::MPI_Aint, target_count::Int32, target_datatype::MPI_Datatype, win::MPI_Win) =
   @symbolcall MPI_Put(origin_addr::Ptr{Nothing}, origin_count::Int32, origin_datatype.x::UInt32, target_rank::Int32, target_disp.x::UInt32, target_count::Int32, target_datatype.x::UInt32, win.x::UInt32)::Int32
@inline MPI_Win_complete(win::MPI_Win) = @symbolcall MPI_Win_complete(win.x::UInt32)::Int32
@inline MPI_Win_create(base::Ptr{Nothing}, size::MPI_Aint, disp_unit::Int32, info::MPI_Info, comm::MPI_Comm, win::Ptr{MPI_Win}) =
   @symbolcall MPI_Win_create(base::Ptr{Nothing}, size.x::UInt32, disp_unit::Int32, info.x::UInt32, comm.x::UInt32, win::Ptr{MPI_Win})::Int32
@inline MPI_Win_fence(assert::Int32, win::MPI_Win) = @symbolcall MPI_Win_fence(assert::Int32, win.x::UInt32)::Int32
@inline MPI_Win_free(win::Ptr{MPI_Win}) = @symbolcall MPI_Win_free(win::Ptr{MPI_Win})::Int32
@inline MPI_Win_get_group(win::MPI_Win, group::Ptr{MPI_Group}) = @symbolcall MPI_Win_get_group(win.x::UInt32, group::Ptr{MPI_Group})::Int32
@inline MPI_Win_lock(lock_type::Int32, rank::Int32, assert::Int32, win::MPI_Win) = @symbolcall MPI_Win_lock(lock_type::Int32, rank::Int32, assert::Int32, win.x::UInt32)::Int32
@inline MPI_Win_post(group::MPI_Group, assert::Int32, win::MPI_Win) = @symbolcall MPI_Win_post(group.x::UInt32, assert::Int32, win.x::UInt32)::Int32
@inline MPI_Win_start(group::MPI_Group, assert::Int32, win::MPI_Win) = @symbolcall MPI_Win_start(group.x::UInt32, assert::Int32, win.x::UInt32)::Int32
@inline MPI_Win_test(win::MPI_Win, flag::Ptr{Int32}) = @symbolcall MPI_Win_test(win.x::UInt32, flag::Ptr{Int32})::Int32
@inline MPI_Win_unlock(rank::Int32, win::MPI_Win) = @symbolcall MPI_Win_unlock(rank::Int32, win.x::UInt32)::Int32
@inline MPI_Win_wait(win::MPI_Win) = @symbolcall MPI_Win_wait(win.x::UInt32)::Int32

# MPI-3 One-Sided Communication Routines:
@inline MPI_Win_allocate(size::MPI_Aint, disp_unit::Int32, info::MPI_Info, comm::MPI_Comm, baseptr::Ptr{Nothing}, win::Ptr{MPI_Win}) =
   @symbolcall MPI_Win_allocate(size.x::UInt32, disp_unit::Int32, info.x::UInt32, comm.x::UInt32, baseptr::Ptr{Nothing}, win::Ptr{MPI_Win})::Int32
@inline MPI_Win_allocate_shared(size::MPI_Aint, disp_unit::Int32, info::MPI_Info, comm::MPI_Comm, baseptr::Ptr{Nothing}, win::Ptr{MPI_Win}) =
   @symbolcall MPI_Win_allocate_shared(size.x::UInt32, disp_unit::Int32, info.x::UInt32, comm.x::UInt32, baseptr::Ptr{Nothing}, win::Ptr{MPI_Win})::Int32
@inline MPI_Win_shared_query(win::MPI_Win, rank::Int32, MPI_Asize::Ptr{Int32}, disp_unit::Ptr{Int32}, baseptr::Ptr{Nothing}) =
   @symbolcall MPI_Win_shared_query(win.x::UInt32, rank::Int32, MPI_Asize::Ptr{Int32}, disp_unit::Ptr{Int32}, baseptr::Ptr{Nothing})::Int32
@inline MPI_Win_create_dynamic(info::MPI_Info, comm::MPI_Comm, win::Ptr{MPI_Win}) =
   @symbolcall MPI_Win_create_dynamic(info.x::UInt32, comm.x::UInt32, win::Ptr{MPI_Win})::Int32
@inline MPI_Win_attach(win::MPI_Win, base::Ptr{Nothing}, size::MPI_Aint) =
   @symbolcall MPI_Win_attach(win.x::UInt32, base::Ptr{Nothing}, size.x::UInt32)::Int32
@inline MPI_Win_detach(win::MPI_Win, base::Ptr{Nothing}) = @symbolcall MPI_Win_detach(win.x::UInt32, base::Ptr{Nothing})::Int32
@inline MPI_Win_get_info(win::MPI_Win, info_used::Ptr{MPI_Info}) = @symbolcall MPI_Win_get_info(win.x::UInt32, info_used::Ptr{MPI_Info})::Int32
@inline MPI_Win_set_info(win::MPI_Win, info::MPI_Info) = @symbolcall MPI_Win_set_info(win.x::UInt32, info.x::UInt32)::Int32
@inline MPI_Get_accumulate(origin_addr::Ptr{Nothing}, origin_count::Int32, origin_datatype::MPI_Datatype, result_addr::Ptr{Nothing}, result_count::Int32, result_datatype::MPI_Datatype,
   target_rank::Int32, target_disp::MPI_Aint, target_count::Int32, target_datatype::MPI_Datatype, op::MPI_Op, win::MPI_Win) =
   @symbolcall MPI_Get_accumulate(origin_addr::Ptr{Nothing}, origin_count::Int32, origin_datatype.x::UInt32, result_addr::Ptr{Nothing}, result_count::Int32, result_datatype.x::UInt32,
      target_rank::Int32, target_disp.x::UInt32, target_count::Int32, target_datatype.x::UInt32, op.x::UInt32, win.x::UInt32)::Int32
@inline MPI_Fetch_and_op(origin_addr::Ptr{Nothing}, result_addr::Ptr{Nothing}, datatype::MPI_Datatype, target_rank::Int32, target_disp::MPI_Aint, op::MPI_Op, win::MPI_Win) =
   @symbolcall MPI_Fetch_and_op(origin_addr::Ptr{Nothing}, result_addr::Ptr{Nothing}, datatypewin.x::UInt32, target_rank::Int32, target_disp.x::UInt32, op.x::UInt32, win.x::UInt32)::Int32
@inline MPI_Compare_and_swap(origin_addr::Ptr{Nothing}, compare_addr::Ptr{Nothing}, result_addr::Ptr{Nothing}, datatype::MPI_Datatype, target_rank::Int32, target_disp::MPI_Aint, win::MPI_Win) =
   @symbolcall MPI_Compare_and_swap(origin_addr::Ptr{Nothing}, compare_addr::Ptr{Nothing}, result_addr::Ptr{Nothing}, datatypewin.x::UInt32, target_rank::Int32, target_disp.x::UInt32, win.x::UInt32)::Int32
@inline MPI_Rput(origin_addr::Ptr{Nothing}, origin_count::Int32, origin_datatype::MPI_Datatype, target_rank::Int32, target_disp::MPI_Aint, target_count::Int32, target_datatype::MPI_Datatype, win::MPI_Win, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Rput(origin_addr::Ptr{Nothing}, origin_count::Int32, origin_datatypewin.x::UInt32, target_rank::Int32, target_disp.x::UInt32, target_count::Int32, target_datatypewin.x::UInt32, win.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Rget(origin_addr::Ptr{Nothing}, origin_count::Int32, origin_datatype::MPI_Datatype, target_rank::Int32, target_disp::MPI_Aint, target_count::Int32, target_datatype::MPI_Datatype, win::MPI_Win, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Rget(origin_addr::Ptr{Nothing}, origin_count::Int32, origin_datatypewin.x::UInt32, target_rank::Int32, target_disp.x::UInt32, target_count::Int32, target_datatypewin.x::UInt32, win.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Raccumulate(origin_addr::Ptr{Nothing}, origin_count::Int32, origin_datatype::MPI_Datatype, target_rank::Int32, target_disp::MPI_Aint, target_count::Int32, target_datatype::MPI_Datatype, op::MPI_Op, win::MPI_Win, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Raccumulate(origin_addr::Ptr{Nothing}, origin_count::Int32, origin_datatypewin.x::UInt32, target_rank::Int32, target_disp.x::UInt32, target_count::Int32, target_datatypewin.x::UInt32, op.x::UInt32, win.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Rget_accumulate(origin_addr::Ptr{Nothing}, origin_count::Int32, origin_datatype::MPI_Datatype, result_addr::Ptr{Nothing}, result_count::Int32, result_datatype::MPI_Datatype,
   target_rank::Int32, target_disp::MPI_Aint, target_count::Int32, target_datatype::MPI_Datatype, op::MPI_Op, win::MPI_Win, request::Ptr{MPI_Request}) =
   @symbolcall MPI_Rget_accumulate(origin_addr::Ptr{Nothing}, origin_count::Int32, origin_datatypeinfo_used::Ptr{MPI_Info}, result_addr::Ptr{Nothing}, result_count::Int32, result_datatypeinfo_used::Ptr{MPI_Info},
      target_rank::Int32, target_disp.x::UInt32, target_count::Int32, target_datatypeinfo_used::Ptr{MPI_Info}, op.x::UInt32, win.x::UInt32, request::Ptr{MPI_Request})::Int32
@inline MPI_Win_lock_all(assert::Int32, win::MPI_Win) = @symbolcall MPI_Win_lock_all(assert::Int32, win.x::UInt32)::Int32
@inline MPI_Win_unlock_all(win::MPI_Win) = @symbolcall MPI_Win_unlock_all(win.x::UInt32)::Int32
@inline MPI_Win_flush(rank::Int32, win::MPI_Win) = @symbolcall MPI_Win_flush(rank::Int32, win.x::UInt32)::Int32
@inline MPI_Win_flush_all(win::MPI_Win) = @symbolcall MPI_Win_flush_all(win.x::UInt32)::Int32
@inline MPI_Win_flush_local(rank::Int32, win::MPI_Win) = @symbolcall MPI_Win_flush_local(rank::Int32, win.x::UInt32)::Int32
@inline MPI_Win_flush_local_all(win::MPI_Win) = @symbolcall MPI_Win_flush_local_all(win.x::UInt32)::Int32
@inline MPI_Win_sync(win::MPI_Win) = @symbolcall MPI_Win_sync(win.x::UInt32)::Int32

# MPI-3 "large count" routines:
@inline MPI_Get_elements_x(status::Ptr{MPI_Status}, datatype::MPI_Datatype, count::Ptr{MPI_Count}) =
   @symbolcall MPI_Get_elements_x(status::Ptr{MPI_Status}, datatype.x::UInt32, count::Ptr{MPI_Count})::Int32
@inline MPI_Status_set_elements_x(status::Ptr{MPI_Status}, datatype::MPI_Datatype, count::MPI_Count) =
   @symbolcall MPI_Status_set_elements_x(status::Ptr{MPI_Status}, datatype.x::UInt32, count.x::Int64)::Int32
@inline MPI_Type_get_extent_x(datatype::MPI_Datatype, lb::Ptr{MPI_Count}, extent::Ptr{MPI_Count}) =
   @symbolcall MPI_Type_get_extent_x(datatype.x::UInt32, lb::Ptr{MPI_Count}, extent::Ptr{MPI_Count})::Int32
@inline MPI_Type_get_true_extent_x(datatype::MPI_Datatype, lb::Ptr{MPI_Count}, extent::Ptr{MPI_Count}) =
   @symbolcall MPI_Type_get_true_extent_x(datatype.x::UInt32, lb::Ptr{MPI_Count}, extent::Ptr{MPI_Count})::Int32
@inline MPI_Type_size_x(datatype::MPI_Datatype, size::Ptr{MPI_Count}) =
   @symbolcall MPI_Type_size_x(datatype.x::UInt32, size::Ptr{MPI_Count})::Int32


# Files and IO
@inline MPI_File_open(comm::MPI_Comm, filename::Ptr{UInt8}, amode::Int32, info::MPI_Info, fh::Ptr{MPI_File}) =
	@symbolcall MPI_File_open(comm.x::UInt32, filename::Ptr{UInt8}, amode::Int32, info.x::UInt32, fh::Ptr{MPI_File})::Int32
@inline MPI_File_close(fh::Ptr{MPI_File}) = @symbolcall MPI_File_close(fh::Ptr{MPI_File})::Int32
@inline MPI_File_delete(filename::Ptr{UInt8}, info::MPI_Info) = @symbolcall MPI_File_delete(filename::Ptr{UInt8}, info.x::UInt32)::Int32
@inline MPI_File_set_size(file::MPI_File, size::MPI_Offset) = @symbolcall MPI_File_set_size(file.x::Ptr{UInt8}, size::Int64)::Int32
@inline MPI_File_preallocate(file::MPI_File, size::MPI_Offset) = @symbolcall MPI_File_preallocate(file.x::Ptr{UInt8}, size::Int64)::Int32
@inline MPI_File_get_size(file::MPI_File, size::Ptr{MPI_Offset}) = @symbolcall MPI_File_get_size(file.x::Ptr{UInt8}, size::Ptr{Int64})::Int32
@inline MPI_File_get_group(file::MPI_File, group::Ptr{MPI_Group}) = @symbolcall MPI_File_get_group(file.x::Ptr{UInt8}, group::Ptr{MPI_Group})::Int32
@inline MPI_File_get_amode(file::MPI_File, amode::Ptr{Int32}) = @symbolcall MPI_File_get_amode(file.x::Ptr{UInt8}, amode::Ptr{Int32})::Int32
@inline MPI_File_set_info(file::MPI_File, info::MPI_Info) = @symbolcall MPI_File_set_info(file.x::Ptr{UInt8}, info.x::UInt32)::Int32
@inline MPI_File_get_info(file::MPI_File, info_used::Ptr{MPI_Info}) = @symbolcall MPI_File_get_info(file.x::Ptr{UInt8}, info_used::Ptr{MPI_Info})::Int32

@inline MPI_File_set_view(file::MPI_File, disp::MPI_Offset, etype::MPI_Datatype, filetype::MPI_Datatype, datarep::Ptr{UInt8}, info::MPI_Info) =
	@symbolcall MPI_File_set_view(file.x::Ptr{UInt8}, disp::Int64, etype.x::UInt32, filetype.x::UInt32, datarep::Ptr{UInt8}, info.x::UInt8)::Int32
@inline MPI_File_get_view(file::MPI_File, disp::Ptr{MPI_Offset}, etype::Ptr{MPI_Datatype}, filetype::Ptr{MPI_Datatype}, datarep::Ptr{UInt8}) =
	@symbolcall MPI_File_get_view(file.x::Ptr{UInt8}, disp::Ptr{Int64}, etype::Ptr{MPI_Datatype}, filetype::Ptr{MPI_Datatype}, datarep::Ptr{UInt8})::Int32

@inline MPI_File_read_at(file::MPI_File, offset::MPI_Offset, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_read_at(file.x::Ptr{UInt8}, offset::Int64, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, status::Ptr{MPI_Status})::Int32
@inline MPI_File_read_at_all(file::MPI_File, offset::MPI_Offset, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_read_at_all(file.x::Ptr{UInt8}, offset::Int64, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, status::Ptr{MPI_Status})::Int32
@inline MPI_File_write_at(file::MPI_File, offset::MPI_Offset, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_write_at(file.x::Ptr{UInt8}, offset::Int64, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, status::Ptr{MPI_Status})::Int32
@inline MPI_File_write_at_all(file::MPI_File, offset::MPI_Offset, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_write_at_all(file.x::Ptr{UInt8}, offset::Int64, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, status::Ptr{MPI_Status})::Int32

@inline MPI_File_iread_at(file::MPI_File, offset::MPI_Offset, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, request::Ptr{MPIO_Request}) =
	@symbolcall MPI_File_iread_at(file.x::Ptr{UInt8}, offset::Int64, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, request::Ptr{MPIO_Request})::Int32
@inline MPI_File_iwrite_at(file::MPI_File, offset::MPI_Offset, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, request::Ptr{MPIO_Request}) =
	@symbolcall MPI_File_iwrite_at(file.x::Ptr{UInt8}, offset::Int64, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, request::Ptr{MPIO_Request})::Int32

@inline MPI_File_read(file::MPI_File, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_read(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, status::Ptr{MPI_Status})::Int32
@inline MPI_File_read_all(file::MPI_File, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_read_all(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, status::Ptr{MPI_Status})::Int32
@inline MPI_File_write(file::MPI_File, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_write(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, status::Ptr{MPI_Status})::Int32
@inline MPI_File_write_all(file::MPI_File, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_write_all(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, status::Ptr{MPI_Status})::Int32

@inline MPI_File_iread(file::MPI_File, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, request::Ptr{MPIO_Request}) =
	@symbolcall MPI_File_iread(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, request::Ptr{MPIO_Request})::Int32
@inline MPI_File_iwrite(file::MPI_File, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, request::Ptr{MPIO_Request}) =
	@symbolcall MPI_File_iwrite(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, request::Ptr{MPIO_Request})::Int32

@inline MPI_File_seek(file::MPI_File, offset::MPI_Offset, whence::Int32) =
	@symbolcall MPI_File_seek(file.x::Ptr{UInt8}, offset::Int64, whence::Int32)::Int32
@inline MPI_File_get_position(file::MPI_File, offset::Ptr{MPI_Offset}) =
	@symbolcall MPI_File_get_position(file.x::Ptr{UInt8}, offset::Ptr{Int64})::Int32
@inline MPI_File_get_byte_offset(file::MPI_File, offset::MPI_Offset, disp::Ptr{MPI_Offset}) =
	@symbolcall MPI_File_get_byte_offset(file.x::Ptr{UInt8}, offset::Int64, disp::Ptr{Int64})::Int32

@inline MPI_File_read_shared(file::MPI_File, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_read_shared(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, status::Ptr{MPI_Status})::Int32
@inline MPI_File_write_shared(file::MPI_File, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_write_shared(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, status::Ptr{MPI_Status})::Int32
@inline MPI_File_iread_shared(file::MPI_File, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, request::Ptr{MPIO_Request}) =
	@symbolcall MPI_File_iread_shared(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, request::Ptr{MPIO_Request})::Int32
@inline MPI_File_iwrite_shared(file::MPI_File, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, request::Ptr{MPIO_Request}) =
	@symbolcall MPI_File_iwrite_shared(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, request::Ptr{MPIO_Request})::Int32
@inline MPI_File_read_ordered(file::MPI_File, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_read_ordered(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, status::Ptr{MPI_Status})::Int32
@inline MPI_File_write_ordered(file::MPI_File, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_write_ordered(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32, status::Ptr{MPI_Status})::Int32
@inline MPI_File_seek_shared(file::MPI_File, offset::MPI_Offset, whence::Int32) =
	@symbolcall MPI_File_seek_shared(file.x::Ptr{UInt8}, offset::Int64, whence::Int32)::Int32
@inline MPI_File_get_position_shared(file::MPI_File, offset::Ptr{MPI_Offset}) =
	@symbolcall MPI_File_get_position_shared(file.x::Ptr{UInt8}, offset::Ptr{Int64})::Int32

@inline MPI_File_read_at_all_begin(file::MPI_File, offset::MPI_Offset, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype) =
	@symbolcall MPI_File_read_at_all_begin(file.x::Ptr{UInt8}, offset::Int64, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32)::Int32
@inline MPI_File_read_at_all_end(file::MPI_File, buf::Ptr{Nothing}, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_read_at_all_end(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, status::Ptr{MPI_Status})::Int32
@inline MPI_File_write_at_all_begin(file::MPI_File, offset::MPI_Offset, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype) =
	@symbolcall MPI_File_write_at_all_begin(file.x::Ptr{UInt8}, offset::Int64, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32)::Int32
@inline MPI_File_write_at_all_end(file::MPI_File, buf::Ptr{Nothing}, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_write_at_all_end(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, status::Ptr{MPI_Status})::Int32
@inline MPI_File_read_all_begin(file::MPI_File, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype) =
	@symbolcall MPI_File_read_all_begin(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32)::Int32
@inline MPI_File_read_all_end(file::MPI_File, buf::Ptr{Nothing}, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_read_all_end(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, status::Ptr{MPI_Status})::Int32
@inline MPI_File_write_all_begin(file::MPI_File, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype) =
	@symbolcall MPI_File_write_all_begin(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32)::Int32
@inline MPI_File_write_all_end(file::MPI_File, buf::Ptr{Nothing}, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_write_all_end(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, status::Ptr{MPI_Status})::Int32

@inline MPI_File_read_ordered_begin(file::MPI_File, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype) =
	@symbolcall MPI_File_read_ordered_begin(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32)::Int32
@inline MPI_File_read_ordered_end(file::MPI_File, buf::Ptr{Nothing}, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_read_ordered_end(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, status::Ptr{MPI_Status})::Int32
@inline MPI_File_write_ordered_begin(file::MPI_File, buf::Ptr{Nothing}, count::Int32, datatype::MPI_Datatype) =
	@symbolcall MPI_File_write_ordered_begin(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, count::Int32, datatype.x::UInt32)::Int32
@inline MPI_File_write_ordered_end(file::MPI_File, buf::Ptr{Nothing}, status::Ptr{MPI_Status}) =
	@symbolcall MPI_File_write_ordered_end(file.x::Ptr{UInt8}, buf::Ptr{Nothing}, status::Ptr{MPI_Status})::Int32

# File atomics
@inline MPI_File_set_atomicity(file::MPI_File, flag::Int32) = @symbolcall MPI_File_set_atomicity(file.x::Ptr{UInt8}, flag::Int32)::Int32
@inline MPI_File_get_atomicity(file::MPI_File, flag::Ptr{Int32}) = @symbolcall MPI_File_get_atomicity(file.x::Ptr{UInt8}, flag::Ptr{Int32})::Int32
@inline MPI_File_sync(file::MPI_File) = @symbolcall MPI_File_sync(file.x::Ptr{UInt8})::Int32

# GPU extensions:
const MPIX_GPU_SUPPORT_CUDA  = 0
const MPIX_GPU_SUPPORT_ZE    = 1
const MPIX_GPU_SUPPORT_HIP   = 2
@inline MPIX_GPU_query_support(gpu_type::Int32, is_supported::Ptr{Int32}) = MPIX_GPU_query_support(gpu_type::Int32, is_supported::Ptr{Int32})::Int32
@inline MPIX_Query_cuda_support() = @symbolcall MPIX_Query_cuda_support()::Int32

# Various utility functions
@inline MPI_Attr_put(comm::MPI_Comm, keyval::Int32, attribute_val::Ptr{Nothing}) =
   @symbolcall MPI_Attr_put(comm.x::UInt32, keyval::Int32, attribute_val::Ptr{Nothing})::Int32
@inline MPI_Attr_get(comm::MPI_Comm, keyval::Int32, attribute_val::Ptr{Nothing}, flag::Ptr{Int32}) =
   @symbolcall MPI_Attr_get(comm.x::UInt32, keyval::Int32, attribute_val::Ptr{Nothing}, flag::Ptr{Int32})::Int32
@inline MPI_Attr_delete(comm::MPI_Comm, keyval::Int32) =
   @symbolcall MPI_Attr_delete(comm.x::UInt32, keyval::Int32)::Int32
@inline MPI_Topo_test(comm::MPI_Comm, status::Ptr{Int32}) =
   @symbolcall MPI_Topo_test(comm.x::UInt32, status::Ptr{Int32})::Int32
@inline MPI_Cart_create(comm_old::MPI_Comm, ndims::Int32, dims::Ptr{Int32}, periods::Ptr{Int32}, reorder::Int32, comm_cart::Ptr{MPI_Comm}) =
   @symbolcall MPI_Cart_create(comm_old.x::UInt32, ndims::Int32, dims::Ptr{Int32}, periods::Ptr{Int32}, reorder::Int32, comm_cart::Ptr{MPI_Comm})::Int32
@inline MPI_Dims_create(nnodes::Int32, ndims::Int32, dims::Ptr{Int32}) =
   @symbolcall MPI_Dims_create(nnodes::Int32, ndims::Int32, dims::Ptr{Int32})::Int32
@inline MPI_Graph_create(comm_old::MPI_Comm, nnodes::Int32, indx::Ptr{Int32}, edges::Ptr{Int32}, reorder::Int32, comm_graph::Ptr{MPI_Comm}) =
   @symbolcall MPI_Graph_create(comm_old.x::UInt32, nnodes::Int32, indx::Ptr{Int32}, edges::Ptr{Int32}, reorder::Int32, comm_graph::Ptr{MPI_Comm})::Int32
@inline MPI_Graphdims_get(comm::MPI_Comm, nnodes::Ptr{Int32}, nedges::Ptr{Int32}) =
   @symbolcall MPI_Graphdims_get(comm.x::UInt32, nnodes::Ptr{Int32}, nedges::Ptr{Int32})::Int32
@inline MPI_Graph_get(comm::MPI_Comm, maxindex::UInt32, maxedges::Int32, indx::Ptr{Int32}, edges::Ptr{Int32}) =
   @symbolcall MPI_Graph_get(comm.x::UInt32, maxindex::UInt32, maxedges::Int32, indx::Ptr{Int32}, edges::Ptr{Int32})::Int32
@inline MPI_Cartdim_get(comm::MPI_Comm, ndims::Ptr{Int32}) =
   @symbolcall MPI_Cartdim_get(comm.x::UInt32, ndims::Ptr{Int32})::Int32
@inline MPI_Cart_get(comm::MPI_Comm, maxdims::Int32, dims::Ptr{Int32}, periods::Ptr{Int32}, coords::Ptr{Int32}) =
   @symbolcall MPI_Cart_get(comm.x::UInt32, maxdims::Int32, dims::Ptr{Int32}, periods::Ptr{Int32}, coords::Ptr{Int32})::Int32
@inline MPI_Cart_rank(comm::MPI_Comm, coords::Ptr{Int32}, rank::Ptr{Int32}) =
   @symbolcall MPI_Cart_rank(comm.x::UInt32, coords::Ptr{Int32}, rank::Ptr{Int32})::Int32
@inline MPI_Cart_coords(comm::MPI_Comm, rank::Int32, maxdims::Int32, coords::Ptr{Int32}) =
   @symbolcall MPI_Cart_coords(comm.x::UInt32, rank::Int32, maxdims::Int32, coords::Ptr{Int32})::Int32
@inline MPI_Graph_neighbors_count(comm::MPI_Comm, rank::Int32, nneighbors::Ptr{Int32}) =
   @symbolcall MPI_Graph_neighbors_count(comm.x::UInt32, rank::Int32, nneighbors::Ptr{Int32})::Int32
@inline MPI_Graph_neighbors(comm::MPI_Comm, rank::Int32, maxneighbors::Int32, neighbors::Ptr{Int32}) =
   @symbolcall MPI_Graph_neighbors(comm.x::UInt32, rank::Int32, maxneighbors::Int32, neighbors::Ptr{Int32})::Int32
@inline MPI_Cart_shift(comm::MPI_Comm, direction::Int32, disp::Int32, rank_source::Ptr{Int32}, rank_dest::Ptr{Int32}) =
   @symbolcall MPI_Cart_shift(comm.x::UInt32, direction::Int32, disp::Int32, rank_source::Ptr{Int32}, rank_dest::Ptr{Int32})::Int32
@inline MPI_Cart_sub(comm::MPI_Comm, remain_dims::Ptr{Int32}, newcomm::Ptr{MPI_Comm}) =
   @symbolcall MPI_Cart_ub(comm.x::UInt32, remain_dims::Ptr{Int32}, newcomm::Ptr{MPI_Comm})::Int32
@inline MPI_Cart_map(comm::MPI_Comm, ndims::Int32, dims::Ptr{Int32}, periods::Ptr{Int32}, newrank::Ptr{Int32}) =
   @symbolcall MPI_Cart_map(comm.x::UInt32, ndims::Int32, dims::Ptr{Int32}, periods::Ptr{Int32}, newrank::Ptr{Int32})::Int32
@inline MPI_Graph_map(comm::MPI_Comm, nnodes::Int32, indx::Ptr{Int32}, edges::Ptr{Int32}, newrank::Ptr{Int32}) =
   @symbolcall MPI_Graph_map(comm.x::UInt32, nnodes::Int32, indx::Ptr{Int32}, edges::Ptr{Int32}, newrank::Ptr{Int32})::Int32
@inline MPI_Get_processor_name(name::Ptr{UInt8}, resultlen::Ptr{Int32}) =
   @symbolcall MPI_Get_processor_name(name::Ptr{UInt8}, resultlen::Ptr{Int32})::Int32
@inline MPI_Get_version(version::Ptr{Int32}, subversion::Ptr{Int32}) =
   @symbolcall MPI_Get_version(version::Ptr{Int32}, subversion::Ptr{Int32})::Int32
@inline MPI_Get_library_version(version::Ptr{UInt8}, resultlen::Ptr{Int32}) =
   @symbolcall MPI_Get_library_version(version::Ptr{UInt8}, resultlen::Ptr{Int32})::Int32
@inline MPI_Errhandler_free(errhandler::Ptr{MPI_Errhandler}) =
   @symbolcall MPI_Errhandler_free(errhandler::Ptr{MPI_Errhandler})::Int32
@inline MPI_Error_string(errorcode::Int32, string::Ptr{UInt8}, resultlen::Ptr{Int32}) =
   @symbolcall MPI_Error_string(errorcode::Int32, string::Ptr{UInt8}, resultlen::Ptr{Int32})::Int32
@inline MPI_Error_class(errorcode::Int32, errorclass::Ptr{Int32}) =
   @symbolcall MPI_Error_class(errorcode::Int32, errorclass::Ptr{Int32})::Int32


end # module
