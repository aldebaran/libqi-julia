
export Object, call

type Object
  o::Ptr{Void}
end

function createTupleValue(args...)
  ccall((:qi_value_create, "libqic"), Value, (Ptr{Uint8},), "()")
end

function call(o::Object, name::String, args...)
  println("Calling method:", name, args)

  valargs = createTupleValue(args...)

  return await(ccall((:qi_object_call, "libqic"), Future, (Ptr{Void}, Ptr{Uint8}, Value), o.o, name, valargs))
end
