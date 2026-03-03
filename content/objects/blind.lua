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
		if G.GAME.current_round.hands_played == 0 and #G.jokers.cards > 0 then
			local sticks = {}
			for _, sticker in ipairs(SMODS.Sticker.obj_buffer) do
				if G.jokers.cards[#G.jokers.cards].ability[sticker] then
					sticks[#sticks + 1] = sticker
				end
			end
			SMODS.destroy_cards(G.jokers.cards[#G.jokers.cards], true)
			local joker = SMODS.add_card({
				set = "joker",
				key = "j_xdx|",
				edition = G.jokers.cards[#G.jokers.cards].edition and G.jokers.cards[#G.jokers.cards].edition.key
					or nil,
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
	pos = { y = 0 },
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
	pos = { y = 0 },
	discovered = true,
	mult = 2,
	boss = { min = 3 },
	loc_vars = function(self)
		return { vars = { G.GAME.probabilities.normal } }
	end,
	boss_colour = HEX("F5DD8A"),
	set_blind = function(self)
		for _, pcard in ipairs(G.playing_cards) do
			if pseudorandom("chatspam") <= G.GAME.probabilities.normal / 6 then
				SMODS.debuff_card(pcard, true, "chatspam")
			end
		end
	end,
	disable = function(self)
		local hiyori = false
		for _, joker in ipairs(G.jokers.cards) do
			if joker.config.center.key == "j_hiyori" then
				hiyori = true
			end
		end
		for _, joker in ipairs(G.playbook_extra.cards) do
			if joker.config.center.key == "j_hiyori" then
				hiyori = true
			end
		end
		for _, v in ipairs(G.playing_cards) do
			SMODS.debuff_card(v, false, "chatspam")
			if v:is_suit("Hearts") and hiyori then
				SMODS.debuff_card(v, true, "filter")
			end
		end
	end,
	defeat = function(self)
		local hiyori = false
		for _, joker in ipairs(G.jokers.cards) do
			if joker.config.center.key == "j_hiyori" then
				hiyori = true
			end
		end
		for _, joker in ipairs(G.playbook_extra.cards) do
			if joker.config.center.key == "j_hiyori" then
				hiyori = true
			end
		end
		for _, v in ipairs(G.playing_cards) do
			SMODS.debuff_card(v, false, "chatspam")
			if v:is_suit("Hearts") and hiyori then
				SMODS.debuff_card(v, true, "filter")
			end
		end
	end,
})
