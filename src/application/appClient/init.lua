local Promises
local app

Promises = require(script.Parent.Parent._index['@1.00'].Promise)

app = {}
_G['ports'] = {}
local express = script.Parent.Parent
local services = express:WaitForChild('services')

function app.connectServer()
	return Promises.new(function(Resolve,Reject,OnCancel)
		local result = services.utility.remote.updater:InvokeServer()
		if result then
			for port,remote in pairs(result) do
				_G.ports[tonumber(port)] ={
					remote = remote,
					routes = {}
				}
			end
			Resolve(_G.ports)
		end
	end)
end

function app.request(port,reqObject)
	return Promises.new(function(Resolve,Reject,OnCancel)
		print(_G.ports)
		_G.ports[port].remote:FireServer(reqObject)
		Resolve(port)
	end)
end

function app.response()
	
end

return app