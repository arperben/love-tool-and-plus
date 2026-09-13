-- création github
-- lien : https://github.com/zhsso/Tserial.lua/blob/master/TSerial.lua
-- retrouvable sur löve

-- TSerial (version compatible Lua moderne / LÖVE 11.x)
-- basé sur TSerial v1.3 de Taehl
-- remit au propre et à jour pour les version actuelles de Lua et LÖVE

local TSerial = {}

function TSerial.pack(t, drop, indent)
	assert(type(t) == "table", "Can only TSerial.pack tables.")

	local s = "{" .. (indent and "\n" or "")
	indent = indent and math.max(type(indent) == "number" and indent or 0, 0)

	for k, v in pairs(t) do
		local tk, tv, skip = type(k), type(v)

		-- clés
		if tk == "boolean" then
			k = k and "[true]" or "[false]"
		elseif tk == "string" then
			if string.format("%q", k) ~= '"' .. k .. '"' then
				k = "[" .. string.format("%q", k) .. "]"
			end
		elseif tk == "number" then
			k = "[" .. k .. "]"
		elseif tk == "table" then
			k = "[" .. TSerial.pack(k, drop, indent and indent + 1) .. "]"
		elseif type(drop) == "function" then
			k = "[" .. string.format("%q", drop(k)) .. "]"
		elseif drop then
			skip = true
		else
			error("Invalid key type: " .. tostring(k))
		end

		-- valeurs
		if tv == "boolean" then
			v = v and "true" or "false"
		elseif tv == "string" then
			v = string.format("%q", v)
		elseif tv == "number" then
			-- ok
		elseif tv == "table" then
			v = TSerial.pack(v, drop, indent and indent + 1)
		elseif type(drop) == "function" then
			v = "[" .. string.format("%q", drop(v)) .. "]"
		elseif drop then
			skip = true
		else
			error("Invalid value type: " .. tostring(v))
		end

		if not skip then
			s = s .. string.rep("\t", indent or 0) .. k .. "=" .. v .. "," .. (indent and "\n" or "")
		end
	end

	return s .. string.rep("\t", (indent or 1) - 1) .. "}"
end

function TSerial.unpack(s)
	assert(type(s) == "string", "Can only TSerial.unpack strings.")

	local chunk, err = load("return " .. s)
	assert(chunk, err)

	return chunk()
end

return TSerial