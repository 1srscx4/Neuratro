SMODS.Tag({
	key = "filter_tag",
	loc_txt = {
		name = "Filtered tag",
		text = {
			"Next base edition shop",
			"joker is free and",
			"becomes {V:1}filtered{}.",
		},
	},
	atlas = "neuroTags",
	pos = { x = 0, y = 0 },
	discovered = false,
	in_pool = function(self, args)
		return true
	end,
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_filtered
		return { vars = { colours = { HEX("589c4b") } } }
	end,
	apply = function(self, tag, context)
		if context.type == "store_joker_modify" then
			if not context.card.edition and not context.card.temp_edition and context.card.ability.set == "Joker" then
			local lock = tag.ID
				if G.CONTROLLER and G.CONTROLLER.locks then
					G.CONTROLLER.locks[lock] = true
				end
				context.card.temp_edition = true
				tag:yep("+", G.C.DARK_EDITION, function()
					context.card:set_edition({ filtered = true }, true)
					context.card.ability.couponed = true
					context.card:set_cost()
					context.card.temp_edition = nil
					if G.CONTROLLER and G.CONTROLLER.locks then
						G.CONTROLLER.locks[lock] = nil
					end
					return true
				end)
				tag.triggered = true
			end
		end
	end,
})
SMODS.Tag({
	key = "eliv_tag",
	loc_txt = {
		name = "Eliv tag",
		text = {
			"Gives a free",
			"{C:attention}Evil Pack",
		},
	},
	atlas = "neuroTags",
	pos = { x = 1, y = 0 },
	discovered = false,
	in_pool = function(self, args)
		return true
	end,
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.p_neurpack4
	end,
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			local lock = tag.ID
			if G.CONTROLLER and G.CONTROLLER.locks then
				G.CONTROLLER.locks[lock] = true
			end
			tag:yep("+", G.C.SECONDARY_SET.Spectral, function()
				local key = "p_neurpack4"
				local card = Card(
					G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
					G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
					G.CARD_W * 1.27,
					G.CARD_H * 1.27,
					G.P_CARDS.empty,
					G.P_CENTERS[key],
					{ bypass_discovery_center = true, bypass_discovery_ui = true }
				)
				card.cost = 0
				card.from_tag = true
				G.FUNCS.use_card({ config = { ref_table = card } })
				card:start_materialize()
				if G.CONTROLLER and G.CONTROLLER.locks then
					G.CONTROLLER.locks[lock] = nil
				end
				return true
			end)
			tag.triggered = true
			return true
		end
	end,
})
