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
    ' count the frequency if each char
    symbolFrequency = sortArr(charCount(data))
    printArray(symbolFrequency)
    ' put the sorted arr into a tree
    createTree(symbolFrequency)
    return "done"
end function

Sub printArray(o as Dynamic) as void
    ? type(o)
    for each i in o
        ? i.key, i.value
    end for
end sub

Function sortArr(o as Object) as Dynamic
    ar = CreateObject("roArray", o.count(), true)
    for each i in o.items()
        ar.push({key: i.key, value: i.value})
    end for
    ar.sortBy("value")
    return ar
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

Function createTree(o as Object) as void
    ' ar = CreateObject("roArray", o.count(), true)
    ' ' Create a leaf node for each symbol
    ' for each i in o
    '     ' and add it to the priority queue'
    '     ? "adding element " i.key
    '     ar.push(i)
    ' end for
    ' While there is more than one node
    while o.count() > 1
        ' remove two highest nodes
        l = o.pop()
        r = o.pop()

    end while
end Function
