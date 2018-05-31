local sensorInfo = {
	name = "Units to UIds",
	desc = "Converts units map to a map of UIds.",
	author = "Petrroll",
	date = "2018-05-31",
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
return function()

    local uids = {}
    for x=1, units.length do
        uids[x] = units[x]
    end

	return uids

end