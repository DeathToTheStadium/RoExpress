local express = {}
local Promise = require(script.utility.Promise)

local function CreateServicer()
	local exist = (script:FindFirstChild('servicer'))
	if not exist then
		local servicer = Instance.new("Folder",script)
		servicer.Name = 'servicer'
		local ports = Instance.new('Folder',servicer)
		ports.Name = 'ports'
	end
end

express.router = {}

setmetatable(express,{
	__call = function()
		local runservice = game:GetService('RunService')
		if runservice:IsServer() then
			CreateServicer()
			return require(script.application.appServer)
		elseif runservice:IsClient() then
			local appserver = script.application:FindFirstChild('appServer')
			if appserver then
				appserver:Destroy()
			end
			return require(script.application.appClient)
		end
	end,
})


return express