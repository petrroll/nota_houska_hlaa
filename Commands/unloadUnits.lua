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
			},
			{ 
				name = "safeUnload",
				variableType = "expression",
				componentType = "checkBox",
				defaultValue = "false",
			}
		}
	}
end

SpringGiveOrderToUnit = Spring.GiveOrderToUnit
SpringGetUnitCommands = Spring.GetUnitCommands
SpringGetUnitIsTransporting = Spring.GetUnitIsTransporting

commands_issued = false
function Run(self, units, parameter)
	local transportIds = parameter.transporter
	local location = parameter.location
	
	local useQueue = parameter.useQueue
	local safeUnload = parameter.safeUnload
	local modifier = {}

	if useQueue then modifier = {"shift"} end
	if type(transportIds) == "number" then transportIds = {transportIds} end

	if not commands_issued then
		for tKey, tId in pairs(transportIds) do
			
			-- hack to mitigate physics bug that causes unloaded towers to drift away
			if safeUnload then
				SpringGiveOrderToUnit(tId, CMD.MOVE, location:AsSpringVector(), modifier)
				SpringGiveOrderToUnit(tId, CMD.TIMEWAIT, { 750 }, CMD.OPT_SHIFT)
				SpringGiveOrderToUnit(tId, CMD.UNLOAD_UNITS, {location.x, location.y, location.z, 256+128}, CMD.OPT_SHIFT)		
			else
				SpringGiveOrderToUnit(tId, CMD.UNLOAD_UNITS, {location.x, location.y, location.z, 100}, modifier)		
			end
			
		end

		commands_issued = true
		return RUNNING
    end

	for tKey, tId in pairs(transportIds) do	
		local transUnits = SpringGetUnitIsTransporting(tId)
		local cmdQ = SpringGetUnitCommands(tId)

		-- running only if some command hasn't been finished & I'm still transporting untis 
		if (transUnits ~= nil and #transUnits > 0) and (cmdQ ~= nil and #cmdQ > 0) then
			return RUNNING
		end
	end	

	return SUCCESS

end

function Reset(self)
	commands_issued = false
end
