function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Draws short line marks at all specified locations.",
		parameterDefs = {
			{ 
				name = "locations",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{ 
				name = "linesBaseId",
				variableType = "number",
				componentType = "editBox",
				defaultValue = "1",
			},
		}
	}
end


-- Requires exampleDebug_update function for the drawing itself. 
function Run(self, units, parameter)
	local idBase = parameter.linesBaseId
	for id, loc in pairs(parameter.locations) do
		local linePos = {	-- data
			startPos = loc - Vec3(5, 0, 0), 
			endPos = loc + Vec3(5, 0, 0)
		}
		if (Script.LuaUI('exampleDebug_update')) then
			Script.LuaUI.exampleDebug_update(
				idBase+id, -- key
				linePos -- data
			)
		end
	end
	return SUCCESS
end


function Reset(self)

end
