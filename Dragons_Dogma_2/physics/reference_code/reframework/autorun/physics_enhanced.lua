-- More physics (jiggle)
-- by mauricios

local version = "v1.1.1"
print("Initializing `More Boob Jiggle` v"..version)
-- This script is part of the REFramework project.

local function generate_statics(typename)
	-- Generates a dic of static fields from a type definition.
	local t = sdk.find_type_definition(typename)
	local fields = t:get_fields()
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
				table.insert(names, name)
			end
		end
	end
	return enum, names
end

-- Generates a dic of static fields from a type definition.
local function get_dict(dict, as_array, sort_fn)
	local output = {}
	if not dict._entries then return output end
	if as_array then
		for i, value_obj in pairs(dict._entries) do
			output[i] = value_obj.value
		end
		if sort_fn then
			table.sort(output, sort_fn)
		end
	else
		for i, value_obj in pairs(dict._entries) do
			if value_obj.value ~= nil then
				output[value_obj.key] = output[value_obj.key] or value_obj.value
				-- If the value is a table, merge it with the existing value
				if type(value_obj.value) == "table" and type(output[value_obj.key]) == "table" then
					for k, v in pairs(value_obj.value) do
						output[value_obj.key][k] = v
					end
				else
					output[value_obj.key] = value_obj.value
					-- If the value is a string, convert it to a number if possible
					if type(output[value_obj.key]) == "string" then
						local num_value = tonumber(output[value_obj.key])
						if num_value then
							output[value_obj.key] = num_value
							-- If the value is a number, convert it to a string
						end
					end
				end
			end
		end
	end
	return output
end

local chr_edit_mgr = sdk.get_managed_singleton("app.CharacterEditManager")
-- Get the enum for the body types

local female = 1910070090 --Female ID
local male = 2776536455   -- Male ID


-- Female
for enum_id, entry in pairs(get_dict(chr_edit_mgr._TopsDB[female])) do
    if entry._BreastSwaying > 0 then
		entry._BreastSwaying = entry._BreastSwaying * 2
       
    end
end

-- male
--for enum_id, entry in pairs(get_dict(chr_edit_mgr._TopsDB[male])) do
--    if 
--    end
--end lol