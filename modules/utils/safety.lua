-- Neuratro Safety Wrappers
-- Defensive programming utilities to handle nil values gracefully

Neuratro = Neuratro or {}

-- Safely access nested table values
-- @param ... List of keys to traverse (last arg is default value)
-- @return The value at the path, or default if any key is nil
function Neuratro.safe_access(...)
	local args = {...}
	local default = args[#args]
	local path_length = #args - 1
	
	if path_length == 0 then
		return default
	end
	
	local current = args[1]
	if current == nil then
		return default
	end
	
	for i = 2, path_length do
		local key = args[i]
		if type(current) ~= "table" or current[key] == nil then
			return default
		end
		current = current[key]
	end
	
	return current
end

-- Safely call a function with error handling
-- @param fn Function to call
-- @param ... Arguments to pass to function
-- @return success (boolean), result (any) or error message
function Neuratro.safe_call(fn, ...)
	local success, result = pcall(fn, ...)
	return success, result
end

-- Safely get game state value with fallback
-- @param path Table path as array of keys
-- @param default Default value if path doesn't exist
-- @return The value or default
function Neuratro.safe_game_state(path, default)
	if not G then
		return default
	end
	
	local current = G
	for _, key in ipairs(path) do
		if type(current) ~= "table" or current[key] == nil then
			return default
		end
		current = current[key]
	end
	
	return current
end

-- Check if game is in a valid state for operations
-- @return boolean true if G and G.GAME are available
function Neuratro.is_game_ready()
	return G ~= nil and G.GAME ~= nil
end

-- Safely check if a card area exists and has cards
-- @param area The area (e.g., G.jokers)
-- @return boolean true if area exists and has cards
function Neuratro.has_cards_in_area(area)
	return area ~= nil and area.cards ~= nil and #area.cards > 0
end

-- Safely get number of cards in an area
-- @param area The area (e.g., G.jokers)
-- @return number Count of cards, 0 if area doesn't exist
function Neuratro.get_card_count(area)
	if not Neuratro.has_cards_in_area(area) then
		return 0
	end
	return #area.cards
end

-- Safely iterate over cards in an area
-- @param area The area (e.g., G.jokers)
-- @param fn Function(card, index) to call for each card
-- @return boolean true if iteration completed
function Neuratro.safe_card_iterate(area, fn)
	if not Neuratro.has_cards_in_area(area) then
		return false
	end
	
	for i, card in ipairs(area.cards) do
		local success, err = pcall(fn, card, i)
		if not success then
			print("[Neuratro] Error iterating card: " .. tostring(err))
		end
	end
	
	return true
end

-- Safely destroy a card
-- @param card The card to destroy
-- @param force If true, force destroy even if card is eternal
-- @return boolean true if destroy was initiated
function Neuratro.safe_destroy(card, force)
	if not card then
		return false
	end
	
	local success, err = pcall(function()
		SMODS.destroy_cards(card, force)
	end)
	
	if not success then
		print("[Neuratro] Error destroying card: " .. tostring(err))
		return false
	end
	
	return true
end

-- Safely debuff a card
-- @param card The card to debuff
-- @param debuff If true, debuff; if false, remove debuff
-- @param source Source string for the debuff
-- @return boolean true if debuff was applied
function Neuratro.safe_debuff(card, debuff, source)
	if not card then
		return false
	end
	
	local success, err = pcall(function()
		SMODS.debuff_card(card, debuff, source)
	end)
	
	if not success then
		print("[Neuratro] Error debuffing card: " .. tostring(err))
		return false
	end
	
	return true
end

-- Safely add event to event manager
-- @param event Event object
-- @return boolean true if event was added
function Neuratro.safe_add_event(event)
	if not G or not G.E_MANAGER then
		return false
	end
	
	local success, err = pcall(function()
		G.E_MANAGER:add_event(event)
	end)
	
	if not success then
		print("[Neuratro] Error adding event: " .. tostring(err))
		return false
	end
	
	return true
end

-- Validate joker config structure
-- @param config The config table to validate
-- @param required_fields Array of required field names
-- @return boolean true if valid, false and error message if not
function Neuratro.validate_joker_config(config, required_fields)
	if type(config) ~= "table" then
		return false, "Config must be a table"
	end
	
	if not config.extra then
		return false, "Config must have 'extra' field"
	end
	
	if required_fields then
		for _, field in ipairs(required_fields) do
			if config.extra[field] == nil then
				return false, "Missing required field: " .. field
			end
		end
	end
	
	return true
end

-- Safely get pool flag
-- @param flag_name Name of the pool flag
-- @return boolean value of flag, or false if doesn't exist
function Neuratro.get_pool_flag(flag_name)
	return Neuratro.safe_game_state({"GAME", "pool_flags", flag_name}, false)
end

-- Safely set pool flag
-- @param flag_name Name of the pool flag
-- @param value Value to set
-- @return boolean true if set successfully
function Neuratro.set_pool_flag(flag_name, value)
	if not Neuratro.is_game_ready() or not G.GAME.pool_flags then
		return false
	end
	
	G.GAME.pool_flags[flag_name] = value
	return true
end
