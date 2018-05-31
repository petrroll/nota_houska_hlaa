function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Loads all units to transporter.",
		parameterDefs = {
			{ 
				name = "transporter",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{ 
				name = "location", 
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{ 
				name = "useQueue",
				variableType = "expression",
				componentType = "checkBox",
				defaultValue = "false",
			}
		}
	}
end

SpringGiveOrderToUnit = Spring.GiveOrderToUnit
SpringGetUnitCommands = Spring.GetUnitCommands

commands_issued = false
function Run(self, units, parameter)
	local transportIds = parameter.transporter
	local location = parameter.location
	
	local useQueue = parameter.useQueue
	local modifier = {}

	if useQueue then modifier = {"shift"} end
	if type(transportIds) == "number" then transportIds = {transportIds} end

	if not commands_issued then
		for tKey, tId in pairs(transportIds) do		
			SpringGiveOrderToUnit(tId, CMD.UNLOAD_UNITS, {location.x, location.y, location.z, 100}, modifier)
		end

		commands_issued = true
		return RUNNING
    end

	for tKey, tId in pairs(transportIds) do	
		if SpringGetUnitCommands(tId) ~= nil and #SpringGetUnitCommands(tId) > 0 then
			return RUNNING
		end
	end	

	return SUCCESS

end

function Reset(self)
	commands_issued = false
end
