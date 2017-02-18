local FileHandler = {}

function FileHandler.init()
  local fileHandler = {}
  
  function fileHandler.exists(name)
    local file = io.open("assets/files/" .. name, "r")
    
    if file then
      file:close()
      return true
    else
      return false
    end
  end
  
  function fileHandler.read(name)
    if fileHandler.exists(name) then
      local file = io.open("assets/files/" .. name, "r")
      local contents = file:read("*all")
      file:close()
      return contents
    else 
      return nil
    end
  end
  
  function fileHandler.write(name, data)
    local file = io.open("assets/files/" .. name, "w")
    file:write(tostring(data))
    file:close()
  end
  
  return fileHandler
end

return FileHandler