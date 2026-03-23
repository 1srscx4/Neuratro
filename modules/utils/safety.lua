
Neuratro = Neuratro or {}

-- Safely access nested table values
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
function Neuratro.safe_call(fn, ...)
	local success, result = pcall(fn, ...)
	return success, result
end

-- Safely get game state value with fallback
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
function Neuratro.is_game_ready()
	return G ~= nil and G.GAME ~= nil
end

-- Safely check if a card area exists and has cards
function Neuratro.has_cards_in_area(area)
	return area ~= nil and area.cards ~= nil and #area.cards > 0
end

-- Safely get number of cards in an area
function Neuratro.get_card_count(area)
	if not Neuratro.has_cards_in_area(area) then
		return 0
	end
	return #area.cards
end

-- Safely iterate over cards in an area
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
function Neuratro.get_pool_flag(flag_name)
	return Neuratro.safe_game_state({"GAME", "pool_flags", flag_name}, false)
end

-- Safely set pool flag
function Neuratro.set_pool_flag(flag_name, value)
	if not Neuratro.is_game_ready() or not G.GAME.pool_flags then
		return false
	end
	
	G.GAME.pool_flags[flag_name] = value
	return true
end
