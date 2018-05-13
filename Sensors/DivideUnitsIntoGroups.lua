local sensorInfo = {
	name = "Divide units into groups",
	desc = "Divides units[] into a number of groups 'randomly'.",
	author = "Petrroll",
	date = "2018-05-13",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- actual, no caching

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
return function(numerOfGroups, unitsToDivide)
    unitsToDivide = unitsToDivide or units

    local groups = {}
    for x=1, unitsToDivide.length do
        local groupIndex = (x % numerOfGroups) + 1
        if groups[groupIndex] == nil then groups[groupIndex] = {} end
        groups[groupIndex][#groups[groupIndex] + 1] = unitsToDivide[x]
    end

	return groups

end