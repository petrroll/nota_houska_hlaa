local sensorInfo = {
	name = "Switch keys and values",
	desc = "Switches keys and values in lua map'.",
	author = "Petrroll",
	date = "2018-05-13",
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

-- @description divides units into a number of groups
return function(inputMap)

    local switchedMap = {}
    for k, v in pairs(inputMap) do
        switchedMap[v] = k
    end

	return switchedMap

end