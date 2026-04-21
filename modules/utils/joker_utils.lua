Neuratro = Neuratro or {}

function Neuratro.find_joker(joker_key)
	local areas = {
		G.jokers and G.jokers.cards or {},
		G.playbook_extra and G.playbook_extra.cards or {},
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

function Neuratro.find_jokers(joker_key)
	local results = {}
	local areas = {
		G.jokers and G.jokers.cards or {},
		G.playbook_extra and G.playbook_extra.cards or {},
	}

	for _, area in ipairs(areas) do
		for _, joker in ipairs(area) do
			if joker.config and joker.config.center and joker.config.center.key == joker_key then
				results[#results + 1] = joker
			end
		end
	end

	return results
end

function Neuratro.has_joker(joker_key)
	return Neuratro.find_joker(joker_key) ~= nil
end
