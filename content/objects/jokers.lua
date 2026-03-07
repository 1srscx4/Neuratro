local neuro_jokers = {
	"j_plasma_globe",
	"j_btmc",
	"j_highlighted",
	"j_anny",
	"j_kyoto",
	"j_pipes",
	"j_milc",
	"j_teru",
	"j_schedule",
	"j_lavalamp",
	"j_lucy",
	"j_queenpb",
	"j_tutelsoup",
	"j_layna",
	"j_forghat",
	"j_3heart",
	"j_argirl",
	"j_tiredtutel",
	"j_hype",
	"j_recbin",
	"j_harpoon",
	"j_cfrb",
	"j_sispace",
	"j_allin",
	"j_camila",
	"j_jokr",
	"j_xdx|",
	"j_bday1",
	"j_bday2",
	"j_sistream",
	"j_donowall",
	"j_stocks",
	"j_techhard",
	"j_gimbag",
	"j_void",
	"j_collab",
	"j_cavestream",
	"j_jorker",
	"j_roulette",
	"j_Vedds",
	"j_ddos",
	"j_hiyori",
	"j_Glorp",
	"j_Emuz",
	"j_anteater",
	"j_drive",
	"j_deliv",
	"j_fourtoes",
	"j_abandonedarchive",
	"j_minikocute",
	"j_neurodog",
	"j_ely",
	"j_cerbr",
	"j_corpa",
	"j_emojiman",
	"j_shoomimi",
	"j_plush",
	"j_vedalsdrink",
	"j_filtersister",
	"j_envy",
	"j_koko",
	"j_cerber",
	"j_chimps",
	"j_bwaa",
	"j_coldfish",
	"j_coldfish_unleashed",
	"j_paulamarina",
	"j_toma",
	"j_tomaniacs",
	"j_angel_neuro",
	"j_neuro_issues",
}

local PLAYBOOK_MAX_CARD_LIMIT = Neuratro.CONSTANTS.LIMITS.PLAYBOOK_MAX_CARDS
local sea = Neuratro.sea
local RANDOM_SEED = {
	ALLIN_SUIT = "allin_suit",
	ALLIN_SEAL = "allin_seal",
	ALLIN_ENH = "allin_enh",
	ALLIN_EDITION = "allin_edition",
}
local CARD_RANK = {
	TWO = 2,
	THREE = 3,
	FOUR = 4,
	FIVE = 5,
	SIX = 6,
	SEVEN = 7,
	EIGHT = 8,
	NINE = 9,
	JACK = 11,
	KING = 13,
	ACE = 14,
}

-- DEPRECATED: Use Neuratro.get_probability_scale() instead
local function probability_scale()
	return Neuratro.get_probability_scale()
end

-- DEPRECATED: Use Neuratro.roll_with_odds() instead
local function roll_with_odds(seed, base, odds)
	return Neuratro.roll_with_odds(base, odds, seed)
end

local function set_queenpb_pool_flags(song)
	if not (G and G.GAME and G.GAME.pool_flags) then
		return
	end
	G.GAME.pool_flags.BOOM = song == Neuratro.CONSTANTS.SONGS.BOOM
	G.GAME.pool_flags.LIFE = song == Neuratro.CONSTANTS.SONGS.LIFE
	G.GAME.pool_flags.NEVER = song == Neuratro.CONSTANTS.SONGS.NEVER
end

local function joker_cards()
	return G and G.jokers and G.jokers.cards or {}
end

local function playbook_cards()
	return G and G.playbook_extra and G.playbook_extra.cards or {}
end

local function is_rank(card, rank)
	return card and card.get_id and card:get_id() == rank
end

local function has_negative_edition(card)
	return card and card.edition and card.edition.key == "e_negative"
end

local function all_cards_are_rank(cards, rank, expected_count)
	if #cards ~= expected_count then
		return false
	end
	for i = 1, expected_count do
		if not is_rank(cards[i], rank) then
			return false
		end
	end
	return true
end

local function randomize_allin_card(card)
	local _suit = Neuratro.random_suit_abbrev(RANDOM_SEED.ALLIN_SUIT)
	local _card = create_playing_card({
		front = G.P_CARDS[_suit .. "_" .. tostring(CARD_RANK.SIX)],
		center = G.P_CENTERS.c_base,
	}, G.hand, nil, nil, { G.C.SECONDARY_SET.Enhanced })

	local seal_type = pseudorandom(RANDOM_SEED.ALLIN_SEAL)
	local enh_type = pseudorandom(RANDOM_SEED.ALLIN_ENH)
	local edit_type = pseudorandom(RANDOM_SEED.ALLIN_EDITION)

	if seal_type > 0.75 then
		_card:set_seal("Red", true)
	elseif seal_type > 0.5 then
		_card:set_seal("Blue", true)
	elseif seal_type > 0.25 then
		_card:set_seal("Gold", true)
	else
		_card:set_seal("Purple", true)
	end

	if enh_type > 0.889 then
		_card:set_ability(G.P_CENTERS["m_twin"], nil, true)
	elseif enh_type > 0.778 then
		_card:set_ability(G.P_CENTERS["m_glass"], nil, true)
	elseif enh_type > 0.667 then
		_card:set_ability(G.P_CENTERS["m_lucky"], nil, true)
	elseif enh_type > 0.556 then
		_card:set_ability(G.P_CENTERS["m_wild"], nil, true)
	elseif enh_type > 0.444 then
		_card:set_ability(G.P_CENTERS["m_bonus"], nil, true)
	elseif enh_type > 0.333 then
		_card:set_ability(G.P_CENTERS["m_mult"], nil, true)
	elseif enh_type > 0.222 then
		_card:set_ability(G.P_CENTERS["m_steel"], nil, true)
	elseif enh_type > 0.111 then
		_card:set_ability(G.P_CENTERS["m_dono"], nil, true)
	else
		_card:set_ability(G.P_CENTERS["m_gold"], nil, true)
	end

	if edit_type > 0.80 then
		_card:set_edition("e_filtered", true)
	elseif edit_type > 0.55 then
		_card:set_edition("e_foil", true)
	elseif edit_type > 0.3 then
		_card:set_edition("e_holo", true)
	elseif edit_type > 0.1 then
		_card:set_edition("e_polychrome", true)
	else
		_card:set_edition("e_negative", true)
	end

	G.GAME.blind:debuff_card(_card)
	G.hand:sort()
	G.E_MANAGER:add_event(Event({
		func = function()
			SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
			return true
		end,
	}))
end

local function allin_should_trigger(context)
	if context.blueprint or not context.pre_discard then
		return false
	end
	return all_cards_are_rank(context.full_hand or {}, CARD_RANK.SIX, 4)
end

local function count_cards_of_rank(cards, rank)
	local count = 0
	for _, card in ipairs(cards) do
		if is_rank(card, rank) then
			count = count + 1
		end
	end
	return count
end

local function paula_cycle_matches_hand(cycle, full_hand)
	if cycle == 1 then
		return all_cards_are_rank(full_hand, CARD_RANK.NINE, 2)
	end
	if cycle == 2 then
		return all_cards_are_rank(full_hand, CARD_RANK.NINE, 1)
	end
	if cycle == 3 then
		return all_cards_are_rank(full_hand, CARD_RANK.SIX, 1)
	end
	if cycle == 4 then
		return all_cards_are_rank(full_hand, CARD_RANK.SEVEN, 1)
	end
	if cycle == 0 and #full_hand == 4 then
		local fours = count_cards_of_rank(full_hand, CARD_RANK.FOUR)
		local fives = count_cards_of_rank(full_hand, CARD_RANK.FIVE)
		return fours == 2 and fives == 2
	end
	return false
end

local function mooods_penalty_percent(card)
	local percent = 0
	if not (G and G.GAME and G.playing_cards) then
		return percent
	end
	for _, pcard in ipairs(G.playing_cards) do
		if is_rank(pcard, CARD_RANK.EIGHT) then
			percent = percent + card.ability.extra.decrease
		end
	end
	return percent
end

local function is_live_context(context)
	return not context.blueprint and not context.retrigger_joker
end

local function has_seal(card, seal)
	return card and card.seal == seal
end

local function card_is_suit_rank(card, suit, rank)
	return card and card.is_suit and card:is_suit(suit) and is_rank(card, rank)
end

local function any_card_has_seal(cards, seal)
	for _, playing_card in ipairs(cards or {}) do
		if has_seal(playing_card, seal) then
			return true
		end
	end
	return false
end

local function count_face_cards(cards)
	local count = 0
	for _, playing_card in ipairs(cards or {}) do
		if playing_card:is_face() then
			count = count + 1
		end
	end
	return count
end

local function harpoon_can_trigger(context)
	return context.before
		and context.cardarea == G.jokers
		and is_live_context(context)
		and G.GAME
		and G.GAME.current_round
		and G.GAME.current_round.discards_left > 0
end

local function cfrb_upgrade_count(removed_cards)
	local count = 0
	for _, playing_card in ipairs(removed_cards or {}) do
		if card_is_suit_rank(playing_card, Neuratro.CONSTANTS.SUITS.CLUBS, CARD_RANK.KING) then
			count = count + 1
		end
	end
	return count
end

local function btmc_before_result(card, scoring_hand)
	if any_card_has_seal(scoring_hand, "osu_seal") then
		card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.upg
		return { message = "x" .. tostring(card.ability.extra.xmult), colour = G.C.CHIPS }
	end
	card.ability.extra.xmult = 1
	return { message = "X", colour = G.C.RED }
end

local function set_negative_for_twos(cards)
	for _, pcard in ipairs(cards or {}) do
		if is_rank(pcard, CARD_RANK.TWO) and not has_negative_edition(pcard) then
			pcard:set_edition("e_negative", true)
		end
	end
end

local function cerber_apply_to_obtained_card(card)
	if Neuratro.has_joker("j_cerber") and is_rank(card, CARD_RANK.TWO) and not has_negative_edition(card) then
		card:set_edition("e_negative", true)
	end
end

local function evilsand_can_store_sold_joker(context, card)
	return context.selling_card
		and context.card ~= card
		and context.card.area == G.jokers
		and is_live_context(context)
end

local function all_cards_negative(cards, expected_count)
	if #cards ~= expected_count then
		return false
	end
	for i = 1, expected_count do
		if not has_negative_edition(cards[i]) then
			return false
		end
	end
	return true
end

local function emuz_chip_bonus(other_card, mult)
	if not has_negative_edition(other_card) then
		return nil
	end
	if is_rank(other_card, CARD_RANK.ACE) then
		return { chips = 11 * mult, mult = mult }
	end
	if other_card:is_face() then
		return { chips = 10 * mult, mult = mult }
	end
	if other_card:get_id() < CARD_RANK.JACK then
		return { chips = other_card:get_id() * mult, mult = mult }
	end
	return nil
end

local function evilsand_has_other_copy(card)
	for _, joker in ipairs(joker_cards()) do
		if joker.config.center.key == "j_evilsand" and joker ~= card then
			return true
		end
	end
	return false
end

local function evilsand_count_default_cards()
	local count = 0
	for _, v in ipairs(playbook_cards()) do
		if v.ability and v.ability.set == "Default" then
			count = count + 1
		end
	end
	return count
end

local function evilsand_trim_default_cards(max_defaults)
	local defaults = evilsand_count_default_cards()
	if defaults <= max_defaults then
		return
	end
	for _, v in ipairs(playbook_cards()) do
		if v.ability and v.ability.set == "Default" then
			v:start_dissolve()
			defaults = defaults - 1
			if defaults <= max_defaults then
				break
			end
		end
	end
end

local function evilsand_store_sold_joker(card, sold_card)
	card.ability.extra.sold = card.ability.extra.sold + sold_card.sell_cost
	if card.ability.extra.sold >= card.ability.extra.goal then
		card.ability.extra.sold = card.ability.extra.sold - card.ability.extra.goal
		G.playbook_extra.config.card_limit = math.min((G.playbook_extra.config.card_limit or 0) + 1, PLAYBOOK_MAX_CARD_LIMIT)
	end

	local thing = copy_card(sold_card)
	G.playbook_extra:emplace(thing)

	local default_cards = evilsand_count_default_cards()
	local extra_cards = G.playbook_extra and G.playbook_extra.cards or {}
	if #extra_cards - default_cards > G.playbook_extra.config.card_limit - 2 then
		for _, v in ipairs(playbook_cards()) do
			if v.ability and v.ability.set == "Joker" then
				SMODS.destroy_cards(v, true)
				break
			end
		end
	end
end

local function evilsand_store_removed_cards(card, removed_cards)
	for _, removed_card in ipairs(removed_cards) do
		local turn = tonumber(card.ability.extra.turn) or 1
		if turn == 1 then
			card.ability.extra.turn = "2"
			local pcard = copy_card(removed_card)
			SMODS.debuff_card(pcard, true, "sand")
			G.playbook_extra:emplace(pcard)
			card.ability.extra.card1 = true
		elseif turn == 2 then
			card.ability.extra.turn = "1"
			local pcard = copy_card(removed_card)
			SMODS.debuff_card(pcard, true, "sand")
			G.playbook_extra:emplace(pcard)
			card.ability.extra.card2 = true
		end
	end

	evilsand_trim_default_cards(2)
end

