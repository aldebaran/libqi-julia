
export Future, await

typealias Future Ptr{Void}

const FutureTimeoutInfinite = 0x7fffffff


function await_notify_cb(f::Future, data::Ptr{Void})
    println("AWAIIT")
    c = data::Condition
    notify(c)
    return
end

function await(f::Future)

    c = Condition()


    mycb = cfunction(await_notify_cb, Void, (Future, Ptr{Void}))

    ccall((:qi_future_add_callback, "libqic"), Void, (Future, Ptr{Void}, Ptr{Void}), f, mycb, &c)

    #register a callback on the future
    #wait for the condition
    wait(c)  #yield to julia

    hasValue = ccall((:qi_future_has_value, "libqic"), Int, (Future, Int), f, FutureTimeoutInfinite)
    if hasValue > 0
      toJulia(ccall((:qi_future_get_value, "libqic"), Ptr{Void}, (Future,), f))
    else
      error(bytestring(ccall((:qi_future_get_error, "libqic"), Ptr{Uint8}, (Future,), f)))
    end
end
