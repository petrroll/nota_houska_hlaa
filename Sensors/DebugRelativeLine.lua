local sensorInfo = {
	name = "DrawRelativeLine",
	desc = "Draws a uni-realative debug line",
	author = "Petrroll",
	date = "2018-05-18",
	license = "MIT",
}

-- get madatory module operators
VFS.Include("modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message") -- communication backend load

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

-- @description return current wind statistics
return function(relX, relZ)
	if #units > 0 then
		local unitID = units[1]
		local x,y,z = Spring.GetUnitPosition(unitID)
		if (Script.LuaUI('exampleDebug_update')) then
			Script.LuaUI.exampleDebug_update(
				unitID, -- key
				{	-- data
					startPos = Vec3(x,y,z), 
					endPos = Vec3(x,y,z) + Vec3(relX,0,relZ)
				}
			)
		end
		return {	-- data
					startPos = Vec3(x,y,z), 
					endPos = Vec3(x,y,z) + Vec3(relX,0,relZ)
				}
	end
end