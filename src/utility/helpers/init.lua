local helper = {}
local runService = game:GetService('RunService')

function  helper.IsArray(tab)
	local isTab,IsArr = (type(tab) == 'table'),true
	if isTab == true then
		for key,_ in pairs(tab) do
			if type(key) ~= 'number' then
				IsArr = false
				break
			end
		end
	else
		IsArr = false
	end
	return IsArr
end

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

--Compares All Index Values then Returns The values Asociated with the Index
function helper.DeepCompareIndex(searchTable,searchvalue)
	local ReturnValue,IsValue = {},false
	local searchLogic = function(name,search)
		if name == search then
			return true
		end
		return false
	end

	local function DeepRead(searchTable,searchvalue)
		for _index,_value in pairs(searchTable) do
			IsValue = searchLogic(_index,searchvalue)
			if IsValue then
				ReturnValue[#ReturnValue + 1] = _value
			elseif not IsValue then
				if type(_value) == 'table' then
					DeepRead(_value,searchvalue)
				end
			end
		end
	end
	
	DeepRead(searchTable,searchvalue)
	if ReturnValue[1] == nil  and runService:IsStudio() then
		print('Value Not Found')
	end
	return ReturnValue
end

--Deletes All Specified Indexes and returns a new Table 
--with Values not marked For Deletion 
-- Delete key Can be array or single Value

function helper.DeepDeleteIndex(searchTable,DeleteKeys)
	local backup,IsDeleteKey = helper.DeepCopy(searchTable,{}),false
	local function searchLogic(name,deletekeys)
		local IsArray,Matched = helper.IsArray(deletekeys),false
		if IsArray then
			for _index,_value in ipairs(deletekeys) do
				if _value == name then
					Matched = true
					break
				end
			end
			return Matched
		else 
			if name == deletekeys then
				return true
			end
		end
		return false
	end
	local function search(Table)
		local typeIs;
		for deleteIndex,deleteValue in pairs(Table) do
			IsDeleteKey = searchLogic(deleteIndex,DeleteKeys)
			if IsDeleteKey then
				Table[deleteIndex] = nil
			elseif not IsDeleteKey then
				typeIs = type(deleteValue)
				if typeIs == 'table' then
					search(deleteValue)
				end
			end
		end
		return backup
	end
	return search(backup)
end



return helper