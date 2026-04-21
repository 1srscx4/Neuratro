SMODS.Edition({
	shader = "filtered",
	key = "filtered",
	loc_txt = {
		name = "Filtered",
		label = "Filtered",
		text = {
			"{C:green,E:1}50/50{} chance to retrigger",
			"the {C:attention}scored{} card or debuff it ",
			"until {C:attention}end of round",
		},
	},
	credits = {
		sug = { "Emuz", "1srscx4" },
		idea = { "1srscx4" },
		art = { "pers" },
		code = { "1srscx4" },
	},

	in_shop = true,
	weight = 20,
	extra_cost = 3,
	discovered = false,
	sound = { sound = "filter_sfx", vol = 0.7 },
	apply_to_float = false,
	badge_colour = HEX("298542"),
	in_pool = function(self, args)
		return true
	end,
	calculate = function(self, card, context)
		if context.repetition and (context.cardarea == G.play or context.cardarea == G.hand or context.cardarea == G.deck) and context.other_card == card then
			if Neuratro.coin_flip("filter") then
				Neuratro.trigger_filtersister_upgrade()
				SMODS.debuff_card(card, true, "filter")
				return { repetitions = 0, message = "[Filtered]" }
			end
			return { repetitions = 1 }
		end
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card == card then
			if Neuratro.coin_flip("filter") then
				Neuratro.trigger_filtersister_upgrade()
				SMODS.debuff_card(card, true, "filter")
				return { repetitions = 0, message = "[Filtered]" }
			end
			return { repetitions = 1, message = "Again!" }
		end
	end,
	on_apply = function(card)
		card.edition.filtered_seed = (pseudorandom("filtered_seed") * 2 - 1) * 1000
	end,
})

SMODS.Edition({
	key = "angelic",
	loc_txt = {
		name = "Angelic",
		label = "Angelic",
		text = {
			"{C:mult}+3{} Mult",
			"{C:chips}+30{} Chips",
		},
	},
	credits = {
		idea = { "1srscx4" },
		art = { "None" },
		code = { "1srscx4" },
	},
	shader = "foil",
	in_shop = true,
	weight = 15,
	extra_cost = 2,
	discovered = false,
	badge_colour = HEX("FFD700"),
	in_pool = function(self, args)
		return true
	end,
	calculate = function(self, card, context)
		if context.main_scoring and context.cardarea == G.play then
			return { mult = 3, chips = 30 }
		end
	end,
})
