AKYRS.card_conf_any_drag = function(area, card)
	return false
end
local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.playbook_hph = 0
	return ret
end

SMODS.current_mod.reset_game_globals = function(run_start)
	if not (G and G.GAME and G.GAME.round_resets) then
		return
	end
	if G.GAME.bosses_used and G.P_BLINDS then
		for k, v in pairs(G.P_BLINDS) do
			if v.boss and G.GAME.bosses_used[k] == nil then
				G.GAME.bosses_used[k] = 0
			end
		end
	end
	if G.GAME.playbook_last_ante ~= G.GAME.round_resets.ante then
		G.GAME.playbook_flush_of_hearts_discarded_this_ante = false
		G.GAME.playbook_last_ante = G.GAME.round_resets.ante
	end
end

local cfc = AKYRS.card_conf_any_drag
AKYRS.card_conf_any_drag = function(area, card)
	if card.area and card.area == G.playbook_extra then
		if card.ability.consumeable and area == G.consumeables then
			return true
		elseif card.ability.set == "Joker" and area == G.jokers then
			return true
		elseif area == G.deck or area == G.hand then
			return true
		end
	end
	return cfc(area, card)
end

local _set_sprites = Card.set_sprites
function Card:set_sprites(center, ...)
	if center and center.atlas and G.ANIMATION_ATLAS and G.ANIMATION_ATLAS[center.atlas] then
		if not (G.ASSET_ATLAS and G.ASSET_ATLAS[center.atlas]) then
			G.ASSET_ATLAS[center.atlas] = G.ANIMATION_ATLAS[center.atlas]
		end
	end
	return _set_sprites(self, center, ...)
end

local card_set_base = Card.set_base
function Card:set_base(...)
	local x = { card_set_base(self, ...) }
	Neuratro.trigger_cerber(self)
	return unpack(x)
end

local smods_change_base = SMODS.change_base
function SMODS.change_base(card, ...)
	local x = { smods_change_base(card, ...) }
	Neuratro.trigger_cerber(card)
	return unpack(x)
end

local cardUpdateHook = Card.update
function Card:update(dt)
	self.playbook_click_delay = math.max((self.playbook_click_delay or 0) - dt, 0)
	if self.config.center_key == "j_evilsand" and self.states.drag.is and G.playbook_extra then
		G.playbook_extra:set_role({
			role_type = "Minor",
			xy_bond = "Strong",
			major = self,
			offset = { x = -G.playbook_extra.T.w / 2 + 1, y = 3 },
		})
	end
	local x = { cardUpdateHook(self, dt) }
	return unpack(x)
end

local cardClickHook = Card.click
function Card:click()
	if self.config.center_key == "j_evilsand" and G and G.GAME then
		if self.states.drag.is and G.playbook_extra then
			G.playbook_extra:set_role({
				role_type = "Minor",
				xy_bond = "Strong",
				major = self,
				offset = { x = -G.playbook_extra.T.w / 2 + 1, y = 3 },
			})
		end
	end
	self.playbook_click_delay = (self.playbook_click_delay or 0) + 10

	local x = { cardClickHook(self) }

	if self.config.center_key == "j_evilsand" and G and G.GAME and G.playbook_extra then
		G.playbook_extra.states.visible = self.highlighted
	end
	return unpack(x)
end

local strun = Game.start_run
function Game:start_run(args)
	local x = { strun(self, args) }
	if G.GAME.playbook_hph > 0 and G.playbook_extra then
		G.playbook_extra.states.collide.can = true
	end
	return unpack(x)
end

local evalc_h = eval_card
function eval_card(c, ctx)
	c.ability.playbook_triggers = (c.ability.playbook_triggers or 0) + 1
	local x = { evalc_h(c, ctx) }
	return unpack(x)
end

local dpc_h = draw_card
function draw_card(from, to, percent, dir, sort, card, Delay, mute, resolved, final_lag)
	if card and card.ability and card.ability.set == "Default" and G and G.jokers and G.jokers.cards then
		local coldfish = nil
		for _, joker in ipairs(G.jokers.cards) do
			if joker.config.center.key == "j_coldfish" and not joker.debuff then
				coldfish = joker
				break
			end
		end
		if coldfish and SMODS.has_enhancement(card, "m_glass") and card.ability.shattered then
			card.ability.shattered = nil
			card.ability.prevented_break = true
			SMODS.calculate_context({ preventing_glass_break = true, card = card })
		end
	end
	return dpc_h(from, to, percent, dir, sort, card, Delay, mute, resolved, final_lag)
end
