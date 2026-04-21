--Enhancement
local function enhancement_probability_scale()
	return (G and G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal) or 1
end

SMODS.Enhancement({
	key = "m_twin",
	loc_txt = {
		name = "Twin",
		text = {
			"{C:chips}+15{} extra chips",
			"{C:mult}+2{} mult",
		},
	},
	discovered = false,
	atlas = "neuroEnh",
	pos = { x = 0, y = 0 },
	config = { bonus = 15, mult = 2 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.bonus } }
	end,
})
SMODS.Enhancement({
	key = "m_dono",
	loc_txt = {
		name = "Donation",
		text = {
			"Gives {C:money}$2{} when scored",
		},
	},
	atlas = "neuroEnh",
	pos = { x = 1, y = 0 },
	config = { extra = { money = 2 } },
	calculate = function(self, card, context)
		if context.main_scoring and context.cardarea == G.play then
			local msg = false
			local msg_pos = 1
			local area = nil
			for pos, joker in ipairs(G.jokers and G.jokers.cards or {}) do
				if joker.config.center.key == "j_highlighted" and not joker.debuff then
					msg = true
					msg_pos = pos
					area = joker.area
					break
				end
			end
			if not msg and G.playbook_extra then
				for pos, joker in ipairs(G.playbook_extra and G.playbook_extra.cards or {}) do
					if joker.config.center.key == "j_highlighted" and not joker.debuff then
						msg = true
						msg_pos = pos
						area = joker.area
						break
					end
				end
			end
			if msg and area and area.cards and area.cards[msg_pos] then
				return { xmult = area.cards[msg_pos].ability.extra.xmult }
			else
				return { dollars = card.ability.extra.money }
			end
		end
	end,
})
SMODS.Enhancement({
	key = "m_glorp",
	loc_txt = {
		name = "Glorpy",
		text = {
			"{C:red,E:2}Break on end of round",
		},
	},
	atlas = "neuroEnh",
	config = { extra = { can_break = false } },
	pos = { x = 2, y = 0 },
	weight = 0,
	in_pool = function(self, args)
		return false
	end,
	calculate = function(self, card, context)
		if context.before then
			card.ability.extra.can_break = true
		end
		if context.end_of_round and card.ability.extra.can_break then
			card.ability.extra.can_break = false
			SMODS.destroy_cards(card)
		end
	end,
})
SMODS.Enhancement({
	key = "m_blood",
	loc_txt = {
		name = "Bloody",
		text = {
			"{C:green}#1# in #2#{} chance to spread",
			"to {C:attention}adjacent{} cards",
			"after {C:attention}played{}",
		},
	},
	atlas = "neuroEnh",
	pos = { x = 6, y = 1 },
	config = { extra = { base = 1, odds = 3 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.base * enhancement_probability_scale(), card.ability.extra.odds } }
	end,
	calculate = function(self, card, context)
		if context.after then
			local full_hand = context.full_hand or {}
			local trg = false
			for pos, pcard in ipairs(full_hand) do
				local safe_odds = tonumber(card.ability.extra.odds) or 0
				local chance = safe_odds > 0 and (card.ability.extra.base * enhancement_probability_scale()) / safe_odds
					or 0
				if pcard == card and pseudorandom("blood") < math.min(chance, 1) then
					local left_card = full_hand[pos - 1]
					if left_card then
						sea(function()
							left_card:set_ability(G.P_CENTERS["m_blood"], nil, true)
							return true
						end)
					end
					local right_card = full_hand[pos + 1]
					if right_card then
						sea(function()
							right_card:set_ability(G.P_CENTERS["m_blood"], nil, true)
							return true
						end)
					end
					trg = true
				end
			end
			if trg then
				return { message = "Spread!" }
			end
		end
	end,
})
--Seal
SMODS.Seal({
	key = "shoomiminion_seal",
	loc_txt = {
		name = "Shoominion seal",
		label = "Shoomiminion seal",
		text = {
			"When this card is {C:attention}destroyed{},",
			"create {C:attention}two{} copies of it",
		},
	},
	atlas = "neuroEnh",
	pos = { x = 7, y = 0 },
	badge_colour = HEX("8CE6BD"),
	config = { mimi = false },
	discovered = false,
	unlocked = true,
	calculate = function(self, card, context)
		if context.remove_playing_cards then
			for i = 1, #context.removed do
				if context.removed[i].seal == "shoomiminion_seal" and context.removed[i] == card then
					for l = 1, 2 do
						local copy_card = copy_card(context.removed[i], nil, nil, G.playing_card)
						copy_card:add_to_deck()
						G.deck.config.card_limit = G.deck.config.card_limit + 1
						table.insert(G.playing_cards, copy_card)
						G.hand:emplace(copy_card)
						copy_card.states.visible = nil
						G.E_MANAGER:add_event(Event({
							func = function()
								copy_card:start_materialize()
								return true
							end,
						}))
						SMODS.calculate_context({ playing_card_added = true, cards = { copy_card } })
					end
				end
			end
		end
	end,
})
SMODS.Seal({
	key = "osu_seal",
	loc_txt = {
		name = "Osu! seal",
		label = "Osu! seal",
		text = {
			"Gains {C:mult}+#1#{} Mult when played.",
			"{C:attention}Resets{} if the card is {C:red}discarded{}.",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
		},
	},
	atlas = "neuroEnh",
	pos = { x = 1, y = 1 },
	badge_colour = HEX("DB5893"),
	config = { mult = 0, upg = 5 },
	discovered = false,
	unlocked = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.seal.upg, card.ability.seal.mult } }
	end,
	calculate = function(self, card, context)
		if context.before then
			for _, pcard in ipairs(context.full_hand or {}) do
				if pcard == card then
					card.ability.seal.mult = card.ability.seal.mult + card.ability.seal.upg
					return { message = "Upgrade!" }
				end
			end
		end
		if context.main_scoring and context.cardarea == G.play then
			return { mult = card.ability.seal.mult }
		end
		if context.discard and context.other_card == card then
			card.ability.seal.mult = 0
		end
	end,
})
--Sticker
SMODS.Sticker({
	key = "schizo_sticker",
	loc_txt = {
		name = "Schizo",
		text = { "{C:red,E:1}Self-destructs{} at {C:attention}end of round{}." },
		label = "Schizo",
	},
	atlas = "neuroEnh",
	pos = { x = 7, y = 1 },
	badge_colour = HEX("7A3FD6"),
	sets = { Joker = true },
	rate = 0,
	needs_enabled_flag = false,
	calculate = function(self, card, context)
		if context.end_of_round then
			SMODS.destroy_cards(card, true)
		end
	end,
	should_apply = function(self, card, center, area, bypass_reroll)
		return G.GAME.schizo
	end,
})
--Modifications
SMODS.Enhancement:take_ownership("m_steel", {
	config = { extra = { xmult = 1.5 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.main_scoring and context.cardarea == G.hand then
			local pipes = false
			local pipes_pos = 1
			local area = nil
			for pos, joker in ipairs(G.jokers and G.jokers.cards or {}) do
				if joker.config.center.key == "j_pipes" and not joker.debuff then
					pipes = true
					pipes_pos = pos
					area = joker.area
					break
				end
			end
			if G.playbook_extra then
				for pos, joker in ipairs(G.playbook_extra and G.playbook_extra.cards or {}) do
					if joker.config.center.key == "j_pipes" and not joker.debuff then
						pipes = true
						pipes_pos = pos
						area = joker.area
						break
					end
				end
			end
			if pipes and area and area.cards and area.cards[pipes_pos] then
				return { xmult = area.cards[pipes_pos].ability.extra.xmult, message = "Pipe!", sound = "pipe_sfx" }
			else
				return { xmult = card.ability.extra.xmult }
			end
		end
	end,
}, true)
SMODS.Enhancement:take_ownership("m_stone", {
	config = { extra = { chips = 50 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	replace_base_card = true,
	calculate = function(self, card, context)
		if context.main_scoring and context.cardarea == G.play then
			for _, area in ipairs({
				G.jokers and G.jokers.cards or {},
				G.playbook_extra and G.playbook_extra.cards or {},
			}) do
				for _, joker in ipairs(area) do
					if joker.config.center.key == "j_breadge" then
						return { mult = joker.ability.extra.mult or 21 }
					end
				end
			end
			return { chips = card.ability.extra.chips }
		end
	end,
}, true)
