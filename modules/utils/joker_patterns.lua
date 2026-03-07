-- Neuratro Joker Pattern Templates
-- Common calculate() function patterns for jokers

Neuratro = Neuratro or {}

-- Pattern: Upgrade on specific hand type
-- Use when joker upgrades when playing a specific hand
-- @param context Game context
-- @param hand_name Name of hand type (e.g., "Three of a Kind")
-- @param upgrade_fn Function(card) that performs upgrade, returns true if upgraded
-- @param message Message to show on upgrade (default "Upgrade!")
-- @return table Result or nil
function Neuratro.patterns.upgrade_on_hand(context, hand_name, upgrade_fn, message)
	if context.before and context.scoring_name == hand_name and not context.blueprint then
		local upgraded = upgrade_fn()
		if upgraded then
			return { message = message or "Upgrade!" }
		end
	end
	return nil
end

-- Pattern: Simple xmult on joker_main
-- Use for basic xmult jokers
-- @param context Game context
-- @param xmult_value The xmult value to apply
-- @return table Result or nil
function Neuratro.patterns.simple_xmult(context, xmult_value)
	if context.joker_main then
		return { xmult = xmult_value }
	end
	return nil
end

-- Pattern: Simple mult on joker_main
-- Use for basic mult jokers
-- @param context Game context
-- @param mult_value The mult value to apply
-- @return table Result or nil
function Neuratro.patterns.simple_mult(context, mult_value)
	if context.joker_main then
		return { mult = mult_value }
	end
	return nil
end

-- Pattern: Simple chips on joker_main
-- Use for basic chips jokers
-- @param context Game context
-- @param chips_value The chips value to apply
-- @return table Result or nil
function Neuratro.patterns.simple_chips(context, chips_value)
	if context.joker_main then
		return { chips = chips_value }
	end
	return nil
end

-- Pattern: Probability-based trigger
-- Use when effect has a chance to trigger
-- @param context Game context
-- @param trigger_context When to check (e.g., "before", "joker_main")
-- @param base Base probability value
-- @param odds Odds denominator
-- @param seed Seed string
-- @param effect_fn Function to call if roll succeeds, returns result table
-- @param message Message on success
-- @return table Result or nil
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

-- Pattern: Count-based bonus
-- Use when bonus scales with count of something
-- @param context Game context
-- @param count_fn Function that returns count
-- @param base_value Base value per count
-- @param bonus_type "mult", "chips", or "xmult"
-- @return table Result or nil
function Neuratro.patterns.count_based_bonus(context, count_fn, base_value, bonus_type)
	if context.joker_main then
		local count = count_fn()
		if count > 0 then
			return { [bonus_type] = base_value * count }
		end
	end
	return nil
end

-- Pattern: Upgrade on end of round
-- Use for jokers that upgrade each round
-- @param context Game context
-- @param upgrade_fn Function(card) that performs upgrade, returns true if upgraded
-- @param message Message to show (default "Upgrade!")
-- @return table Result or nil
function Neuratro.patterns.round_upgrade(context, upgrade_fn, message)
	if context.end_of_round and not context.blueprint then
		local upgraded = upgrade_fn()
		if upgraded then
			return { message = message or "Upgrade!" }
		end
	end
	return nil
end

-- Pattern: Destroy self on condition
-- Use for self-destructing jokers
-- @param context Game context
-- @param condition_fn Function that returns true if should destroy
-- @param message Message to show (default "Destroyed!")
-- @return table Result or nil
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

-- Pattern: Retrigger card
-- Use for jokers that retrigger other cards
-- @param context Game context
-- @param condition_fn Function(context) that returns true if should retrigger
-- @param repetitions Number of repetitions
-- @return table Result or nil
function Neuratro.patterns.retrigger(context, condition_fn, repetitions)
	if context.repetition and condition_fn(context) then
		return { repetitions = repetitions or 1 }
	end
	return nil
end

-- Pattern: Check for specific cards in hand
-- Use for jokers that care about specific card types
-- @param scoring_hand Table of scored cards
-- @param check_fn Function(card) that returns true for matching cards
-- @return boolean, number true if found and count of matches
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

-- Pattern: Suit-based bonus
-- Use for jokers that give bonuses based on suit presence
-- @param context Game context
-- @param scoring_hand Table of scored cards
-- @param suit The suit to check for
-- @param min_cards Minimum cards of that suit required
-- @param bonus_table {mult, chips, xmult} with bonus values
-- @return table Result or nil
function Neuratro.patterns.suit_bonus(context, scoring_hand, suit, min_cards, bonus_table)
	if context.joker_main then
		local count = Neuratro.count_suit(scoring_hand, suit, true)
		if count >= min_cards then
			return bonus_table
		end
	end
	return nil
end

-- Pattern: Face card bonus
-- Use for jokers that give bonuses based on face cards
-- @param context Game context
-- @param scoring_hand Table of scored cards
-- @param min_faces Minimum face cards required
-- @param bonus_table {mult, chips, xmult} with bonus values
-- @return table Result or nil
function Neuratro.patterns.face_card_bonus(context, scoring_hand, min_faces, bonus_table)
	if context.joker_main then
		local count = Neuratro.count_face_cards(scoring_hand)
		if count >= min_faces then
			return bonus_table
		end
	end
	return nil
end

-- Pattern: Deck-based bonus
-- Use for jokers that scale with deck composition
-- @param context Game context
-- @param condition_fn Function(card) that returns true for cards to count
-- @param base_value Value per matching card
-- @param bonus_type "mult", "chips", or "xmult"
-- @return table Result or nil
function Neuratro.patterns.deck_based_bonus(context, condition_fn, base_value, bonus_type)
	if context.joker_main then
		local count = Neuratro.count_cards(condition_fn)
		if count > 0 then
			return { [bonus_type] = base_value * count }
		end
	end
	return nil
end

-- Pattern: Random effect selector
-- Use for jokers that randomly choose between multiple effects
-- @param seed Seed string
-- @param effects Table of {effect_type, value} pairs
-- @return table Selected effect {effect_type = value}
function Neuratro.patterns.random_effect(seed, effects)
	local selected = Neuratro.random_from_list(effects, seed)
	return { [selected.type] = selected.value }
end

-- Pattern: Track and trigger on threshold
-- Use for jokers that track something and trigger when threshold reached
-- @param context Game context
-- @param track_fn Function to increment/call on tracking context
-- @param check_fn Function that returns true if threshold reached
-- @param effect_fn Function that returns effect table when threshold reached
-- @return table Result or nil
function Neuratro.patterns.threshold_trigger(context, track_fn, check_fn, effect_fn)
	track_fn()
	
	if check_fn() then
		return effect_fn()
	end
	
	return nil
end
