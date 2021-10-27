local express = {}

setmetatable(express,{
	__call = function()
		local runservice = game:GetService('RunService')
		if runservice:IsServer() then
			return require(script.application.appServer)
		elseif runservice:IsClient() then
			script.application.appServer:Destroy()
			return require(script.application.appClient)
		end
	end,
})

return express