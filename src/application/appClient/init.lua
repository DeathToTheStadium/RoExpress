local appClient,props,methods = {},{},{}
local Promise = require(script.Parent.Parent.utility.Promise)

props.ports ={}

methods.action = function()
	
end

methods.request = function()

end

methods.getbind = function()

end

methods.init = function()

end


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