local function evilsand_append_default_cards_to_scoring_hand(context)
	local extra_scoring_cards = {}
	for _, pcard in ipairs(playbook_cards()) do
		if pcard.ability.set == "Default" then
			local added = copy_card(pcard)
			SMODS.debuff_card(added, false, "sand")
			table.insert(G.playing_cards, added)
			G.play:emplace(added)
			extra_scoring_cards[#extra_scoring_cards + 1] = added
		end
	end

	if context.scoring_hand then
		local existing_scoring_hand = context.scoring_hand
		local scoring_hand = {}
		for i = 1, #existing_scoring_hand do
			scoring_hand[i] = existing_scoring_hand[i]
		end
		for _, added in ipairs(extra_scoring_cards) do
			scoring_hand[#scoring_hand + 1] = added
		end
		context.scoring_hand = scoring_hand
	end
end

local function evilsand_destroy_tracked_cards_after(card, full_hand)
	local hand_count = #full_hand
	if card.ability.extra.card1 then
		local target_index = card.ability.extra.card2 ~= nil and hand_count - 1 or hand_count
		if target_index > 0 and full_hand[target_index] then
			SMODS.destroy_cards(full_hand[target_index])
		end
	end
	if card.ability.extra.card2 then
		if hand_count > 0 and full_hand[hand_count] then
			SMODS.destroy_cards(full_hand[hand_count])
		end
	end
end

--Neuro related
SMODS.Joker({
	key = "3heart",
	loc_txt = {
		name = "heartheartheart",
		text = {
			"Give {X:mult,C:white}X#1#{} Mult",
			"If played hand is {C:attention}3 of a kind{}",
			"and all cards are {C:hearts}hearts{},",
			"increase by {X:mult,C:white}x#2#{}",
		},
	},
	credits = {
		idea = { "Evil Sand" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = { x = 2, y = 0 },
	soul_pos = { x = 3, y = 0 },
	config = {
		extra = {
			Xmult = 1,
			xmbonus = 0.45,
		},
	},
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.Xmult, center.ability.extra.xmbonus } } --#1# is replaced with card.ability.extra.Xmult
	end,
	calculate = function(self, card, context)
		if
			context.before
			and context.scoring_name == "Three of a Kind"
			and not context.blueprint
			and not context.retrigger_joker
			and Neuratro.is_flush(context.scoring_hand or {})
		then
			local scoring_hand = context.scoring_hand or {}
			local upgs = true
			for _, playing_card in ipairs(scoring_hand) do
				if not playing_card:is_suit(Neuratro.CONSTANTS.SUITS.HEARTS) then
					upgs = false
					break
				end
			end
			if not context.blueprint and upgs then
				card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.xmbonus
				return { message = "Upgrade!" }
			end
		end
		if context.joker_main then
			return { xmult = card.ability.extra.Xmult }
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "gimbag",
	loc_txt = {
		name = "Gym Bag",
		text = {
			"{C:attention}+1{} hand size.",
			"{C:attention}Aces{} held in hand give",
			"{C:mult}+#1#{} mult and {C:chips}+#2#{} chips",
			"Double for {C:attention}Aces{} of {C:hearts}Hearts{}",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 6,
	credits = {
		idea = { "1srscx4" },
		art = { "Tony7268" },
		code = { "1srscx4" },
	},
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 6, y = 5 },
	config = { extra = { added = 12 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.added, center.ability.extra.added } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(1)
	end,
	remove_from_deck = function(self, card, from_debuff)
		for _, joker in ipairs(joker_cards()) do
			if joker.config.center.key == "j_evilsand" and card.area ~= G.playbook_extra then
				return
			end
		end
		G.hand:change_size(-1)
	end,
	calculate = function(self, card, context)
		if
			context.individual
			and context.cardarea == G.hand
			and not context.end_of_round
			and context.other_card
			and context.other_card:get_id() == CARD_RANK.ACE
		then
			if context.other_card:is_suit(Neuratro.CONSTANTS.SUITS.HEARTS) then
				return { mult = card.ability.extra.added * 2, chips = card.ability.extra.added * 2 }
			end
			return { mult = card.ability.extra.added, chips = card.ability.extra.added }
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "roulette",
	loc_txt = {
		name = "Neuro Roulette",
		text = {
			"Multiply mult by either",
			"{X:mult,C:white}x#1#{} or {X:mult,C:white}x#2#{}",
			"{s:0.8,C:red,E:1}Don't be afraid, Vedal",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	credits = {
		idea = { "1srscx4" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 1, y = 4 },
	config = { extra = { xhigh = 4, xlow = 0.25 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.xhigh, center.ability.extra.xlow } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = Neuratro.random_xmult_high_low(card.ability.extra.xhigh, card.ability.extra.xlow, "seed"),
			}
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "plush",
	loc_txt = {
		name = "Neuro Fumo",
		text = {
			"This joker gains {C:mult}+#1#{} mult",
			"for every {C:money}$#2#{} spent. {C:inactive}(Currently: {C:mult}+#3#{C:inactive})",
			"{C:inactive}({C:money}$#4#{C:inactive} left until next upgrade)",
		},
	},
	credits = {
		sug = { "Pers" },
		idea = { "1srscx4" },
		art = { "Etzyio+" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = { x = 7, y = 1 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { upg = 12, goal = 30, mult = 0, current = 0, triggers = false } },
	loc_vars = function(self, info_queue, center)
		return {
			vars = {
				center.ability.extra.upg,
				center.ability.extra.goal,
				center.ability.extra.mult,
				center.ability.extra.goal - center.ability.extra.current,
			},
		}
	end,
	calculate = function(self, card, context)
		if (context.buying_card or context.open_booster) and not context.retrigger_joker then
			card.ability.extra.current = card.ability.extra.current + context.card.cost
		end
		if context.end_of_round and G.GAME.current_round.free_rerolls == 0 and not context.retrigger_joker then
			card.ability.extra.triggers = true
		end
		if context.reroll_shop and G.GAME.current_round.free_rerolls == 0 and not context.retrigger_joker then
			if card.ability.extra.triggers then
				card.ability.extra.current = card.ability.extra.current + G.GAME.current_round.reroll_cost - 1
			end
			card.ability.extra.triggers = true
		end
		if context.ending_shop and not context.retrigger_joker then
			card.ability.extra.triggers = false
		end
		if
			card.ability.extra.current >= card.ability.extra.goal
			and not context.blueprint
			and not context.retrigger_joker
		then
			card.ability.extra.current = card.ability.extra.current - card.ability.extra.goal
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.upg
			return { message = "Upgrade!" }
		end
		if context.joker_main then
			return { mult = card.ability.extra.mult }
		end
	end,
})
SMODS.Joker({
	key = "forghat",
	loc_txt = {
		name = "Frog Hat",
		text = {
			"When a card with a seal is {C:attention}played{},",
			"the card to the {C:attention}right{} has a ",
			"{C:green,E:1}#1# in #2#{} chance to gain this seal.",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "Kloovree" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 8, y = 3 },
	in_pool = function(self, args)
		local inpool = false
		for _, playing_card in ipairs(G.playing_cards) do
			if playing_card.seal then
				inpool = true
				break
			end
		end
		return inpool
	end,
	config = { extra = { base = 1, odds = 3 } },
	loc_vars = function(self, info_queue, center)
		return {
			vars = Neuratro.get_probability_vars(center.ability.extra.base, center.ability.extra.odds),
		}
	end,
	calculate = function(self, card, context)
		if context.before then
			local full_hand = context.full_hand or {}
			for pos, _ in ipairs(full_hand) do
				local source_idx = #full_hand + 1 - pos
				local source_card = full_hand[source_idx]
				local next_card = full_hand[source_idx + 1]
				if source_card and source_card.seal and next_card and roll_with_odds("anteater", card.ability.extra.base, self.config.extra.odds) then
					sea(function()
						next_card:flip()
						next_card:juice_up(0.3, 0.3)
						return true
					end, 0.35, "before")
					sea(function()
						next_card:set_seal(source_card.seal, nil, true)
						return true
					end, 0.55, "before")
					sea(function()
						next_card:flip()
						next_card:juice_up(0.3, 0.3)
						return true
					end, 0.35, "before")
				end
			end
		end
	end,
})
SMODS.Joker({
	key = "lavalamp",
	loc_txt = {
		name = "Lava Lamp",
		text = {
			"Gives {X:mult,C:white}x#4#{} mult.",
			"{C:attention}Cycles{} back and forth through:",
			"{X:mult,C:white}x#1#{} , {X:mult,C:white}x#2#{} and {X:mult,C:white}x#3#{}",
		},
	},
	credits = {
		sug = { "Evil Sand" },
		idea = { "1srscx4" },
		art = { "Tony7268" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 0, y = 5 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { xmult = 1.5, cycle = "1", c1 = 1.5, c2 = 2, c3 = 2.5 } },
	loc_vars = function(self, info_queue, center)
		return {
			vars = {
				center.ability.extra.c1,
				center.ability.extra.c2,
				center.ability.extra.c3,
				center.ability.extra.xmult,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return { xmult = card.ability.extra.xmult }
		end
		if context.after and is_live_context(context) then
			if card.ability.extra.cycle == "1" then
				card.ability.extra.cycle = tostring(tonumber(card.ability.extra.cycle) + 1)
				card.ability.extra.xmult = card.ability.extra.c2
				sea(function()
					card.children.center:set_sprite_pos({ x = 1, y = 5 })
					return true
				end, 0.1)
				return { message = "Upgrade!" }
			elseif card.ability.extra.cycle == "2" then
				card.ability.extra.cycle = tostring(tonumber(card.ability.extra.cycle) + 1)
				card.ability.extra.xmult = card.ability.extra.c3
				sea(function()
					card.children.center:set_sprite_pos({ x = 2, y = 5 })
					return true
				end, 0.1)
				return { message = "Upgrade!" }
			elseif card.ability.extra.cycle == "3" then
				card.ability.extra.cycle = tostring(tonumber(card.ability.extra.cycle) + 1)
				card.ability.extra.xmult = card.ability.extra.c2
				sea(function()
					card.children.center:set_sprite_pos({ x = 1, y = 5 })
					return true
				end, 0.1)
				return { message = "Upgrade!" }
			elseif card.ability.extra.cycle == "4" then
				card.ability.extra.cycle = "1"
				card.ability.extra.xmult = card.ability.extra.c1
				sea(function()
					card.children.center:set_sprite_pos({ x = 0, y = 5 })
					return true
				end, 0.1)
				return { message = "Upgrade!" }
			end
		end
	end,
})
SMODS.Joker({
	key = "breadge",
	loc_txt = {
		name = "Neuro Bread",
		text = {
			"{C:attention}Stone Cards{} instead give {C:mult}+#1#{} Mult.",
			"Decrease by {C:mult}#2#{} Mult at {C:attention}end of round{}.",
		},
	},

	credits = {
		sug = { "Evil Sand" },
		idea = { "1srscx4" },
		art = { "Tony7268" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 2, y = 7 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { mult = 21, decr = 3 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
		return { vars = { card.ability.extra.mult, card.ability.extra.decr } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.decr
			if card.ability.extra.mult <= 0 then
				SMODS.destroy_cards(card)
				return { message = "Filtered" }
			end
			return { message = "-" .. tostring(card.ability.extra.decr), colour = G.C.MULT }
		end
	end,
})
--Evil Related
SMODS.Joker({
	key = "harpoon",
	loc_txt = {
		name = "Get Harpooned!",
		text = {
			"Gives {X:mult,C:white}X#3#{} Mult.",
			"{C:green,E:1} #1# in #2#{} chance to lose all {C:red}discards{}.",
		},
	},
	credits = {
		idea = { "Evil Sand" },
		art = { "Etzyio+" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 8, y = 1 },
	config = { extra = { odds = 3, xmult = 3, base = 1 } },
	loc_vars = function(self, info_queue, center)
		local vars = Neuratro.get_probability_vars(center.ability.extra.base, center.ability.extra.odds)
		table.insert(vars, center.ability.extra.xmult)
		return { vars = vars }
	end,
	calculate = function(self, card, context)
		if harpoon_can_trigger(context) then
			if roll_with_odds("seed", card.ability.extra.base, card.ability.extra.odds) then
				G.GAME.current_round.discards_left = 0
				return { message = "Harpooned!" }
			end
		end
		if context.joker_main then
			return { Xmult = card.ability.extra.xmult }
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "cfrb",
	loc_txt = {
		name = "CFRB",
		text = {
			"{C:attention}Kings{} of {C:spades}Spades{} give {X:mult,C:white}X#1#{} Mult.",
			"Increases by {X:mult,C:white}X#2#{} when",
			"a {C:attention}King{} of {C:clubs}Clubs{} is destroyed",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	credits = {
		idea = { "Evil Sand" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = { x = 6, y = 2 },
	config = { extra = { Xmult_bonus = 1, upg = 0.5 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.Xmult_bonus, center.ability.extra.upg } }
	end,
	calculate = function(self, card, context)
		if context.remove_playing_cards and is_live_context(context) then
			local upgrade_count = cfrb_upgrade_count(context.removed)
			if upgrade_count > 0 then
				card.ability.extra.Xmult_bonus = card.ability.extra.Xmult_bonus
					+ (card.ability.extra.upg * upgrade_count)
				return { message = "Upgrade!" }
			end
		end
		if context.individual and context.cardarea == G.play and context.other_card then
			if card_is_suit_rank(context.other_card, Neuratro.CONSTANTS.SUITS.SPADES, CARD_RANK.KING) then
				return { xmult = card.ability.extra.Xmult_bonus }
			end
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "bday1",
	loc_txt = {
		name = "Evil's First Birthday",
		text = {
			"Gives {C:mult}+#1#{} mult. Increase",
			"this by {C:mult}+#3#{} when a {C:attention}face card",
			"is destroyed. Goes {C:attention,E:2}extinct{} at {C:attention}#4#{}",
			"{C:attention}face cards{} destroyed. {C:inactive}[#2# left]{}",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	credits = {
		idea = { "Emuz" },
		art = { "Etzyio+" },
		code = { "1srscx4" },
	},
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	pos = { x = 5, y = 3 },
	config = { extra = { mult_bonus = 4, upg = 2, face = 0, goal = 6 } },
	loc_vars = function(self, info_queue, center)
		return {
			vars = {
				center.ability.extra.mult_bonus,
				center.ability.extra.goal - center.ability.extra.face,
				center.ability.extra.upg,
				center.ability.extra.goal,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return { mult = card.ability.extra.mult_bonus }
		end
		if context.remove_playing_cards and is_live_context(context) then
			local faces_removed = count_face_cards(context.removed)
			if faces_removed > 0 then
				card.ability.extra.mult_bonus = card.ability.extra.mult_bonus + (card.ability.extra.upg * faces_removed)
				card.ability.extra.face = card.ability.extra.face + faces_removed
				if card.ability.extra.face >= card.ability.extra.goal then
					SMODS.destroy_cards(card)
					if G and G.GAME and G.GAME.pool_flags then
						G.GAME.pool_flags.trauma = true
					end
				end
				return { message = "Upgrade!" }
			end
		end
	end,
	in_pool = function(self, args)
		return G and G.GAME and G.GAME.pool_flags and not G.GAME.pool_flags.trauma
	end,
})
SMODS.Joker({
	key = "bday2",
	loc_txt = {
		name = "Evil's Second Birthday",
		text = {
			"Gives {X:mult,C:white}X#1#{} Mult. Increase",
			"by {X:mult,C:white}X#2#{} Mult when a",
			"{C:attention}face card{} is added to the deck",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	credits = {
		idea = { "Emuz" },
		art = { "Etzyio+" },
		code = { "1srscx4" },
	},
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = { x = 6, y = 3 },
	config = { extra = { xmult_bonus = 1.5, upg = 0.5 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.xmult_bonus, center.ability.extra.upg } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return { xmult = card.ability.extra.xmult_bonus }
		end
		if context.playing_card_added and is_live_context(context) then
			local faces_added = count_face_cards(context.cards)
			if faces_added > 0 then
				card.ability.extra.xmult_bonus = card.ability.extra.xmult_bonus + (card.ability.extra.upg * faces_added)
				return { message = "Upgrade!" }
			end
		end
	end,
	in_pool = function(self, args)
		return G and G.GAME and G.GAME.pool_flags and G.GAME.pool_flags.trauma
	end,
})
SMODS.Joker({
	key = "pipes",
	loc_txt = {
		name = "PIPES",
		text = {
			"{C:attention}Steel cards{} give {X:mult,C:white}x#1#{} mult instead.",
			"Leftmost card {C:attention}held{} in hand",
			"becomes a {C:attention}steel card{}",
			"{C:red,E:1,s:0.9}Steel cards play a metal pipe sound.{}",
		},
	},
	credits = {
		idea = { "1srscx4", "Pers" },
		art = { "Dirtlord" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 2, y = 6 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { xmult = 2 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.before and G.hand and G.hand.cards and G.hand.cards[1] then
			local first_hand_card = G.hand.cards[1]
			sea(function()
				first_hand_card:flip()
				first_hand_card:juice_up(0.3, 0.3)
				return true
			end, 0.35, "before")
			sea(function()
				first_hand_card:set_ability(G.P_CENTERS["m_steel"])
				return true
			end, 0.55, "before")
			sea(function()
				first_hand_card:flip()
				first_hand_card:juice_up(0.3, 0.3)
				return true
			end, 0.35, "before")
		end
	end,
})
SMODS.Joker({
	key = "deliv",
	loc_txt = {
		name = "Abber Demon",
		text = {
			"Each {C:attention}scored card{} has a",
			"{C:green,E:1}#1# in #2#{} chance of being {C:red,E:1}destroyed",
			"When this happens, this joker",
			"gains {X:mult,C:white}x#3#{} mult. {C:inactive}(currently: {X:mult,C:white}x#4#{C:inactive})",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 3,
	credits = {
		idea = { "Bigbuckies" },
		art = { "Etzyio+" },
		code = { "1srscx4" },
	},
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = { x = 9, y = 5 },
	config = { extra = { base = 1, odds = 6, upg = 0.25, xmult = 1 } },
	loc_vars = function(self, info_queue, center)
		return {
			vars = {
				center.ability.extra.base * probability_scale(),
				center.ability.extra.odds,
				center.ability.extra.upg,
				center.ability.extra.xmult,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return { xmult = card.ability.extra.xmult }
		end
		if
			context.individual
			and context.cardarea == G.play
			and context.other_card
			and roll_with_odds("seed", card.ability.extra.base, self.config.extra.odds)
		then
			SMODS.destroy_cards(context.other_card)
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.upg
			return { message = "Destroy!" }
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "mcneuros",
	loc_txt = {
		name = "McNeuro's",
		text = {
			"If played hand consists of exactly",
			"{C:attention}#1#{}, lose {C:money}$#2#{} and create",
			"two random {C:tarot}Tarot{} cards. {C:inactive}(Required",
			"{C:inactive}hand changes after each activation)",
		},
	},
	credits = {
		idea = { "PaulaMarina" },
		art = { "Kloovree" },
		code = { "PaulaMarina" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 6, y = 8 },
	config = { extra = { cycle = 1, dollars = 2, tarots = 2 } },
	loc_vars = function(self, info_queue, center)
		local ret = ""
		if center.ability.extra.cycle == 1 then
			ret = "two 9s"
		elseif center.ability.extra.cycle == 2 then
			ret = "one 9"
		elseif center.ability.extra.cycle == 3 then
			ret = "one 6"
		elseif center.ability.extra.cycle == 4 then
			ret = "one 7"
		elseif center.ability.extra.cycle == 0 then
			ret = "two 4s and two 5s"
		end
		return { vars = { ret, center.ability.extra.dollars } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local full_hand = context.full_hand or {}
			local activate = paula_cycle_matches_hand(card.ability.extra.cycle, full_hand)
			if activate then
				card.ability.extra.cycle = math.fmod(card.ability.extra.cycle + 1, 5)
				G.E_MANAGER:add_event(Event({
					func = function()
						if G.consumeables.config.card_limit > #G.consumeables.cards + 1 then
							play_sound("timpani")
							G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 2
							SMODS.add_card({
								set = "Tarot",
								key_append = "mcneuros",
							})
							SMODS.add_card({
								set = "Tarot",
								key_append = "mcneuros",
							})
						elseif G.consumeables.config.card_limit > #G.consumeables.cards then
							play_sound("timpani")
							G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
							SMODS.add_card({
								set = "Tarot",
								key_append = "mcneuros",
							})
						end
						G.GAME.consumeable_buffer = 0
						return true
					end,
				}))
				delay(0.5)
				return { dollars = -1 * card.ability.extra.dollars }
			end
		end
	end,
})
SMODS.Joker({
	key = "plasma_globe",
	loc_txt = {
		name = "Plasma Globe",
		text = {
			"Gains {X:mult,C:white}X#1#{} Mult when",
			"a {C:spectral}Spectral{} card is used.",
			"{C:inactive}(currently {X:mult,C:white}X#2#{C:inactive} Mult)",
		},
	},
	credits = {
		sug = { "Evil Sand" },
		idea = { "PaulaMarina" },
		art = { "Tony7268" },
		code = { "PaulaMarina" },
	},
	atlas = "animeplasma",
	pools = { ["neurJoker"] = true },
	blueprint_compat = true,
	perishable_compat = false,
	rarity = 2,
	cost = 6,
	pos = { x = 0, y = 0 },
	config = { extra = { Xmult = 1, Xmult_mod = 0.75 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if
			context.using_consumeable
			and not context.blueprint
			and context.consumeable.ability.set == "Spectral"
			and not context.retrigger_joker
		then
			card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
			return {
				message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.Xmult } }),
			}
		end
		if context.joker_main then
			return {
				Xmult = card.ability.extra.Xmult,
			}
		end
	end,
})
--Both twin
SMODS.Joker({
	key = "sispace",
	loc_txt = {
		name = "Twins In Space",
		text = {
			"Gives {C:chips}+#2#{} chips per",
			"{C:planet}planet{} card used this run.",
			"{C:inactive}[Currently{} {C:chips}+#1#{} {C:inactive}chips{}]",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	credits = {
		idea = { "2nd Umbrella" },
		art = { "None" },
		code = { "1srscx4" },
	},
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = { x = 7, y = 8 },
	config = { extra = { chip_bonus = 9 } },
	loc_vars = function(self, info_queue, center)
		return {
			vars = {
				center.ability.extra.chip_bonus
					* (G.GAME and G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.planet or 0),
				center.ability.extra.chip_bonus,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chip_bonus
					* (G.GAME and G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.planet or 0),
			}
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "sistream",
	loc_txt = {
		name = "Twin Stream",
		text = {
			"Retrigger all ",
			"played {C:attention}twin cards{}",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	credits = {
		idea = { "1srscx4" },
		art = { "Kloovree" },
		code = { "1srscx4" },
	},
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 5, y = 9 },
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_twin
		return
	end,

	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and context.other_card then
			if SMODS.has_enhancement(context.other_card, "m_twin") then
				return { repetitions = 1 }
			end
		end
	end,
	in_pool = function(self, args)
		local inpool = false
		for _, cards in ipairs(G.playing_cards) do
			if SMODS.has_enhancement(cards, "m_twin") then
				inpool = true
				break
			end
		end
		return inpool
	end,
})
--Vedal related
SMODS.Joker({
	key = "tiredtutel",
	loc_txt = {
		name = "Turtle At Work",
		text = {
			"Gives {C:mult}+#2#{} Mult per used {C:red}discard{} this blind",
			"{C:inactive}(Currently {C:mult}+#1#{} {C:inactive}Mult{C:inactive})",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	credits = {
		idea = { "2nd Umbrella" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 1, y = 0 },
	config = { extra = { mult = 0, base = 4 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.mult, center.ability.extra.base } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and not context.retrigger_joker then
			card.ability.extra.mult = 0
			return { message = "Reset" }
		end
		if context.pre_discard and is_live_context(context) then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.base
			return { message = "Upgrade!" }
		end
		if context.joker_main then
			return { mult = card.ability.extra.mult }
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "recbin",
	loc_txt = {
		name = "Recycle Bin",
		text = {
			"Gives {C:chips}+#2#{} chips per",
			"{C:red}discarded{} card this round",
			"{C:inactive}[Currently {C:chips}+#1#{} {C:inactive}chips]{}",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	credits = {
		idea = { "2nd Umbrella" },
		art = { "Tony7268" },
		code = { "1srscx4" },
	},
	pos = { x = 6, y = 4 },
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = { extra = { bonus_chips = 0, extra_chips = 7 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.bonus_chips, center.ability.extra.extra_chips } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return { chips = card.ability.extra.bonus_chips }
		end
		if context.discard and is_live_context(context) then
			card.ability.extra.bonus_chips = card.ability.extra.bonus_chips + card.ability.extra.extra_chips
		end
		if context.end_of_round and context.cardarea == G.jokers and not context.retrigger_joker then
			card.ability.extra.bonus_chips = 0
			return { message = "Reset" }
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "vedalsdrink",
	loc_txt = {
		name = "Banana Rum",
		text = {
			"If a {C:attention}King{} of {C:clubs}Clubs{} is played,",
			"{C:attention}triple{} the chips and {C:red,E:2}break",
		},
	},
	credits = {
		sug = { "Pers" },
		idea = { "1srscx4" },
		art = { "Etzyio+" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	pos = { x = 9, y = 1 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { chips_min = 20, chips_max = 200 } },
	loc_vars = function(self, info_queue, card)
		local r_mults = {}
		for i = card.ability.extra.chips_min, card.ability.extra.chips_max do
			r_mults[#r_mults + 1] = tostring(i)
		end
		main_start = {
			{ n = G.UIT.T, config = { text = "Gives ", colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
			{ n = G.UIT.T, config = { text = "+", colour = G.C.CHIPS, scale = 0.32 } },
			{
				n = G.UIT.O,
				config = {
					object = DynaText({
						string = r_mults,
						colours = { G.C.CHIPS },
						pop_in_rate = 9999999,
						silent = true,
						random_element = true,
						pop_delay = 0.5,
						scale = 0.32,
						min_cycle_time = 0,
					}),
				},
			},
			{ n = G.UIT.T, config = { text = " chips.", colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
		}
		return { main_start = main_start }
	end,
	calculate = function(self, card, context)
		if context.joker_main and not context.retrigger_joker then
			local scoring_hand = context.scoring_hand or {}
			local breaking = false
			for _, playing_card in ipairs(scoring_hand) do
			if playing_card:get_id() == CARD_RANK.KING and playing_card:is_suit(Neuratro.CONSTANTS.SUITS.CLUBS) then
					breaking = true
				end
			end
			if breaking then
				return {
					chips = pseudorandom("rum", card.ability.extra.chips_min, card.ability.extra.chips_max) * 3,
					func = function() SMODS.destroy_cards(card) return true end,
					message = "Drunk!",
				}
			else
				return { chips = pseudorandom("rum", card.ability.extra.chips_min, card.ability.extra.chips_max) }
			end
		end
	end,
})
SMODS.Joker({
	key = "Vedds",
	loc_txt = {
		name = "Vedd's Store",
		text = {
			"Give {C:chips}+#1#{} chips per",
			"{C:attention}Ace{} of {C:clubs}Clubs{} in deck",
			"{C:inactive}(Currently: {C:chips}+#2#{}{C:inactive})",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "None" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 1, y = 0 },
	config = { extra = { chips = 35 } },
	loc_vars = function(self, info_queue, center)
		local n_ace = Neuratro.count_cards(function(card)
			return card:get_id() == CARD_RANK.ACE and card:is_suit(Neuratro.CONSTANTS.SUITS.CLUBS)
		end)
		return { vars = { center.ability.extra.chips, center.ability.extra.chips * n_ace } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local n_ace = Neuratro.count_cards(function(card)
				return card:get_id() == CARD_RANK.ACE and card:is_suit(Neuratro.CONSTANTS.SUITS.CLUBS)
			end)
			return { chips = card.ability.extra.chips * n_ace }
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "fourtoes",
	loc_txt = {
		name = "Four Toes",
		text = { "All {C:attention}Mixes{} can be", "made with {C:attention}4{} cards" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 3,
	credits = {
		idea = { "Evil Sand", "PaulaMarina" },
		art = { "None" },
		code = { "PaulaMarina" },
	},
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 1, y = 0 },
	in_pool = function(self, args)
		return G.GAME.hands["mix"].played > 0
	end,
})
SMODS.Joker({
	key = "tutelsoup",
	loc_txt = {
		name = "Tutel Soup",
		text = {
			"Gives either {C:mult}+#1#{} mult, {C:chips}+#2#{} chips, {C:money}$#3#{} or {X:mult,C:white}x#4#{} mult",
			"{C:red,E:1}Destroys{} self in {C:attention}#5#{} rounds.",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "Tony7268" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	pos = { x = 7, y = 4 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { mult = 15, chips = 100, money = 3, xmult = 1.5, rounds = 0, goal = 4, chosen = "" } },
	loc_vars = function(self, info_queue, center)
		return {
			vars = {
				center.ability.extra.mult,
				center.ability.extra.chips,
				center.ability.extra.money,
				center.ability.extra.xmult,
				center.ability.extra.goal - center.ability.extra.rounds,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.before then
			card.ability.extra.chosen = pseudorandom_element({ "mult", "chips", "money", "xmult" }, pseudoseed("soup"))
		end
		if context.joker_main then
			if card.ability.extra.chosen == "mult" then
				return { mult = card.ability.extra.mult }
			elseif card.ability.extra.chosen == "chips" then
				return { chips = card.ability.extra.chips }
			elseif card.ability.extra.chosen == "money" then
				return { dollars = card.ability.extra.money }
			elseif card.ability.extra.chosen == "xmult" then
				return { xmult = card.ability.extra.xmult }
			end
		end
		if context.end_of_round and context.cardarea == G.jokers and not context.retrigger_joker then
			card.ability.extra.rounds = card.ability.extra.rounds + 1
			if card.ability.extra.rounds >= card.ability.extra.goal then
				SMODS.destroy_cards(card)
				card:start_dissolve()
				return { message = "Eaten!" }
			end
			return { message = "Soup!" }
		end
	end,
})
SMODS.Joker({
	key = "abandonedarchive",
	loc_txt = {
		name = "Abandoned Archive 2",
		text = {
			"When a joker is {C:attention}sold{}, gain mult",
			"{C:attention}to its {C:attention}sell value{}.",
			"{C:inactive}(Currently {C:mult}+#1# {C:inactive}mult)",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	credits = {
		sug = { "Evil Sand" },
		idea = { "1srscx4" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = { x = 6, y = 0 },
	config = { extra = { mult = 0 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return { mult = card.ability.extra.mult }
		end
		if context.selling_card and is_live_context(context) then
			card.ability.extra.mult = card.ability.extra.mult + context.card.sell_cost
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "tutel_credit",
	loc_txt = {
		name = "Vedal's Credit Card",
		text = {
			"{C:attention}Get back{} your money for",
			"the {C:attention}first{} purchase in each {C:attention}shop{}.",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "Etzyio+" },
		code = { "1srscx4" },
	},
	rarity = 2,
	cost = 7,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	pos = { x = 8, y = 5 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { active = true } },
	calculate = function(self, card, context)
		if
			(context.buying_card or context.open_booster)
			and card.ability.extra.active
			and context.card ~= card
			and not context.blueprint
		then
			card.ability.extra.active = false
			return { dollars = context.card.cost }
		end
		if context.end_of_round and context.cardarea == G.jokers then
			card.ability.extra.active = true
			return { message = "Active!" }
		end
	end,
})
--Stream related
SMODS.Joker({
	key = "hype",
	loc_txt = {
		name = "Hype Train",
		text = {
			"Gives {C:money}$#1#{} at end of round, increases by",
			"{C:money}$#2#{} if played hand contains a {C:attention}Donation",
			"{C:attention}Card{}. {C:red,E:2}Destroys self{} after {C:attention}two {C:inactive}[#3#]{}",
			"consecutive hands without {C:attention}Donation Cards{}.",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 6,
	credits = {
		sug = { "2nd Umbrella" },
		idea = { "That one guy" },
		art = { "Tony7268" },
		code = { "PaulaMarina" },
	},
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	pos = { x = 8, y = 8 },
	config = { extra = { gain = 1, upg = 1, no_bit_hands = 0, max_no_bit_hands = 2 } },
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_dono
		return { vars = { center.ability.extra.gain, center.ability.extra.upg, center.ability.extra.no_bit_hands } }
	end,
	calc_dollar_bonus = function(self, card)
		return card.ability.extra.gain
	end,
	calculate = function(self, card, context)
		if context.after and not context.blueprint then
			local scoring_hand = context.scoring_hand or {}
			card.ability.extra.no_bit_hands = card.ability.extra.no_bit_hands + 1
			for _k, val in ipairs(scoring_hand) do
				if SMODS.has_enhancement(val, "m_dono") then
					card.ability.extra.gain = card.ability.extra.gain + card.ability.extra.upg
					card.ability.extra.no_bit_hands = 0
					break
				end
			end
			if card.ability.extra.no_bit_hands == card.ability.extra.max_no_bit_hands then
				SMODS.destroy_cards(card)
				return { message = "Destroyed" }
			end
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "techhard",
	loc_txt = {
		name = "Technical Difficulties",
		text = {
			"{C:attention}First{} hand of round",
			"gives {X:mult,C:white}x#1#{} Mult",
			"All other hands",
			"give {X:mult,C:white}x#2#{} Mult",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	credits = {
		idea = { "1srscx4" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 0, y = 6 },
	config = { extra = { low = 0.5, high = 1.5 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.low, center.ability.extra.high } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if G.GAME.current_round.hands_played == 0 then
				return { xmult = card.ability.extra.low }
			else
				return { xmult = card.ability.extra.high }
			end
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "donowall",
	loc_txt = {
		name = "Donowall",
		text = {
			"Give {C:mult}+#1#{} mult per {C:attention}unscored{}",
			"card in played hand.",
		},
	},
	credits = {
		idea = { "PaulaMarina" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 8, y = 0 },
	config = { extra = { mult_bonus = 0, percard = 7 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.percard } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local full_hand = context.full_hand or {}
			local scoring_hand = context.scoring_hand or {}
			card.ability.extra.mult_bonus = 0
			for i = 1, #full_hand do
				card.ability.extra.mult_bonus = card.ability.extra.mult_bonus + card.ability.extra.percard
			end
			for _, playing_card in ipairs(scoring_hand) do
				card.ability.extra.mult_bonus = card.ability.extra.mult_bonus - card.ability.extra.percard
			end
			return { mult = card.ability.extra.mult_bonus }
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "stocks",
	loc_txt = {
		name = "VedalAI Stocks",
		text = {
			"At end of round, increase",
			"this joker {C:money}sell value{} by",
			"a number between {C:attention}#1#{} and {C:attention}+#2#{}",
		},
	},
	credits = {
		idea = { "PaulaMarina" },
		art = { "SupDrazor" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	config = { extra = { price = 0, down = 3, up = 6 } },
	pos = { x = 3, y = 5 },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.down * -1, center.ability.extra.up } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			local value = pseudorandom("seed")
			if value <= 0.55 then
				card.ability.extra.price = pseudorandom("stocks_down", 1, card.ability.extra.down) * -1
			else
				card.ability.extra.price = pseudorandom("stocks_up", 1, card.ability.extra.up)
			end
			card.ability.extra_value = card.ability.extra_value + card.ability.extra.price
			card:set_cost()
			if value <= 0.55 then
				return { message = "Value down :(" }
			else
				return { message = "Value up!" }
			end
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "collab",
	loc_txt = {
		name = "Collab",
		text = {
			"Gives {X:mult,C:white}x#1#{} Mult if hand",
			"contains three {C:attention}face{} cards",
			"of different {C:attention}suits{}",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 3,
	cost = 8,
	credits = {
		idea = { "1srscx4" },
		art = { "none" },
		code = { "1srscx4" },
	},
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 1, y = 0 },
	config = { extra = { xmult = 4 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local scoring_hand = context.scoring_hand or {}
			local suits = { ["Hearts"] = false, ["Diamonds"] = false, ["Spades"] = false, ["Clubs"] = false }
			local suit_count = 0
			local face_count = 0

			for _, scored_card in ipairs(scoring_hand) do
				if scored_card:is_face() then
					face_count = math.min(face_count + 1, 3)
					for suit, found in pairs(suits) do
						if not found and scored_card:is_suit(suit, true) then
							suits[suit] = true
							suit_count = suit_count + 1
							break
						end
					end
				end
			end

			if suit_count >= 3 and face_count >= 3 then
				return { xmult = card.ability.extra.xmult }
			end
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "cavestream",
	loc_txt = {
		name = "Cave Stream",
		text = {
			"Retrigger all played {C:attention}stone cards{}",
			"If hand contains no {C:attention}stone cards{},",
			"Turn the leftmost played card",
			"into a {C:attention}stone card{}",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 6,
	credits = {
		idea = { "1srscx4" },
		art = { "None" },
		code = { "1srscx4" },
	},
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = { extra = {} },
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
		return
	end,
	pos = { x = 1, y = 0 },
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and context.other_card then
			if SMODS.has_enhancement(context.other_card, "m_stone") then
				return { repetitions = 1 }
			end
		end
		if context.joker_main then
			local full_hand = context.full_hand or {}
			local nostones = true
			for _, p_card in ipairs(full_hand) do
				if SMODS.has_enhancement(p_card, "m_stone") then
					nostones = false
				end
			end
			local first_play_card = G.play and G.play.cards and G.play.cards[1]
			if nostones and first_play_card then
				sea(function()
					first_play_card:flip()
					first_play_card:juice_up(0.3, 0.3)
					return true
				end, 0.35, "before")
				sea(function()
					first_play_card:set_ability(G.P_CENTERS["m_stone"])
					return true
				end, 0.55, "before")
				sea(function()
					first_play_card:flip()
					first_play_card:juice_up(0.3, 0.3)
					return true
				end, 0.35, "before")
			end
			return { message = "Echo!" }
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "ddos",
	loc_txt = {
		name = "Live DDOS",
		text = {
			"Gives {C:chips}+#1#{} chips.",
			"{C:green,E:1}#2# in #3#{} chance to",
			"debuff self after",
			"hand is played.",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	credits = {
		idea = { "Pers" },
		art = { "EmojiMan" },
		code = { "1srscx4" },
	},
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 7, y = 0 },
	config = { extra = { chips = 150, odds = 3, base = 1 } },
	loc_vars = function(self, info_queue, center)
		return {
			vars = {
				center.ability.extra.chips,
				center.ability.extra.base * (G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal or 1),
				center.ability.extra.odds,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if roll_with_odds("seed", card.ability.extra.base, card.ability.extra.odds) then
				G.E_MANAGER:add_event(Event({
					func = function()
						card:set_debuff(true)
						return true
					end,
				}))
				return { message = "DDOS" }
			end
			return { chips = card.ability.extra.chips }
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "drive",
	loc_txt = {
		name = "Long Drive",
		text = {
			"Gives {X:mult,C:white}x#1#{} mult. Every {C:attention}#2#",
			"rounds, increase by {X:mult,C:white}x#4#{}.",
			"{C:inactive}({C:attention}#3#{C:inactive} rounds left)",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 3,
	credits = {
		idea = { "Bigbuckies" },
		art = { "None" },
		code = { "1srscx4" },
	},
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = { x = 1, y = 0 },
	config = { extra = { xmult = 1, goal = 3, left = 0, upg = 1 } },
	loc_vars = function(self, info_queue, center)
		return {
			vars = {
				center.ability.extra.xmult,
				center.ability.extra.goal,
				center.ability.extra.goal - center.ability.extra.left,
				center.ability.extra.upg,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return { xmult = card.ability.extra.xmult }
		end
		if
			context.end_of_round
			and context.cardarea == G.jokers
			and not context.blueprint
			and not context.retrigger_joker
		then
			card.ability.extra.left = card.ability.extra.left + 1
			if card.ability.extra.left >= card.ability.extra.goal then
				card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.upg
				card.ability.extra.left = 0
				return { message = "Upgrade!" }
			end
			return { message = "Driving" }
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "highlighted",
	loc_txt = {
		name = "Highlighted Message",
		text = {
			"{C:attention}Donation Cards{} instead give {X:mult,C:white}x#1#{} Mult.",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	credits = {
		suggested = { "pers" },
		idea = { "1srscx4" },
		art = { "Kloovree" },
		code = { "1srscx4" },
	},
	cost = 7,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 4, y = 9 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { xmult = 2 } },
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_dono
		return { vars = { center.ability.extra.xmult } }
	end,
})
--Ani

SMODS.Joker({
	key = "ermermerm",
	loc_txt = {
		name = "Erm",
		text = {
			"If played hand is a {C:attention}High Card{},",
			"{C:green}Randomize{} the rank, suit, and enhancement of all {C:attention}scored cards{}.",
		},
	},
	credits = {
		idea = { "Evil Sand" },
		art = { "None" },
		code = { "1srscx4" },
	},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	pos = { x = 1, y = 0 },
	in_pool = function(self, args)
		return true
	end,
	calculate = function(self, card, context)
		if context.before and context.scoring_name == "High Card" then
			local scoring_hand = context.scoring_hand or {}
			for _, pcard in ipairs(scoring_hand) do
			local suit = Neuratro.random_suit("Erm")
				local rank = Neuratro.random_rank("Erm2")
				pcard:set_ability(SMODS.poll_enhancement({ guaranteed = true, type_key = "Erm3" }))
				SMODS.change_base(pcard, suit, rank)
			end
			return { message = "Erm", sound = "erm_sfx" }
		end
	end,
})
SMODS.Joker({
	key = "michaeljacksonani",
	loc_txt = {
		name = "Ani r u ok",
		text = {
			"{C:attention}Kings{} of {C:diamonds}diamonds{} have priority",
			"to be drawn",
		},
	},
	credits = {
		idea = { "Evil Sand" },
		art = { "None" },
		code = { "1srscx4" },
	},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	pos = { x = 1, y = 0 },
	in_pool = function(self, args)
		return true
	end,
	calculate = function(self, card, context)
		if
			(context.setting_blind or context.pre_discard or context.after or context.open_booster)
			and not context.retrigger_joker
		then
			local hand_cards = G.hand and G.hand.cards or {}
			local full_hand = context.full_hand or {}
			if not (G.deck and G.deck.cards and G.hand and G.hand.config) then
				return
			end
			local cards_added = context.pre_discard and math.max(#hand_cards - #full_hand, 0) or #hand_cards
			for _, pcard in ipairs(G.deck.cards) do
			if pcard:get_id() == CARD_RANK.KING and pcard:is_suit(Neuratro.CONSTANTS.SUITS.DIAMONDS) and cards_added < G.hand.config.card_limit then
					draw_card(G.deck, G.hand, 90, "up", nil, pcard)
					cards_added = cards_added + 1
				end
			end
		end
		-- Make it only work on packs that draw cards
	end,
})
--Camel
SMODS.Joker({

	key = "camila",
	loc_txt = {
		name = "Camila",
		text = { "All played {C:attention}6s{} get retriggered", "and give {X:mult,C:white}X#1#{} mult." },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 3,
	credits = {
		idea = { "Evil Sand" },
		art = { "Kloovree" },
		code = { "1srscx4" },
	},
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 6, y = 9 },
	config = { extra = { xmult = 1.3 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and context.other_card and context.other_card:get_id() == CARD_RANK.SIX then
			return { repetitions = 1, card = card }
		end
		if context.individual and context.cardarea == G.play and context.other_card and context.other_card:get_id() == CARD_RANK.SIX then
			return { xmult = card.ability.extra.xmult }
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "allin",
	loc_txt = {
		name = "I'm All In",
		text = { "If you {C:red}discard{} four {C:attention}6s{},", "gain a new one with", "{E:1}random{} upgrades" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	credits = {
		idea = { "Evil Sand" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	config = { extra = {} },
	pos = { x = 8, y = 2 },
	soul_pos = { x = 9, y = 2 },
	calculate = function(self, card, context)
		if allin_should_trigger(context) then
			G.E_MANAGER:add_event(Event({
				func = function()
					randomize_allin_card(card)
					return true
				end,
			}))
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
--MinikoMew
SMODS.Joker({
	key = "minikocute",
	loc_txt = {
		name = "Mini is cute mhm pass it on",
		text = {
			"If hand contains a {C:attention}3{}, turn",
			"the card to the {C:attention}left{} to a {C:attention}3{}",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	credits = {
		sug = { "1srscx4" },
		idea = { "1srscx4" },
		art = { "SupDrazor" },
		code = { "1srscx4" },
	},
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = { x = 4, y = 4 },
	calculate = function(self, card, context)
		local full_hand = context.full_hand or {}
		if context.individual and context.cardarea == G.play and context.other_card and context.other_card:get_id() == CARD_RANK.THREE then
			for key, playing_card in pairs(full_hand) do
				if playing_card == context.other_card then
					if key - 1 > 0 then
						local left_card = full_hand[key - 1]
						if not left_card then
							break
						end
						sea(function()
							left_card:flip()
							left_card:juice_up(0.3, 0.3)
							return true
						end, 0.35, "before")
						sea(function()
							SMODS.change_base(left_card, nil, "3")
							return true
						end, 0.55, "before")
						sea(function()
							left_card:flip()
							left_card:juice_up(0.3, 0.3)
							return true
						end, 0.35, "before")
					end
				end
			end
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
--Cerbr
SMODS.Joker({
	key = "cerbr",
	loc_txt = {
		name = "Yippee!",
		text = {
			"Gains {C:mult}+#1#{} mult per {C:attention}retrigger",
			"on a played card. {C:attention}Resets{} at",
			"{C:attention}end of round{}. {C:inactive}(Currently: {C:mult}+#2#{C:inactive})",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 6,
	credits = {
		idea = { "Bigbuckies" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 0, y = 2 },
	soul_pos = { x = 3, y = 0 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { upg = 5, mult = 0, yippee = 0 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.upg, center.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if
			context.individual
			and context.cardarea == G.play
			and not context.blueprint
			and context.retrigger_joker
		then
			if context.other_card then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.upg
				G.E_MANAGER:add_event(Event({
					func = function()
						card.ability.extra.yippee = card.ability.extra.yippee + 5
						if card.ability.extra.yippee > 0 and card.ability.extra.yippee <= 20 then
							card.children.floating_sprite:set_sprite_pos({ x = 1, y = 2 })
						end
						if card.ability.extra.yippee > 20 and card.ability.extra.yippee <= 40 then
							card.children.floating_sprite:set_sprite_pos({ x = 2, y = 2 })
						end
						if card.ability.extra.yippee > 40 and card.ability.extra.yippee <= 60 then
							card.children.floating_sprite:set_sprite_pos({ x = 3, y = 2 })
						end
						if card.ability.extra.yippee > 60 and card.ability.extra.yippee <= 80 then
							card.children.floating_sprite:set_sprite_pos({ x = 4, y = 2 })
						end
						if card.ability.extra.yippee > 80 then
							card.children.floating_sprite:set_sprite_pos({ x = 5, y = 2 })
						end
						return true
					end,
				}))
				return { message = "Yippee!", sound = "Yippee" }
			end
		end
		if context.joker_main then
			local scoring_hand = context.scoring_hand or {}
			local debuffs = 0
			for _, playing_card in ipairs(scoring_hand) do
				if playing_card.debuff then
					debuffs = debuffs + 1
				end
			end
			card.ability.extra.mult = card.ability.extra.mult
				- (#scoring_hand * card.ability.extra.upg - debuffs * card.ability.extra.upg)
			return { mult = card.ability.extra.mult }
		end
		if context.end_of_round and context.cardarea == G.jokers then
			card.ability.extra.mult = 0
			card.ability.extra.yippee = 0
			card.children.floating_sprite:set_sprite_pos({ x = 3, y = 0 })
		end
	end,
})
SMODS.Joker({
	key = "milc",
	loc_txt = {
		name = "Milc",
		text = {
			"If played hand contains",
			"less {C:attention}Jacks{} of {C:diamonds}diamonds",
			"than {C:attention}2s{} held in hand,",
			"retrigger {C:attention}Jacks{} of {C:diamonds}diamonds {C:attention}#1#{}-{C:attention}#2#{} times",
		},
	},
	credits = {
		idea = { "Evil Sand" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 4, y = 1 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { rt_min = 1, rt_max = 2 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.rt_min, center.ability.extra.rt_max } }
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
			local full_hand = context.full_hand or {}
			local cerbr = 0
			local wans = 0
			for _, cards in ipairs(full_hand) do
			if cards:get_id() == CARD_RANK.JACK and cards:is_suit(Neuratro.CONSTANTS.SUITS.DIAMONDS, true) then
					cerbr = cerbr + 1
				end
			end
			for _, cards in ipairs(G.hand and G.hand.cards or {}) do
				if cards:get_id() == CARD_RANK.TWO then
					wans = wans + 1
				end
			end
			if context.other_card and context.other_card:get_id() == CARD_RANK.JACK and context.other_card:is_suit(Neuratro.CONSTANTS.SUITS.DIAMONDS) and cerbr < wans then
				return {
					repetitions = pseudorandom(
						"Milc",
						math.floor(card.ability.extra.rt_min + 0.5),
						math.floor(card.ability.extra.rt_max + 0.5)
					),
				}
			end
		end
	end,
})
--Filipino Boy
SMODS.Joker({
	key = "filipino_boy",
	loc_txt = {
		name = "Filian",
		text = {
			"Reduce {C:attention}blind{} requirement by {C:green}#1#%{}",
			"when hand is {C:attention}played{}.",
		},
	},
	credits = {
		idea = { "Evil Sand" },
		art = { "Kloovree" },
		code = { "1srscx4" },
	},
	rarity = 3,
	cost = 9,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	pos = { x = 9, y = 8 },
	in_pool = function(self, args)
		return true
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.reduce * 100 } }
	end,
	config = { extra = { reduce = 5 / 100 } },
	calculate = function(self, card, context)
		if context.before and G.GAME and G.GAME.blind then
			G.GAME.blind.chips = math.max(math.floor((G.GAME.blind.chips * (1 - card.ability.extra.reduce)) + 0.5), 1)
			G.GAME.blind.chip_text = tostring(G.GAME.blind.chips)
			return { message = "Backflip!" }
		end
	end,
})
SMODS.Joker({
	key = "frut",
	loc_txt = {
		name = "Fruit Snacks Bag",
		text = {
			"When {C:attention}blind{} is selected,",
			"lower the {C:attention}score requirement{}",
			"by {C:green}#1#%{} per {C:attention}8{} in deck.",
			"{C:inactive}(Currently {C:green}#2#%{C:inactive})",
		},
	},
	credits = {
		idea = { "Evil Sand" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "neuroCustomJokers",
	pos = { x = 5, y = 6 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { decrease = 0.4 / 100 } },
	loc_vars = function(self, info_queue, card)
		local percent = mooods_penalty_percent(card)
		return { vars = { card.ability.extra.decrease * 100, percent * 100 } }
	end,
	calculate = function(self, card, context)
		if G.GAME and G.GAME.blind and context.setting_blind then
			local percent = mooods_penalty_percent(card)
			G.GAME.blind.chips = math.max(math.floor((G.GAME.blind.chips * (1 - percent)) + 0.5), 1)
			G.GAME.blind.chip_text = tostring(G.GAME.blind.chips)
		end
	end,
})
SMODS.Joker({
	key = "moooooooooods",
	loc_txt = {
		name = "MOOODS!",
		text = {
			"If on {C:attention}last hand{} your {C:attention}current score{} is",
			"less than half of the {C:attention}required score{},",
			"{C:green}halve{} the {C:attention}required score{}.",
		},
	},
	credits = {
		idea = { "Evil Sand" },
		art = { "Kloovree" },
		code = { "1srscx4" },
	},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	pos = { x = 3, y = 4 },
	in_pool = function(self, args)
		return true
	end,
	calculate = function(self, card, context)
		if context.after and G.GAME.current_round.hands_left == 1 and G.GAME.chips < G.GAME.blind.chips / 2 then
			sea(function()
				if G.GAME.chips < G.GAME.blind.chips / 2 then
					G.GAME.blind.chips = G.GAME.blind.chips / 2
					G.GAME.blind.chip_text = tostring(G.GAME.blind.chips)
				end
				return true
			end)
		end
	end,
})
--Ellie
SMODS.Joker({
	key = "ely",
	loc_txt = {
		name = "Ellie",
		text = {
			"{C:green,E:1}#1# in #2#{} chance to create",
			"a {C:attention}neurodog{} when {C:attention}blind",
			"is selected. Gains {X:mult,C:white}x#3#{} mult",
			"per {C:attention}neurodog{} owned.",
			"{C:inactive}(Currently: {X:mult,C:white}x#4#{C:inactive})",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	credits = {
		idea = { "Bigbuckies" },
		art = { "Etzyio+" },
		code = { "1srscx4" },
	},
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = { x = 4, y = 3 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { base = 1, odds = 2, upg = 1, xmult = 1 } },
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_neurodog
		local result = 1
		if G.jokers then
			for _, joker in ipairs(joker_cards()) do
				if joker.config.center.key == "j_neurodog" then
					result = result + center.ability.extra.upg
				end
			end
			for _, joker in ipairs(playbook_cards()) do
				if joker.config.center.key == "j_neurodog" then
					result = result + center.ability.extra.upg
				end
			end
		end
		return {
			vars = {
				center.ability.extra.base * probability_scale(),
				center.ability.extra.odds,
				center.ability.extra.upg,
				result,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local result = 1
			for _, joker in ipairs(joker_cards()) do
				if joker.config.center.key == "j_neurodog" then
					result = result + card.ability.extra.upg
				end
			end
			for _, joker in ipairs(playbook_cards()) do
				if joker.config.center.key == "j_neurodog" then
					result = result + card.ability.extra.upg
				end
			end
			return { xmult = result }
		end
		if
			context.setting_blind
			and roll_with_odds("seed", card.ability.extra.base, card.ability.extra.odds)
			and G.jokers
			and G.jokers.cards
			and G.jokers.config
			and #G.jokers.cards < G.jokers.config.card_limit
		then
			SMODS.add_card({ set = "Joker", area = G.jokers, key = "j_neurodog" })
			return { message = "Ely!" }
		end
	end,
})

SMODS.Joker({
	key = "neurodog",
	loc_txt = {
		name = "Neurodog",
		text = {
			"Gives {C:mult}+#1#{} mult and {C:chips}+#2#{} chips",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	credits = {
		sug = { "Evil Sand" },
		idea = { "Evil Sand", "1srscx4" },
		art = { "Oli7" },
		code = { "1srscx4" },
	},
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 3, y = 7 },
	in_pool = function(self, args)
		return false
	end,
	config = { extra = { mult = 10, chips = 9 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.mult, center.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return { mult = card.ability.extra.mult, chips = card.ability.extra.chips }
		end
	end,
})

--Layna

SMODS.Joker({
	key = "layna",
	loc_txt = {
		name = "Layna",
		text = {
			"If scored hand has a {C:attention}9{},",
			"all scored cards give {X:mult,C:white}x#1#{} mult",
			"and {C:red,E:1}destroy{} themselves.",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "Etzyio+" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 3,
	cost = 9,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 9, y = 3 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { xmult = 3, works = false } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.before then
			local scoring_hand = context.scoring_hand or {}
			for _, play_card in ipairs(scoring_hand) do
				if is_rank(play_card, CARD_RANK.NINE) then
					card.ability.extra.works = true
					return { message = "Active" }
				end
			end
		end
		if context.individual and context.cardarea == G.play and context.other_card and card.ability.extra.works then
			return {
				xmult = card.ability.extra.xmult,
				func = function()
					SMODS.destroy_cards(context.other_card)
				end,
			}
		end
	end,
})
SMODS.Joker({
	key = "cakelayna",
	loc_txt = {
		name = "Abomination Cake",
		text = {
			"Gives {C:mult}+#1#{} Mult for each",
			"{C:attention}Bloody card{} in {C:attention}full deck{}.",
			"{C:inactive}(Currently: {C:mult}+#2#{C:inactive} Mult)",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "None" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 9, y = 9 },
	in_pool = function(self, args)
		for _, pcard in ipairs(G.playing_cards) do
			if SMODS.has_enhancement(pcard, "m_blood") then
				return true
			end
		end
		return false
	end,
	config = { extra = { mult = 3 } },
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_blood
		local blood = 0
		if G.playing_cards then
			for _, pcard in ipairs(G.playing_cards) do
				if SMODS.has_enhancement(pcard, "m_blood") then
					blood = blood + 1
				end
			end
		end
		return { vars = { center.ability.extra.mult, center.ability.extra.mult * blood } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local blood = 0
			for _, pcard in ipairs(G.playing_cards) do
				if SMODS.has_enhancement(pcard, "m_blood") then
					blood = blood + 1
				end
			end
			return { mult = card.ability.extra.mult * blood }
		end
	end,
})
--Other peopled
SMODS.Joker({
	key = "void",
	loc_txt = {
		name = "Alex Void",
		text = {
			"{C:dark_edition}Negative{} jokers give {X:mult,C:white}x#1#{} Mult",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 3,
	cost = 8,
	credits = {
		idea = { "1srscx4" },
		art = { "Etzyio+" },
		code = { "1srscx4" },
	},
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 7, y = 5 },
	config = { extra = { xmult = 2 } },
	loc_vars = function(self, info_queue, card)
		if (not card.edition) or (card.edition and card.edition.key ~= "e_negative") then
			info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
		end
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.other_joker and context.other_joker.edition and context.other_joker.edition.key == "e_negative" then
			return { xmult = card.ability.extra.xmult }
		end
	end,
	in_pool = function(self, args)
		local inpool = false
		for _, joker in ipairs(joker_cards()) do
			if joker.edition and joker.edition.key == "e_negative" then
				inpool = true
				break
			end
		end
		for _, joker in ipairs(playbook_cards()) do
			if joker.edition and joker.edition.key == "e_negative" then
				inpool = true
				break
			end
		end
		return inpool
	end,
})
SMODS.Joker({
	key = "jorker",
	loc_txt = {
		name = "J0ker",
		text = {
			"Gives {C:chips}+#1#{} chips",
			"per joker owned.",
			"{C:inactive}(Currently {}{C:chips}+#2#{}{C:inactive})",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	cost = 4,
	credits = {
		sug = { "Pers" },
		idea = { "1srscx4" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 4, y = 0 },
	config = { extra = { chips_bonus = 15 } },
	loc_vars = function(self, info_queue, center)
		return {
			vars = {
				center.ability.extra.chips_bonus,
				center.ability.extra.chips_bonus
					* ((G.jokers and #G.jokers.cards or 0) + (G.playbook_extra and #G.playbook_extra.cards or 0)),
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chips_bonus
					* ((G.jokers and #G.jokers.cards or 0) + (G.playbook_extra and #G.playbook_extra.cards or 0)),
			}
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "shoomimi",
	loc_txt = {
		name = "Shoomimi",
		text = {
			"Cards with {C:attention}shoomimi seal{} give {C:money}$#1#",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 8,
	credits = {
		idea = { "Evil Sand" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 2, y = 1 },
	add_to_deck = function(self, card, from_debuff)
		G.shared_seals["shoomiminion_seal"] = Sprite(0, 0, 71, 95, G.ASSET_ATLAS["neuroEnh"], { x = 8, y = 0 })
	end,
	remove_from_deck = function(self, card, from_debuff)
		for _, joker in ipairs(joker_cards()) do
			if
				joker.config.center.key == "j_shoomimi"
				or (joker.config.center.key == "j_evilsand" and card.area ~= G.playbook_extra)
			then
				return
			end
		end
		for _, joker in ipairs(playbook_cards()) do
			if joker.config.center.key == "j_shoomimi" then
				return
			end
		end
		G.shared_seals["shoomiminion_seal"] = Sprite(0, 0, 71, 95, G.ASSET_ATLAS["neuroEnh"], { x = 9, y = 0 })
	end,
	in_pool = function(self, args)
		local is_in_pool = false
		for _, playing_card in ipairs(G.playing_cards) do
			if playing_card.seal == "shoomiminion_seal" then
				is_in_pool = true
				break
			end
		end
		return is_in_pool
	end,
	config = { extra = { money = 5 } },
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_SEALS["shoomiminion_seal"]
		return { vars = { center.ability.extra.money } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card and context.other_card.seal == "shoomiminion_seal" then
				return { dollars = card.ability.extra.money }
			end
		end
	end,
})

SMODS.Joker({
	key = "queenpb",
	loc_txt = {
		name = "Queenpb",
		text = {
			"Gives {X:mult,C:white}x#1#{} mult. Increase this by {X:mult,C:white}x#2#{} at {C:attention}end of round{}.",
			"Changes music to {C:attention}LIFE{} or {C:attention}BOOM{}.",
		},
	},
	credits = {
		sug = { "Emuz" },
		idea = { "1srscx4" },
		art = { "Etzyio+" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = { x = 4, y = 5 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { xmult = 1, upg = 0.25, song = "" } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.xmult, center.ability.extra.upg } }
	end,
	add_to_deck = function(self, card, from_debuff)
		card.ability.extra.song = Neuratro.random_song("pb")
		local other_queenpb = Neuratro.find_joker("j_queenpb")
		if other_queenpb and other_queenpb ~= card then
			card.ability.extra.song = other_queenpb.ability.extra.song
		end
		set_queenpb_pool_flags(card.ability.extra.song)
	end,
	remove_from_deck = function(self, card, from_debuff)
		if Neuratro.has_joker("j_queenpb") then
			return
		end
		set_queenpb_pool_flags(nil)
	end,
	calculate = function(self, card, context)
		if
			context.end_of_round
			and context.cardarea == G.jokers
			and not context.blueprint
			and not context.retrigger_joker
		then
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.upg
			return { message = "Upgrade!" }
		end
		if context.joker_main then
			return { xmult = card.ability.extra.xmult }
		end
	end,
})
SMODS.Joker({
	key = "lucy",
	loc_txt = {
		name = "Lucy",
		text = {
			"Gains {C:mult}+#1#{} mult if played",
			"hand contains a {C:attention}flush{}.",
			"{C:inactive}(Currently: {C:mult}+#2#{C:inactive})",
		},
	},
	credits = {
		idea = { "Evil Sand" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = { x = 2, y = 4 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { upg = 4, mult = 0 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.upg, center.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if
			context.before
			and next(context.poker_hands["Flush"])
			and not context.blueprint
			and not context.retrigger_joker
		then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.upg
			return { message = "Upgrade!" }
		end
		if context.joker_main then
			return { mult = card.ability.extra.mult }
		end
	end,
})
SMODS.Joker({
	key = "teru",
	loc_txt = {
		name = "Teru",
		text = {
			"Gains {X:mult,C:white}x#1#{} mult when a",
			"{C:attention}face card{} is scored.",
			"{C:inactive}(Currently: {X:mult,C:white}x#2#{C:inactive})",
		},
	},
	credits = {
		sug = { "Evil Sand" },
		idea = { "1srscx4" },
		art = { "None" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = { x = 1, y = 0 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { upg = 0.03, xmult = 1 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.upg, center.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if
			context.individual
			and context.cardarea == G.play
			and context.other_card
			and context.other_card:is_face()
			and not context.blueprint
			and not context.retrigger_joker
		then
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.upg
		end
		if context.joker_main then
			return { xmult = card.ability.extra.xmult }
		end
	end,
})
SMODS.Joker({
	key = "kyoto",
	loc_txt = {
		name = "KYOTO AT ALL COSTS",
		text = {
			"{C:green}#2# in #3#{} chance of",
			"giving {X:mult,C:white}X#1#{} Mult.",
		},
	},
	credits = {
		idea = { "PaulaMarina" },
		art = { "Evil Sand" },
		code = { "PaulaMarina" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 3, y = 6 },
	soul_pos = { x = 4, y = 6 },
	config = { extra = { odds = 20, Xmult = 100, base = 1 } },
	loc_vars = function(self, info_queue, center)
		return {
			vars = {
				center.ability.extra.Xmult,
				probability_scale() * center.ability.extra.base,
				center.ability.extra.odds,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if roll_with_odds("kyoto", card.ability.extra.base, card.ability.extra.odds) then
				return {
					message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.Xmult } }),
					Xmult_mod = card.ability.extra.Xmult,
				}
			else
				local miss_messages = {
					"Nope!",
					"Lmao!",
					"Not Kyoto!",
					"So Close!",
					"Too Many PHDs!",
					"Not Enough PHDs!",
					"Neuro Is Better!",
					"Doug Is Bald!",
				}
				return { message = pseudorandom_element(miss_messages, pseudoseed("kyoto")) }
			end
		end
	end,
})
SMODS.Joker({
	key = "btmc",
	loc_txt = {
		name = "BTMC",
		text = {
			"Cards with {C:attention}Osu! seal{} give {X:mult,C:white}x#1#{} Mult",
			"per {C:attention}consecutive{} hand that contains",
			"a scoring card with {C:attention}Osu! seal{}.",
			"{C:inactive}(Currently: {X:mult,C:white}x#2#{C:inactive})",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "None" },
		code = { "1srscx4" },
	},
	cost = 8,
	rarity = 3,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	pos = { x = 1, y = 0 },
	in_pool = function(self, args)
		for _, pcard in ipairs(G.playing_cards) do
			if pcard.seal == "osu_seal" then
				return true
			end
		end
		return false
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS["osu_seal"]
		return { vars = { card.ability.extra.upg, card.ability.extra.xmult } }
	end,
	config = { extra = { xmult = 1, upg = 0.5 } },
	calculate = function(self, card, context)
		if context.before and is_live_context(context) then
			return btmc_before_result(card, context.scoring_hand or {})
		end
		if context.individual and context.cardarea == G.play and has_seal(context.other_card, "osu_seal") then
			return { xmult = card.ability.extra.xmult }
		end
	end,
})
--Glorp
SMODS.Joker({
	key = "Glorp",
	loc_txt = {
		name = "Glorp",
		text = {
			"At start of blind, add",
			"{C:attention}#1# glorpy{} {C:green}gleeb{} cards to deck",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 8,
	credits = {
		idea = { "Evil Sand" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 9, y = 0 },
	config = { extra = { amount = 20 } },
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_glorp
		info_queue[#info_queue + 1] = { set = "Other", key = "Gleeb_desc" }
		return { vars = { center.ability.extra.amount } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			for i = 1, card.ability.extra.amount do
				G.E_MANAGER:add_event(Event({
					func = function()
						local _rank = pseudorandom_element(
							{ "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14" },
							pseudoseed("seed")
						)
					local _card = create_playing_card({
						front = G.P_CARDS["G" .. "_" .. _rank],
						center = G.P_CENTERS.c_base,
					}, G.deck, nil, nil, { G.C.SECONDARY_SET.Enhanced })
					_card:set_ability(G.P_CENTERS["m_glorp"], nil, true)
					SMODS.change_base(_card, "Glorpsuit")
					cerber_apply_to_obtained_card(_card)
					return true
				end,
			}))
			end
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "envy",
	loc_txt = {
		name = "Envious Joker",
		text = {
			"Played cards with the",
			"{C:green}gleeb{} suit give",
			"{C:mult}+#1#{} mult when scored.",
		},
	},
	credits = {
		idea = { "Evil Sand" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 0, y = 4 },
	in_pool = function(self, args)
		local is_in_pool = false
		for _, joker in ipairs(joker_cards()) do
			if joker.config.center.key == "j_Glorp" then
				is_in_pool = true
				break
			end
		end
		for _, joker in ipairs(playbook_cards()) do
			if joker.config.center.key == "j_Glorp" then
				is_in_pool = true
				break
			end
		end
		if G.GAME.selected_back.effect.center.key == "b_glorpdeck" then
			is_in_pool = true
		end
		if not is_in_pool then
			for _, playing_card in ipairs(G.playing_cards) do
				if playing_card:is_suit("Glorpsuit") then
					is_in_pool = true
					break
				end
			end
		end
		return is_in_pool
	end,
	config = { extra = { mult = 6 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card and context.other_card:is_suit("Glorpsuit") then
				return { mult = card.ability.extra.mult }
			end
		end
	end,
})
--Emotes/Neurocord
SMODS.Joker({
	key = "jokr",
	loc_txt = {
		name = "joukr",
		text = {
			"When opening a {C:attention}standard pack{},",
			"{C:green,E:1}#1# in #2#{} chance to obtain a",
			"random playing card",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	credits = {
		idea = { "2nd Umbrella" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 6, y = 1 },
	config = { extra = { odds = 3, base = 1 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { (G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal or 1) * center.ability.extra.base, center.ability.extra.odds } }
	end,
	calculate = function(self, card, context)
		if
			context.open_booster
			and context.card.ability.set == "Booster"
			and context.card.ability.name:find("Standard")
		then
			if roll_with_odds("seed", card.ability.extra.base, card.ability.extra.odds) then
				G.E_MANAGER:add_event(Event({
					func = function()
						local _rank = pseudorandom_element(
							{ "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14" },
							pseudoseed("seed")
						)
						local _suit = pseudorandom_element({ "S", "H", "D", "C" }, pseudoseed("seed"))
						local _card = create_playing_card({
							front = G.P_CARDS[_suit .. "_" .. _rank],
							center = G.P_CENTERS.c_base,
						}, G.hand, nil, nil, { G.C.SECONDARY_SET.Enhanced })
						local seal_type = pseudorandom("seed")
						local enh_type = pseudorandom("seed")
						local edit_type = pseudorandom("seed")

						if seal_type > 0.4 then
							_card:set_seal("Red", true)
						elseif seal_type > 0.3 then
							_card:set_seal("Blue", true)
						elseif seal_type > 0.2 then
							_card:set_seal("Gold", true)
						elseif seal_type > 0.1 then
							_card:set_seal("Purple", true)
						end
						if enh_type > 0.8 then
							_card:set_ability(G.P_CENTERS["m_twin"], nil, true)
						elseif enh_type > 0.7 then
							_card:set_ability(G.P_CENTERS["m_glass"], nil, true)
						elseif enh_type > 0.6 then
							_card:set_ability(G.P_CENTERS["m_lucky"], nil, true)
						elseif enh_type > 0.5 then
							_card:set_ability(G.P_CENTERS["m_wild"], nil, true)
						elseif enh_type > 0.4 then
							_card:set_ability(G.P_CENTERS["m_bonus"], nil, true)
						elseif enh_type > 0.3 then
							_card:set_ability(G.P_CENTERS["m_mult"], nil, true)
						elseif enh_type > 0.2 then
							_card:set_ability(G.P_CENTERS["m_steel"], nil, true)
						elseif enh_type > 0.1 then
							_card:set_ability(G.P_CENTERS["m_stone"], nil, true)
						elseif enh_type > 0 then
							_card:set_ability(G.P_CENTERS["m_gold"], nil, true)
						end
						if edit_type > 0.2 then
							_card:set_edition("e_foil", true)
						elseif edit_type > 0.10 then
							_card:set_edition("e_holo", true)
						elseif edit_type > 0.02 then
							_card:set_edition("e_polychrome", true)
						elseif edit_type > 0 then
							_card:set_edition("e_negative", true)
						end
						G.E_MANAGER:add_event(Event({
							func = function()
								SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
								return true
							end,
						}))
						return true
					end,
				}))
			end
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "xdx|",
	loc_txt = {
		name = "xdx",
		text = {
			"Gives a random amount of",
			"{X:mult,C:white}Xmult{} between {X:mult,C:white}X#1#{} and {X:mult,C:white}X#2#{}",
		},
	},
	credits = {
		sug = { "Evil Sand" },
		idea = { "Emuz" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 7, y = 2 },
	config = { extra = { min = 1, max = 60 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.min / 10, center.ability.extra.max / 10 } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return { xmult = pseudorandom("seed", card.ability.extra.min, card.ability.extra.max) / 10 }
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "corpa",
	loc_txt = {
		name = "Corpa",
		text = {
			"When {C:attention}leaving the shop{},",
			"gain {C:money}$#1#{} for every {C:money}$#2#{} {C:attention}spent{} in that shop.",
			"{C:inactive}(You have spent: {C:money}$#3#{C:inactive})",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 9,
	credits = {
		idea = { "1srscx4" },
		art = { "Etzyio+" },
		code = { "1srscx4" },
	},
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 7, y = 3 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { goal = 5, gain = 2, current = 0, triggers = false } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.gain, center.ability.extra.goal, center.ability.extra.current } }
	end,
	calculate = function(self, card, context)
		if (context.buying_card or context.open_booster) and not context.retrigger_joker then
			card.ability.extra.current = card.ability.extra.current + context.card.cost
		end
		if context.end_of_round and G.GAME.current_round.free_rerolls == 0 and not context.retrigger_joker then
			card.ability.extra.triggers = true
		end
		if context.reroll_shop and G.GAME.current_round.free_rerolls == 0 and not context.retrigger_joker then
			if card.ability.extra.triggers then
				card.ability.extra.current = card.ability.extra.current + G.GAME.current_round.reroll_cost - 1
			end
			card.ability.extra.triggers = true
		end
		if context.ending_shop and not context.retrigger_joker then
			card.ability.extra.triggers = false
		end
		if context.ending_shop then
			local money = 0
			while card.ability.extra.current >= card.ability.extra.goal do
				card.ability.extra.current = card.ability.extra.current - card.ability.extra.goal
				money = money + card.ability.extra.gain
			end
			card.ability.extra.current = 0
			return { dollars = money }
		end
	end,
})
SMODS.Joker({
	key = "schedule",
	loc_txt = {
		name = "Schedule",
		text = {
			"When {C:attention}blind is selected,",
			"{C:green,E:1}#1# in #2#{} chance to create",
			"a {C:attention}wheel of fortune {C:tarot}tarot.",
			"All probabilities are added {C:green}1",
			"{C:inactive}(Ex: {C:green}2 in 7 {C:inactive}-> {C:green}3 in 7{C:inactive})",
		},
	},
	credits = {
		sug = { "Mr. Jdk" },
		idea = { "Evil Sand" },
		art = { "Kloovree" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 9, y = 7 },
	config = { extra = { odds = 3, base = 1, oa6added = "0" } },
	add_to_deck = function(self, card, from_debuff)
		if G.GAME and G.GAME.probabilities then
			G.GAME.probabilities.normal = math.max((G.GAME.probabilities.normal or 1) + 1, 1)
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		local multiplier = 1
		local to_do = tonumber(card.ability.extra.oa6added) or 0
		local done = 0
		for pos, joker in ipairs(joker_cards()) do
			if done < to_do then
				if joker.config.center.key == "j_oops" then
					multiplier = multiplier * 2
					done = done + 1
				end
			end
		end
		if done < to_do then
			for pos, joker in ipairs(playbook_cards()) do
				if joker.config.center.key == "j_oops" then
					if done < to_do then
						multiplier = multiplier * 2
						done = done + 1
					end
				end
			end
		end
		if G.GAME and G.GAME.probabilities then
			G.GAME.probabilities.normal = math.max((G.GAME.probabilities.normal or 1) - (1 * multiplier), 1)
		end
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.c_wheel_of_fortune
		return {
			vars = { probability_scale() * card.ability.extra.base, card.ability.extra.odds },
		}
	end,
	calculate = function(self, card, context)
		if
			context.setting_blind
			and roll_with_odds("schedule", card.ability.extra.base, card.ability.extra.odds)
			and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
		then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			G.E_MANAGER:add_event(Event({
				func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							SMODS.add_card({
								set = "Tarot",
								key = "c_wheel_of_fortune",
							})
							G.GAME.consumeable_buffer = 0
							return true
						end,
					}))
					return true
				end,
			}))
		end
		if context.card_added and context.card and context.card.config and context.card.config.center and context.card.config.center.key == "j_oops" then
			card.ability.extra.oa6added = tostring((tonumber(card.ability.extra.oa6added) or 0) + 1)
		end
	end,
})
SMODS.Joker({
	key = "mod_purge",
	loc_txt = {
		name = "Mod Purge",
		text = {
			"Prevent death and",
			"{C:red,E:1}destroy self and another random joker.",
		},
	},
	credits = {
		sug = { "Emuz" },
		idea = { "1srscx4" },
		art = { "None" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	pos = { x = 1, y = 0 },
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over and context.main_eval and not context.blueprint then
			local valid_index = {}
			for pos, joker in ipairs(joker_cards()) do
				if not joker.ability.eternal and joker ~= card then
					valid_index[#valid_index + 1] = pos
				end
			end

			G.E_MANAGER:add_event(Event({
				func = function()
					G.hand_text_area.blind_chips:juice_up()
					G.hand_text_area.game_chips:juice_up()
					play_sound("tarot1")
					card:start_dissolve()
					local victim = nil
					if G and G.jokers and G.jokers.cards and #valid_index > 0 then
						victim = G.jokers.cards[pseudorandom_element(valid_index, pseudoseed("purge"))]
						if victim then
							victim:start_dissolve()
						end
					end
					return true
				end,
			}))
			return {
				message = "'Saved'",
				saved = "modpurgesave",
				colour = G.C.RED,
			}
		end
	end,
})
SMODS.Joker({
	key = "nwooper",
	loc_txt = {
		name = "Neurooper",
		text = {
			"She's just a silly lil fella",
			"{C:inactive,s:0.8}(Does nothing?)",
		},
	},
	credits = {
		idea = { "Evil Sand" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 1,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 8, y = 4 },
	add_to_deck = function(self, card, from_debuff)
		for _, joker in ipairs(joker_cards()) do
			if joker.config.center.key == "j_Ermfish" then
				joker.children.center:set_sprite_pos({ x = 1, y = 7 })
			end
		end
		for _, joker in ipairs(playbook_cards()) do
			if joker.config.center.key == "j_Ermfish" then
				joker.children.center:set_sprite_pos({ x = 1, y = 7 })
			end
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		for _, joker in ipairs(joker_cards()) do
			if joker.config.center.key == "j_nwooper" then
				return
			end
		end
		for _, joker in ipairs(playbook_cards()) do
			if joker.config.center.key == "j_nwooper" then
				return
			end
		end
		for _, joker in ipairs(joker_cards()) do
			if joker.config.center.key == "j_Ermfish" then
				joker.children.center:set_sprite_pos({ x = 0, y = 7 })
			end
		end
		for _, joker in ipairs(playbook_cards()) do
			if joker.config.center.key == "j_Ermfish" then
				joker.children.center:set_sprite_pos({ x = 0, y = 7 })
			end
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "Ermfish",
	loc_txt = {
		name = "Erm Fish",
		text = {
			"Gives {X:dark_edition,C:white}^#1#{} mult if",
			"you have {C:attention}neurooper{}",
			"Currently crashes the game, sorry.",
		},
	},
	credits = {
		idea = { "Evil Sand" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 0, y = 7 },
	in_pool = function(self, args)
		return true
	end,
	add_to_deck = function(self, card, from_debuff)
		for _, joker in ipairs(joker_cards()) do
			if joker.config.center.key == "j_nwooper" then
				card.children.center:set_sprite_pos({ x = 1, y = 7 })
			end
		end
		for _, joker in ipairs(playbook_cards()) do
			if joker.config.center.key == "j_nwooper" then
				card.children.center:set_sprite_pos({ x = 1, y = 7 })
			end
		end
	end,
	config = { extra = { power = 2 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_nwooper
		return { vars = { card.ability.extra.power } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			for _, pcard in ipairs(joker_cards()) do
				if pcard.config.center.key == "j_nwooper" then
					return {
						remove_default_message = true,
						xmult = card.ability.extra.power,
						message = { "^" .. tostring(card.ability.extra.power) },
						colour = G.C.DARK_EDITION,
						sound = "emultsfx",
					}
				end
			end
			for _, pcard in ipairs(playbook_cards()) do
				if pcard.config.center.key == "j_nwooper" then
					return {
						remove_default_message = true,
						xmult = card.ability.extra.power,
						message = { "^" .. tostring(card.ability.extra.power) },
						colour = G.C.DARK_EDITION,
						sound = "emultsfx",
					}
				end
			end
		end
	end,
})
SMODS.Joker({
	key = "schizoedm",
	loc_txt = {
		name = "SCHIZO",
		text = {
			"At {C:attention}start{} of round create ",
			"a random {C:dark_edition}negative{} joker.",
			"At {C:attention}end{} of round {C:red,E:1}destroy{} the created joker.",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "Tony7268" },
		code = { "1srscx4" },
	},
	atlas = "animeschizo",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 1, y = 0 },
	in_pool = function(self, args)
		return true
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			G.GAME.schizo = true
			local joker = SMODS.add_card({ set = "Joker", edition = "e_negative", stickers = { "schizo_sticker" } })
			for _, sticker in ipairs(SMODS.Sticker.obj_buffer) do
				if sticker ~= "schizo_sticker" and joker.ability[sticker] then
					joker:remove_sticker(sticker)
				end
			end
			joker.sell_cost = 0
			G.GAME.schizo = false
		end
		if context.end_of_round and context.main_eval and not context.blueprint then
			for _, joker in ipairs(joker_cards()) do
				if joker.ability.schizo_sticker then
					SMODS.destroy_cards(joker)
				end
			end
		end
	end,
})

--Other
SMODS.Joker({
	key = "argirl", --joker key
	loc_txt = { -- local text
		name = "{C:dark_edition}Study-Sama{}",
		text = {
			"{C:dark_edition,E:2}A R{}{E:2}andom played card gets",
			"{E:2}retri{}{C:dark_edition,E:2}G{}{E:2}gered between #1# and #2# times.{}",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	credits = {
		sug = { "Flashfire8" },
		idea = { "2nd Umbrella" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 0, y = 0 },
	config = { extra = {
		sel_card = 1,
		min = 1,
		max = 10,
	} },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.min, center.ability.extra.max } }
	end,

	calculate = function(self, card, context)
		local scoring_hand = context.scoring_hand or {}
		if context.before and not context.retrigger_joker then
			if #scoring_hand > 0 then
				card.ability.extra.sel_card = pseudorandom("seed", 1, #scoring_hand)
			else
				card.ability.extra.sel_card = 1
			end
		end
		if
			not context.end_of_round
			and context.repetition
			and scoring_hand[card.ability.extra.sel_card]
			and context.other_card == scoring_hand[card.ability.extra.sel_card]
		then
			return { repetitions = pseudorandom("seed", card.ability.extra.min, card.ability.extra.max) }
		end
	end,
	in_pool = function(self, args)
		--whether or not this card is in the pool, return true if it is, return false if its not
		return true
	end,
})
SMODS.Joker({
	key = "hiyori",
	loc_txt = {
		name = "Hiyori",
		text = {
			"Give {X:chips,C:white}x#1#{} + {X:chips,C:white}x#2#{} chips.",
			"per {C:hearts}heart{} card in {C:attention}full deck{}",
			"{C:red,E:1}All heart cards are debuffed.",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 3,
	cost = 8,
	credits = {
		idea = { "1srscx4" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 5, y = 0 },
	config = { extra = { mult = 1, increase = 0.15 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.mult, center.ability.extra.increase } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.retrigger_joker then
			for _, playing_card in ipairs(G.playing_cards) do
				if playing_card.base.suit == "Hearts" then
					G.E_MANAGER:add_event(Event({
						func = function()
							playing_card:set_debuff(true)
							return true
						end,
					}))
				end
			end
		end
		if context.joker_main then
			for _, playing_card in ipairs(G.playing_cards) do
				if playing_card.base.suit == "Hearts" then
					G.E_MANAGER:add_event(Event({
						func = function()
							playing_card:set_debuff(false)
							return true
						end,
					}))
				end
			end
			local mult = card.ability.extra.mult
			for _, playing_card in ipairs(G.playing_cards) do
				if playing_card.base.suit == "Hearts" then
					mult = mult + card.ability.extra.increase
					G.E_MANAGER:add_event(Event({
						func = function()
							playing_card:set_debuff(true)
							return true
						end,
					}))
				end
			end
			return { xchips = mult }
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "filtersister",
	loc_txt = {
		name = "Nere",
		text = {
			"Gains {X:mult,C:white}x#1#{} mult when a",
			"{V:1}filtered card{} gets debuffed.",
			"{C:inactive}(Currently {X:mult,C:white}x#2#{C:inactive})",
		},
	},
	credits = {
		sug = { "Flashfire8" },
		idea = { "1srscx4" },
		art = { "Kloovree" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	pos = { x = 7, y = 6 },
	in_pool = function(self, args)
		local inpool = false
		for _, joker in ipairs(joker_cards()) do
			if joker.edition and joker.edition.key == "e_filtered" then
				inpool = true
				break
			end
		end
		for _, joker in ipairs(playbook_cards()) do
			if joker.edition and joker.edition.key == "e_filtered" then
				inpool = true
				break
			end
		end
		return inpool
	end,
	config = { extra = { upg = 0.25, xmult = 1 } },
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_filtered
		return { vars = { center.ability.extra.upg, center.ability.extra.xmult, colours = { HEX("589c4b") } } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return { xmult = card.ability.extra.xmult }
		end
	end,
})
SMODS.Joker({
	key = "anteater",
	loc_txt = {
		name = "Anteater",
		text = {
			"Each scored {C:attention}2{} or {C:attention}3{}",
			"has a {C:green,E:1}#1# in #2#{} chance",
			"of being {C:red,E:1}destroyed{}.",
		},
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	credits = {
		sug = { "Evil Sand" },
		idea = { "Evil Sand" },
		art = { "Tony7268" },
		code = { "PaulaMarina" },
	},
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 8, y = 7 },
	config = { extra = { odds = 2, base = 1 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = { probability_scale() * self.config.extra.base, self.config.extra.odds },
		}
	end,
	calculate = function(self, card, context)
		if context.destroy_card and not context.repetition and not context.blueprint then
			if context.destroy_card:get_id() == CARD_RANK.TWO or context.destroy_card:get_id() == CARD_RANK.THREE then
				local scoring_hand = context.scoring_hand or {}
				for _key, val in ipairs(scoring_hand) do
					if context.destroy_card == val and roll_with_odds("anteater", card.ability.extra.base, self.config.extra.odds) then
						return { remove = true }
					end
				end
			end
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})

--Dev
SMODS.Joker({
	key = "me!",
	loc_txt = {
		name = "1srscx4",
		text = {
			"At {C:attention}end of round{}, multiplies most values of {C:attention}neuratro{}",
			"joker to the right by {X:attention,C:white}x#1#{}.",
			"{X:attention,C:white}#2#",
		},
	},
	atlas = "neuroCustomJokers",
	rarity = "dev",
	credits = {
		idea = { "1srscx4" },
		art = { "Kloovree" },
		code = { "1srscx4" },
	},
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = false,
	rental_compat = false,
	pos = { x = 4, y = 7 },
	config = { extra = { multiplier = 1.5 } },
	loc_vars = function(self, info_queue, center)
		local compatible = true
		local text = "Incompatible"
		local self_pos = 0
		local area = center.area
		if G.GAME and area and area.cards and #area.cards > 0 then
			for key, playing_card in ipairs(area.cards) do
				if playing_card == center then
					self_pos = key
				end
			end
			if self_pos > 0 and self_pos < #area.cards and area.cards[self_pos + 1] ~= nil then
				for _, valid in ipairs(neuro_jokers) do
					if area.cards[self_pos + 1].config.center.key == valid then
						text = "Compatible"
						break
					end
				end
			end
		end
		return { vars = { center.ability.extra.multiplier, text } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			local works = false
			local self_pos = 0
			local area = card.area
			if not (area and area.cards and #area.cards > 0) then
				return { message = "Cannot upgrade" }
			end
			for key, playing_card in ipairs(area.cards) do
				if playing_card == card then
					self_pos = key
				end
			end
			if self_pos > 0 and self_pos < #area.cards and area.cards[self_pos + 1] ~= nil then
				for _, valid in ipairs(neuro_jokers) do
					if area.cards[self_pos + 1].config.center.key == valid then
						works = true
						break
					end
				end
			end
			if works then
				local success, err = pcall(function()
					for key, effect in pairs(area.cards[self_pos + 1].ability.extra) do
						if type(effect) == "number" then
							area.cards[self_pos + 1].ability.extra[key] = effect * card.ability.extra.multiplier
						end
					end
				end)
				if not success then
					return { message = "Failed to Upgrade" }
				end
				return { message = "Upgrade!" }
			end
			if not works then
				return { message = "Cannot upgrade" }
			end
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "Emuz",
	loc_txt = {
		name = "Noriko",
		text = {
			{
				"{C:dark_edition}Negative{} cards give ",
				"{C:attention}#1#x{} their base {C:chips}chip{} value and {C:mult}+#1#{} mult.",
				"and cannot be debuffed nor flipped",
			},
			{
				"First {C:red}discarded{} card turns {C:dark_edition}negative{}",
				"If you discard exactly 3 {C:dark_edition}negative{}",
				"cards, {C:attention}destroy{} them and",
				"gain a {E:1}random{} {C:dark_edition}negative{} joker.",
			},
		},
	},
	atlas = "neuroCustomJokers",
	rarity = "dev",
	credits = {
		idea = { "Emuz", "1srscx4" },
		art = { "Ramen" },
		code = { "1srscx4" },
	},
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = false,
	rental_compat = false,
	pos = { x = 3, y = 1 },
	config = { extra = { joker = 0, mult = 10 } },
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
		return { vars = { center.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		local full_hand = context.full_hand or {}
		if
			context.pre_discard
			and not context.blueprint
			and G.GAME.current_round.discards_used <= 0
			and not context.retrigger_joker
		then
			local first_discard_card = full_hand[1]
			if not first_discard_card then
				return
			end
			sea(function()
				first_discard_card:flip()
				first_discard_card:juice_up(0.3, 0.3)
				return true
			end, 0.35, "after")
			sea(function()
				first_discard_card:set_edition("e_negative", true)
				return true
			end, 0.55, "after")
			sea(function()
				first_discard_card:flip()
				first_discard_card:juice_up(0.3, 0.3)
				return true
			end, 0.35, "after")
		end
		if
			context.individual
			and context.cardarea == G.play
			and not context.blueprint
			and not context.retrigger_joker
			and context.other_card
		then
			local bonus = emuz_chip_bonus(context.other_card, card.ability.extra.mult)
			if bonus then
				return bonus
			end
		end
		if
			context.discard
			and all_cards_negative(full_hand, 3)
			and not context.blueprint
			and not context.retrigger_joker
		then
			for _, playing_card in ipairs(full_hand) do
				SMODS.destroy_cards(playing_card)
			end
			card.ability.extra.joker = card.ability.extra.joker + 1
			if card.ability.extra.joker >= 3 then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.4,
					func = function()
						play_sound("timpani")
						SMODS.add_card({ set = "Joker", edition = "e_negative" })
						card:juice_up(0.3, 0.5)
						return true
					end,
				}))
				card.ability.extra.joker = 0
			end
		end
		if context.hand_drawn and is_live_context(context) and G.hand and G.hand.cards then
			for i = 1, #G.hand.cards do
				local hand_card = G.hand.cards[i]
				if has_negative_edition(hand_card) and hand_card.debuff then
					SMODS.debuff_card(hand_card, "prevent_debuff", "any")
					G.hand:change_size(1)
				end
				if has_negative_edition(hand_card) and hand_card.facing == "back" then
					hand_card:flip()
				end
			end
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})
SMODS.Joker({
	key = "emojiman",
	loc_txt = {
		name = "EmojiMan",
		text = {
			"{C:attention}Smiley face{} gives",
			"{X:mult,C:white}x#1#{} mult instead.",
			"{C:attention}Smiley face{} may",
			"appear multiple times.",
		},
	},
	atlas = "neuroCustomJokers",
	rarity = "dev",
	credits = {
		idea = { "Evil Sand", "Emojiman", "1srscx4" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	pos = { x = 5, y = 1 },
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { xmult = 3 } },
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_smiley
		return { vars = { center.ability.extra.xmult } }
	end,
})
-- Part of the code from the next joker is also done by Aikoyori, again, check them out!
SMODS.Joker({
	key = "j_evilsand",
	loc_txt = {
		name = "Evil Sand",
		text = {
			{
				"Plays the last two {C:attention}destroyed{} cards.",
			},
			{
				"{C:attention}Stores{} the last {C:attention}#1# jokers sold{}.",
				"When you sell a total value of {C:money}$#2#{},",
				"increase this amount by {C:attention}1{}. {C:inactive}({C:money}$#3#{C:inactive} left)",
				"If you get a second copy of this joker,",
				"destroy it and {C:attention}double{} this joker's storage",
				"{C:inactive}Click on the joker to check the jokers stored.",
				"{C:inactive}(This part of the code was done by {C:attention}Aikoyori{C:inactive}, check them out!)",
			},
		},
	},
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	rental_compat = false,
	in_pool = function(self, args)
		return true
	end,
	config = { extra = { card1 = nil, card2 = nil, turn = "1", sold = 0, goal = 50 }, extras = {} },
	add_to_deck = function(self, card, from_debuff)
		if not G.playbook_extra then
			return
		end
		if evilsand_has_other_copy(card) then
			G.playbook_extra.config.card_limit = math.min(
				((G.playbook_extra.config.card_limit - 2) * 2) + 2,
				PLAYBOOK_MAX_CARD_LIMIT
			)
			SMODS.destroy_cards(card)
			return true
		end
		G.playbook_extra.states.collide.can = true
		G.playbook_extra.states.visible = false
		G.playbook_extra.config.card_limit = 4
		sea(function()
			G.GAME.playbook_hph = #SMODS.find_card("j_evilsand", true)
			return true
		end, 0)
	end,
	remove_from_deck = function(self, card, from_debuff)
		if not G.playbook_extra then
			return
		end
		if not evilsand_has_other_copy(card) then
			for _, v in ipairs(playbook_cards()) do
				if v.ability and v.ability.set == "Default" then
					v:start_dissolve()
				end
			end
		end
		sea(function()
			G.GAME.playbook_hph = #SMODS.find_card("j_evilsand", true)
			if G.GAME.playbook_hph < 1 then
				G.playbook_extra.states.collide.can = false
				G.playbook_extra.states.visible = false
				for _, cr in ipairs(playbook_cards()) do
					if cr.ability.consumeable then
						draw_card(G.playbook_extra, G.consumeables, nil, nil, false, cr)
					elseif cr.ability.set == "Joker" then
						draw_card(G.playbook_extra, G.jokers, nil, nil, false, cr)
					else
						draw_card(G.playbook_extra, G.deck, nil, nil, false, cr)
					end
				end
			end
			return true
		end, 0)
	end,
	credits = {
		idea = { "Evil Sand" },
		art = { "Evil Sand" },
		code = { "Aikoyori", "1srscx4", "Aikoyori" },
	},
	rarity = "dev",
	cost = 20,
	atlas = "neuroCustomJokers",
	pos = { x = 0, y = 1 },
	soul_pos = { x = 1, y = 1 },
	loc_vars = function(self, info_queue, card)
		local yes = false
		if G.jokers and #G.jokers.cards > 0 then
			for _, joker in ipairs(joker_cards()) do
				if joker.config.center.key == "j_evilsand" then
					yes = true
					break
				end
			end
		end
		return {
			vars = {
				G.playbook_extra and yes and (G.playbook_extra.config.card_limit - 2) or 2,
				card.ability.extra.goal,
				card.ability.extra.goal - card.ability.extra.sold,
			},
		}
	end,
	calculate = function(self, card, context)
		if not G.playbook_extra then
			return
		end
		if evilsand_can_store_sold_joker(context, card) then
			evilsand_store_sold_joker(card, context.card)
		end
		if context.remove_playing_cards and is_live_context(context) then
			evilsand_store_removed_cards(card, context.removed)
		end
		if context.before and is_live_context(context) then
			evilsand_append_default_cards_to_scoring_hand(context)
		end
		if context.after and is_live_context(context) then
			evilsand_destroy_tracked_cards_after(card, context.full_hand or {})
		end
	end,
})
SMODS.Joker:take_ownership("smiley", {
	config = { extra = { mult = 5 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			local deved = false
			local emoji_pos = 0
			local area = nil
			for pos, joker in ipairs(joker_cards()) do
				if joker.config.center.key == "j_emojiman" then
					emoji_pos = pos
					deved = true
					area = G.jokers.cards
				end
			end
			if not deved then
				for pos, joker in ipairs(playbook_cards()) do
					if joker.config.center.key == "j_emojiman" then
						emoji_pos = pos
						deved = true
						area = G.playbook_extra.cards
					end
				end
			end
			if context.other_card and context.other_card:is_face() then
				if deved then
					return { xmult = area[emoji_pos].ability.extra.xmult }
				else
					return { mult = card.ability.extra.mult }
				end
			end
		end
	end,
}, true)

-- TEMPORARY POSITION: needs unique atlas sprite
SMODS.Joker({
	key = "koko",
	loc_txt = {
		name = "Koko",
		text = {
			"{C:attention}Double{}{} effect",
			"of {C:tarot}Tarot{} cards",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "None" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	cost = 3,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 1, y = 0 },
	config = { extra = { retriggering = false } },
	calculate = function(self, card, context)
		if context.using_consumeable and context.consumeable.ability.set == "Tarot" and not context.retrigger_joker and not card.ability.extra.retriggering then
			card.ability.extra.retriggering = true
			local consumed_card = context.consumeable
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					if consumed_card and not consumed_card.removed and consumed_card.area then
						consumed_card:use(consumed_card.config.center, consumed_card)
					end
					card.ability.extra.retriggering = false
					return true
				end,
			}))
			return { message = "Again!" }
		end
	end,
})

SMODS.Joker({
	key = "cerber",
	loc_txt = {
		name = "Cerber",
		text = {
			"All {C:attention}2s{} become",
			"{C:dark_edition}Negative{} when obtained",
		},
	},
	credits = {
		idea = { "Evil Sand", "1srscx4" },
		art = { "None" },
		code = { "Adesi", "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	pos = { x = 0, y = 2 },
	add_to_deck = function(self, card, from_debuff)
		if G.playing_cards and not card.debuff then
			set_negative_for_twos(G.playing_cards)
		end
	end,
	calculate = function(self, card, context)
		if context.playing_card_added and is_live_context(context) then
			set_negative_for_twos(context.cards)
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})

-- TEMPORARY POSITION: needs unique atlas sprite
SMODS.Joker({
	key = "chimps",
	loc_txt = {
		name = "Chimps",
		text = {
			"{C:tarot}Tarot{} packs",
			"contain {C:attention}+1{} card",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "None" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 2, y = 0 },
	in_pool = function(self, args)
		return true
	end,
})

-- TEMPORARY POSITION: needs unique atlas sprite
SMODS.Joker({
	key = "bwaa",
	loc_txt = {
		name = "Bwaa",
		text = {
			"Spawn an {C:spectral}Aura{} card",
			"at {C:attention}start{} of each round",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "None" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 5, y = 4 },
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint and G and G.GAME and G.E_MANAGER then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			G.E_MANAGER:add_event(Event({
				func = function()
					if G.GAME.consumeable_buffer > 0 then
						play_sound("timpani")
						SMODS.add_card({
							set = "Spectral",
							key = "c_aura",
						})
					end
					return true
				end,
			}))
			return { message = "Bwaa!" }
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})

SMODS.Joker({
	key = "coldfish",
	loc_txt = {
		name = "Coldfish",
		text = {
			"{C:attention}Glass{} cards don't break",
			"On the {C:attention}6th{} prevention,",
			"{C:green,E:1}1 in 6{} chance to {C:red}break{}",
			"the bag and become {C:attention}Unleashed",
			"{C:inactive}[Preventions: #1#]",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "None" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 8, y = 6 },
	config = { extra = { prevented = 0, odds = 6 } },
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.prevented } }
	end,
	calculate = function(self, card, context)
		if context.preventing_glass_break and not context.blueprint then
			card.ability.extra.prevented = card.ability.extra.prevented + 1
			if card.ability.extra.prevented >= 6 then
				if roll_with_odds("coldfish", 1, card.ability.extra.odds) then
					G.E_MANAGER:add_event(Event({
						func = function()
							card:start_dissolve()
							SMODS.add_card({ set = "Joker", area = G.jokers, key = "j_coldfish_unleashed" })
							return true
						end,
					}))
					return { message = "Unleashed!" }
				end
			end
			return { message = "Saved!" }
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})

SMODS.Joker({
	key = "coldfish_unleashed",
	loc_txt = {
		name = "Coldfish Unleashed",
		text = {
			"Counts as a {C:attention}Vedal{} card",
			"{C:attention}Gold{} and {C:attention}Donation{} cards",
			"give {C:mult}+#1#{} mult when scored",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "None" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 7, y = 7 },
	config = { extra = { mult = 2 } },
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
		info_queue[#info_queue + 1] = G.P_CENTERS.m_dono
		return { vars = { center.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card then
			if SMODS.has_enhancement(context.other_card, "m_gold") or SMODS.has_enhancement(context.other_card, "m_dono") then
				return { mult = card.ability.extra.mult }
			end
		end
	end,
	in_pool = function(self, args)
		return false
	end,
})

-- TEMPORARY POSITION: needs unique atlas sprite
SMODS.Joker({
	key = "paulamarina",
	loc_txt = {
		name = "PaulaMarina",
		text = {
			"Retrigger {C:planet}Planet{} cards",
			"{C:attention}#1#{} additional time",
			"Increase by {C:attention}1{} every {C:attention}16",
			"upgraded levels across all hands",
			"{C:inactive}[Total: #2# levels]",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "None" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 6, y = 6 },
	config = { extra = { retriggers = 1, threshold = 16 } },
	loc_vars = function(self, info_queue, center)
		local total_levels = 0
		if G and G.GAME and G.GAME.hands then
			for hand, data in pairs(G.GAME.hands) do
				total_levels = total_levels + (data.level or 1) - 1
			end
		end
		local retriggers = math.floor(total_levels / center.ability.extra.threshold) + 1
		return { vars = { retriggers, total_levels } }
	end,
	calculate = function(self, card, context)
		if context.using_consumeable and context.consumeable.ability.set == "Planet" and not context.retrigger_joker then
			local consumed_card = context.consumeable
			local total_levels = 0
			for hand, data in pairs(G.GAME.hands) do
				total_levels = total_levels + (data.level or 1) - 1
			end
			local retriggers = math.floor(total_levels / card.ability.extra.threshold)
			for i = 1, retriggers do
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.1,
					func = function()
						if consumed_card and not consumed_card.removed and consumed_card.area then
							consumed_card:use(consumed_card.config.center, consumed_card)
						end
						return true
					end,
				}))
			end
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})

SMODS.Joker({
	key = "toma",
	loc_txt = {
		name = "Toma",
		text = {
			"{C:attention}Bloody{} cards get {C:attention}Punched{}",
			"and are {C:attention}reshuffled{} into deck",
			"at end of scoring",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "None" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 5, y = 7 },
	calculate = function(self, card, context)
		if context.after and not context.blueprint then
			local scoring_hand = context.scoring_hand or {}
			for _, pcard in ipairs(scoring_hand) do
				if SMODS.has_enhancement(pcard, "m_blood") then
					pcard.ability.punched = true
				end
			end
		end
		if context.end_of_round and context.cardarea == G.jokers then
			for _, pcard in ipairs(G.playing_cards) do
				if pcard.ability.punched then
					pcard.ability.punched = nil
					if pcard.area and pcard.area ~= G.deck then
						G.E_MANAGER:add_event(Event({
							func = function()
								draw_card(pcard.area, G.deck, 90, "up", nil, pcard)
								return true
							end,
						}))
					end
				end
			end
		end
	end,
	in_pool = function(self, args)
		for _, pcard in ipairs(G.playing_cards) do
			if SMODS.has_enhancement(pcard, "m_blood") then
				return true
			end
		end
		return false
	end,
})

SMODS.Joker({
	key = "tomaniacs",
	loc_txt = {
		name = "Tomaniacs",
		text = {
			"{C:attention}Combo punch{} all {C:attention}Bloody{} cards",
			"in played hand until no",
			"{C:attention}Bloody{} cards are scored",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "None" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 6, y = 7 },
	calculate = function(self, card, context)
		if context.after and not context.blueprint then
			local scoring_hand = context.scoring_hand or {}
			local has_bloody = true
			local iterations = 0
			local max_iterations = 20
			while has_bloody and iterations < max_iterations do
				has_bloody = false
				for _, pcard in ipairs(scoring_hand) do
					if SMODS.has_enhancement(pcard, "m_blood") then
						pcard.ability.punched = true
						has_bloody = true
					end
				end
				iterations = iterations + 1
				if has_bloody then
					for _, pcard in ipairs(G.playing_cards) do
						if pcard.ability.punched then
							pcard.ability.punched = nil
							if pcard.area and pcard.area ~= G.deck then
								G.E_MANAGER:add_event(Event({
									func = function()
										draw_card(pcard.area, G.deck, 90, "up", nil, pcard)
										return true
									end,
								}))
							end
						end
					end
					break
				end
			end
		end
	end,
	in_pool = function(self, args)
		for _, joker in ipairs(joker_cards()) do
			if joker.config.center.key == "j_toma" then
				return true
			end
		end
		return false
	end,
})

-- TEMPORARY POSITION: needs unique atlas sprite
SMODS.Joker({
	key = "angel_neuro",
	loc_txt = {
		name = "Angel Neuro",
		text = {
			"Apply {C:dark_edition}Angelic{} edition",
			"to all scored cards",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "None" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 5, y = 0 },
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			local scoring_hand = context.scoring_hand or {}
			for _, pcard in ipairs(scoring_hand) do
				pcard:set_edition("e_angelic", true)
			end
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})

-- TEMPORARY POSITION: needs unique atlas sprite
SMODS.Joker({
	key = "neuro_issues",
	loc_txt = {
		name = "Neuro Issues",
		text = {
			"{C:green,E:1}1 in 10{} chance to",
			"{C:attention}instantly win{} blind",
			"when hand is played",
			"{s:0.8,C:red}Something's wrong with my AI...",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "None" },
		code = { "1srscx4" },
	},
	atlas = "neuroCustomJokers",
	pools = { ["neurJoker"] = true },
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 6, y = 0 },
	config = { extra = { odds = 10 } },
	calculate = function(self, card, context)
		if context.joker_main and G and G.GAME and G.GAME.blind and G.GAME.chips < G.GAME.blind.chips then
			if roll_with_odds("neuro_issues", 1, card.ability.extra.odds) then
				G.GAME.chips = math.max(G.GAME.chips, G.GAME.blind.chips)
				return { message = "AI Error!" }
			end
		end
	end,
	in_pool = function(self, args)
		return true
	end,
})

SMODS.Joker({
	key = "bao",
	loc_txt = {
		name = "Bao",
		text = {
			"WIP",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "Tony7268" },
		code = { "1srscx4" },
	},
	atlas = "animebao",
	pools = { ["neurJoker"] = true },
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 0, y = 0 },
	hidden = true,
	in_pool = function(self, args)
		return false
	end,
	calculate = function(self, card, context)
		-- TODO: implement Bao effect
	end,
})

--Legendaries
local vedals_items = {
	["j_vedalsdrink"] = true,
	["j_tutel_credit"] = true,
	["j_tutelsoup"] = true,
	["j_vedds"] = true,
	["j_abandonedarchive"] = true,
	["j_coldfish_unleashed"] = true,
}
SMODS.Joker({
	key = "vedal",
	loc_txt = {
		name = "Vedal",
		text = {
			"Gives {X:mult,C:white}X#1#{} Mult for every {C:money}$#2#{} gained this {C:attention}run{}.",
			"Each {C:attention}Vedal Item {C:inactive}(Currently owned: #5#){}",
			"increases the base amount by {X:mult,C:white}X#3#{} Mult",
			"{C:inactive}(Currently {X:mult,C:white}X#4#{} {C:inactive}Mult){}",
		},
	},
	credits = {
		idea = { "Evil Sand" },
		art = { "None" },
		code = { "luq" },
	},
	rarity = 4,
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "neuroCustomJokers",
	pos = { x = 1, y = 0 },
	config = { extra = { dollars = 1, upg = 0.01, vedal_bonus = 0.01 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { set = "Other", key = "Vedal_items_desc" }
		local ved_cards = 0
		if G and G.jokers then
			for _, area in ipairs({ joker_cards(), playbook_cards() }) do
				for _, v in ipairs(area) do
					if vedals_items[v.config.center.key] then
						ved_cards = ved_cards + 1
					end
				end
			end
		end
		local money_earned = (Neuratro and Neuratro.MONEY_EARNED) or 0
		local mult = math.floor(money_earned / card.ability.extra.dollars)
			* (ved_cards * card.ability.extra.vedal_bonus + card.ability.extra.upg)
		return {
			vars = {
				card.ability.extra.upg,
				card.ability.extra.dollars,
				card.ability.extra.vedal_bonus,
				mult + 1,
				ved_cards,
			},
		}
	end,
	calculate = function(self, card, context)
		local ved_cards = 0
		if context.joker_main then
			for _, area in ipairs({ joker_cards(), playbook_cards() }) do
				for _, v in ipairs(area) do
					if vedals_items[v.config.center.key] then
						ved_cards = ved_cards + 1
					end
				end
			end
			local money_earned = (Neuratro and Neuratro.MONEY_EARNED) or 0
			local mult = math.floor(money_earned / card.ability.extra.dollars)
				* (ved_cards * card.ability.extra.vedal_bonus + card.ability.extra.upg)
			return { xmult = mult + 1 }
		end
	end,
})
SMODS.Joker({
	key = "neuro",
	loc_txt = {
		name = "Neuro",
		text = {
			"Gives {X:mult,C:white}X#1#{} Mult for every {C:attention}#2#%{} overkill",
			"chips scored in the {C:attention}previous{} blind",
			"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult){}",
		},
	},
	credits = {
		idea = { "Evil Sand" },
		art = { "Kloovree" },
		code = { "luq" },
	},
	rarity = 4,
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "neuroCustomJokers",
	pos = { x = 1, y = 8 },
	soul_pos = { x = 1, y = 9 },
	config = { extra = { xmult = 1, xmult_gain = 0.2, overkill = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult_gain, card.ability.extra.overkill, card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.blind_defeated then
			if G.GAME.chips / G.GAME.blind.chips >= 1.0 then
				card.ability.extra.xmult = (G.GAME.chips / G.GAME.blind.chips - 1)
					* 100
					/ card.ability.extra.overkill
					* card.ability.extra.xmult_gain
			else
				card.ability.extra.xmult = 1
			end
		end
		if context.joker_main then
			return { xmult = card.ability.extra.xmult }
		end
	end,
})
SMODS.Joker({
	key = "evil",
	loc_txt = {
		name = "Evil",
		text = {
			"This joker gains {X:mult,C:white}X#1#{} Mult",
			"for every {C:attention}playing card{} destroyed",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}",
		},
	},
	credits = {
		idea = { "Evil Sand" },
		art = { "Evil Sand" },
		code = { "luq" },
	},
	rarity = 4,
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "neuroCustomJokers",
	pos = { x = 2, y = 8 },
	soul_pos = { x = 2, y = 9 },
	config = { extra = { xmult = 1, upg = 0.2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.upg, card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.remove_playing_cards and not context.blueprint then
			card.ability.extra.xmult = card.ability.extra.xmult + (card.ability.extra.upg * #context.removed)
			return { message = "Upgrade!" }
		end
		if context.joker_main then
			return { xmult = card.ability.extra.xmult }
		end
	end,
})
SMODS.Joker({
	key = "anny",
	loc_txt = {
		name = "Anny",
		text = {
			"For every {C:attention}Unique card{} in {C:attention}deck{}.",
			"gives {X:mult,C:white}x#1#{} Mult.",
			"{C:inactive}(Currently: {X:mult,C:white}x#2#{C:inactive} Mult)",
		},
	},
	credits = {
		idea = { "Adesi", "Evil Sand" },
		art = { "Tony7268" },
		code = { "Adesi" },
	},
	atlas = "neuroCustomJokers",
	rarity = 4,
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pos = { x = 3, y = 8 },
	soul_pos = { x = 3, y = 9 },
	in_pool = function(self, args)
		return true
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { set = "Other", key = "Unique_card_desc" }
		local uniquecardsTable = {}
		local xmult = 1
		if G.GAME and G.deck and #G.deck.cards > 0 then
			for index, value in ipairs(G.deck.cards) do
				local edition = ""
				if value.config.card.edition == nil then
					edition = "0"
				else
					edition = value.config.card.edition.type
				end
				local sealname = ""
				if value.seal then
					sealname = value.seal .. ""
				end
				local uniqueID = sealname
					.. "_"
					.. value.base.value
					.. value.base.suit
					.. value.base.name
					.. "_"
					.. value.label
					.. "_"
					.. edition
				local oldval = uniquecardsTable[uniqueID] or 0
				uniquecardsTable[uniqueID] = oldval + 1
			end
			local amount_of_uniques = table_length(uniquecardsTable)
			xmult = math.max(amount_of_uniques * card.ability.extra.upg, card.ability.extra.upg)
		end
		return { vars = { card.ability.extra.upg, xmult } }
	end,
	config = { extra = { upg = 0.2, xmult = 1 } },
	calculate = function(self, card, context)
		if context.before then
			local uniquecardsTable = {}
			for index, value in ipairs(G.deck.cards) do
				local edition = ""
				if value.config.card.edition == nil then
					edition = "0"
				else
					edition = value.config.card.edition.type
				end
				local sealname = ""
				if value.seal then
					sealname = value.seal .. ""
				end
				local uniqueID = sealname
					.. "_"
					.. value.base.value
					.. value.base.suit
					.. value.base.name
					.. "_"
					.. value.label
					.. "_"
					.. edition
				local oldval = uniquecardsTable[uniqueID] or 0
				uniquecardsTable[uniqueID] = oldval + 1
			end
			local amount_of_uniques = table_length(uniquecardsTable)
			card.ability.extra.xmult = math.max(amount_of_uniques * card.ability.extra.upg, card.ability.extra.upg)
			return {
				message = amount_of_uniques .. " Unique!",
				colour = G.C.YELLOW,
			}
		end
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
	end,
})
