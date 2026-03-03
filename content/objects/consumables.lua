-- Tarots
SMODS.Consumable({
	key = "twins",
	loc_txt = {
		name = "The Twins",
		text = {
			"Enhance {C:attention}2{}",
			"selected cards to",
			"{C:attention}twin cards{}",
		},
	},
	set = "Tarot",
	discovered = false,
	atlas = "neuroCons",
	pos = { x = 0, y = 0 },
	config = { max_highlighted = 2, mod_conv = "m_twin" },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
		return {
			vars = {
				card.ability.max_highlighted,
				localize({ type = "name_text", set = "Enhanced", key = card.ability.mod_conv }),
			},
		}
	end,
})
SMODS.Consumable({
	key = "donation",
	loc_txt = {
		name = "The Bit",
		text = {
			"Enhance {C:attention}1{}",
			"selected card to",
			"{C:attention}donation card{}",
		},
	},
	set = "Tarot",
	discovered = false,
	atlas = "neuroCons",
	pos = { x = 1, y = 0 },
	config = { max_highlighted = 1, mod_conv = "m_dono" },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
		return {
			vars = {
				card.ability.max_highlighted,
				localize({ type = "name_text", set = "Enhanced", key = card.ability.mod_conv }),
			},
		}
	end,
})
SMODS.Consumable({
	key = "blood_set",
	loc_txt = {
		name = "The Juice",
		text = {
			"Enhance {C:attention}1{}",
			"selected card to",
			"{C:attention}Bloody card{}",
		},
	},
	set = "Tarot",
	discovered = false,
	atlas = "neuroCons",
	pos = { x = 1, y = 0 },
	config = { max_highlighted = 1, mod_conv = "m_blood" },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
		return {
			vars = {
				card.ability.max_highlighted,
				localize({ type = "name_text", set = "Enhanced", key = card.ability.mod_conv }),
			},
		}
	end,
})
-- Spectrals
SMODS.Consumable({
	key = "shomimi_set_seal",
	loc_txt = {
		name = "Mitosis",
		text = {
			"Add a {C:attention}shoomimi seal",
			"to {C:attention}1{} selected",
			"card in hand",
		},
	},
	atlas = "neuroCons",
	pos = { x = 6, y = 0 },
	set = "Spectral",
	discovered = false,
	unlocked = true,
	config = { extra = { seal = "shoomiminion_seal" }, max_highlighted = 1 },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
		return { vars = { card.ability.max_highlighted } }
	end,
	use = function(self, card, area, copier)
		local conv_card = G.hand.highlighted[1]
		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound("tarot1")
				card:juice_up(0.3, 0.5)
				return true
			end,
		}))

		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.1,
			func = function()
				conv_card:set_seal(card.ability.extra.seal, nil, true)
				return true
			end,
		}))

		delay(0.5)
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all()
				return true
			end,
		}))
	end,
})
SMODS.Consumable({
	key = "osu_set_seal",
	loc_txt = {
		name = "Rhythm",
		text = {
			"Add a {C:attention}Osu! seal",
			"to {C:attention}#1#{} selected",
			"cards in hand",
		},
	},
	atlas = "neuroCons",
	pos = { x = 7, y = 0 },
	set = "Spectral",
	discovered = false,
	unlocked = true,
	config = { extra = { seal = "osu_seal" }, max_highlighted = 2 },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
		return { vars = { card.ability.max_highlighted } }
	end,
	use = function(self, card, area, copier)
		for i = 1, #G.hand.highlighted do
			local conv_card = G.hand.highlighted[i]
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					card:juice_up(0.3, 0.5)
					return true
				end,
			}))

			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					conv_card:set_seal(card.ability.extra.seal, nil, true)
					return true
				end,
			}))

			delay(0.5)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
})
-- Planets
SMODS.Consumable({
	key = "io",
	set = "Planet",
	unlocked = true,
	discovered = false,
	config = { hand_type = "mix" },
	atlas = "neuroCons",
	pos = { x = 2, y = 0 },
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge("Satellite", get_type_colour(self or card.config, card), nil, 1.2)
	end,
	process_loc_text = function(self)
		local target_text = G.localization.descriptions[self.set]["c_mercury"].text
		SMODS.Consumable.process_loc_text(self)
		G.localization.descriptions[self.set][self.key].text = target_text
	end,
	generate_ui = 0,
	loc_txt = {
		name = "Io",
	},
	in_pool = function(self, args)
		return G.GAME.hands[self.config.hand_type].played > 0
	end,
})
SMODS.Consumable({
	key = "europa",
	set = "Planet",
	config = { hand_type = "straightmix" },
	atlas = "neuroCons",
	unlocked = true,
	discovered = false,
	pos = { x = 3, y = 0 },
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge("Satellite", get_type_colour(self or card.config, card), nil, 1.2)
	end,
	process_loc_text = function(self)
		local target_text = G.localization.descriptions[self.set]["c_mercury"].text
		SMODS.Consumable.process_loc_text(self)
		G.localization.descriptions[self.set][self.key].text = target_text
	end,
	generate_ui = 0,
	loc_txt = {
		name = "Europa",
	},
	in_pool = function(self, args)
		return G.GAME.hands[self.config.hand_type].played > 0
	end,
})
SMODS.Consumable({
	key = "ganymede",
	set = "Planet",
	unlocked = true,
	discovered = false,
	config = { hand_type = "mixed5" },
	atlas = "neuroCons",
	pos = { x = 4, y = 0 },
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge("Satellite", get_type_colour(self or card.config, card), nil, 1.2)
	end,
	process_loc_text = function(self)
		local target_text = G.localization.descriptions[self.set]["c_mercury"].text
		SMODS.Consumable.process_loc_text(self)
		G.localization.descriptions[self.set][self.key].text = target_text
	end,
	generate_ui = 0,
	loc_txt = {
		name = "Ganymede",
	},
	in_pool = function(self, args)
		return G.GAME.hands[self.config.hand_type].played > 0
	end,
})
SMODS.Consumable({
	key = "callisto",
	set = "Planet",
	unlocked = true,
	discovered = false,
	config = { hand_type = "mixhouse" },
	atlas = "neuroCons",
	pos = { x = 5, y = 0 },
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge("Satellite", get_type_colour(self or card.config, card), nil, 1.2)
	end,
	process_loc_text = function(self)
		local target_text = G.localization.descriptions[self.set]["c_mercury"].text
		SMODS.Consumable.process_loc_text(self)
		G.localization.descriptions[self.set][self.key].text = target_text
	end,
	generate_ui = 0,
	loc_txt = {
		name = "Callisto",
	},
	in_pool = function(self, args)
		return G.GAME.hands[self.config.hand_type].played > 0
	end,
})
