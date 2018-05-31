local sensorInfo = {
	name = "Position",
	desc = "Return position of the unit specified by uid.",
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

-- speedups
local SpringGetUnitPosition = Spring.GetUnitPosition

-- @description return static position of the first unit
return function(uid)
	local x,y,z = SpringGetUnitPosition(uid)
	return Vec3(x,y,z)
end