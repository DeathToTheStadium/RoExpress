local appClient,props,methods,mainModule = {},{},{},script.Parent.Parent;
local promise, request, response = require(mainModule.utility.Promise), require(mainModule.request),require(mainModule.response)

props.ports = {}

methods.action = function()
	
end

methods.request = function()
	local function get(port,dataObject)
		-- body
	end 
	local function post()
		-- body
	end 
	local function put()
		-- body
	end 
	local function delete()
		-- body
	end 
	
	return setmetatable({get = get,post = post,put = put,delete = delete},{
		__call = function()
			--This Is Call To Let You Specify a Table
		end
	})
end

methods.getbind = function()

end

methods.sync = function()
	
end

methods.sync()

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