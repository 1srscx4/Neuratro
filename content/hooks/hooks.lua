local er_ref = end_round
function end_round()
   	er_ref()
   	local hiyori = false
   	for _,joker in ipairs(G.jokers.cards)do
		if joker.config.center.key == "j_hiyori" then
			hiyori = true
		end
   	end
   	for _,joker in ipairs(G.playbook_extra.cards)do
		if joker.config.center.key == "j_hiyori" then
			hiyori = true
		end
   	end
	for _,v in ipairs(G.playing_cards) do
		SMODS.debuff_card(v,false,"filter")
		if v:is_suit("Hearts") and hiyori then
			SMODS.debuff_card(v,true,"filter")
		end
	end
	for _,v in ipairs(G.jokers.cards) do
		SMODS.debuff_card(v,false,"filter")
	end
	for _,v in ipairs(G.playbook_extra.cards) do
		SMODS.debuff_card(v,false,"filter")
	end 
end

local oldsell = Card.sell_card
function Card:sell_card()
  
  if self.area == G.playbook_extra then
    return true
  else
    local w = oldsell(self)
    return w
  end
end

local smcmb = SMODS.create_mod_badges
function SMODS.create_mod_badges(obj, badges)
	smcmb(obj, badges)
	if obj and obj.credits then
		local function calc_scale_fac(text)
			local size = 0.9
			local font = G.LANG.font
			local max_text_width = 2 - 2 * 0.05 - 4 * 0.03 * size - 2 * 0.03
			local calced_text_width = 0

			for _, c in utf8.chars(text) do
				local tx = font.FONT:getWidth(c) * (0.33 * size) * G.TILESCALE * font.FONTSCALE
					+ 2.7 * 1 * G.TILESCALE * font.FONTSCALE
				calced_text_width = calced_text_width + tx / (G.TILESIZE * G.TILESCALE)
			end
			local scale_fac = calced_text_width > max_text_width and max_text_width / calced_text_width or 1
			return scale_fac
		end
		if obj.credits.art or obj.credits.code or obj.credits.idea or obj.credits.sug then
			local scale_fac = {}
			local min_scale_fac = 1
			local strings = { "Neuratro" }
			for pos, v in ipairs({ "sug","idea", "art", "code" }) do
				if obj.credits[v] then
					for i = 1, #obj.credits[v] do
            if pos == 1 then
              strings[#strings + 1] = "Suggested by: " .. obj.credits.sug[1]
            elseif pos == 2 then 
				strings[#strings + 1] = "Idea: " .. obj.credits.idea[i]
            elseif pos == 3 then
              strings[#strings + 1] = "Art: " .. obj.credits.art[1]
            elseif pos == 4 then
              strings[#strings + 1] = "Code: " .. obj.credits.code[1]
            end
					end
				end
			end
			for i = 1, #strings do
				scale_fac[i] = calc_scale_fac(strings[i])
				min_scale_fac = math.min(min_scale_fac, scale_fac[i])
			end
			local ct = {}
			for i = 1, #strings do
				ct[i] = {
					string = strings[i],
				}
			end
			local badge = {
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.R,
						config = {
							align = "cm",
							colour = G.C.SECONDARY_SET.Spectral,
							r = 0.1,
							minw = 2 / min_scale_fac,
							minh = 0.36,
							emboss = 0.05,
							padding = 0.03 * 0.9,
						},
						nodes = {
							{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
							{
								n = G.UIT.O,
								config = {
									object = DynaText({
										string = ct or "ERROR",
										colours = { obj.credits and obj.credits.text_colour or G.C.WHITE },
										silent = true,
										float = true,
										shadow = true,
										offset_y = -0.03,
										spacing = 1,
										scale = 0.33 * 0.9,
									}),
								},
							},
							{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
						},
					},
				},
			}
			for i = 1, #badges do
        if i == #badges then
					badges[i].nodes[1].nodes[2].config.object:remove()
					badges[i] = badge
					break
        end
			end
		end
	end
end

local smods_showman_ref = SMODS.showman
function SMODS.showman(card_key)
    if next(SMODS.find_card('j_emojiman')) and card_key == "j_smiley" then
        return true
    end
    return smods_showman_ref(card_key)
end

local oldcardgetchipbonus = Card.get_chip_bonus
function Card:get_chip_bonus()
    local g = oldcardgetchipbonus(self)
    if self.base.suit == "Glorpsuit" and SMODS.has_enhancement(self, "m_bonus") then g = (g-30) * 10 + 30
    elseif self.base.suit == "Glorpsuit" and not SMODS.has_enhancement(self, "m_stone") then g = g * 10 end
    return g
end

SMODS.Stickers["rental"].should_apply = function(self, card, center, area, bypass_roll)
	if G.GAME.stake ~= 8 or pseudorandom("rentalapply") <= 0.7 or card.ability.set ~= 'Joker' or card.config.center.rarity == "dev" or card.config.center.rarity == 4 then
		return false
	end
	return true
end

local Game_update = Game.update
local prev_money = 0
MONEY_EARNED = 0
function Game:update(dt)
	Game_update(self, dt)

	if self.GAME and self.GAME.dollars then
		local money = self.GAME.dollars
		if money > prev_money then
			MONEY_EARNED = MONEY_EARNED + money - prev_money	
		end
		prev_money = money
	end
end

local start_run = G.FUNCS.start_run
function G.FUNCS.start_run(e, args)
	MONEY_EARNED = 0
	prev_money = 0
	start_run(e, args)
end

-- arg shader for her deck. simple. scuffed. gets the job done
-- surely no other mods will ever replace the CRT shader :glueless:
-- replace "Deck Name"
local originalshader = false

local drawg = Game.draw
function Game:draw(args)
    local x = {drawg(self,args)}
    if(G.SHADERS['CRT'] and not originalshader) then
        originalshader = G.SHADERS['CRT']
    else
        if(self.STATE ~= self.STATES.MENU and self.GAME.selected_back and self.GAME.selected_back.name == "Deck Name") then
            G.SHADERS['CRT'] = G.SHADERS['arg']
        else
            G.SHADERS['CRT'] = originalshader
        end
    end
    return x
end