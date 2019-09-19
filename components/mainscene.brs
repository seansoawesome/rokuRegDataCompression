function init()
  ' m.top.setFocus(true)
  m.myLabel = m.top.findNode("myLabel")

  m.registryTask = CreateObject("roSGNode", "regTask")
  m.registryTask.control = "run"

  m.compTask = CreateObject("roSGNode", "compressionTask")
  m.compTask.control = "run"

  m.data = ReadAsciiFile("pkg:/tmp/sample.txt")
  ? m.data
  m.myLabel.text = "Data to be encoded: " + chr(10) + m.data
  makeRequest("compress", {command: "encode", data: m.data}, "onEncodeComplete")
end function

function onEncodeComplete()
end function

function makeRequest(reqType as String, parameters as Object, callback as String)
    context = createObject("RoSGNode","Node")
    if type(parameters)="roAssociativeArray"
        context.addFields({parameters: parameters, response: {}})
        context.observeField("response", callback) ' response callback is request-specific
        if reqType = "registry"
            m.regTask.request = {context: context}
        else if reqType = "compress"
            m.compTask.request = {context: context}
        end if
    end if
end function
