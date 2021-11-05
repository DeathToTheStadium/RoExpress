local appServer,props,methods = {},{},{}
local Promise = require(script.Parent.Parent.utility.Promise)
local MainModule = script.Parent.Parent
local ReadExplorer = {
	workspace  = workspace:GetDescendants(),
	replicated = game:GetService("ReplicatedStorage"):GetDescendants()
}

props.ports = {}
props.layers = {}
--Instantiates Remote Port

methods.setRemote = function(port)
	local remote
	return Promise.async(function(Resolve,Reject)
		assert(type(port) == 'number',error('port must be a number'))
		local Is = (props[ports][port] == nil)
		if Is then
			remote = Instance.new("RemoteEvent",MainModule.servicer.ports)
			props['ports'][port] = {
				remote = remote,
				subPorts = {} 
			}
			Resolve()
		else
			Reject('Can Not Create duplicate Remotes')
		end
	end)
end

-- Gets a remote Port or an external remote and Returns it 

--pass in a port or a name
methods.getRemote = function(name)
	local remotes = {}
	local lookFor = function(IsAFilter,tab,name)
		for index,value in pairs(tab) do
			if typeof(value) =='table' then
				lookFor(IsAFilter,value,name)
			elseif typeof(value) == 'Instance' then
				if value:IsA(IsAFilter) then
					remotes[Value.name] = value
				end
			end
		end
		return remotes[name]
	end
	local Isport = (type(name) == 'number')
	return Promise.async(function(Resolve,Reject)
		if Isport == true then
			local ports = MainModule.servicer.ports:GetChildren()
			for _,remote in pairs(ports) do
				if remote:IsA('RemoteEvent') and remote.Name == name then
					Resolve(remote)
					break
				end
			end
		else
			Resolve(lookFor('RemoteEvent',ReadExplorer,name))
		end	
	end)
end


methods.setbind = function(bindingObject)
	local remote,Is
	Is = (props['ports'][bindingObject.port] == nil)
	return Promise.async(function(Resolve,Reject)
		if Is ~= nil then
			remote = Instance.new('RemoteFunction',props['ports'][bindingObject.port].remote)
			remote.Name = bindingObject.name
			props['ports'][bindingObject.port].subports[remote.Name] = {
				event = remote,
				callBack = bindingObject.callBack
			}
			resolve()
		end
	end)
end

methods.setbind({
	name = 'string',
	port = remotePort, -- Parents your remoteFunctions to this 
	callback = function(req,res)
	end
})


methods.get = function(port,route)
	return Promise.new(function(Resolve,Reject)
		-- will work on this tomorow 
	end)
end

methods.post = function()
	
end

methods.put = function()

end

methods.delete = function()

end

methods.sanity = function()
	
end

methods.send = function(port)
	
end

methods.sendAll = function(port)
	
end

methods.setSignal = function()

end

methods.getSignal = function()

end

methods.enable = function()
end

methods.use = function()

end

methods.listen = function()
	
end

return setmetatable(appServer,{
	__index = function(tab,key)
		local method = methods[key]
		if method ~= nil then
			return method
		else
			error("["..key:upper().."]".. "is not a indexable method")
		end
	end
})

