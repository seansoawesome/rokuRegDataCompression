function init()
  m.port = createobject("roMessagePort")
  m.top.observefield("request", m.port)
  m.top.functionName = "mainThread"
end function

function mainThread()
    while true
        msg = wait(0, m.port)
        mt = type(msg)
        compressionInput(msg.getData())
    end while
end function

function compressionInput(context as Object)
    context = m.top.request.context
    parameters = context.parameters
    command = parameters.command
    if command = "encode"
        ? "< Encoding data: " parameters.data
        context.response = {"encoded" : encodeData(parameters.data) }
    else if command = "decode"
    '     ? "< Writing (" parameters.key " , " parameters.value ") in " parameters.section
    '     RegWrite(parameters.key, parameters.value, parameters.section)
    ' else if command = "delete"
    '     RegDelete(parameters.key, parameters.section)
    ' else if command = "deleteRegistry"
    '     ? "< Deleting the entire sample registry section"
    '     deleteRegistry()
    end if
end function

Function encodeData(data as String) as String
    if data = invalid or data = "" then return "invalid"
    symbolFrequency = charCount(data)

    return "done"
end function

Sub printAssocArray(o as Object) as void
    for each i in symbolFrequency.keys()
        ? i
    end for
end sub

Function sortAssocArray(o as Object) as Void
end Function

Function charCount(data as String) as Object
    f = CreateObject("roAssociativeArray")
    for each c in data.split("")
        incrementVal = 1
        if f.DoesExist(c)
          incrementVal = f.LookUp(c) + 1
        end if
        f.AddReplace(c, incrementVal)
    end for

    return f
end function
