local helper = {}

function helper.DeepCopy(TableToCopy,NewTable)
	for key,value in pairs(TableToCopy) do
		if typeof(value) == 'table' then
			NewTable[key] = helper.DeepCopy(TableToCopy[key],{})
		else
			NewTable[key] = value
		end
	end
	return NewTable
end

--Compares All Values in The Table and returns its Value
function helper.DeepCompare()
	
end


return helper