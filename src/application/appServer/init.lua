local appServer,props,methods,mainModule = {},{},{},script.Parent.Parent
local promise = require(script.Parent.Parent.utility.Promise)

-- props to 
props.ports = {
	[--[[ Port]] 1 ] = {
		[--[[ remote]] 2 ] = '';
		[--[[ bindings]] 3 ] = '';
		[--[[ routes]] 4 ] = {
			['get'] = {
				["remote://myroute/route/:id"] = "callback",
				["remote://myroute/router/:id"] = "callback",
				["remote://myroute/routes/:id"] = "callback",
				["remote://myroute/routed/:id"] = "callback",	
			},
			['post'] = {
				["remote://myroute/route/:id"] = "callback",
				["remote://myroute/router/:id"] = "callback",
				["remote://myroute/routes/:id"] = "callback",
				["remote://myroute/routed/:id"] = "callback",	
			},
			['put'] = {
				["remote://myroute/route/:id"] = "callback",
				["remote://myroute/router/:id"] = "callback",
				["remote://myroute/routes/:id"] = "callback",
				["remote://myroute/routed/:id"] = "callback",	
			},
			['delete'] = {
				["remote://myroute/route/:id"] = "callback",
				["remote://myroute/router/:id"] = "callback",
				["remote://myroute/routes/:id"] = "callback",
				["remote://myroute/routed/:id"] = "callback",	
			}
		};
	}
}
props.sanity = {}
props.portlocation = mainModule:WaitForChild('services').ports

props.connections = {}
methods.setportLocation = function(location)
	return promise.new(function(Resolve,Reject)
		if location:FindFirstAncestorOfClass('Part') or location:IsA('BasePart') then
			warn('setting port location to part can result in accdental remote deletions');
		else
			props.portlocation = location;
		end
	end)
end


--Instantiates Remote Port
methods.setRemote = function(port)
	return promise.new(function(Resolve,Reject)
		local remote = Instance.new("RemoteEvent",props.portlocation);
		remote.Name = port;
		props.ports[port] = {
			remote = remote,
			bindings = {},
			routes = {
				['get'] ={},
				['post'] ={},
				['put'] ={},
				['delete'] ={},
			},
		}
		Resolve()
	end)
end


--returns an Actual remote Object to Allow Custom WorkArounds
methods.getRemote = function(port)
	return promise.new(function(Resolve,Reject)
		if props.ports[port] then
			Resolve(props[port].remote)
		else
			Reject('getRemote error: Remote Does Not Exist ')
		end
	end)
end

--Passes in a binding object which has a port reference
-- Note a port must Exist Before Setting a Bind 

methods.setbind = function(bindObject)
	return promise.new(function(Resolve,Reject)
		local bind, port
		if props.ports[bindingObject.port] then
			port = props.ports[bindingObject.port]
			bind = Instance.new("RemoteFunction",port.remote)
			port.bindings[bindObject.actionName] = {
				bind = bind,
				callback = bindObject.callback
			}
		end
	end)
end

-- methods.setbind({
-- 	actionName = 'string', -- Action Name
-- 	port = remotePort, -- Parents your remoteFunctions to this 
-- 	callback = function(player,body) -- returns Player and Data Object
-- 		return true
-- 	end
-- })


--Accepts get requests from the Client From a Specified Port 
methods.get = function(port,route,callback)
	return promise.new(function(Resolve,Reject)
		if props.ports[port] then
			port = props.ports[port]
			port.routes.get[route] = callback
			Resolve()
		else
			Reject('.get error: Port Doesn\'t Not Exist')
		end
	end)
end


--Accepts Post request from the client the data from this request is in base64
methods.post = function(port,route,callback)
	return promise.new(function(Resolve,Reject)
		if props.ports[port] then
			port = props.ports[port]
			port.routes.post[route] = callback
			Resolve()
		else
			Reject('.post error: Port Doesn\'t Not Exist')
		end
	end)
end

--acceots put request from the client the data from this request is managed by your sanity checks 
-- and will kick a player if 
methods.put = function(port,route,callback)
	return promise.new(function(Resolve,Reject)
		if props.ports[port] then
			port = props.ports[port]
			port.routes.put[route] = callback
			Resolve()
		else
			Reject('.get error: Port Doesn\'t Not Exist')
		end
	end)
end

methods.delete = function(port,route,callback)
	return promise.new(function(Resolve,Reject)
		if props.ports[port] then
			port = props.ports[port]
			port.routes.delete[route] = callback
			Resolve()
		else
			Reject('.get error: Port Doesn\'t Not Exist')
		end
	end)
end

methods.sanity = function(port,callback)
	return promise.new(function(Resolve,Reject)
		if props.ports[port] then
			props.sanity[port][#props.sanity[port] + 1] = callback
			Resolve()
		else
			Reject('Sanity error: Port Does Not Exist')
		end
	end)
end

--Gives a Player another Simple Worker to just use the RBX Api as Is
methods.send = function(port,player,data)
	return promise.new(function(Resolve,Reject)
		if props.ports[port] then
			port =  props.ports[port]
			port.remote:FireClient(player,data)
			Resolve()
		end
	end)
end

methods.sendAll = function(port,data)
	return promise.new(function(Resolve,Reject)
		if props.ports[port] then
			port =  props.ports[port]
			port.remote:FireAllClients(data)
			Resolve()
		end
	end)
end

methods.setSignal = function()
	return promise.new(function(Resolve,Reject)
		-- will work on this tomorow 
	end)
end

methods.getSignal = function()
	return promise.new(function(Resolve,Reject)
		-- will work on this tomorow 
	end)
end

methods.enable = function()
	return promise.new(function(Resolve,Reject)
		-- will work on this tomorow 
	end)
end

methods.use = function()
	return promise.new(function(Resolve,Reject)
		-- will work on this tomorow 
	end)
end

methods.listen = function(port,callback)
	return promise.new(function(Resolve,Reject)
		if props.ports[port] then
			local portnum = port
			port = props.ports[port]
			props.connections[portnum] = port.remote.OnServerEvent:Connect(function(player,req)
			-- Run In Built Sanity Checks
			-- run custom Sanity Checks
			-- Automaticly load All App.used Functions
			-- Call a Route Call Back pass in the request and response objects
			end)
			Resolve()
		else
			Reject('listen error: Port Does Not Exist')
		end
	end)
end

methods.disconnect = function(port)
	return promise.new(function(Resolve,Reject)
		if props.ports[port] then
			props.connections[port]:Disconnect()
			Resolve()
		else
			Reject('disconnect error: Port Does Not Exist')
		end
	end)
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

