
Neuratro = Neuratro or {}
if not Neuratro.patterns then Neuratro.patterns = {} end

function Neuratro.patterns.upgrade_on_hand(context, hand_name, upgrade_fn, message)
	if context.before and context.scoring_name == hand_name and not context.blueprint then
		local upgraded = upgrade_fn()
		if upgraded then
			return { message = message or "Upgrade!" }
		end
	end
	return nil
end

function Neuratro.patterns.simple_xmult(context, xmult_value)
	if context.joker_main then
		return { xmult = xmult_value }
	end
	return nil
end

function Neuratro.patterns.simple_mult(context, mult_value)
	if context.joker_main then
		return { mult = mult_value }
	end
	return nil
end

function Neuratro.patterns.simple_chips(context, chips_value)
	if context.joker_main then
		return { chips = chips_value }
	end
	return nil
end

function Neuratro.patterns.probability_trigger(context, trigger_context, base, odds, seed, effect_fn, message)
	if context[trigger_context] and Neuratro.roll_with_odds(base, odds, seed) then
		local result = effect_fn()
		if result then
			if message and not result.message then
				result.message = message
			end
			return result
		end
	end
	return nil
end

function Neuratro.patterns.count_based_bonus(context, count_fn, base_value, bonus_type)
	if context.joker_main then
		local count = count_fn()
		if count > 0 then
			return { [bonus_type] = base_value * count }
		end
	end
	return nil
end

function Neuratro.patterns.round_upgrade(context, upgrade_fn, message)
	if context.end_of_round and not context.blueprint then
		local upgraded = upgrade_fn()
		if upgraded then
			return { message = message or "Upgrade!" }
		end
	end
	return nil
end

function Neuratro.patterns.self_destruct(context, condition_fn, message)
	if condition_fn() then
		G.E_MANAGER:add_event(Event({
			func = function()
				SMODS.destroy_cards(card)
				return true
			end,
		}))
		return { message = message or "Destroyed!" }
	end
	return nil
end

function Neuratro.patterns.retrigger(context, condition_fn, repetitions)
	if context.repetition and condition_fn(context) then
		return { repetitions = repetitions or 1 }
	end
	return nil
end

function Neuratro.patterns.check_cards(scoring_hand, check_fn)
	local count = 0
	local found = false
	
	for _, card in ipairs(scoring_hand) do
		if check_fn(card) then
			count = count + 1
			found = true
		end
	end
	
	return found, count
end

function Neuratro.patterns.suit_bonus(context, scoring_hand, suit, min_cards, bonus_table)
	if context.joker_main then
		local count = Neuratro.count_suit(scoring_hand, suit, true)
		if count >= min_cards then
			return bonus_table
		end
	end
	return nil
end

function Neuratro.patterns.face_card_bonus(context, scoring_hand, min_faces, bonus_table)
	if context.joker_main then
		local count = Neuratro.count_face_cards(scoring_hand)
		if count >= min_faces then
			return bonus_table
		end
	end
	return nil
end

function Neuratro.patterns.deck_based_bonus(context, condition_fn, base_value, bonus_type)
	if context.joker_main then
		local count = Neuratro.count_cards(condition_fn)
		if count > 0 then
			return { [bonus_type] = base_value * count }
		end
	end
	return nil
end

function Neuratro.patterns.random_effect(seed, effects)
	local selected = Neuratro.random_from_list(effects, seed)
	return { [selected.type] = selected.value }
end

function Neuratro.patterns.threshold_trigger(context, track_fn, check_fn, effect_fn)
	track_fn()
	
	if check_fn() then
		return effect_fn()
	end
	
	return nil
end
