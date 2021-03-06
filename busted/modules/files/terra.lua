local ret = {}
local ok, terralib = pcall(function() return require 'terralib' end)

local getTrace =  function(filename, info)
  local index = info.traceback:find('\n%s*%[C]')
  info.traceback = info.traceback:sub(1, index)
  return info
end

ret.match = function(busted, filename)
  if ok then
    local path, name, ext = filename:match('(.-)([^\\/\\\\]-%.?([^%.\\/]*))$')
    if ext == 't' then
      return true
    end
  end
  return false
end

ret.load = function(busted, filename)
  local file, err = terralib.loadfile(filename)
  if not file then
    busted.publish({ 'error', 'file' }, { descriptor = 'file', name = filename }, nil, err, {})
  end
  return file, getTrace
end

return ret
