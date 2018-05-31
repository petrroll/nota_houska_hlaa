local sensorInfo = {
	name = "Filter out units in area",
	desc = "Filters out unit ids that corresponds to units in certain area.",
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

local SpringGetUnitPosition = Spring.GetUnitPosition
function GetPosition(uid) 
	local x,y,z = SpringGetUnitPosition(uid)
	return Vec3(x,y,z)
end

-- @description filters out unit ids that corresponds to units in certain area
return function(uids, areaCenter, areaRadius)

	local notFilteredUIds = {}
	local j = 1

	for i=1, #uids do

		local uid = uids[i]
		local unitLoc = GetPosition(uid)

		if areaCenter:Distance(unitLoc) > areaRadius then
			notFilteredUIds[j] = uid
			j = j + 1
		end
	end

	return notFilteredUIds

end