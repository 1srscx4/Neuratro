
Neuratro = Neuratro or {}

-- Find first joker by key across all joker areas
function Neuratro.find_joker(joker_key)
	local areas = {
		G.jokers and G.jokers.cards or {},
		G.playbook_extra and G.playbook_extra.cards or {}
	}

	for _, area in ipairs(areas) do
		for _, joker in ipairs(area) do
			if joker.config and joker.config.center and joker.config.center.key == joker_key then
				return joker
			end
		end
	end
	return nil
end

-- Find all jokers by key across all areas
function Neuratro.find_jokers(joker_key)
	local results = {}
	local areas = {
		G.jokers and G.jokers.cards or {},
		G.playbook_extra and G.playbook_extra.cards or {}
	}

	for _, area in ipairs(areas) do
		for _, joker in ipairs(area) do
			if joker.config and joker.config.center and joker.config.center.key == joker_key then
				table.insert(results, joker)
			end
		end
	end
	return results
end

-- Check if joker exists in any area
function Neuratro.has_joker(joker_key)
	return Neuratro.find_joker(joker_key) ~= nil
end

-- Find joker by key with optional debuff check
function Neuratro.find_joker_undebuffed(joker_key)
	local joker = Neuratro.find_joker(joker_key)
	return joker and not joker.debuff and joker
end

-- Count cards in deck matching condition
function Neuratro.count_cards(condition_fn)
	if not G.playing_cards then return 0 end

	local count = 0
	for _, card in ipairs(G.playing_cards) do
		if condition_fn(card) then
			count = count + 1
		end
	end
	return count
end

-- Get the area containing a specific joker
function Neuratro.get_joker_area(joker_key)
	local areas = {
		{ cards = G.jokers and G.jokers.cards or {}, area = G.jokers },
		{ cards = G.playbook_extra and G.playbook_extra.cards or {}, area = G.playbook_extra }
	}

	for _, area_data in ipairs(areas) do
		for pos, joker in ipairs(area_data.cards) do
			if joker.config and joker.config.center and joker.config.center.key == joker_key then
				return area_data.area, pos
			end
		end
	end
	return nil, nil
end
