
export Future, await

typealias Future Ptr{Void}

const FutureTimeoutInfinite = 0x7fffffff


function await_notify_cb(f::Future, data::Ptr{Void})
    println("AWAIIT")
    c = unsafe_pointer_to_objref(data)::Condition
    println("notify")
    notify(c, 42)
    println("notify done:", c)
    return
end

function await(f::Future)

    #THIS CODE DO NOT WORK ATM
    # c = Condition()

    # println("cond:", c)


    # mycb = cfunction(await_notify_cb, Void, (Future, Ptr{Void}))

    # ccall((:qi_future_add_callback, "libqic"), Void, (Future, Ptr{Void}, Ptr{Void}), f, mycb, pointer_from_objref(c))

    # #register a callback on the future
    # #wait for the condition
    # println("wait c'est parti")
    # wait(c)  #yield to julia

    # println("WHOUUUUUUUUHOUUUUU WAITED")

    hasValue = ccall((:qi_future_has_value, "libqic"), Int, (Future, Int), f, FutureTimeoutInfinite)
    if hasValue > 0
      toJulia(ccall((:qi_future_get_value, "libqic"), Ptr{Void}, (Future,), f))
    else
      error(bytestring(ccall((:qi_future_get_error, "libqic"), Ptr{Uint8}, (Future,), f)))
    end
end
