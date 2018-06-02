local sensorInfo = {
	name = "Tst",
	desc = "Sensor for testing purposes.",
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

-- @description tst
return function()
	return {}
end