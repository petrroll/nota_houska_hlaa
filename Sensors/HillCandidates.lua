local sensorInfo = {
	name = "HillCandidates",
	desc = "Gets all points that can potentially be hill candidates.",
	author = "Petrroll",
	date = "2018-05-10",
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

-- @description return all points that could be considered hills (their height > 2/3 lowest<>highest)
return function(lowestHighestTresholdRatio, partioningDensity)
	lowestHighestTresholdRatio = lowestHighestTresholdRatio or 2/3
	partioningDensity = partioningDensity or 100

	local sizeX = Game.mapSizeX
 	local sizeY = Game.mapSizeZ

	local lowestHight, highestHight = Spring.GetGroundExtremes()
	local heightTresholdForHill = lowestHight + (highestHight - lowestHight) * lowestHighestTresholdRatio

	local hills = {}
	local hillId = 1

	local unitID = units[1]
	for x=0, sizeX, sizeX / 100 do
		for y=0, sizeY, sizeY / 100 do
			local height = Spring.GetGroundOrigHeight(x, y)
			if height > heightTresholdForHill then
				hills[hillId] = Vec3(x, height, y)
				hillId = hillId + 1
			end
		end
	end

	return hills

end