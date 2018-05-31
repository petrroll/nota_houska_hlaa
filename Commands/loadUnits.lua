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
				name = "unitsToLoad", 
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

function getUnitsVecPocition(uid)
    local pointX, pointY, pointZ = Spring.GetUnitPosition(uid)
    local loc = Vec3(pointX, pointY, pointZ)
    
    return loc
end

firstRun = true
function Run(self, units, parameter)

	local transportIds = parameter.transporter
    local transportedIds = parameter.unitsToLoad

	local useQueue = parameter.useQueue
	local modifier = {}

	if useQueue or not firstRun then modifier = {"shift"} end
	if type(transportIds) == "number" then transportIds = {transportIds} end

    if firstRun then
        local transportsNum = #transportIds
        local currTransportId = 1

        for tKey, tId in pairs(transportedIds) do		
            SpringGiveOrderToUnit(transportIds[currTransportId], CMD.LOAD_UNITS, {tId}, modifier)

            -- We've issued first commands for all transports -> queue the next ones
            if currTransportId >= transportsNum then modifier = {"shift"} end
            currTransportId = (currTransportId % transportsNum) + 1
        end

        firstRun = false
        return RUNNING
    end

	for tKey, tId in pairs(transportIds) do	
		if #SpringGetUnitCommands(tId) > 0 then
			return RUNNING
        end
    end

    return SUCCESS

end

function Reset(self)
    firstRun = true
end
