##SIMPLE TEST CLIENT

include("qi.jl")
using Qi

s = Session()

connect(s, "tcp://127.0.0.1:9559")
sd = service(s, "ServiceDirectory")


println("mId:", call(sd, "machineId"))

