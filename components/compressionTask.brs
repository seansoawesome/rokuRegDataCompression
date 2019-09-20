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
    tree_root = createTree(symbolFrequency)
    ? "--------------print tree--------------"
    recursivePrint(tree_root)
    ? "--------------print tree--------------"
    m.dictionary = CreateObject("roAssociativeArray")
    m.flipFix = false
    assiginBits(tree_root, "")
    ? "--------------char binary assignment--------------"
    for each w in m.dictionary.items()
      ? w.key, w.value
    end for
    ? "--------------char binary assignment--------------"
    enc = encode(data)
    ? enc
    return "done"
end function

Sub printArray(o as Dynamic) as void
    ? type(o)
    for each i in o
        ? i.key, i.value
    end for
end sub

Sub recursivePrint(root as Object)
  if not root = invalid
      ? "    " root.value, root.key
      recursivePrint(root.l)
      recursivePrint(root.r)
  end if
end sub

Function sortArr(o as Object) as Dynamic
    ar = CreateObject("roArray", o.count(), true)
    for each i in o.items()
        ar.push({key: i.key, value: i.value})
    end for
    ar.sortBy("value", "r")
    return ar
end Function

Function charCount(data as String) as Object
    f = CreateObject("roAssociativeArray")
    for each c in data.split("")
        ' check if new line
        if Asc(c) = 10 then c = "\n"
        if Asc(c) = 32 then c = "space"
        incrementVal = 1
        if f.DoesExist(c)
          incrementVal = f.LookUp(c) + 1
        end if
        f.AddReplace(c, incrementVal)
    end for
    return f
end function

Function createTree(o as Object) as Object
    ar = o
    ' While there is more than one node
    while ar.count() > 1
        ' remove two lowest nodes
        l = ar.pop()
        r = ar.pop()
        ' if r = invalid then r = {key: "null", value: 0}
        ' add new node to queue and internal node with children
        ar.push({key: "internal node", value: l.value + r.value, l: l, r: r})
        ar.sortBy("value", "r")
    end while
    root = ar.pop()
    return root
end Function

Function assiginBits(root as Object, bits as String) as Void
    if not root = invalid
        ? root.key, bits
        if not root.key = "internal node" then m.dictionary.addReplace(root.key, bits)
        if root.key = "internal node" and bits ="1" then m.flipFix = true
        if not m.flipFix
          assiginBits(root.r,bits + "0")
          assiginBits(root.l,bits + "1")
        else
          assiginBits(root.r,bits + "1")
          assiginBits(root.l,bits + "0")
        end if
        ' assiginBits(root.r,bits + "0")
    end if
end Function

Function encode(s as String) as String
  encoded = ""
  for each c in s.split("")
    if Asc(c) = 10 then c = "\n"
    if Asc(c) = 32 then c = "space"
    encoded = encoded + m.dictionary.lookup(c)
  end for
  return encoded
end Function
