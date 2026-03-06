--Code here done by PaulaMarina
SMODS.PokerHandPart({
	key = "_mix",
	func = function(hand)
		-- calculate threshold
		local threshold = 5
		local suit_keys = {}
		for suit, _ in pairs(SMODS.Suits) do
			suit_keys[#suit_keys + 1] = suit
		end
		if next(SMODS.find_card("j_fourtoes")) then
			sendDebugMessage("Four Toes detected, threshold = 4", "part._mix")
			threshold = 4
		end

		if #hand < threshold then
			return {}
		end
		-- find all suits that can apply to each card
		local applicable_suits = {}
		for i = 1, #hand do
			if not SMODS.has_enhancement(hand[i], "m_wild") then -- optimization #1: place non-wild cards before wild cards to minimize backtracking later on
				local index = #applicable_suits + 1
				applicable_suits[index] = {}
				for _, suit in ipairs(suit_keys) do
					if hand[i]:is_suit(suit, true) then
						applicable_suits[index][#applicable_suits[index] + 1] = suit
					end
				end
			end
		end
		for i = 1, #hand do
			if SMODS.has_enhancement(hand[i], "m_wild") then
				local index = #applicable_suits + 1
				applicable_suits[index] = {}
				for _, suit in ipairs(suit_keys) do
					if hand[i]:is_suit(suit, true) then
						applicable_suits[index][#applicable_suits[index] + 1] = suit
					end
				end
			end
		end
		-- backtrack through all possible suit interpretations and get max num of unique suits among all of them
		local function get_max_unique(applicable_suits, suits, i, count) -- due to early pruning the number is a little low sometimes but it always gets it right if hand contains a mix
			if i > #hand then
				return count
			end
			local max_count = count
			for j = 1, #applicable_suits[i] + 1 do -- does one extra loop in case card has no suit
				local suit = applicable_suits[i][j]
				local is_new_suit = false
				if not suit then
				elseif suits[suit] then
				end
				if suit and not suits[suit] then
					is_new_suit = true
					suits[suit] = true
					count = count + 1
				end
				local repeats = i - count
				if #hand - repeats < threshold then -- optimization #2: prunes this branch of the function once it detects the num of repeat suits is too high
					goto continue
				end
				local local_max = get_max_unique(applicable_suits, suits, i + 1, count)
				if local_max > max_count then
					max_count = local_max
					if max_count >= threshold then -- optimization #3: shortcuts execution once it detects max_count is high
						return max_count
					end
				end
				if is_new_suit then
					suits[suit] = false
					count = count - 1
				end
				::continue::
			end
			return max_count
		end
		-- check
		local suits_var = {}
		local unique_suits = get_max_unique(applicable_suits, suits_var, 1, 0)
		if unique_suits >= threshold then
			return { hand }
		end
	end,
})
SMODS.PokerHand({
	key = "mix",
	mult = 5,
	l_mult = 3,
	chips = 45,
	l_chips = 35,
	example = {
		{ "S_K", true, edition = "e_negative" },
		{ "H_9", true, seal = "Red" },
		{ "C_7", true },
		{ "D_3", true, enhancement = "m_gold" },
		{ "G_A", true, enhancement = "m_glorp" },
	},
	loc_txt = {
		name = "Mix",
		description = { "5 cards with different suit" },
	},
	visible = false,
	evaluate = function(parts, hand)
		return parts._mix
	end,
})
SMODS.PokerHand({
	key = "mixhouse",
	mult = 12,
	l_mult = 4,
	chips = 100,
	l_chips = 45,
	example = {
		{ "S_K", true, edition = "e_foil" },
		{ "H_K", true },
		{ "C_A", true },
		{ "D_A", true, seal = "Red", enhancement = "m_gold" },
		{ "G_A", true, enhancement = "m_glorp" },
	},
	loc_txt = {
		name = "Mixed House",
		description = { "A pair and a three of a kind.", "All cards have a different suit." },
	},
	visible = false,
	evaluate = function(parts, hand)
		if next(parts._mix) and next(parts._2) and next(parts._3) and #SMODS.merge_lists(parts._2, parts._3) == 5 then
			return { hand }
		end
	end,
})
SMODS.PokerHand({
	key = "straightmix",
	mult = 10,
	l_mult = 4,
	chips = 100,
	l_chips = 55,
	example = {
		{ "S_A", true },
		{ "H_K", true, seal = "Blue" },
		{ "C_Q", true, enhancement = "m_steel" },
		{ "D_J", true },
		{ "G_10", true, enhancement = "m_glorp" },
	},
	loc_txt = {
		name = "Straight Mix",
		description = { "5 cards with different suit", "and consecutive ranks" },
	},
	visible = false,
	evaluate = function(parts, hand)
		if next(parts._straight) and next(parts._mix) then
			return { hand }
		end
	end,
})
SMODS.PokerHand({
	key = "mixed5",
	mult = 16,
	l_mult = 4,
	chips = 140,
	l_chips = 60,
	example = {
		{ "S_7", true, enhancement = "m_mult" },
		{ "H_7", true, edition = "e_holo" },
		{ "C_7", true, seal = "Gold" },
		{ "D_7", true },
		{ "G_7", true, enhancement = "m_glorp" },
	},
	loc_txt = {
		name = "Mixed Five",
		description = { "5 cards with different suit", "and the same rank" },
	},
	visible = false,
	evaluate = function(parts, hand)
		if next(parts._mix) and next(parts._5) then
			return { hand }
		end
	end,
})
