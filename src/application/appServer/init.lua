local Promises
local app
local 
Promises = require(script.Parent.Parent._index['@1.00'].Promise)

app = {}
_G['ports'] = {}
local services,portFolder,utility,remote,data,Exist

Exist = script.Parent.Parent:FindFirstChild('services')
if Exist == nil then
	services = Instance.new('Folder',script.Parent.Parent)
	services.Name = 'services'
	portFolder = Instance.new('Folder', services)
	portFolder.Name = 'ports'
	utility = Instance.new('Folder',services)
	utility.Name = "utility"
	remote = Instance.new('Folder',utility)
	remote.Name = "remote"
	data = Instance.new('Folder',utility)
	data.Name = "data"
	updater = Instance.new('RemoteFunction',remote)
	updater.Name = "updater"
	
	isListening = Instance.new('BoolValue',data)
	isListening.Name = 'IsListening'
	isListening.Value = false
else
	services = Exist
	portFolder = services.ports
	utility = services.utility
	remote = utility.remote
	data = utility.data
	updater =  remote.updater
	isListening = data.IsListening
end

function app.setRemote(port)
	local remote
	return Promises.new(function(Resolve,Reject,OnCancel)
		if type(port) ~= 'number' then
			Reject('port Must Be A number')
		end
		if _G.ports[port] == nil then
			remote = Instance.new('RemoteEvent',portFolder)
			remote.Name = port
			_G.ports[port] = {
				routes = {},
				remote = remote
			}
			Resolve(_G.ports[port])
		else
			Reject('Can Not Spawn Duplicate Ports')
		end
	end)
end

function app.get(port,route,callback)
	return Promises.new(function(Resolve,Reject,OnCancel)
		if _G.ports[port].routes[route] == nil then
			if typeof(callback) == 'function' then
				_G.ports[port].routes[route] = callback
				Resolve(_G.ports[port])
			else
				Reject('callback must be a function')
			end
		else
			Reject('Can Only Call same Route For One function')
		end
		
	end)
end

function app.send(port,connObject)
	return Promises.new(function(Resolve)
		_G.ports[port].remote:FireClient(connObject.client,connObject.data)
		if connObject.desciption ~= nil then
			Resolve(connObject.desciption)
		else
			Resolve('sent Data')
		end
	end)
end

function app.listen()
	return Promises.new(function(Resolve,Reject,OnCancel)
		for portNum,port in pairs(_G.ports) do
			port.remote.OnServerEvent:Connect(function(player,data)
				-- Add Check For Cookies
				print(player)
				if port.routes[data.route] then
					port.routes[data.route](data.data)
				end
			end)	
		end
		if isListening.Value == false then
			isListening.Value = true
			isListening.Changed:Connect(function(value)
				value = true
			end)
			updater.OnServerInvoke = function(player)
				local update = {}
				for portNum,port in pairs(_G.ports) do
					update[portNum] = port.remote
				end
				return update
			end
		end
		Resolve(_G.ports)
	end)
end

return app