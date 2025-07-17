-- More physics (jiggle)
-- by mauricios


local version = "v1.1"
print("Initializing `physics_enhanced` v"..version)
--local sdk = require("sdk") TURNED OFF: 

-- Converts "System.Enum" --> Lua (table) for easier access to enum values.
local function generate_statics(typename)
	local t = sdk.find_type_definition(typename)
	local fields = t:get_fields() -- get all fields of the type definition
	local enum = {}
	local rev_enum = {}
	local names = {}
	for i, field in ipairs(fields) do
		if field:is_static() then
			local raw_value = field:get_data(nil)
			if raw_value ~= nil then
				local name = field:get_name()
				enum[name] = raw_value
				enum[raw_value] = name
				table.insert(names, name) -- collect names for sorting
				-- rev_enum[raw_value] = name -- reverse lookup
			end
		end
	end
	return enum, names 
end

-- Gets a dic from an RE (managed object).
local function get_dict(dict, as_array, sort_fn) -- dict: the managed object, as_array: boolean, sort_fn: function
	local output = {}
	if not dict._entries then return output end
	if as_array then
		for i, value_obj in pairs(dict._entries) do
			output[i] = value_obj.value -- value_obj.value is the actual value, key is the index in the array
		end
		if sort_fn then
			table.sort(output, sort_fn) -- sort_fn should be a function that takes two arguments and returns true if the first argument should come before the second
		end
	else
		for i, value_obj in pairs(dict._entries) do
			if value_obj.value ~= nil then
				output[value_obj.key] = output[value_obj.key] or value_obj.value
			end
		end
	end
	return output
end

local chr_edit_mgr = sdk.get_managed_singleton("app.CharacterEditManager")

local male = 2776536455   -- Male   character ID
local female = 1910070090 -- Female character ID

-- Female
for enum_id, entry in pairs(get_dict(chr_edit_mgr._TopsDB[female])) do
    if entry._BreastSwaying > 0 then
		entry._BreastSwaying = entry._BreastSwaying * 2 --max --> 100000 
    end
end