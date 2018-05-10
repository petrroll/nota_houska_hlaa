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
			{ 
				name = "lineId",
				variableType = "number",
				componentType = "editBox",
				defaultValue = "1",
			},
		}
	}
end

-- Requires exampleDebug_update function for the drawing itself. 
function Run(self, units, parameter)
	local lineId = parameter.lineId
	local linePos = {	-- data
		startPos = parameter.position, 
		endPos = parameter.position + parameter.relativeVector
	}
	if (Script.LuaUI('exampleDebug_update')) then
	Script.LuaUI.exampleDebug_update(
		lineId, -- key
		linePos -- data
	)
	end
	return SUCCESS
end


function Reset(self)
end
