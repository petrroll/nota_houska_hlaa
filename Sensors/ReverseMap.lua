local sensorInfo = {
	name = "Reverse map",
	desc = "Reverses order of values in map'.",
	author = "Petrroll",
	date = "2018-06-2",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- actual, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end


-- get madatory module operators
VFS.Include("modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

local SpringGetGroundHeight = Spring.GetGroundHeight 

-- @description reverses order of values in map
return function(inputMap)

	local reversedMap = {}
	
	local len = #inputMap
	for i = 1, len do
		reversedMap[i] = inputMap[len - i + 1]
	end

	return reversedMap

end