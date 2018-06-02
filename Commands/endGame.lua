function getInfo()
	return {
		onNoUnits = RUNNING, -- instant success
		tooltip = "Ends game.",
		parameterDefs = {}
	}
end

-- get madatory module operators
VFS.Include("modules.lua") -- modules table
VFS.Include(modules.attach.data.path .. modules.attach.data.head) -- attach lib module

-- get other madatory dependencies
attach.Module(modules, "message") -- communication backend load

function Run(self, unitIds, p)


	message.SendRules({
        subject = "manualMissionEnd",
        data = {},
    })
	return SUCCESS
end

function Reset(self)
end
