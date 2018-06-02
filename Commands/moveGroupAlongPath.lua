function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Move a group of units along a path (not in any specified formation).",
		parameterDefs = {
			{ 
				name = "unitsToMove",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{ 
				name = "path",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
		}
	}
end

-- constants
local THRESHOLD = 1024

-- speed-ups
local SpringGetUnitPosition = Spring.GetUnitPosition
local SpringGiveOrderToUnit = Spring.GiveOrderToUnit
local SpringGetUnitHealth = Spring.GetUnitHealth

commandsIssued = false
function Run(self, units, parameter)
	local unitsToMove = parameter.unitsToMove
	local path = parameter.path 
	
	local cmdID = CMD.MOVE

	if not commandsIssued then
		for i=1, #unitsToMove do

			local currUid = unitsToMove[i]
			for j=1, #path do
				SpringGiveOrderToUnit(currUid, cmdID, path[j]:AsSpringVector(), {"shift"})
			end	

		end
		commandsIssued = true
		return RUNNING
	end

	for i=1, #unitsToMove do
		local currUid = unitsToMove[i]
		local pointX, pointY, pointZ = SpringGetUnitPosition(currUid)
		local currUidLoc = Vec3(pointX, pointY, pointZ)

		if currUidLoc:Distance(path[#path]) > THRESHOLD then
			if SpringGetUnitHealth(currUid) ~= nil then
				return RUNNING
			end
		end
	
	end
	return SUCCESS
end


function Reset(self)
	commandsIssued = false
end
