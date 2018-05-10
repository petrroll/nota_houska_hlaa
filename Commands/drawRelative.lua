function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Draws a line relative to a specified position.",
		parameterDefs = {
			{ 
				name = "position",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{ 
				name = "relativeVector", -- relative formation
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "Vec3(1, 0, 1)",
			},
		}
	}
end

-- Requires exampleDebug_update function for the drawing itself. 
function Run(self, units, parameter)
	local unitID = units[1]
	local linePos = {	-- data
		startPos = parameter.position, 
		endPos = parameter.position + parameter.relativeVector
	}
	if (Script.LuaUI('exampleDebug_update')) then
	Script.LuaUI.exampleDebug_update(
		unitID, -- key
		linePos -- data
	)
	end
	return SUCCESS
end


function Reset(self)
end
