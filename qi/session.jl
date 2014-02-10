
export Session, connect, service

include("future.jl")
include("type.jl")
include("object.jl")

type Session
  p::Ptr{Void}

  #TODO: add a finalizer
  Session() = new(ccall((:qi_session_create, "libqic"), Ptr{Void}, ()))
end

function connect(s::Session, addr::String)
  println("Connecting to:", addr)
  await(ccall((:qi_session_connect, "libqic"), Future, (Ptr{Void}, Ptr{Uint8}), s.p, addr))
end

function service(s::Session, srv::String)
  println("Getting Service:", srv)
  await(ccall((:qi_session_get_service, "libqic"), Future, (Ptr{Void}, Ptr{Uint8}), s.p, srv))
end


