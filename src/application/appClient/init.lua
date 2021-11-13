local appClient,props,methods,mainModule = {},{},{},script.Parent.Parent;
local promise, request, response = require(mainModule.utility.Promise), require(mainModule.request),require(mainModule.response)

props.ports = {}
props.actions = {}
props.didSync = false

methods.action = function()

end

methods.request = setmetatable({},{
	__index = function(tab,key)
		local rttpMethods,ports,sendtable = {'get','post','put','delete'},props.ports,{}
		sendtable.method = ''
		local send = function(port,options)
			options.port = port
			options.method = sendtable.method
			local req = request.sending(options)
			ports[port].remote:FireServer(req)
		end
		
		for i=1 ,#rttpMethods ,1 do
			if key == rttpMethods[i] then
				sendtable.method = rttpMethods[i]
				return send
			end
		end
		error('method does not exist')
	end,
})



methods.getbind = function()

end

local sync = function()
	local servicer = mainModule.servicer.ports
	local function loadRemotes()
		local Children = servicer:GetChildren()
		for name,object in pairs(Children) do
			if type(name) == 'number' and object:IsA('RemoteEvent') then
				props.ports[tonumber(object.Name)] = {remote = object,bindings = {},actions = {}}
				for bindname,bind in pairs(object:GetChildren()) do
					if bind:IsA('RemoteFunction') then
						props.ports[tonumber(object.Name)]['bindings']= {
							[bind.name] = bind
						}
					end
				end
				object.childAdded:Connect(function(subchild)
					if subchild:IsA('RemoteFunction') then
						props.ports[tonumber(object.Name)]['bindings']= {
							[subchild.name] = subchild
						}
					end
				end)
			end
		end
	end
	local function CHLDAdded(Child)
		if Child:IsA('RemoteEvent') then
			props.ports[tonumber(Child.Name)] = {
				remote = Child,
				bindings = {},
				actions={},
			}
			Child.ChildAdded:Connect(function(subchild)
				if subchild:IsA('RemoteFunction') then
					props.ports[tonumber(Child.Name)]['bindings']= {
						[subchild.name] = subchild
					}
				end
			end)
		end
		print(props.ports)
	end
	local function CHLDRemoved(Child)
		if Child:IsA('RemoteEvent') then
			props.ports[tonumber(Child.Name)] = nil
		end
		print('Removed')
		print(props.ports)
	end
	if props.didSync == false then
		props.didSync = true
		loadRemotes()
	end
	servicer.ChildAdded:Connect(CHLDAdded)
	servicer.ChildRemoved:Connect(CHLDRemoved)
end

sync()

return setmetatable(appClient,{
	__index = function(tab,key)
		local method = methods[key]
		if method ~= nil then
			return method
		else
			error("["..key:upper().."]".. "is not a indexable method")
		end
	end
})