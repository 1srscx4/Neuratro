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
	local card_id = card and card.base and card.base.id
	if
		not card
		or not card_id
		or not card.ability
		or card.ability.set ~= "Default"
		or card_id ~= 2
		or (card.edition and card.edition.key == "e_negative")
	then
		return false
	end

	card:set_edition("e_negative", true)
	return true
end

function Neuratro.cerberify_cards(cards)
	if not cards then
		return false
	end

	local triggered = false

	for _, card in ipairs(cards) do
		if Neuratro.cerberify_card(card) then
			triggered = true
		end
	end

	return triggered
end

function Neuratro.trigger_cerber_on_card(card)
	if not card or not Neuratro.has_joker("j_cerber") then
		return false
	end

	return Neuratro.cerberify_card(card)
end

function Neuratro.trigger_cerber_on_cards(cards)
	if not cards or not Neuratro.has_joker("j_cerber") then
		return false
	end

	return Neuratro.cerberify_cards(cards)
end

function Neuratro.trigger_filtersister_upgrade()
	for _, joker in ipairs(Neuratro.find_jokers("j_filtersister")) do
		joker.ability.extra.xmult = joker.ability.extra.xmult + joker.ability.extra.upg
	end
end
