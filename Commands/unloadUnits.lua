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
		}
	}
end

--sometimes it takes a few frames before the queue for transporter registers the unload command
beforeQueueKicksInCooldown = 2 
command_issued = false
function Run(self, units, parameter)
	local transporterId = parameter.transporter
    local location = parameter.location

    if not command_issued then
        Spring.GiveOrderToUnit(transporterId, CMD.UNLOAD_UNITS, {location.x, location.y, location.z, 100}, {})
        command_issued = true
    end

    if #Spring.GetUnitCommands(transporterId) == 0 then
        if beforeQueueKicksInCooldown > 0 then
            beforeQueueKicksInCooldown = beforeQueueKicksInCooldown - 1
            return RUNNING
        end
        return SUCCESS
    else 
        beforeQueueKicksInCooldown = 0
        return RUNNING
    end
end

function Reset(self)
    beforeQueueKicksInCooldown = 2
    command_issued = false
end
