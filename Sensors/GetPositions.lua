local sensorInfo = {
	name = "Positions",
	desc = "Return positions of all units keyed by their uid.",
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

-- @description returns map of positions of all units keyed by their uid
return function(uids)

	positions = {}
	for i=1,#uids do 
		local uid = uids[i]
		local x,y,z = SpringGetUnitPosition(uid)
		positions[uid] = Vec3(x,y,z)
	end

	return positions
end