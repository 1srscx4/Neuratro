SMODS.Blind({
	key = "xdx|2",
	loc_txt = {
		name = "The Vertical Bar",
		text = {
			"When the first hand is played,",
			"replace the rightmost joker",
			"with xdx.",
		},
	},
	atlas = "neuroblinds",
	pos = { y = 0 },
	discovered = true,
	mult = 2,
	boss = { min = 3 },
	vars = {},
	boss_colour = HEX("F5DD8A"),
	press_play = function(self)
		if
			G
			and G.GAME
			and G.GAME.current_round
			and G.jokers
			and G.jokers.cards
			and G.GAME.current_round.hands_played == 0
			and #G.jokers.cards > 0
		then
			local rightmost_joker = G.jokers.cards[#G.jokers.cards]
			local edition_key = rightmost_joker and rightmost_joker.edition and rightmost_joker.edition.key or nil
			local sticks = {}
			for _, sticker in ipairs(SMODS.Sticker.obj_buffer) do
				if rightmost_joker and rightmost_joker.ability[sticker] then
					sticks[#sticks + 1] = sticker
				end
			end
			SMODS.destroy_cards(rightmost_joker, true)
			local joker = SMODS.add_card({
				set = "Joker",
				key = "j_xdx|",
				edition = edition_key,
			})
			for _, sticker in ipairs(SMODS.Sticker.obj_buffer) do
				if joker.ability[sticker] then
					joker:remove_sticker(sticker)
				end
			end
			for _, sticker in ipairs(sticks) do
				joker:add_sticker(sticker, true)
			end
		end
	end,
})
SMODS.Blind({
	key = "meowmeowmeow",
	loc_txt = {
		name = "Meow Meow lol",
		text = {
			"Enhanced cards",
			"are debuffed.",
		},
	},
	atlas = "neuroblinds",
	pos = { y = 1 },
	discovered = true,
	mult = 2,
	boss = { min = 2 },
	vars = {},
	boss_colour = HEX("F5DD8A"),
	recalc_debuff = function(self, card, from_blind)
		if next(SMODS.get_enhancements(card)) then
			return true
		end
		return false
	end,
})

local function clear_chatspam_debuffs()
	local hiyori = Neuratro.has_joker("j_hiyori")
	for _, v in ipairs(G.playing_cards or {}) do
		SMODS.debuff_card(v, false, "chatspam")
		if v:is_suit("Hearts") and hiyori then
			SMODS.debuff_card(v, true, "filter")
		end
	end
end

SMODS.Blind({
	key = "chatspam",
	loc_txt = {
		name = "Chat Spam",
		text = {
			"#1# in 6 chance for",
			"cards to be debuffed.",
		},
	},
	atlas = "neuroblinds",
	pos = { y = 2 },
	discovered = true,
	mult = 2,
	boss = { min = 3 },
	loc_vars = function(self)
		return { vars = { Neuratro.get_probability_scale() } }
	end,
	boss_colour = HEX("F5DD8A"),
	set_blind = function(self)
		for _, pcard in ipairs(G.playing_cards or {}) do
			if Neuratro.roll_simple_odds(6, "chatspam") then
				SMODS.debuff_card(pcard, true, "chatspam")
			end
		end
	end,
	disable = function(self)
		clear_chatspam_debuffs()
	end,
	defeat = function(self)
		clear_chatspam_debuffs()
	end,
})
