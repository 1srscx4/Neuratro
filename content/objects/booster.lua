SMODS.ObjectType({
	key = "neurJoker",
	default = "j_recbin",
})
SMODS.Booster({
	key = "neurpack1",
	loc_txt = {
		name = "Neur Pack",
		text = {
			"Pick 1 of 2 {C:attention}Neuratro{} jokers",
		},
		group_name = "Neur Pack",
	},
	atlas = "neuroBooster",
	credits = {
		idea = { "1srscx4" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	pos = { x = 1, y = 0 },
	config = { extra = 2, choose = 1 },
	discovered = false,
	cost = 5,
	draw_hand = false,
	weight = 1.25,
	create_card = function(self, card)
		return { set = "neurJoker", area = G.pack_cards, skip_materialize = true, soulable = true }
	end,
})
SMODS.Booster({
	key = "neurpack2",
	loc_txt = {
		name = "Neur Pack",
		text = {
			"Pick 1 of 2 {C:attention}Neuratro{} jokers",
		},
		group_name = "Neur Pack",
	},
	atlas = "neuroBooster",
	credits = {
		idea = { "1srscx4" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	pos = { x = 2, y = 0 },
	config = { extra = 2, choose = 1 },
	discovered = false,
	cost = 5,
	draw_hand = false,
	weight = 1.25,
	create_card = function(self, card)
		return { set = "neurJoker", area = G.pack_cards, skip_materialize = true, soulable = true }
	end,
})
SMODS.Booster({
	key = "neurpack3",
	loc_txt = {
		name = "Bwaa Neur Pack",
		text = {
			"Pick 1 of 4 {C:attention}Neuratro{} jokers",
		},
		group_name = "Bwaa Neur Pack",
	},
	atlas = "neuroBooster",
	credits = {
		idea = { "1srscx4" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	pos = { x = 3, y = 0 },
	config = { extra = 4, choose = 1 },
	discovered = false,
	cost = 7,
	draw_hand = false,
	weight = 0.65,
	create_card = function(self, card)
		return { set = "neurJoker", area = G.pack_cards, skip_materialize = true, soulable = true }
	end,
})
SMODS.Booster({
	key = "neurpack4",
	loc_txt = {
		name = "Evil Pack",
		text = {
			"Pick 2 of 4 {C:attention}Neuratro{} jokers",
		},
		group_name = "Evil Pack",
	},
	atlas = "neuroBooster",
	credits = {
		idea = { "1srscx4" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	pos = { x = 4, y = 0 },
	config = { extra = 4, choose = 2 },
	discovered = false,
	cost = 9,
	draw_hand = false,
	weight = 0.2,
	create_card = function(self, card)
		return { set = "neurJoker", area = G.pack_cards, skip_materialize = true, soulable = true }
	end,
})
SMODS.Booster({
	key = "devpack",
	loc_txt = {
		name = "Dev pack",
		text = {
			"Pick 1 of 3 {V:1}dev{} cards",
		},
		group_name = "Dev pack",
	},
	atlas = "neuroBooster",
	credits = {
		idea = { "Evil Sand" },
		art = { "Evil Sand" },
		code = { "1srscx4" },
	},
	pos = { x = 0, y = 0 },
	config = { extra = 3, choose = 1 },
	discovered = false,
	cost = 15,
	draw_hand = false,
	loc_vars = function(self, info_queue, center)
		return { vars = { colours = { HEX("fcba03") } } }
	end,
	weight = 0.035,
	create_card = function(self, card, i)
		return { set = "Joker", area = G.pack_cards, skip_materialize = true, rarity = "dev" }
	end,
})
