
include("object.jl")
include("future.jl")


typealias Value Ptr{Void}
typealias Type Ptr{Void}

const QI_TYPE_KIND_INVALID  = -1
const QI_TYPE_KIND_UNKNOWN  = 0
const QI_TYPE_KIND_VOID     = 1
const QI_TYPE_KIND_INT      = 2
const QI_TYPE_KIND_FLOAT    = 3
const QI_TYPE_KIND_STRING   = 4
const QI_TYPE_KIND_LIST     = 5
const QI_TYPE_KIND_MAP      = 6
const QI_TYPE_KIND_OBJECT   = 7
const QI_TYPE_KIND_POINTER  = 8
const QI_TYPE_KIND_TUPLE    = 9
const QI_TYPE_KIND_DYNAMIC  = 10
const QI_TYPE_KIND_RAW      = 11
const QI_TYPE_KIND_ITERATOR = 13
const QI_TYPE_KIND_FUNCTION = 14
const QI_TYPE_KIND_SIGNAL   = 15
const QI_TYPE_KIND_PROPERTY = 16


#TODO: remove me
function signature(t::DataType)
    if t === Int
            "l"
    elseif t === Uint
            "L"
    elseif t === String
            "s"
    else
            error("Signature not implemented")
    end
end




function toJulia(v::Value)

  if v == 0
    error("Invalid null value")
  end
  kind = ccall((:qi_value_get_kind, "libqic"), Int32, (Value,), v)
  t    = ccall((:qi_value_get_type, "libqic"), Type, (Value,), v)

  println("Kind:", kind)
  if kind == QI_TYPE_KIND_INVALID
    error("Invalid Value")
  elseif kind == QI_TYPE_KIND_VOID
    return ()
  elseif kind == QI_TYPE_KIND_INT
    #TODO: be more extensive
    signed = ccall((:qi_type_is_signed, "libqic"), Int32, (Type,), t)
    if signed
      return ccall((:qi_value_get_int64, "libqic"), Int64, (Value,), v)
    else
      return ccall((:qi_value_get_uint64, "libqic"), Uint64, (Value,), v)
    end
  elseif kind == QI_TYPE_KIND_FLOAT
    return ccall((:qi_value_get_double, "libqic"), Float64, (Value,), v)
  elseif kind == QI_TYPE_KIND_STRING
    return bytestring(  ccall((:qi_value_get_string, "libqic"), Ptr{Uint8}, (Value,), v) )
  elseif kind == QI_TYPE_KIND_OBJECT || kind == QI_TYPE_KIND_DYNAMIC
    obj = ccall((:qi_value_get_object, "libqic"), Ptr{Void}, (Value,), v)
    return Object(obj)
  else
    error("type conversion not implemented for this kind: ", kind)
  end
end
