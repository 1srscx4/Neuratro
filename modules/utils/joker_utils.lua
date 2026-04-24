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

function Neuratro.cerberify_card(card)
	if
		not card
		or not card.ability
		or card.ability.set ~= "Default"
		or card:get_id() ~= 2
		or (card.edition and card.edition.key == "e_negative")
	then
		return false
	end

	card:set_edition("e_negative", true)
	return true
end

function Neuratro.trigger_cerber(cards, force)
	if not cards or (#cards == 0) or (not force and not Neuratro.has_joker("j_cerber")) then
		return false
	end

	local triggered = false

	for _, card in ipairs(cards) do
		triggered = Neuratro.cerberify_card(card) or triggered
	end

	return triggered
end

function Neuratro.trigger_filtersister_upgrade()
	for _, joker in ipairs(Neuratro.find_jokers("j_filtersister")) do
		joker.ability.extra.xmult = joker.ability.extra.xmult + joker.ability.extra.upg
	end
end
