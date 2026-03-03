SMODS.Back({
	key = "twindeck",
	loc_txt = {
		name = "Twin deck",
		text = {
			"Replace {C:attention}face cards{} with",
			"4 {C:attention}kings{} of {C:spades}spades{} and",
			"4 {C:attention}kings{} of {C:hearts}hearts{}.",
			"Start with {C:attention}two{}",
			"copies of {C:tarot,T:c_twins}The twins{}.",
		},
	},
	atlas = "neuroEnh",
	pos = { x = 4, y = 0 },
	config = { extra = { consumables = { "c_twins", "c_twins" } } },
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			func = function()
				for _, playing_card in ipairs(G.playing_cards) do
					if playing_card:is_face() then
						SMODS.destroy_cards(playing_card)
					end
				end

				for i = 1, 8 do
					local _rank = "K"
					local _suit = "S"
					if i < 5 then
						_suit = "H"
					end
					local _card = create_playing_card({
						front = G.P_CARDS[_suit .. "_" .. _rank],
						center = G.P_CENTERS.c_base,
					}, G.deck, nil, nil, { G.C.SECONDARY_SET.Enhanced })
				end
				G.GAME.starting_deck_size = 48
				return true
			end,
		}))
		delay(0.4)
		G.E_MANAGER:add_event(Event({
			func = function()
				for k, v in ipairs(self.config.extra.consumables) do
					SMODS.add_card({ key = v })
				end
				return true
			end,
		}))
	end,
})
SMODS.Back({
	key = "glorpdeck",
	loc_txt = {
		name = "Invader deck",
		text = {
			"Adds {C:attention}6{} random {C:green}gleeb{} cards",
			"to deck when {C:attention}blind{} is selected. ",
		},
	},
	atlas = "neuroEnh",
	pos = { x = 3, y = 0 },
	calculate = function(self, card, context)
		if context.setting_blind then
			for i = 1, 6 do
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
						G.E_MANAGER:add_event(Event({
							func = function()
								return true
							end,
						}))
						return true
					end,
				}))
			end
		end
	end,
})
SMODS.Back({
	key = "Euchre",
	loc_txt = {
		name = "Euchre deck",
		text = {
			"Start with 4 {C:attention}9s{}, {C:attention}10s{}, {C:attention}Queens{},",
			" {C:attention}Kings{} and {C:attention}Aces{}, and with 8 {C:attention}Jacks{},",
			"4 of which are {C:attention}wild{}.",
			"Start with {C:attention}5{} hand size.",
			"{C:inactive,s:0.8}(Pronounced 'Yu-ker')",
		},
	},
	atlas = "neuroEnh",
	pos = { x = 0, y = 1 },
	credits = {
		idea = { "Emuz" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	config = { hand_size = -3 },
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			func = function()
				for _, playing_card in ipairs(G.playing_cards) do
					if playing_card:get_id() < 9 then
						SMODS.destroy_cards(playing_card)
					end
				end

				for i = 1, 4 do
					local _rank = "J"
					local _suitlist = { "S", "H", "C", "D" }
					local _suit = _suitlist[i]
					local _card = create_playing_card({
						front = G.P_CARDS[_suit .. "_" .. _rank],
						center = G.P_CENTERS.c_base,
					}, G.deck, nil, nil, { G.C.SECONDARY_SET.Enhanced })
					_card:set_ability(G.P_CENTERS["m_wild"], nil, true)
				end

				G.GAME.starting_deck_size = 28
				return true
			end,
		}))
	end,
})
SMODS.Back({
	key = "ARGdeck",
	loc_txt = {
		name = "ARG Deck",
		text = {
			"{C:dark_edition,E:1}Does nothing.",
			"{s:0.7}like genuinely, it does nothing",
		},
	},
	atlas = "neuroEnh",
	pos = { x = 2, y = 1 },
	credits = {
		idea = { "A lot of people." },
		art = { "Evil Sand" },
		code = { "1srscx4", "Pers" },
	},
	apply = function(self, back)
		G.GAME.ARG = true
	end,
	calculate = function(self, back, context)
		if context.setting_blind then
		end
	end,
})
