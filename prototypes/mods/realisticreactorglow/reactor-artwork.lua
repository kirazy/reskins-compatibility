-- Copyright (c) 2026 Kirazy
-- Part of Artisanal Reskins: Compatibility
--
-- See LICENSE.md in the project directory for license information.

---@using data

---Provides methods for reading the artwork of reactors.
---@class ReactorArtwork
local ReactorArtwork = {}

---Gets the tint of the artwork of Artisanal Reskins that the given `reactor` draws.
---@param reactor ReactorPrototype
---@return Color? # The tint of the first tinted layer of `reactor.picture` that draws a file of an Artisanal Reskins mod, if any; otherwise, `nil`.
---@nodiscard
function ReactorArtwork.get_reskins_tint(reactor)
	local layers = reactor.picture and reactor.picture.layers
	if not layers then
		return nil
	end

	for _, layer in ipairs(layers) do
		if layer.tint and layer.filename and layer.filename:find("^__reskins%-") then
			return layer.tint
		end
	end

	return nil
end

return ReactorArtwork
