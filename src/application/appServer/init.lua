local appServer, props, methods, mainModule = {}, {}, {}, script.Parent.Parent;
local promise, request, response = require(mainModule.utility.Promise), require(mainModule.request),require(mainModule.response)
local helper = require(mainModule.utility.helpers)
-- props to 
props.ports = {
    [ --[[ Port]] 1] = {
        ['remote'] = Instance.new('RemoteEvent',mainModule.servicer.ports),--[[ remote]]
        [ 'bindings'] = {
			['sync'] = {
				['bind'] = Instance.new("RemoteFunction"),
				['callback'] = function(player)
                    return helper.DeepDeleteIndex(props.ports,{
                        'callback',
                        'routes',
                    })
				end
			}
		}, --[[ bindings]] 
        [ 'routes'] = { --[[ routes]] 
            ['get'] = {
                ["remote://route1"] = function(req,res)end,
                ["remote://route2"] = function(req,res)end,
                ["remote://route3"] = function(req,res)end,
                ["remote://route4"] = function(req,res)end
            },
            ['post'] = {
                ["remote://route1"] = function(req,res)end,
                ["remote://route2"] = function(req,res)end,
                ["remote://route3"] = function(req,res)end,
                ["remote://route4"] = function(req,res)end
            },
            ['put'] = {
                ["remote://route1"] = function(req,res)end,
                ["remote://route2"] = function(req,res)end,
                ["remote://route3"] = function(req,res)end,
                ["remote://route4"] = function(req,res)end
            },
            ['delete'] = {
                ["remote://route1"] = function(req,res)end,
                ["remote://route2"] = function(req,res)end,
                ["remote://route3"] = function(req,res)end,
                ["remote://route4"] = function(req,res)end
            }
        }
    }
}
props.ports[1].remote.Name = '1'
props.ports[1].bindings.sync.bind.Parent = props.ports[1].remote
props.ports[1].bindings.sync.bind.Name= "sync"


props.sanity = {}
props.portlocation = mainModule:WaitForChild('servicer').ports

props.connections = {}
props.Events = {
    tamper = Instance.new('BindableEvent'),
    error  = Instance.new('BindableEvent'),
}
methods.setportLocation = function(location)
    return promise.new(function(Resolve, Reject)
        if location:FindFirstAncestorOfClass('Part') or location:IsA('BasePart') then
            warn('setting port location to part can result in accdental remote deletions');
        else
            props.portlocation = location;
        end
    end)
end

-- Instantiates Remote Port
methods.setRemote = function(port)
    return promise.new(function(Resolve, Reject)
        if props.ports[port] == nil then
            local remote = Instance.new("RemoteEvent", props.portlocation);
            remote.Name = port;
            props.ports[port] = {
                remote = remote,
                bindings = {},
                routes = {
                    ['get'] = {},
                    ['post'] = {},
                    ['put'] = {},
                    ['delete'] = {}
                }
            }
            Resolve()
		else
			Reject('setRemote Error: Can Not create Duplicate Ports remote thread has aborted')
        end
    end)
end

-- returns an Actual remote Object to Allow Custom WorkArounds
methods.getRemote = function(port)
    if props.ports[port] then
        return props.ports[port].remote
    else
        warn('getRemote error: Remote Does Not Exist')
    end
    return nil;
end

-- Passes in a binding object which has a port reference
-- Note a port must Exist Before Setting a Bind 

