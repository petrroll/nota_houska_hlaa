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
		}
	}
end

function getUnitsVecPocition(uid)
    local pointX, pointY, pointZ = Spring.GetUnitPosition(uid)
    local loc = Vec3(pointX, pointY, pointZ)
    
    return loc
end

loading = 0
finished = false
beforeQueueKicksInCooldown = 1
function Run(self, units, parameter)
	local transporterId = parameter.transporter
    local transportedIds = parameter.unitsToLoad

    -- keeping altenative method for reference
    -- Spring.GiveOrderToUnit(transporterId, CMD.LOAD_UNITS, {loadPosition.x, loadPosition.y, loadPosition.z, 500}, {})

    if #Spring.GetUnitCommands(transporterId) == 0 then
        if beforeQueueKicksInCooldown > 0 then
            beforeQueueKicksInCooldown = beforeQueueKicksInCooldown - 1
            return RUNNING
        end

        loading = loading + 1
        if loading <= transportedIds.length then
            Spring.Echo("loading")
            Spring.Echo(loading)
            Spring.GiveOrderToUnit(transporterId, CMD.LOAD_UNITS, {transportedIds[loading]}, {})
            beforeQueueKicksInCooldown = 1
        else
            Spring.Echo("finished")
            finished = true
        end
    else
        beforeQueueKicksInCooldown = 0
    end
    

    if finished then return SUCCESS
    else return RUNNING end


end

function Reset(self)
    loading = 0
    finished = false
    beforeQueueKicksInCooldown = 1
end
