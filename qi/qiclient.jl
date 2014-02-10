##SIMPLE TEST CLIENT

include("qi.jl")
using Qi

s = Session()

println("Connecting SD")
connect(s, "tcp://127.0.0.1:9559")

println("Getting SD")
sd = service(s, "ServiceDirectory")

println("Calling sd.machineId()")
println("mId:", call(sd, "machineId"))

# println("Calling sd.updateServiceInfo()")
# println("mId:", call(sd, "error"))