methods.setbind = function(bindObject)
    return promise.new(function(Resolve, Reject)
        local bind, port
        if props.ports[bindObject.port] then
            port = props.ports[bindObject.port]
            bind = Instance.new("RemoteFunction", port.remote)
            bind.Name = bindObject.actionName
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

-- Accepts get requests from the Client From a Specified Port 
methods.get = function(port, route, callback)
    return promise.new(function(Resolve, Reject)
        if props.ports[port] then
            port = props.ports[port]
            port.routes.get[route] = callback
            Resolve()
        else
            Reject('.get error: Port Doesn\'t Not Exist')
        end
    end)
end

-- Accepts Post request from the client the data from this request is in base64
methods.post = function(port, route, callback)
    return promise.new(function(Resolve, Reject)
        if props.ports[port] then
            port = props.ports[port]
            port.routes.post[route] = callback
            Resolve()
        else
            Reject('.post error: Port Doesn\'t Not Exist')
        end
    end)
end

-- acceots put request from the client the data from this request is managed by your sanity checks 
-- and will kick a player if 
methods.put = function(port, route, callback)
    return promise.new(function(Resolve, Reject)
        if props.ports[port] then
            port = props.ports[port]
            port.routes.put[route] = callback
            Resolve()
        else
            Reject('.get error: Port Doesn\'t Not Exist')
        end
    end)
end

methods.delete = function(port, route, callback)
    return promise.new(function(Resolve, Reject)
        if props.ports[port] then
            port = props.ports[port]
            port.routes.delete[route] = callback
            Resolve()
        else
            Reject('.get error: Port Doesn\'t Not Exist')
        end
    end)
end

methods.sanity = function(port, callback)
    return promise.new(function(Resolve, Reject)
        if props.ports[port] then
            props.sanity[port][#props.sanity[port] + 1] = callback
            Resolve()
        else
            Reject('sanity error: Port Does Not Exist')
        end
    end)
end

-- Gives a Player another Simple Worker to just use the RBX Api as Is
methods.send = function(port, player, data)
    return promise.new(function(Resolve, Reject)
        if props.ports[port] then
            port = props.ports[port]
            port.remote:FireClient(player, data)
            Resolve()
        end
    end)
end

methods.sendAll = function(port, data)
    return promise.new(function(Resolve, Reject)
        if props.ports[port] then
            port = props.ports[port]
            port.remote:FireAllClients(data)
            Resolve()
        end
    end)
end

-- Bindable Events
methods.setSignal = function()
    return promise.new(function(Resolve, Reject)
        -- will work on this tomorow 
    end)
end

methods.getSignal = function()
    return promise.new(function(Resolve, Reject)
        -- will work on this tomorow 
    end)
end

methods.enable = function()
    return promise.new(function(Resolve, Reject)
        -- will work on this tomorow 
    end)
end

methods.use = function()
    return promise.new(function(Resolve, Reject)
        -- will work on this tomorow 
    end)
end

--Handles Tamper Events
--OrLogged Errors

methods.handler = function(listenType,callback)
    local handler
    if listenType == nil then
        error('handler error: ListenType Can Not Equal NIL')
    elseif type(listenType) ~= 'string' then
        error('handler error: ListenType Must Be A String')
    else
        if type(callback) ~= 'function' then
            error('handler error: Callback Must Be Specified.')
        end
    end

    if listenType == 'tamper' then
       handler = props.errorEvents.tamper.Event:Connect(callback)
    elseif listenType == 'error' then
        handler = props.errorEvents.error.Event:Connect(callback)
    else
        error('handler error: listenType  mismatched must equal tamper or error')
    end
    return handler
end

methods.listen = function(port, callback)
    local function HandleModuleConnection(player,...)
        local args = {...}
        local reqObject,resObject;
        for pos,data in ipairs(args) do
            if pos == 1 then
                if type(data) ~= 'string' then
                    props.Events.tamper:FireEvent({
                        player = player,
                        tamperType = 'exploiter',
                        tamperMessage = "player Fired mainModule Remote"
                    })
                else
                    -- reqObject = request.received(data,props.ports)
                    -- resObject = {}

                end
            end
        end
    end
    local function HandleDeveloperConnections(player,...)
        local args = {...}
        local reqObject,resObject;
        if #args == 1 and type(args[1]) == 'string' then
            print(args)
            reqObject = request.received(player,args[1],props.ports)
            resObject = {}
            for key,value in pairs(props.ports[reqObject.port]['routes']) do
                if key == reqObject.method then
                    value[reqObject.url](reqObject,resObject)
                end
            end
        end
    end

    -- Reject('listen error: Port Does Not Exist')
    return promise.new(function(Resolve, Reject)
        local portConn = props.ports[port]
        if port == 1 then
            if portConn == nil then Reject() end
            if props.connections[port] == nil then
                props.connections[port] = portConn.remote.OnServerEvent:Connect(HandleModuleConnection)
                
                for _,binding in pairs(portConn.bindings) do
                    print(_)
                    binding.bind.OnServerInvoke = binding.callback
                end
                Resolve()
            end
        elseif port ~= 1 then
            if props.connections[port] == nil then
                print(port," _loaded")
                props.connections[port] = portConn.remote.OnServerEvent:Connect(HandleDeveloperConnections)
            end
        end
    end)
end

methods.disconnect = function(port)
    return promise.new(function(Resolve, Reject)
        if props.ports[port] then
            props.connections[port]:Disconnect()
            Resolve()
        else
            Reject('disconnect error: Port Does Not Exist')
        end
    end)
end

methods.listen(1,function()
    warn('Main Port Connected')
end):catch(warn)

return setmetatable(appServer, {
    __index = function(tab, key)
        local method = methods[key]
        if method ~= nil then
            return method
        else
            error("[" .. key:upper() .. "]" .. "is not a indexable method")
        end
    end
})