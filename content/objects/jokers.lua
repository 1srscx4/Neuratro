local neuro_jokers = {"j_plasma_globe","j_btmc","j_highlighted","j_anny","j_kyoto","j_pipes","j_milc","j_teru","j_schedule","j_lavalamp","j_lucy","j_queenpb","j_tutelsoup","j_layna","j_forghat",'j_3heart','j_argirl',"j_tiredtutel","j_hype","j_recbin","j_harpoon","j_cfrb","j_sispace","j_allin","j_camila","j_jokr","j_xdx|","j_bday1","j_bday2","j_sistream","j_donowall","j_stocks","j_techhard","j_gimbag","j_void","j_collab","j_cavestream","j_jorker","j_roulette","j_Vedds","j_ddos","j_hiyori","j_Glorp","j_Emuz","j_anteater","j_drive","j_deliv","j_fourtoes","j_abandonedarchive","j_minikocute","j_neurodog","j_ely","j_cerbr","j_corpa","j_emojiman","j_shoomimi","j_plush","j_vedalsdrink","j_plush","j_filtersister","j_envy"}
--Neuro related 
SMODS.Joker{
key = '3heart', 
loc_txt = { 
name = 'heartheartheart',
text = {
'Give {X:mult,C:white}X#1#{} Mult',
'If played hand is {C:attention}3 of a kind{}',
'and all cards are {C:hearts}hearts{},',
'increase by {X:mult,C:white}x#2#{}'
},

},
credits = {
idea = {"Evil Sand"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 5, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = false, 
pos = {x = 2, y = 0}, 
soul_pos = { x = 3, y = 0 },
config = { 
extra = {
Xmult = 1,
xmbonus = 0.45
} 
},
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.Xmult,center.ability.extra.xmbonus}} --#1# is replaced with card.ability.extra.Xmult
end,
calculate = function(self,card,context)
if context.before and context.scoring_name == "Three of a Kind" and not context.blueprint and not context.retrigger_joker then 
  local upgs = true
  for _, playing_card in ipairs(context.scoring_hand) do
    if not playing_card:is_suit("Hearts") then
    upgs = false
    break
  end
end
if not context.blueprint and upgs then
  card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.xmbonus
  return { message = "Upgrade!"} 
end
end
if context.joker_main then
  return { xmult = card.ability.extra.Xmult }
end
end,
in_pool = function(self,wawa,wawa2)
return true
end 
}
SMODS.Joker{
key = "gimbag",
loc_txt = {
name = "Gym Bag",
text = {
"{C:attention}+1{} hand size.",
"{C:attention}Aces{} held in hand give",
"{C:mult}+#1#{} mult and {C:chips}+#2#{} chips",
"Double for {C:attention}Aces{} of {C:hearts}Hearts{}"}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 6,
credits = {
idea = {"1srscx4"},
art = {"Tony7268"},
code = {"1srscx4"}
},
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 6, y = 5},
config = { extra = { added = 12 }},
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.added,center.ability.extra.added}}
end,
add_to_deck = function(self, card, from_debuff)
G.hand:change_size(1)
end,
remove_from_deck = function(self, card, from_debuff)
for _,joker in ipairs(G.jokers.cards) do
if joker.config.center.key == "j_evilsand" and card.area ~= G.playbook_extra then
return
end
end
G.hand:change_size(-1)
end,
calculate = function(self,card,context)
if context.individual and context.cardarea == G.hand and not context.end_of_round and context.other_card:get_id() == 14 then
if context.other_card:is_suit("Hearts") then
return {mult = card.ability.extra.added * 2, chips = card.ability.extra.added * 2 }
end
return {mult = card.ability.extra.added , chips = card.ability.extra.added }
end
end,
in_pool = function(self, args) 
return true
end
}
SMODS.Joker{
key = "roulette",
loc_txt = {
name = "Neuro Roulette",
text = {
"Multiply mult by either",
"{X:mult,C:white}x#1#{} or {X:mult,C:white}x#2#{}",
"{s:0.8,C:red,E:1}Don't be afraid, Vedal"}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true},
credits = {
idea = {"1srscx4"},
art = {"Evil Sand"},
code = {"1srscx4"}
}, 
rarity = 2, 
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 1, y = 4},
config = { extra = { xhigh = 4, xlow = 0.25 }},
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.xhigh,center.ability.extra.xlow}}
end,
calculate = function(self,card,context)
if context.joker_main then
return { xmult = pseudorandom_element({card.ability.extra.xhigh,card.ability.extra.xlow},pseudoseed("seed")) }
end
end,
in_pool = function(self,args)
return true
end
}
SMODS.Joker{
key = "plush",
loc_txt = {
name = "Neuro Fumo",
text = {
"This joker gains {C:mult}+#1#{} mult",
"for every {C:money}$#2#{} spent. {C:inactive}(Currently: {C:mult}+#3#{C:inactive})",
"{C:inactive}({C:money}$#4#{C:inactive} left until next upgrade)"
}
},
credits = {
sug = {"Pers"},
idea = {"1srscx4"},
art = {"Etzyio+"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = false,
pos = { x = 7, y = 1 },
in_pool = function(self, args) 
return true
end,
config = { extra = {upg = 12 , goal = 30 , mult = 0, current = 0, triggers = false} },
loc_vars = function(self,info_queue,center)
return { vars = {center.ability.extra.upg,center.ability.extra.goal,center.ability.extra.mult,center.ability.extra.goal - center.ability.extra.current} }
end,
calculate = function(self,card,context)
if context.buying_card or context.open_booster and not context.retrigger_joker then
card.ability.extra.current = card.ability.extra.current + context.card.cost
end
if context.end_of_round and G.GAME.current_round.free_rerolls == 0 and not context.retrigger_joker then
card.ability.extra.triggers = true
end
if context.reroll_shop and G.GAME.current_round.free_rerolls == 0 and not context.retrigger_joker then
if card.ability.extra.triggers then
card.ability.extra.current = card.ability.extra.current + G.GAME.current_round.reroll_cost - 1
end 
card.ability.extra.triggers = true
end
if context.ending_shop and not context.retrigger_joker then
card.ability.extra.triggers = false
end
if card.ability.extra.current >= card.ability.extra.goal and not context.blueprint and not context.retrigger_joker then
card.ability.extra.current = card.ability.extra.current - card.ability.extra.goal
card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.upg
return { message = "Upgrade!"}
end
if context.joker_main then
return {mult = card.ability.extra.mult}
end
end
}
SMODS.Joker{
key = "forghat",
loc_txt = {
name = "Frog Hat",
text = {
"When a card with a seal is {C:attention}played{},",
"the card to the {C:attention}right{} has a ",
"{C:green,E:1}#1# in #2#{} chance to gain this seal."
}
},
credits = {
idea = {"1srscx4"},
art = {"Kloovree"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 8, y = 3 },
in_pool = function(self, args)
local inpool = false
for _,playing_card in ipairs(G.playing_cards) do
if playing_card.seal then
inpool = true
break
else
inpool = false
end
end
return inpool
end,
config = { extra = {base = 1, odds = 3} },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.base * (G.GAME and G.GAME.probabilities.normal or 1),center.ability.extra.odds } }
end,
calculate = function (self, card, context)
if context.before then
for pos,v in pairs(context.full_hand) do
if context.full_hand[#context.full_hand + 1 - pos].seal and context.full_hand[ #context.full_hand - pos + 2] ~= nil and pseudorandom("anteater") < ((G.GAME and G.GAME.probabilities.normal or 1) * card.ability.extra.base) / self.config.extra.odds then
sea(
function ()
context.full_hand[ #context.full_hand - pos + 2]:flip()
context.full_hand[ #context.full_hand - pos + 2]:juice_up(0.3, 0.3)
return true
end,0.35,"before")
sea(
function ()
context.full_hand[ #context.full_hand - pos + 2]:set_seal(context.full_hand[#context.full_hand + 1 - pos].seal)
return true
end,0.55,"before"
)
sea(
function ()
context.full_hand[ #context.full_hand - pos + 2]:flip()
context.full_hand[ #context.full_hand - pos + 2]:juice_up(0.3, 0.3)
return true
end,0.35,"before")
end
end
end
end
}
SMODS.Joker{
key = "lavalamp",
loc_txt = {
name = "Lava Lamp",
text = {
"Gives {X:mult,C:white}x#4#{} mult.",
"{C:attention}Cycles{} back and forth through:",
"{X:mult,C:white}x#1#{} , {X:mult,C:white}x#2#{} and {X:mult,C:white}x#3#{}"
}
},
credits = {
  sug = {"Evil Sand"},
  idea = {"1srscx4"},
  art = {"Tony7268"},
  code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 3, 
cost = 8, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 0, y = 5 },
in_pool = function(self, args) 
  return true
end,
config = { extra = {xmult = 1.5, cycle = "1",c1 = 1.5, c2 = 2, c3 = 2.5} },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.c1,center.ability.extra.c2,center.ability.extra.c3,center.ability.extra.xmult} }
end,
calculate = function (self, card, context)
if context.joker_main then
return {xmult = card.ability.extra.xmult}
end
if context.after and not context.blueprint  and not context.retrigger_joker then
if card.ability.extra.cycle == "1" then
card.ability.extra.cycle = tostring(tonumber(card.ability.extra.cycle)+1)
card.ability.extra.xmult = card.ability.extra.c2
sea(
function()
card.children.center:set_sprite_pos({x = 1, y = 5})
return true
end,0.1
)
return {message = "Upgrade!"}
elseif card.ability.extra.cycle == "2" then
card.ability.extra.cycle = tostring(tonumber(card.ability.extra.cycle)+1)
card.ability.extra.xmult = card.ability.extra.c3
sea(
function()
card.children.center:set_sprite_pos({x = 2, y = 5})
return true
end,0.1
)
return {message = "Upgrade!"}
elseif card.ability.extra.cycle == "3" then
card.ability.extra.cycle = tostring(tonumber(card.ability.extra.cycle)+1)
card.ability.extra.xmult = card.ability.extra.c2
sea(
function()
card.children.center:set_sprite_pos({x = 1, y = 5})
return true
end,0.1
)
return {message = "Upgrade!"}
elseif card.ability.extra.cycle == "4" then
card.ability.extra.cycle = "1"
card.ability.extra.xmult = card.ability.extra.c1
sea(
function()
card.children.center:set_sprite_pos({x = 0, y = 5})
return true
end,0.1
)
return {message = "Upgrade!"}
end
end
end
}
SMODS.Joker{
  key = "breadge",
  loc_txt = {
    name = "Neuro Bread",
    text = {
      "{C:attention}Stone Cards{} instead give {C:mult}+#1#{} Mult.",
      "{C:mult}-#2#{} Mult at {C:attention}end of round{}."
    }
  },
  
credits = {
  sug = {"Evil Sand"},
  idea = {"1srscx4"},
  art = {"Tony7268"},
  code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 8, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 2, y = 7 },
in_pool = function(self, args) 
  return true
end,
config = { extra = {mult = 21, decr = 3}},
loc_vars = function (self, info_queue, card)
  info_queue[#info_queue+1] = G.P_CENTERS.m_stone
  return { vars = {card.ability.extra.mult, card.ability.extra.decr}}
end,
calculate = function (self, card, context)
  if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
    card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.decr
    if card.ability.extra.mult <= 0 then
      SMODS.destroy_cards(card)
      return {message = "Filtered"}
    end
    return {message = "-" .. tostring(card.ability.extra.decr), colour = 	G.C.MULT}
  end
end
}
--Evil Related 
SMODS.Joker{
key = "harpoon",
loc_txt = {
name = "Get Harpooned!",
text = {"Gives {X:mult,C:white}X#3#{} Mult.",
"{C:green,E:1} #1# in #2#{} chance to lose all {C:red}discards{}."}
},
credits = {
idea = {"Evil Sand"},
art = {"Etzyio+"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 3, 
cost = 8, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true, 
pos = {x = 8, y = 1}, 
config = { extra = { odds = 3 , xmult = 3, base = 1} },
loc_vars = function(self,info_queue,center)
return {vars = {G.GAME.probabilities.normal * center.ability.extra.base,center.ability.extra.odds,center.ability.extra.xmult}}
end,
calculate = function(self,card,context)
if context.before and context.cardarea == G.jokers and G.GAME.current_round.discards_left > 0 then
  if pseudorandom("seed") <= (G.GAME.probabilities.normal * card.ability.extra.base)/card.ability.extra.odds then
  G.GAME.current_round.discards_left = 0
  return { message = "Harpooned!" }
  end
end
if context.joker_main then
  return { Xmult = card.ability.extra.xmult }
end
end,
in_pool = function(self,wawa,wawa2)
return true
end
}
SMODS.Joker{
key = "cfrb",
loc_txt = {
name = "CFRB",
text = {"{C:attention}Kings{} of {C:spades}Spades{} give {X:mult,C:white}X#1#{} Mult.",
"Increases by {X:mult,C:white}X#2#{} when",
"a {C:attention}King{} of {C:clubs}Clubs{} is destroyed"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
credits = {
idea = {"Evil Sand"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
rarity = 3, 
cost = 8, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = false, 
pos = {x = 6, y = 2}, 
config = { extra = { Xmult_bonus = 1 , upg = 0.5} },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.Xmult_bonus,center.ability.extra.upg}}
end,
calculate = function(self,card,context)
if context.remove_playing_cards and not context.blueprint and not context.retrigger_joker then
local upg_happened = false
for _, playing_card in ipairs(context.removed) do
if playing_card:is_suit("Clubs") and playing_card:get_id() == 13 then
card.ability.extra.Xmult_bonus = card.ability.extra.Xmult_bonus + card.ability.extra.upg
upg_happened = true
end
end
if upg_happened then
return { message = "Upgrade!"}
end
end
if context.individual and context.cardarea == G.play then
if context.other_card:is_suit("Spades") and context.other_card:get_id() == 13 then
return { xmult = card.ability.extra.Xmult_bonus }
end
end
end,
in_pool = function(self,wawa,wawa2)
return true
end
}
SMODS.Joker{
key = "bday1",
loc_txt = {
name = "Evil's First Birthday",
text = {
"Gives {C:mult}+#1#{} mult. Increase",
"this by {C:mult}+#3#{} when a {C:attention}face card",
"is destroyed. Goes {C:attention,E:2}extinct{} at {C:attention}#4#{}",
"{C:attention}face cards{} destroyed. {C:inactive}[#2# left]{}"
}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 1, 
credits = {
idea = {"Emuz"},
art = {"Etzyio+"},
code = {"1srscx4"}
},
cost = 4, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = false, 
perishable_compat = false, 
pos = {x = 5, y = 3},
config = { extra = { mult_bonus = 4 , upg = 2, face = 0, goal = 6} },          
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.mult_bonus,center.ability.extra.goal - center.ability.extra.face,center.ability.extra.upg,center.ability.extra.goal}}
end,
calculate = function(self,card,context)
if context.joker_main then
return { mult = card.ability.extra.mult_bonus }
end
if context.remove_playing_cards and not context.blueprint and not context.retrigger_joker then
local upgraded = false
for _, playing_card in ipairs(context.removed) do
if playing_card:is_face() then
card.ability.extra.mult_bonus = card.ability.extra.mult_bonus + card.ability.extra.upg
card.ability.extra.face = card.ability.extra.face + 1
if card.ability.extra.face >= card.ability.extra.goal then
SMODS.destroy_cards(card)
G.GAME.pool_flags.trauma = true
end
upgraded = true
end
end
if upgraded then
return { message = "Upgrade!"}
end
end
end,
in_pool = function(self, args) 
return not G.GAME.pool_flags.trauma
end
}
SMODS.Joker{
key = "bday2",
loc_txt = {
name = "Evil's Second Birthday",
text = {
"Gives {X:mult,C:white}X#1#{} Mult. Increase",
"by {X:mult,C:white}X#2#{} Mult when a",
"{C:attention}face card{} is added to the deck"
}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2,
credits = {
idea = {"Emuz"},
art = {"Etzyio+"},
code = {"1srscx4"}
}, 
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = false, 
pos = {x = 6, y = 3},
config = { extra = { xmult_bonus = 1.5, upg = 0.5} },          
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.xmult_bonus, center.ability.extra.upg}}
end,
calculate = function(self,card,context)
if context.joker_main then
return { xmult = card.ability.extra.xmult_bonus }
end
if context.playing_card_added and not context.blueprint and not context.retrigger_joker then
local upg_happened = false
for _,playing_card in ipairs(context.cards) do
if playing_card:is_face() then
card.ability.extra.xmult_bonus = card.ability.extra.xmult_bonus + card.ability.extra.upg 
upg_happened = true
end
end
if upg_happened then
return { message = "Upgrade!"}
end
end
end,
in_pool = function(self, args) 
return G.GAME.pool_flags.trauma
end
}
SMODS.Joker{
key = "pipes",
loc_txt = {
name = "PIPES",
text = {
"{C:attention}Steel cards{} give {X:mult,C:white}x#1#{} mult instead.",
"Leftmost card {C:atention}held{} in hand",
"becomes a {C:attention}steel card{}",
"{C:red,E:1,s:0.9}Steel cards play a metal pipe sound.{}"
}
},
credits = {
idea = {"1srscx4","Pers"},
art = {"Dirtlord"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 5, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 2, y = 6 },
in_pool = function(self, args) 
return true
end,
config = { extra = {xmult = 2} },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.xmult} }
end,
calculate = function (self, card, context)
if context.before and #G.hand.cards > 0 then
sea(
function ()
G.hand.cards[1]:flip()
G.hand.cards[1]:juice_up(0.3, 0.3)
return true
end,0.35,"before")
sea(
function ()
G.hand.cards[1]:set_ability(G.P_CENTERS["m_steel"])
return true
end,0.55,"before"
)
sea(
function ()
G.hand.cards[1]:flip()
G.hand.cards[1]:juice_up(0.3, 0.3)
return true
end,0.35,"before")
end
end
}
SMODS.Joker{
key = "deliv",
loc_txt = {
name = "Abber Demon",
text = {
"Each {C:attention}scored card{} has a",
"{C:green,E:1}#1# in #2#{} chance of being {C:red,E:1}destroyed",
"When this happens, this joker",
"gains {X:mult,C:white}x#3#{} mult. {C:inactive}(currently: {X:mult,C:white}x#4#{C:inactive})"}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 3, 
credits = {
idea = {"Bigbuckies"},
art = {"Etzyio+"},
code = {"1srscx4"}
},
cost = 8, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = false,
pos = { x = 9, y = 5 },
config = { extra = { base = 1 , odds = 6 , upg = 0.25 , xmult = 1} },
loc_vars = function(self,info_queue,center)
return { vars = {center.ability.extra.base * (G.GAME and G.GAME.probabilities.normal or 1),center.ability.extra.odds,center.ability.extra.upg,center.ability.extra.xmult } }
end,
calculate = function(self,card,context)
if context.joker_main then
return { xmult = card.ability.extra.xmult}
end
if context.individual and context.cardarea == G.play and pseudorandom("seed") <= ((G.GAME and G.GAME.probabilities.normal or 1) * card.ability.extra.base) / self.config.extra.odds then
SMODS.destroy_cards(context.other_card)
card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.upg
return { message = "Destroy!" }
end
end,
in_pool = function(self, args) 
return true
end
}
SMODS.Joker {
key = "mcneuros",
loc_txt = {
name = "McNeuro's",
text = {
"If played hand consists of exactly",
"{C:attention}#1#{}, lose {C:money}$#2#{} and create",
"two random {C:tarot}Tarot{} cards. {C:inactive}(Required", 
"{C:inactive}hand changes after each activation)"
}
},
credits = {
idea = {"PaulaMarina"},
art = {"None"},
code = {"PaulaMarina"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 1, 
cost = 4, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 6, y = 8 },
config = { extra = { cycle = 1, dollars = 2, tarots = 2 }},
loc_vars = function(self,info_queue,center)
local ret = ""
if center.ability.extra.cycle == 1 then
ret = "two 9s"
elseif center.ability.extra.cycle == 2 then
ret = "one 9"
elseif center.ability.extra.cycle == 3 then
ret = "one 6"
elseif center.ability.extra.cycle == 4 then
ret = "one 7"
elseif center.ability.extra.cycle == 0 then
ret = "two 4s and two 5s"
end
return { vars = { ret, center.ability.extra.dollars}}
end,
calculate = function(self, card, context)
if context.joker_main then
local activate = false
if card.ability.extra.cycle == 1 then
activate = #context.full_hand == 2 and context.full_hand[1]:get_id() == 9 and context.full_hand[2]:get_id() == 9
elseif card.ability.extra.cycle == 2 then
activate = #context.full_hand == 1 and context.full_hand[1]:get_id() == 9
elseif card.ability.extra.cycle == 3 then
activate = #context.full_hand == 1 and context.full_hand[1]:get_id() == 6
elseif card.ability.extra.cycle == 4 then
activate = #context.full_hand == 1 and context.full_hand[1]:get_id() == 7
elseif card.ability.extra.cycle == 0 then
if #context.full_hand == 4 then
local fours = 0
local fives = 0
for _key, val in ipairs(context.full_hand) do
if val:get_id() == 4 then fours = fours + 1 end
if val:get_id() == 5 then fives = fives + 1 end
end
if fours == 2 and fives == 2 then activate = true end
end
end
if activate then
card.ability.extra.cycle = math.fmod(card.ability.extra.cycle + 1, 5)
G.E_MANAGER:add_event(Event({
func = (function()
if G.consumeables.config.card_limit > #G.consumeables.cards + 1 then
play_sound('timpani')
G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 2
SMODS.add_card {
set = 'Tarot',
key_append = 'mcneuros' 
}
SMODS.add_card {
set = 'Tarot',
key_append = 'mcneuros' 
}
elseif G.consumeables.config.card_limit > #G.consumeables.cards then
play_sound('timpani')
G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
SMODS.add_card {
set = 'Tarot',
key_append = 'mcneuros' 
}
end
G.GAME.consumeable_buffer = 0
return true
end)
}))
delay(0.5)
return { dollars = (-1) * card.ability.extra.dollars }
end
end
end
}
SMODS.Joker {
key = "plasma_globe",
loc_txt = {
name = "Plasma Globe",
text = {
"Gains {X:mult,C:white}X#1#{} Mult when", 
"a {C:spectral}Spectral{} card is used.",
"{C:inactive}(currently {X:mult,C:white}X#2#{C:inactive} Mult)"
}
},
credits = {
sug = {"Evil Sand"},
idea = {"PaulaMarina"},
art = {"Tony7268"},
code = {"PaulaMarina"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
blueprint_compat = true,
perishable_compat = false,
rarity = 2,
cost = 6,
pos = { x = 9, y = 6 },
config = { extra = { Xmult = 1, Xmult_mod = 0.75 } },
loc_vars = function(self, info_queue, card)
return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult } }
end,
calculate = function(self, card, context)
if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == 'Spectral' and not context.retrigger_joker then
card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
return {
message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
}
end
if context.joker_main then
return {
Xmult = card.ability.extra.Xmult
}
end
end
}
--Both twin
SMODS.Joker{
key = "sispace",
loc_txt = {
name = "Twins In Space",
text = {"Gives {C:chips}+#2#{} chips per",
"{C:planet}planet{} card used this run.",
"{C:inactive}[Currently{} {C:chips}+#1#{} {C:inactive}chips{}]"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 1, 
credits = {
idea = {"2nd Umbrella"},
art = {"None"},
code = {"1srscx4"}
},
cost = 4, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = false, 
pos = {x = 1, y = 0}, 
config = { extra = { chip_bonus = 9 } },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.chip_bonus * (G.GAME and G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.planet or 0), center.ability.extra.chip_bonus }}
end,
calculate = function(self,card,context)
if context.joker_main then
return { chips = card.ability.extra.chip_bonus * (G.GAME and G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.planet or 0)}
end
end,
in_pool = function(self,wawa,wawa2)
return true
end
}
SMODS.Joker{
key = "sistream",
loc_txt = {
name = "Twin Stream",
text = {
"Retrigger all ",
"played {C:attention}twin cards{}"}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
credits = {
idea = {"1srscx4"},
art = {"None"},
code = {"1srscx4"}
},
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true, 
pos = {x = 1, y = 0},
loc_vars = function(self,info_queue,center)
info_queue[#info_queue+1] = G.P_CENTERS.m_twin
return 
end,

calculate = function(self,card,context)
if context.repetition and context.cardarea == G.play then
if SMODS.has_enhancement(context.other_card, "m_twin") then
return { repetitions = 1 }
end
end
end,
in_pool = function(self,wawa,wawa2)
local inpool = false
for _,cards in ipairs(G.playing_cards) do
if SMODS.has_enhancement(cards,"m_twin") then
inpool = true
break
else
inpool = false
end
end
return inpool
end
}
--Vedal related 
SMODS.Joker{
key = "tiredtutel",
loc_txt = {
name = "Turtle At Work",
text = {"Gives {C:mult}+#2#{} Mult per used {C:red}discard{} this blind",
"{C:inactive}(Currently {C:mult}+#1#{} {C:inactive}Mult{C:inactive})"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true},
credits = {
idea = {"2nd Umbrella"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
rarity = 1,
cost = 4,
unlocked = true,  
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true, 
pos = {x = 1, y = 0},
config = { extra = { mult = 0, base = 5} },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.mult,center.ability.extra.base}}
end,
calculate = function(self,card,context)
if context.end_of_round and context.cardarea == G.jokers  and not context.retrigger_joker then
card.ability.extra.mult = 0
return { message = "Reset" }
end
if context.pre_discard and not context.blueprint and not context.retrigger_joker then 
card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.base
return { message = "Upgrade!" }
end
if context.joker_main then
return {mult = card.ability.extra.mult}
end
end,
in_pool = function(self,wawa,wawa2)
return true
end ,

}
SMODS.Joker{
key = "recbin",
loc_txt = {
name = "Recycle Bin",
text = {"Gives {C:chips}+#2#{} chips per",
"{C:red}discarded{} card this round",
"{C:inactive}[Currently {C:chips}+#1#{} {C:inactive}chips]{}"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true},
credits = {
idea = {"2nd Umbrella"},
art = {"Tony7268"},
code = {"1srscx4"}
},
pos = { x = 6 , y = 4 },
rarity = 1,
cost = 4,
unlocked = true,  
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
config = { extra = { bonus_chips = 0, extra_chips = 7 } },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.bonus_chips,center.ability.extra.extra_chips}}
end,
calculate = function(self,card,context)
if context.joker_main then
return { chips = card.ability.extra.bonus_chips}
end
if context.discard and not context.blueprint and not context.retrigger_joker then
card.ability.extra.bonus_chips = card.ability.extra.bonus_chips + card.ability.extra.extra_chips
end
if context.end_of_round and context.cardarea == G.jokers and not context.retrigger_joker then
card.ability.extra.bonus_chips = 0
return { message = "Reset" }
end
end,
in_pool = function(self,wawa,wawa2)
return true
end
}
SMODS.Joker{
key = "vedalsdrink",
loc_txt = {
name = "Banana Rum",
text = {
"If a {C:attention}King{} of {C:clubs}Clubs{} is played,",
"{C:attention}triple{} the chips and {C:red,E:2}break"
}
},
credits = {
sug = {"Pers"},
idea = {"1srscx4"},
art = {"Etzyio+"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 1, 
cost = 4, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = false, 
perishable_compat = true,
pos = { x = 9, y = 1 },
in_pool = function(self, args) 
return true
end,
config = { extra = {chips_min = 20 , chips_max = 200} },
loc_vars = function(self,info_queue,card)
local r_mults = {}
for i = card.ability.extra.chips_min, card.ability.extra.chips_max do
r_mults[#r_mults + 1] = tostring(i)
end
main_start = {
{ n = G.UIT.T, config = { text = 'Gives ',colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
{ n = G.UIT.T, config = { text = '+', colour = G.C.CHIPS, scale = 0.32 } },
{ n = G.UIT.O, config = { object = DynaText({ string = r_mults, colours = { G.C.CHIPS }, pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0 }) } },
{ n = G.UIT.T, config = { text = ' chips.',colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
}
return { main_start = main_start }
end,
calculate = function(self,card,context)
if context.joker_main then
local breaking = false
for _,playing_card in ipairs(context.scoring_hand) do 
if playing_card:get_id() == 13 and playing_card:is_suit("Clubs") then
breaking = true
end
end
if breaking then
return { chips = pseudorandom("rum",card.ability.extra.chips_min,card.ability.extra.chips_max) * 3 , func = SMODS.destroy_cards(card) , message = "Drunk!"}
else
return { chips = pseudorandom("rum",card.ability.extra.chips_min,card.ability.extra.chips_max)}
end
end
end 
}
SMODS.Joker{
key = "Vedds",
loc_txt = {
name = "Vedd's Store",
text = {
"Give {C:chips}+#1#{} chips per",
"{C:attention}Ace{} of {C:clubs}Clubs{} in deck",
"{C:inactive}(Currently: {C:chips}+#2#{}{C:inactive})"
}},
credits = {
  idea = {"1srscx4"},
  art = {"None"},
  code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 1, y = 0},
config = { extra = { chips = 35 }},
loc_vars = function(self,info_queue,center)
local n_ace = 0
if G.playing_card then
for _,playing_card in ipairs(G.playing_cards) do
if playing_card:get_id() == 14 and playing_card:is_suit("Clubs") then
n_ace = n_ace +1 
end
end
end
return {vars = {center.ability.extra.chips,center.ability.extra.chips * n_ace}}
end,
calculate = function(self,card,context)    
if context.joker_main then
local n_ace = 0
for _,playing_card in ipairs(G.playing_cards) do
if playing_card:get_id() == 14 and playing_card:is_suit("Clubs") then
n_ace = n_ace +1 
end
end
return { chips = card.ability.extra.chips * n_ace }
end
end,
in_pool = function(self,args)
return true
end
}
SMODS.Joker{
key = "fourtoes",
loc_txt = {
name = "Four Toes",
text = { "All {C:attention}Mixes{} can be",
"made with {C:attention}4{} cards" },
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 3, 
credits = {
idea = {"Evil Sand","PaulaMarina"},
art = {"None"},
code = {"PaulaMarina"}
},
cost = 8, 
unlocked = true, 
discovered = false, 
blueprint_compat = false, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 1, y = 0 },
in_pool = function(self, args) 
return G.GAME.hands["mix"].played > 0
end
}
SMODS.Joker{
key = "tutelsoup",
loc_txt = {
name = "Tutel Soup",
text = {
"Gives either {C:mult}+#1#{} mult, {C:chips}+#2#{} chips, {C:money}$#3#{} or {X:mult,C:white}x#4#{} mult",
"{C:red,E:1}Destroys{} self in {C:attention}#5#{} rounds."
}
},
credits = {
idea = {"1srscx4"},
art = {"Tony7268"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 1, 
cost = 5, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = false, 
perishable_compat = true,
pos = { x = 7, y = 4 },
in_pool = function(self, args) 
return true
end,
config = { extra = {mult = 15, chips = 100, money = 3, xmult = 1.5, rounds = 0 , goal = 4, chosen = ""} },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.mult,center.ability.extra.chips,center.ability.extra.money,center.ability.extra.xmult,center.ability.extra.goal - center.ability.extra.rounds} }
end,
calculate = function (self, card, context)
if context.before then
card.ability.extra.chosen = pseudorandom_element({"mult","chips","money","xmult"}, pseudoseed("soup"))
end
if context.joker_main then
if card.ability.extra.chosen == "mult" then
return {mult = card.ability.extra.mult}
elseif card.ability.extra.chosen == "chips" then 
return {chips = card.ability.extra.chips}
elseif card.ability.extra.chosen == "money" then
return {dollars = card.ability.extra.money}
elseif card.ability.extra.chosen == "xmult" then
return {xmult = card.ability.extra.xmult}
end
end
if context.end_of_round and context.cardarea == G.jokers then 
card.ability.extra.rounds = card.ability.extra.rounds + 1
if card.ability.extra.rounds >= card.ability.extra.goal then
SMODS.destroy_cards(card)
card:start_dissolve()
return {message = "Eaten!"}
end
return {message = "Soup!"}
end
end
}
SMODS.Joker{
key = "abandonedarchive",
loc_txt = {
name = "Abandoned Archive 2",
text = {
"When a joker is {C:attention}sold{}, gain mult",
"{C:attention}equal{} to it's {C:attention}sell value{}.",
"{C:inactive}(Currently {C:mult}+#1# {C:inactive}mult)"}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
credits = {
sug = {"Evil Sand"},
idea = {"1srscx4"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = false,
pos = { x = 6, y = 0 },
config = { extra = { mult = 0} },
loc_vars = function(self,info_queue,center)
return { vars = {center.ability.extra.mult } }
end,
calculate = function(self,card,context)
if context.joker_main then
return {mult = card.ability.extra.mult}
end
if context.selling_card and not context.blueprint and not context.retrigger_joker then
card.ability.extra.mult = card.ability.extra.mult + context.card.sell_cost
end
end,
in_pool = function(self, args) 
return true
end
}
SMODS.Joker{
key = "tutel_credit",
loc_txt = {
name = "Vedal's Credit Card",
text = {
"{C:attention}Get back{} your money for",
"the {C:attention}first{} purchase in each {C:attention}shop{}."
}
},
credits = {
idea = {"1srscx4"},
art = {"Etzyio+"},
code = {"1srscx4"}
},
rarity = 2,
cost = 7, 
unlocked = true, 
discovered = false, 
blueprint_compat = false, 
eternal_compat = true, 
perishable_compat = true,
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true},
pos = { x = 8, y = 5 },
in_pool = function(self, args) 
return true
end,
config = { extra = {active = true}},
calculate = function (self, card, context)
if (context.buying_card or context.open_booster) and card.ability.extra.active and context.card ~= card and not context.blueprint then
card.ability.extra.active = false
return{dollars = context.card.cost}
end
if context.end_of_round and context.cardarea == G.jokers then
card.ability.extra.active = true
return {message = "Active!"}
end
end
}
--Stream related
SMODS.Joker{
key = "hype",
loc_txt = {
name = "Hype Train",
text = {"Gives {C:money}$#1#{} at end of round, increases by",
"{C:money}$#2#{} if played hand contains a {C:attention}Donation",
"{C:attention}Card{}. {C:red,E:2}Destroys self{} after {C:attention}two {C:inactive}[#3#]{}",
"consecutive hands without {C:attention}Donation Cards{}."},
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true},
rarity = 2,
cost = 6,
credits = {
sug = {"2nd Umbrella"},
idea = {"That one guy"},
art = {"None"},
code = {"PaulaMarina"}
},
unlocked = true,  
discovered = false, 
blueprint_compat = false, 
eternal_compat = false, 
perishable_compat = true, 
pos = {x = 8, y = 8},
config = { extra = { gain = 1 , upg = 1, no_bit_hands = 0, max_no_bit_hands = 2 } },
loc_vars = function(self,info_queue,center)
info_queue[#info_queue + 1] = G.P_CENTERS.m_dono
return {vars = {center.ability.extra.gain,center.ability.extra.upg, center.ability.extra.no_bit_hands }}
end,
calc_dollar_bonus = function(self, card)
return card.ability.extra.gain
end,
calculate = function(self,card,context)
if context.after and not context.blueprint then
card.ability.extra.no_bit_hands = card.ability.extra.no_bit_hands + 1
for _k, val in ipairs(context.scoring_hand) do
if SMODS.has_enhancement(val,'m_dono') then
card.ability.extra.gain = card.ability.extra.gain + card.ability.extra.upg
card.ability.extra.no_bit_hands = 0
break
end
end
if card.ability.extra.no_bit_hands == card.ability.extra.max_no_bit_hands then
SMODS.destroy_cards(card)
return { message = "Destroyed" }
end
end
end,
in_pool = function(self,wawa,wawa2)
return true
end
}
SMODS.Joker{ 
key = "techhard",
loc_txt = {
name = "Technical Difficulties",
text = {
"{C:attention}First{} hand of round",
"gives {X:mult,C:white}x#1#{} Mult",
"All other hands",
"give {X:mult,C:white}x#2#{} Mult"}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 1, 
credits = {
idea = {"1srscx4"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
cost = 4, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 0, y = 6},
config = { extra = { low = 0.5 , high = 1.5 } },
loc_vars = function(self,info_queue,center)
return { vars = { center.ability.extra.low , center.ability.extra.high }}
end,
calculate = function(self,card,context)
if context.joker_main  then
if G.GAME.current_round.hands_played == 0 then
return { xmult = card.ability.extra.low }
else  return { xmult = card.ability.extra.high }
end
end
end,
in_pool = function(self, args) 
return true
end
}
SMODS.Joker{
key = "donowall",
loc_txt = {
name = "Donowall",
text = {
"Give {C:mult}+#1#{} mult per {C:attention}unscored{}",
"card in played hand."}
},
credits = {
idea = {"PaulaMarina"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 1, 
cost = 4, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true, 
pos = {x = 8, y = 0},
config = { extra = { mult_bonus = 0 , percard = 7 } },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.percard}}
end,
calculate = function(self,card,context)
if context.joker_main then
card.ability.extra.mult_bonus = 0
for i=1,#context.full_hand do
card.ability.extra.mult_bonus = card.ability.extra.mult_bonus + card.ability.extra.percard
end
for _,playing_card in ipairs(context.scoring_hand) do
card.ability.extra.mult_bonus = card.ability.extra.mult_bonus - card.ability.extra.percard
end
return { mult = card.ability.extra.mult_bonus }
end

end,
in_pool = function(self, args) 
return true
end
}
SMODS.Joker{
key = "stocks",
loc_txt = {
name = "VedalAI Stocks",
text = {
"At end of round, increase",
"this joker {C:money}sell value{} by",
"a number between {C:attention}#1#{} and {C:attention}+#2#{}"}
},
credits = {
idea = {"PaulaMarina"},
art = {"SupDrazor"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 1, 
cost = 4, 
unlocked = true, 
discovered = false, 
blueprint_compat = false, 
eternal_compat = true, 
perishable_compat = true, 
config = { extra = { price = 0, down = 3 , up = 6 } },
pos = {x = 3, y = 5},
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.down * -1,center.ability.extra.up}}
end,
calculate = function(self,card,context)
if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
local value = pseudorandom("seed")
if value <= 0.55 then
card.ability.extra.price = pseudorandom("seed",1,card.ability.extra.down) * -1
else card.ability.extra.price = pseudorandom("seed",1,card.ability.extra.up)
end
card.ability.extra_value = card.ability.extra_value + card.ability.extra.price
card:set_cost()
if value <= 0.55 then
return { message = "Value down :(" }
else return { message = "Value up!" }
end
end
end,
in_pool = function(self, args) 
return true
end
} 
SMODS.Joker{
key = "collab",
loc_txt = {
name = "Collab",
text = {
"Gives {X:mult,C:white}x#1#{} Mult if hand",
"contains three {C:attention}face{} cards",
"of different {C:attention}suits{}"}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 3, 
cost = 8,
credits = {
idea = {"1srscx4"},
art = {"none"},
code = {"1srscx4"}
},
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 1, y = 0},
config  = { extra = { xmult = 4 }},
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.xmult}}
end,
calculate = function(self,card,context)
if context.joker_main then
local vars = {
['Hearts'] = 0,
['Diamonds'] = 0,
['Spades'] = 0,
['Clubs'] = 0,
["face"] = 0
}
for i = 1, #context.scoring_hand do
if not SMODS.has_any_suit(context.scoring_hand[i]) then
if context.scoring_hand[i]:is_suit('Hearts', true) and vars["Hearts"] == 0 and context.scoring_hand[i]:is_face() then
  vars["Hearts"] = vars["Hearts"] + 1
elseif context.scoring_hand[i]:is_suit('Diamonds', true) and vars["Diamonds"] == 0 and context.scoring_hand[i]:is_face() then
  vars["Diamonds"] = vars["Diamonds"] + 1
elseif context.scoring_hand[i]:is_suit('Spades', true) and vars["Spades"] == 0 and context.scoring_hand[i]:is_face() then
  vars["Spades"] = vars["Spades"] + 1
elseif context.scoring_hand[i]:is_suit('Clubs', true) and vars["Clubs"] == 0 and context.scoring_hand[i]:is_face() then
  vars["Clubs"] = vars["Clubs"] + 1
end
if context.scoring_hand[i]:is_face() and vars["face"] < 3 then
vars["face"] = vars["face"] +1
end
end
end
for i = 1, #context.scoring_hand do
if SMODS.has_any_suit(context.scoring_hand[i]) then
if context.scoring_hand[i]:is_suit('Hearts', true) and vars["Hearts"] == 0 and context.scoring_hand[i]:is_face() then
  vars["Hearts"] = vars["Hearts"] + 1
elseif context.scoring_hand[i]:is_suit('Diamonds', true) and vars["Diamonds"] == 0 and context.scoring_hand[i]:is_face() then
  vars["Diamonds"] = vars["Diamonds"] + 1
elseif context.scoring_hand[i]:is_suit('Spades', true) and vars["Spades"] == 0  and context.scoring_hand[i]:is_face() then
  vars["Spades"] = vars["Spades"] + 1
elseif context.scoring_hand[i]:is_suit('Clubs', true) and vars["Clubs"] == 0 and context.scoring_hand[i]:is_face() then
  vars["Clubs"] = vars["Clubs"] + 1
end
if context.scoring_hand[i]:is_face() and vars["face"] < 3 then
vars["face"] = vars["face"] +1
end
end
end
if vars["Hearts"] + vars["Diamonds"] + vars["Spades"] + vars["Clubs"] >= 3 and vars["face"] > 2 then
return { xmult = card.ability.extra.xmult }
end

end
end,
in_pool = function(self, args) 
return true
end
} 
SMODS.Joker{
key = "cavestream",
loc_txt = {
name = "Cave Stream",
text = {
"Retrigger all played {C:attention}stone cards{}",
"If hand contains no {C:attention}stone cards{},",
"Turn the leftmost played card",
"into a {C:attention}stone card{}"}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 6,
credits = {
idea = {"1srscx4"},
art = {"None"},
code = {"1srscx4"}
}, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
config = { extra = {}},
loc_vars = function(self,info_queue,center)
info_queue[#info_queue+1] = G.P_CENTERS.m_stone
return 
end,
pos = { x = 1, y = 0},
calculate = function(self,card,context)
if context.repetition and context.cardarea == G.play then
if SMODS.has_enhancement(context.other_card, "m_stone") then
return { repetitions = 1 }
end
end
if context.joker_main then
local nostones = true
local playing_card = context.full_hand[1]
for _,p_card in ipairs(context.full_hand) do
if SMODS.has_enhancement(p_card,"m_stone") then
nostones = false
end
end
if nostones then
sea(
function ()
G.play.cards[1]:flip()
G.play.cards[1]:juice_up(0.3, 0.3)
return true
end,0.35,"before")
sea(
function ()
G.play.cards[1]:set_ability(G.P_CENTERS["m_stone"])
return true
end,0.55,"before"
)
sea(
function ()
G.play.cards[1]:flip()
G.play.cards[1]:juice_up(0.3, 0.3)
return true
end,0.35,"before")
end
return { message = "Echo!" }
end
end,
in_pool = function(self, args) 
return true
end
}
SMODS.Joker{
key = "ddos",
loc_txt = {
name = "Live DDOS",
text = {
"Gives {C:chips}+#1#{} chips.",
"{C:green,E:1}#2# in #3#{} chance to",
"debuff self after",
"hand is played."}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 1,
credits = {
idea = {"Pers"},
art = {"EmojiMan"},
code = {"1srscx4"}
},
cost = 4, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 7, y = 0},
config = { extra = { chips = 150 , odds = 3, base = 1}},
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.chips,center.ability.extra.base * G.GAME.probabilities.normal, center.ability.extra.odds}}
end,
calculate = function(self,card,context)
if context.joker_main then
if pseudorandom("seed") <= (card.ability.extra.base * G.GAME.probabilities.normal)/card.ability.extra.odds then
G.E_MANAGER:add_event(Event({
func = function()
card:set_debuff(true)
return true
end
})) 
return { message = "DDOS" }
end
return { chips = card.ability.extra.chips }
end
end,
in_pool = function(self,args)
return true
end
}
SMODS.Joker{
key = "drive",
loc_txt = {
name = "Long Drive",
text = {
"Gives {X:mult,C:white}x#1#{} mult. Every {C:attention}#2#",
"rounds, increase by {X:mult,C:white}x#4#{}.",
"{C:inactive}({C:attention}#3#{C:inactive} rounds left)"}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 3,
credits = {
idea = {"Bigbuckies"},
art = {"None"},
code = {"1srscx4"}
},
cost = 8, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = false,
pos = { x = 1, y = 0 },
config = { extra = { xmult = 1 , goal = 3 , left = 0 , upg = 1 } },
loc_vars = function(self,info_queue,center)
return { vars = {center.ability.extra.xmult,center.ability.extra.goal,center.ability.extra.goal - center.ability.extra.left,center.ability.extra.upg  } }
end,
calculate = function(self,card,context)
if context.joker_main then
return { xmult = card.ability.extra.xmult }
end
if context.end_of_round and context.cardarea == G.jokers and not context.blueprint and not context.retrigger_joker then
card.ability.extra.left = card.ability.extra.left + 1
if card.ability.extra.left >= card.ability.extra.goal then 
card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.upg
card.ability.extra.left = 0
return {message = "Upgrade!" }
end
return { message = "Driving" }
end
end,
in_pool = function(self, args) 
return true
end
}
SMODS.Joker{
key = "highlighted",
loc_txt = {
name = "Highlighted Message",
text = {
"{C:attention}Donation Cards{} instead give {X:mult,C:white}x#1#{} Mult."
}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
credits = {
suggested = {"pers"},
idea = {"1srscx4"},
art = {"None"},
code = {"1srscx4"}
},
cost = 7, 
unlocked = true, 
discovered = false, 
blueprint_compat = false, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 1, y = 0 },
in_pool = function(self, args) 
return true
end,
config = { extra = {xmult = 2} },
loc_vars = function(self,info_queue,center)
info_queue[#info_queue+1] = G.P_CENTERS.m_dono
return { vars = {center.ability.extra.xmult} }
end
}
--Ani

SMODS.Joker{
key = "ermermerm",
loc_txt = {
name = "Erm",
text = {
"If played hand is a {C:attention}High Card{},",
"{C:green}Randomize{} the rank, suit, and enhancement of all {C:attenion}scored cards{}."
}
},
credits = {
idea = {"Evil Sand"},
art = {"None"},
code = {"1srscx4"}
},
rarity = 2,
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true},
pos = { x = 1, y = 0 },
in_pool = function(self, args) 
return true
end,
calculate = function (self, card, context)
if context.before and context.scoring_name == "High Card" then
  for _,pcard in ipairs(context.scoring_hand) do
    local suit = pseudorandom_element({"Hearts","Diamonds","Spades","Clubs"},pseudoseed("Erm"))
    local rank = pseudorandom_element({"1","2","3","4","5","6","7","8","9","10","J","Q","K","A"},pseudoseed("Erm2"))
    pcard:set_ability(SMODS.poll_enhancement({guaranteed = true, type_key = "Erm3"}))
    SMODS.change_base(pcard,suit,rank)
  end
  return{message = "Erm", sound = "erm_sfx"}
end
end
}
SMODS.Joker{
  key = "michaeljacksonani",
  loc_txt = {
    name = "Ani r u ok",
    text = {
      "{C:attention}Kings{} of {C:diamonds}diamonds{} have priority",
      "to be drawn"
    }},
  credits = {
    idea = {"Evil Sand"},
    art = {"None"},
    code = {"1srscx4"}
  },
  rarity = 2,
  cost = 6, 
  unlocked = true, 
  discovered = false, 
  blueprint_compat = true, 
  eternal_compat = true, 
  perishable_compat = true,
  atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true},
  pos = { x = 1, y = 0 },
  in_pool = function(self, args) 
    return true
  end,
  calculate = function (self, card, context)
    if (context.setting_blind or context.pre_discard or context.after or context.open_booster) and not context.retrigger_joker then
      local cards_added = 0 + (context.pre_discard and (#G.hand.cards - #context.full_hand) or #G.hand.cards or 0)
      for _,pcard in ipairs(G.deck.cards) do
        if pcard:get_id() == 13 and pcard:is_suit("Diamonds") and cards_added < G.hand.config.card_limit then
          draw_card(G.deck, G.hand, 90, 'up', nil, pcard)
          cards_added  = cards_added + 1
        end
      end
    end
    -- Make it only work on packs that draw cards
  end
}
--Camel
SMODS.Joker{

key = "camila",
loc_txt = {
name = "Cumilq",
text = {"All played {C:attention}6s{} get retriggered",
"and give {X:mult,C:white}X#1#{} mult."}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 3,
credits = {
idea = {"Evil Sand"},
art = {"None"},
code = {"1srscx4"}
},
cost = 8, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true, 
pos = {x = 1, y = 0},
config = { extra = { xmult = 1.3 } },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.xmult}}
end,
calculate = function(self,card,context)
if context.repetition and context.cardarea == G.play and context.other_card:get_id() == 6 then
return {repetitions = 1 , card = card}
end
if context.individual and context.cardarea == G.play and context.other_card:get_id() == 6 then
return { xmult = card.ability.extra.xmult }
end
end,
in_pool = function(self,wawa,wawa2)
return true
end
}
SMODS.Joker{
key = "allin",
loc_txt = {
name = "I'm All In",
text = {"If you {C:red}discard{} four {C:attention}6s{},",
"gain a new one with",
"{E:1}random{} upgrades"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
credits = {
idea = {"Evil Sand"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = false, 
eternal_compat = true, 
perishable_compat = true, 
config = { extra = {}},
pos = {x = 8, y = 2},
soul_pos = { x = 9 , y = 2},
calculate = function(self,card,context)
if context.discard and not context.blueprint then
if #context.full_hand == 4 and context.full_hand[1]:get_id() == 6 and context.full_hand[2]:get_id() == 6 and                   context.full_hand[3]:get_id() == 6 and context.full_hand[4]:get_id() == 6 then
end
end
if context.pre_discard and #context.full_hand == 4 and context.full_hand[1]:get_id() == 6 and context.full_hand[2]:get_id() == 6 and                   context.full_hand[3]:get_id() == 6 and context.full_hand[4]:get_id() == 6 and not context.blueprint then
G.E_MANAGER:add_event(Event({
func = function() 
    local _suit = pseudorandom_element({'S','H','D','C'}, pseudoseed('seed'))
    local _card = create_playing_card({
        front = G.P_CARDS[_suit..'_'.."6"], 
        center = G.P_CENTERS.c_base}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
    local seal_type = pseudorandom('seed')
    local enh_type = pseudorandom("seed")
    local edit_type = pseudorandom("seed")
    
    if seal_type > 0.75 then _card:set_seal('Red', true)
    elseif seal_type > 0.5 then _card:set_seal('Blue', true)
    elseif seal_type > 0.25 then _card:set_seal('Gold', true)
    else _card:set_seal('Purple', true)
  end
    if enh_type > 0.889 then _card:set_ability(G.P_CENTERS["m_twin"], nil, true)
    elseif enh_type > 0.778 then _card:set_ability(G.P_CENTERS["m_glass"], nil, true)
    elseif enh_type > 0.667 then _card:set_ability(G.P_CENTERS["m_lucky"], nil, true)
    elseif enh_type > 0.556 then _card:set_ability(G.P_CENTERS["m_wild"], nil, true)
    elseif enh_type > 0.444 then _card:set_ability(G.P_CENTERS["m_bonus"], nil, true)
    elseif enh_type > 0.333 then _card:set_ability(G.P_CENTERS["m_mult"], nil, true)
    elseif enh_type > 0.222 then _card:set_ability(G.P_CENTERS["m_steel"], nil, true)
    elseif enh_type > 0.111 then _card:set_ability(G.P_CENTERS["m_dono"], nil, true)
    else _card:set_ability(G.P_CENTERS["m_gold"], nil, true)
    end
    if edit_type > 0.80 then _card:set_edition("e_filtered",true)
    elseif edit_type > 0.55 then _card:set_edition("e_foil",true)
    elseif edit_type > 0.3 then _card:set_edition("e_holo",true)
    elseif edit_type > 0.1 then _card:set_edition("e_polychrome",true)
    else _card:set_edition("e_negative",true)
    end
    
    G.GAME.blind:debuff_card(_card)
    G.hand:sort()
    G.E_MANAGER:add_event(Event({
    func = function()
      SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
      return true
    end
    }))
    return true
end}))


end
end,
in_pool = function(self,wawa,wawa2)
return true
end
}
--MinikoMew
SMODS.Joker{
key = "minikocute",
loc_txt = {
name = "Mini is cute mhm pass it on",
text = {
"If hand contains a {C:attention}3{}, turn",
"the card to the {C:attention}left{} to a {C:attention}3{}"}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
credits = {
sug = {"1srscx4"},
idea = {"1srscx4"},
art = {"SupDrazor"},
code = {"1srscx4"}
},
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = false,
pos = { x = 4, y = 4 },
calculate = function(self,card,context)
if context.individual and context.cardarea == G.play and context.other_card:get_id() == 3 then
for key,playing_card in pairs(context.full_hand) do
if playing_card == context.other_card then
if key-1 > 0 then
sea(
function ()
context.full_hand[key - 1]:flip()
context.full_hand[key - 1]:juice_up(0.3, 0.3)
return true
end,0.35,"before")
sea(
function ()
SMODS.change_base(context.full_hand[key - 1], nil , "3")
return true
end,0.55,"before"
)
sea(
function ()
context.full_hand[key - 1]:flip()
context.full_hand[key - 1]:juice_up(0.3, 0.3)
return true
end,0.35,"before")
end
end
end
end
end,
in_pool = function(self, args) 
return true
end
}
--Cerbr
SMODS.Joker{
key = "cerbr",
loc_txt = {
name = "Yippee!",
text = {
"Gains {C:mult}+#1#{} mult per {C:attention}retrigger",
"on a played card. {C:attention}Resets{} at",
"{C:attention}end of round{}. {C:inactive}(Currently: {C:mult}+#2#{C:inactive})"
}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 6, 
credits = {
idea = {"Bigbuckies"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 0, y = 2 },
soul_pos = { x = 3, y = 0},
in_pool = function(self, args) 
return true
end,
config = { extra = { upg = 5 , mult = 0, yippee = 0} },
loc_vars = function(self,info_queue,center)
return { vars = {center.ability.extra.upg, center.ability.extra.mult} }
end,
calculate = function(self,card,context)
if context.individual and context.cardarea == G.play and not context.blueprint and not context.retrigger_joker then
if context.other_card then   
card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.upg
G.E_MANAGER:add_event(Event({
func = function()
card.ability.extra.yippee = card.ability.extra.yippee + 5
if card.ability.extra.yippee > 0 and card.ability.extra.yippee <= 20 then
card.children.floating_sprite:set_sprite_pos({x = 1, y = 2})
end
if card.ability.extra.yippee > 20 and card.ability.extra.yippee <= 40 then
card.children.floating_sprite:set_sprite_pos({x = 2, y = 2})
end
if card.ability.extra.yippee > 40 and card.ability.extra.yippee <= 60 then
card.children.floating_sprite:set_sprite_pos({x = 3, y = 2})
end
if card.ability.extra.yippee > 60 and card.ability.extra.yippee <= 80 then
card.children.floating_sprite:set_sprite_pos({x = 4, y = 2})
end
if card.ability.extra.yippee > 80 then
card.children.floating_sprite:set_sprite_pos({x = 5, y = 2})
end
return true
end
})) 
return {message = "Yippee!", sound = "Yippee"}
end
end
if context.joker_main then
local debuffs = 0
for _,playing_card in ipairs(context.scoring_hand) do
if playing_card.debuff then
debuffs = debuffs + 1
end
end
card.ability.extra.mult = card.ability.extra.mult - (#context.scoring_hand * card.ability.extra.upg - debuffs * card.ability.extra.upg)
return {mult = card.ability.extra.mult}
end
if context.end_of_round and context.cardarea == G.jokers then
card.ability.extra.mult = 0 
card.ability.extra.yippee = 0
card.children.floating_sprite:set_sprite_pos({x = 3, y = 0})
end
end
}
SMODS.Joker{
key = "milc",
loc_txt = {
name = "Milc",
text = {
"If played hand contains",
"less {C:attention}Jacks{} of {C:diamonds}diamonds",
"than {C:attention}2s{} held in hand,",
"retrigger {C:attention}Jacks{} of {C:diamonds}diamonds {C:attention}#1#{}-{C:attention}#2#{} times"
}
},
credits = {
idea = {"Evil Sand"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 5, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 4, y = 1 },
in_pool = function(self, args) 
return true
end,
config = { extra = {rt_min = 1, rt_max = 2} },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.rt_min,center.ability.extra.rt_max} }
end,
calculate = function (self, card, context)
if context.repetition and context.cardarea == G.play then
local cerbr = 0
local wans = 0
for _,cards in ipairs(context.full_hand) do
if cards:get_id() == 11 and cards:is_suit("Diamonds",true) then
cerbr = cerbr + 1
end
end
for _,cards in ipairs(G.hand.cards) do
if cards:get_id() == 2 then
wans = wans + 1
end
end
if context.other_card:get_id() == 11 and context.other_card:is_suit("Diamonds") and cerbr < wans then
return{repetitions = pseudorandom("Milc",math.floor(card.ability.extra.rt_min+0.5),math.floor(card.ability.extra.rt_max+0.5))}
end
end
end
}
--Filipino Boy
SMODS.Joker{
key = "filipino_boy",
loc_txt = {
name = "Filian",
text = {
"Reduce {C:attention}blind{} requirement by {C:green}#1#%{}",
"when hand is {C:attention}played{}."
}
},
credits = {
idea = {"Evil Sand"},
art = {"None"},
code = {"1srscx4"}
},
rarity = 2,
cost = 8, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true},
pos = { x = 1, y = 0 },
in_pool = function(self, args) 
return true
end,
loc_vars = function (self, info_queue, card)
return { vars = {card.ability.extra.reduce * 100}}
end,
config = { extra = {reduce = 5/100}},
calculate  = function (self, card, context)
if context.before then
G.GAME.blind.chips = math.floor((G.GAME.blind.chips * (1 - card.ability.extra.reduce)) + 0.5)
G.GAME.blind.chip_text = tostring(G.GAME.blind.chips)
return{message = "Backflip!"}
end
end
}
SMODS.Joker{
key = "frut",
loc_txt = {
name = "Fruit Snacks Bag",
text = {
"When {C:attention}blind{} is selected,",
"lower the {C:attention}score requirement{}",
"by {C:green}#1#%{} per {C:attention}8{} in deck.",
"{C:inactive}(Currently {C:green}#2#%{C:inactive})"
}
},
credits = {
idea = {"Evil Sand"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
rarity = 2,
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
atlas = "neuroCustomJokers",
pos = { x = 5, y = 6 },
in_pool = function(self, args) 
return true
end,
config = {extra = {decrease = 0.4/100}},
loc_vars = function (self, info_queue, card)
local percent = 0
if G and G.GAME and G.playing_cards then
for _,pcard in ipairs(G.playing_cards) do
if pcard:get_id() == 8 then
percent = percent + card.ability.extra.decrease
end
end
end
return{vars = {card.ability.extra.decrease * 100 ,percent * 100}}
end,
calculate = function (self, card, context)
if context.setting_blind then
local percent = 0
for _,pcard in ipairs(G.playing_cards) do
if pcard:get_id() == 8 then
percent = percent + card.ability.extra.decrease
end
end
G.GAME.blind.chips = math.floor((G.GAME.blind.chips * (1 - percent)) + 0.5)
G.GAME.blind.chip_text = tostring(G.GAME.blind.chips)
end
end
}
SMODS.Joker{
key = "moooooooooods",
loc_txt = {
name = "MOOODS!",
text = {
"If on {C:attention}last hand{} your {C:attention}current score{} is",
"less than half of the {C:attention}required score{},",
"{C:green}halve{} the {C:attention}required score{}."
}
},
credits = {
idea = {"Evil Sand"},
art = {"Kloovree"},
code = {"1srscx4"}
},
rarity = 2,
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true},
pos = { x = 3, y = 4 },
in_pool = function(self, args) 
return true
end,
calculate = function (self, card, context)
if context.after and G.GAME.current_round.hands_left == 1 and G.GAME.chips < G.GAME.blind.chips/2 then
  sea( function ()
    if G.GAME.chips < G.GAME.blind.chips/2 then
    G.GAME.blind.chips = G.GAME.blind.chips/2
  G.GAME.blind.chip_text = tostring(G.GAME.blind.chips)
    end
  return true
  end)
end
end
}
--Ellie
SMODS.Joker{
key = "ely",
loc_txt = {
name = "Ellie",
text = {
"{C:green,E:1}#1# in #2#{} chance to create",
"a {C:attention}neurodog{} when {C:attention}blind",
"is selected. Gains {X:mult,C:white}x#3#{} mult",
"per {C:attention}neurodog{} owned.",
"{C:inactive}(Currently: {X:mult,C:white}x#4#{C:inactive})"}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
credits = {
idea = {"Bigbuckies"},
art = {"Etzyio+"},
code = {"1srscx4"}
},
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = false,
pos = { x = 4, y = 3 },
in_pool = function(self, args) 
return true
end,
config = { extra = { base = 1 , odds = 2 , upg = 1 , xmult = 1} },
loc_vars = function(self,info_queue,center)
info_queue[#info_queue+1] = G.P_CENTERS.j_neurodog
local result = 1
if (G.jokers or false) then 
for _,joker in ipairs(G.jokers.cards) do
if joker.config.center.key == "j_neurodog" then
result = result + center.ability.extra.upg
end
end
for _,joker in ipairs(G.playbook_extra.cards) do
if joker.config.center.key == "j_neurodog" then
result = result + center.ability.extra.upg
end
end
end
return { vars = {center.ability.extra.base * (G.GAME and G.GAME.probabilities.normal or 1),center.ability.extra.odds,center.ability.extra.upg,result } }
end,
calculate = function(self,card,context)
if context.joker_main then
local result = 1
for _,joker in ipairs(G.jokers.cards) do
if joker.config.center.key == "j_neurodog" then
result = result + card.ability.extra.upg
end
end
for _,joker in ipairs(G.playbook_extra.cards) do
if joker.config.center.key == "j_neurodog" then
result = result + card.ability.extra.upg
end
end
return {xmult = result}
end
if context.setting_blind and pseudorandom("seed") <= (G.GAME.probabilities.normal * card.ability.extra.base)/card.ability.extra.odds and #G.jokers.cards < G.jokers.config.card_limit then
SMODS.add_card({set = "Joker",area = G.jokers,  key = "j_neurodog"})
return {message = "Ely!"}
end
end
}
SMODS.Joker{
key = "neurodog",
loc_txt = {
name = "Neurodog",
text = {
"Gives {C:mult}+#1#{} mult and {C:chips}+#2#{} chips"}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 1, 
credits = {
sug = {"Evil Sand"},
idea = {"Evil Sand","1srscx4"},
art = {"Oli7"},
code = {"1srscx4"}
},
cost = 4, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 3, y = 7 },
in_pool = function(self, args) 
return false
end,
config = { extra = { mult = 10, chips = 9} },
loc_vars = function(self,info_queue,center)
return { vars = {center.ability.extra.mult , center.ability.extra.chips } }
end,
calculate = function(self,card,context)
if context.joker_main then
return { mult = card.ability.extra.mult , chips = card.ability.extra.chips }
end
end
}
--Layna

SMODS.Joker{
key = "layna",
loc_txt = {
name = "Layna",
text = {
"If scored hand has a {C:attention}9{},",
"all scored cards give {X:mult,C:white}x#1#{} mult",
"and {C:red,E:1}destroy{} themselves."
}
},
credits = {
idea = {"1srscx4"},
art = {"Etzyio+"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 3, 
cost = 9, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 9, y = 3 },
in_pool = function(self, args) 
return true
end,
config = { extra = {xmult = 3, works = false} },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.xmult} }
end,
calculate = function (self, card, context)
if context.before then
for _,play_card in ipairs(context.scoring_hand) do 
if play_card:get_id() == 9 then
card.ability.extra.works = true
return {message = "Active"}
else 
card.ability.extra.works = false
end
end
end
if context.individual and context.cardarea == G.play and context.other_card and card.ability.extra.works then
return {xmult = card.ability.extra.xmult, func = function() SMODS.destroy_cards(context.other_card)
end}
end
end
}
SMODS.Joker{
  key = "cakelayna",
  loc_txt = {
    name = "Abomnination Cake",
    text = {
      "Gives {C:mult}+#1#{} Mult for each",
      "{C:attention}Bloody card{} in {C:attention}full deck{}.",
      "{C:inactive}(Currently: {C:mult}+#2#{C:inactive} Mult)"
    }
  },
credits = {
idea = {"1srscx4"},
art = {"None"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 1, 
cost = 5, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 1, y = 0 },
in_pool = function(self, args) 
for _,pcard in ipairs(G.playing_cards) do
  if SMODS.has_enhancement(pcard,"m_blood") then
    return true
  end
end
return false
end,
config = { extra = {mult = 3} },
loc_vars = function(self,info_queue,center)
  info_queue[#info_queue+1] = G.P_CENTERS.m_blood
  local blood = 0
  if G.playing_cards then
    for _,pcard in ipairs(G.playing_cards) do
      if SMODS.has_enhancement(pcard,"m_blood") then
        blood = blood + 1
      end
    end
  end
return {vars = {center.ability.extra.mult, center.ability.extra.mult * blood} }
end,
calculate = function (self, card, context)
  if context.joker_main then
    local blood = 0
    for _,pcard in ipairs(G.playing_cards) do
      if SMODS.has_enhancement(pcard,"m_blood") then
        blood = blood + 1
      end
    end
    return {mult = card.ability.extra.mult * blood}
  end
end
}
--Other peopled
SMODS.Joker{
key = "void",
loc_txt = {
name = "Alex Void",
text = {
"{C:dark_edition}Negative{} jokers give {X:mult,C:white}x#1#{} Mult"}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 3, 
cost = 8,
credits = {
idea = {"1srscx4"},
art = {"Etzyio+"},
code = {"1srscx4"}
},
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 7, y = 5},
config = { extra = { xmult = 2 }},
loc_vars = function(self,info_queue,card)
if (not card.edition) or (card.edition and card.edition.key ~= "e_negative") then
info_queue[#info_queue+1] = G.P_CENTERS.e_negative
end
return {vars = {card.ability.extra.xmult}}
end,
calculate = function(self,card,context)
if context.other_joker and context.other_joker.edition and context.other_joker.edition.key == "e_negative"then
return { xmult = card.ability.extra.xmult }
end
end,
in_pool = function(self, args) 
local inpool = false
for _,joker in ipairs(G.jokers.cards) do
if joker.edition and joker.edition.key == "e_negative" then
inpool = true
break
end
end
for _,joker in ipairs(G.playbook_extra.cards) do
if joker.edition and joker.edition.key == "e_negative" then
inpool = true
break
end
end
return inpool
end
} 
SMODS.Joker{
key = "jorker",
loc_txt = {
name = "J0ker",
text = {
"Gives {C:chips}+#1#{} chips",
"per joker owned.",
"{C:inactive}(Currently {}{C:chips}+#2#{}{C:inactive})"}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 1, 
cost = 4,
credits = {
sug = {"Pers"},
idea = {"1srscx4"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 4, y = 0},
config = { extra = { chips_bonus = 15 }},
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.chips_bonus,center.ability.extra.chips_bonus * ((G.jokers and #G.jokers.cards or 0)+(G.playbook_extra and #G.playbook_extra.cards or 0))}}
end,
calculate = function(self,card,context)
if context.joker_main then
return { chips = card.ability.extra.chips_bonus * ((G.jokers and #G.jokers.cards or 0)+(G.playbook_extra and #G.playbook_extra.cards or 0))}
end
end,
in_pool = function(self, args) 
return true
end
}
SMODS.Joker{
key = "shoomimi",
loc_txt = {
name = "Shoomimi",
text = {
"Cards with {C:attention}shoomimi seal{} give {C:money}$#1#"}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 8, 
credits = {
idea = {"Evil Sand"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 2, y = 1 },
add_to_deck = function (self, card, from_debuff)
G.shared_seals["shoomiminion_seal"] = Sprite(0, 0, 71, 95, G.ASSET_ATLAS["neuroEnh"], {x = 8, y = 0})
end,
remove_from_deck = function (self, card, from_debuff)
for _,joker in ipairs(G.jokers.cards) do
if joker.config.center.key == "j_shoomimi" or (joker.config.center.key == "j_evilsand" and card.area ~= G.playbook_extra) then
return
end
end
for _,joker in ipairs(G.playbook_extra.cards) do
if joker.config.center.key == "j_shoomimi" then
return
end
end
G.shared_seals["shoomiminion_seal"] = Sprite(0, 0, 71, 95, G.ASSET_ATLAS["neuroEnh"], {x = 9, y = 0})
end,
in_pool = function(self, args) 
local is_in_pool = false
for _, playing_card in ipairs(G.playing_cards) do
if playing_card.seal == "shoomiminion_seal" then
is_in_pool = true
break
end
end
return is_in_pool
end,
config = { extra = {money = 5} },
loc_vars = function(self,info_queue,center)
info_queue[#info_queue + 1] = G.P_SEALS["shoomiminion_seal"]
return { vars = {center.ability.extra.money} }
end,
calculate = function(self,card,context)
if context.individual and context.cardarea == G.play then
if context.other_card.seal == "shoomiminion_seal" then
return { dollars = card.ability.extra.money }
end
end

end
}
SMODS.Joker{
key = "queenpb",
loc_txt = {
name = "Queenpb",
text = {
"Gives {X:mult,C:white}x#1#{} mult. Increase this by {X:mult,C:white}x#2#{} at {C:attention}end of round{}.",
"Changes music to {C:attention}LIFE{} or {C:attention}BOOM{}."
}
},
credits = {
sug = {"Emuz"},
idea = {"1srscx4"},
art = {"Etzyio+"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 3, 
cost = 8, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = false,
pos = { x = 4, y = 5 },
in_pool = function(self, args) 
return true
end,
config = { extra = {xmult = 1, upg = 0.25, song = ""} },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.xmult,center.ability.extra.upg} }
end,
add_to_deck = function (self, card, from_debuff)
card.ability.extra.song = pseudorandom_element({"LIFE","BOOM"},pseudoseed("pb"))
for pos,joker in ipairs(G.jokers.cards) do
if joker.config.center.key == "j_queenpb" and joker ~= card then
card.ability.extra.song = G.jokers.cards[pos].ability.extra.song
end
end
for pos,joker in ipairs(G.playbook_extra.cards) do
if joker.config.center.key == "j_queenpb" and joker ~= card then
card.ability.extra.song = G.playbook_extra.cards[pos].ability.extra.song
end
end
if card.ability.extra.song == "BOOM" then
G.GAME.pool_flags.BOOM = true
G.GAME.pool_flags.LIFE = false
end
if card.ability.extra.song == "LIFE" then
G.GAME.pool_flags.LIFE = true
G.GAME.pool_flags.BOOM = false
end
end,
remove_from_deck = function (self, card, from_debuff)
for pos,joker in ipairs(G.playbook_extra.cards) do
if joker.config.center.key == "j_queenpb" and joker ~= card then
return 
end
end
if card.ability.extra.song == "BOOM" then
G.GAME.pool_flags.BOOM = false
G.GAME.pool_flags.LIFE = false
end
if card.ability.extra.song == "LIFE" then
G.GAME.pool_flags.LIFE = false
G.GAME.pool_flags.BOOM = false
end
end,
calculate = function (self, card, context)
if context.end_of_round and context.cardarea == G.jokers and not context.blueprint and not context.retrigger_joker then 
card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.upg
return {message = "Upgrade!"}
end
if context.joker_main then
return {xmult = card.ability.extra.xmult}
end
end
}
SMODS.Joker{
key = "lucy",
loc_txt = {
name = "Lucy",
text = {
"Gains {C:mult}+#1#{} mult if played",
"hand contains a {C:attention}flush{}.",
"{C:inactive}(Currently: {C:mult}+#2#{C:inactive})"
}
},
credits = {
idea = {"Evil Sand"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 5, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = false,
pos = { x = 2, y = 4 },
in_pool = function(self, args) 
return true
end,
config = { extra = {upg = 4, mult = 0} },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.upg,center.ability.extra.mult} }
end,
calculate = function (self, card, context)
if context.before and next(context.poker_hands["Flush"]) and not context.blueprint and not context.retrigger_joker then
card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.upg
return {message = "Upgrade!"}
end
if context.joker_main then
return {mult = card.ability.extra.mult}
end
end
}
SMODS.Joker{
key = "teru",
loc_txt = {
name = "Teru",
text = {
"Gains {X:mult,C:white}x#1#{} mult when a",
"{C:attention}face card{} is scored.",
"{C:inactive}(Currently: {X:mult,C:white}x#2#{C:inactive})"
}
},
credits = {
sug = {"Evil Sand"},
idea = {"1srscx4"},
art = {"None"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 5, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = false,
pos = { x = 1, y = 0 },
in_pool = function(self, args) 
return true
end,
config = { extra = {upg = 0.03, xmult = 1} },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.upg,center.ability.extra.xmult} }
end,
calculate = function (self, card, context)
if context.individual and context.cardarea == G.play and context.other_card:is_face() and not context.blueprint and not context.retrigger_joker then
card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.upg
end
if context.joker_main then
return {xmult = card.ability.extra.xmult}
end
end
}
SMODS.Joker {
key = "kyoto",
loc_txt = {
name = "KYOTO AT ALL COSTS",
text = {
"{C:green}#2# in #3#{} chance of",
"giving {X:mult,C:white}X#1#{} Mult."
}
},
credits = {
idea = {"PaulaMarina"},
art = {"Evil Sand"},
code = {"PaulaMarina"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 3, y = 6},
soul_pos = {x = 4, y = 6},
config = { extra = { odds = 20, Xmult = 100, base = 1 }},
loc_vars = function(self,info_queue,center)
return { vars = { center.ability.extra.Xmult, (G.GAME.probabilities.normal or 1) * center.ability.extra.base, center.ability.extra.odds } }
end,
calculate = function(self, card, context)
if context.joker_main then
if pseudorandom('kyoto') < (G.GAME.probabilities.normal*card.ability.extra.base) / card.ability.extra.odds then
return {
message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
Xmult_mod = card.ability.extra.Xmult
}
else
local miss_messages = { 'Nope!', 'Lmao!', 'Not Kyoto!', 'So Close!', 
          'Too Many PHDs!', 'Not Enough PHDs!', 
          'Neuro Is Better!', 'Doug Is Bald!'}
return { message = pseudorandom_element(miss_messages, pseudoseed('kyoto')) }
end
end
end
}
SMODS.Joker{
key = "btmc",
loc_txt = {
name = "BTMC",
text = {
"Cards with {C:attention}Osu! seal{} give {X:mult,C:white}x#1#{} Mult",
"per {C:attention}consecutive{} hand that contains",
"a scoring card with {C:attention}Osu! seal{}.",
"{C:inactive}(Currently: {X:mult,C:white}x#2#{C:inactive})"
}
},
credits = {
idea = {"1srscx4"},
art = {"None"},
code = {"1srscx4"}
},
cost = 8, 
rarity = 3,
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = false,
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true},
pos = { x = 1, y = 0 },
in_pool = function(self, args) 
for _,pcard in ipairs(G.playing_cards) do
if pcard.seal == "osu_seal" then
return true
end
end
return false
end,
loc_vars = function (self, info_queue, card)
info_queue[#info_queue+1] = G.P_SEALS["osu_seal"]
return{ vars = {card.ability.extra.upg,card.ability.extra.xmult}}
end,
config = { extra = {xmult = 1, upg = 0.5}},
calculate = function (self, card, context)
if context.before and not context.blueprint and not context.retrigger_joker then
local upgrade = false
for _,pcard in ipairs(context.scoring_hand) do
if pcard.seal == "osu_seal" then
upgrade = true
break
end
end
if upgrade then
card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.upg
return{message = "x"..tostring(card.ability.extra.xmult),colour = G.C.CHIPS}
else
card.ability.extra.xmult = 1
return{message = "X",colour = G.C.RED}
end
end
if context.individual and context.cardarea == G.play and context.other_card.seal == "osu_seal" then
return{xmult = card.ability.extra.xmult}
end
end
}
--Glorp
SMODS.Joker{
key = "Glorp",
loc_txt = {
name = "Glorp",
text = {
"At start of blind, add",
"{C:attention}#1# glorpy{} {C:green}gleeb{} cards to deck",
}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2 , 
cost = 8, 
credits = {
idea = {"Evil Sand"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 9, y = 0},
config = { extra = { amount = 20}},
loc_vars = function(self,info_queue,center)
info_queue[#info_queue+1] = G.P_CENTERS.m_glorp
info_queue[#info_queue+1] = { set = "Other", key = "Gleeb_desc"}
return {vars = {center.ability.extra.amount }}
end,
calculate = function(self,card,context)
if context.setting_blind then
for i = 1,card.ability.extra.amount do 
G.E_MANAGER:add_event(Event({
func = function() 
local _rank = pseudorandom_element({"2","3","4","5","6","7","8","9","10","11","12","13","14"},pseudoseed("seed"))
local _card = create_playing_card({
front = G.P_CARDS["G"..'_'.._rank], 
center = G.P_CENTERS.c_base}, G.deck, nil, nil, {G.C.SECONDARY_SET.Enhanced})
_card:set_ability(G.P_CENTERS["m_glorp"], nil, true)
SMODS.change_base(_card, "Glorpsuit")
return true
end}))
end
end
end,
in_pool = function(self,args)
return true
end
}
SMODS.Joker{
key = "envy",
loc_txt = {
name = "Envious Joker",
text = {
"Played cards with the",
"{C:green}gleeb{} suit give",
"{C:mult}+#1#{} mult when scored."
}
},
credits = {
idea = {"Evil Sand"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 1, 
cost = 5, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 0, y = 4 },
in_pool = function(self, args) 
local is_in_pool = false
for _,joker in ipairs(G.jokers.cards) do
if joker.config.center.key == "j_Glorp" then
is_in_pool = true
break
end
end
for _,joker in ipairs(G.playbook_extra.cards) do
if joker.config.center.key == "j_Glorp" then
is_in_pool = true
break
end
end
if G.GAME.selected_back.effect.center.key == "b_glorpdeck" then
is_in_pool = true
end
if not is_in_pool then
for _,playing_card in ipairs(G.playing_cards) do
if playing_card:is_suit("Glorpsuit") then
is_in_pool = true
break
end
end
end
return is_in_pool
end,
config = { extra = {mult = 6} },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.mult } }
end,
calculate = function (self, card, context)
if context.individual and context.cardarea == G.play then
if context.other_card:is_suit("Glorpsuit") then
return {mult = card.ability.extra.mult}
end
end
end
}
--Emotes/Neurocord
SMODS.Joker{
key = "jokr",
loc_txt = {
name = "joukr",
text = {
"When opening a {C:attention}standard pack{},",
"{C:green,E:1}#1# in #2#{} chance to obtain a",
"random playing card"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 1, 
credits = {
idea = {"2nd Umbrella"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
cost = 4, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true, 
pos = {x = 6, y = 1},
config = { extra = { odds = 3 , base = 1} },
loc_vars = function(self,info_queue,center)
return {vars = {G.GAME.probabilities.normal * center.ability.extra.base,center.ability.extra.odds}}
end,
calculate = function(self,card,context)
if context.open_booster and context.card.ability.set == "Booster" and context.card.ability.name:find('Standard') then
if pseudorandom("seed") <= (G.GAME.probabilities.normal * card.ability.extra.base)/card.ability.extra.odds then
G.E_MANAGER:add_event(Event({
func = function() 
local _rank = pseudorandom_element({"2","3","4","5","6","7","8","9","10","11","12","13","14"},pseudoseed("seed"))
local _suit = pseudorandom_element({'S','H','D','C'}, pseudoseed('seed'))
local _card = create_playing_card({
front = G.P_CARDS[_suit..'_'.._rank], 
center = G.P_CENTERS.c_base}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
local seal_type = pseudorandom('seed')
local enh_type = pseudorandom("seed")
local edit_type = pseudorandom("seed")

if seal_type > 0.4 and seal_type <= 0.5 then _card:set_seal('Red', true)
elseif seal_type > 0.3 and seal_type <= 0.5 then _card:set_seal('Blue', true)
elseif seal_type > 0.2 and seal_type <= 0.5 then _card:set_seal('Gold', true)
elseif seal_type > 0.1 and seal_type <= 0.5 then _card:set_seal('Purple', true)
end
if enh_type > 0.8 and enh_type <= 0.9 then _card:set_ability(G.P_CENTERS["m_twin"], nil, true)
elseif enh_type > 0.7 and enh_type <= 0.9 then _card:set_ability(G.P_CENTERS["m_glass"], nil, true)
elseif enh_type > 0.6 and enh_type <= 0.9 then _card:set_ability(G.P_CENTERS["m_lucky"], nil, true)
elseif enh_type > 0.5 and enh_type <= 0.9 then _card:set_ability(G.P_CENTERS["m_wild"], nil, true)
elseif enh_type > 0.4 and enh_type <= 0.9 then _card:set_ability(G.P_CENTERS["m_bonus"], nil, true)
elseif enh_type > 0.3 and enh_type <= 0.9 then _card:set_ability(G.P_CENTERS["m_mult"], nil, true)
elseif enh_type > 0.2 and enh_type <= 0.9 then _card:set_ability(G.P_CENTERS["m_steel"], nil, true)
elseif enh_type > 0.1 and enh_type <= 0.9 then _card:set_ability(G.P_CENTERS["m_stone"], nil, true)
elseif enh_type > 0 and enh_type <= 0.9 then _card:set_ability(G.P_CENTERS["m_gold"], nil, true)
end
if edit_type > 0.2 and edit_type <= 0.3 then _card:set_edition("e_foil",true)
elseif edit_type > 0.10 and edit_type <= 0.3 then _card:set_edition("e_holo",true)
elseif edit_type > 0.02 and edit_type <= 0.3 then _card:set_edition("e_polychrome",true)
elseif edit_type > 0 and edit_type <= 0.3 then _card:set_edition("e_negative",true)
end
G.E_MANAGER:add_event(Event({
func = function()
SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
return true
end
}))
return true
end}))
end
end
end,
in_pool = function(self,wawa,wawa2)
return true
end
}
SMODS.Joker{
key = "xdx|",
loc_txt = {
name = "xdx",
text = {
"Gives a random amount of",
"{X:mult,C:white}Xmult{} between {X:mult,C:white}X#1#{} and {X:mult,C:white}X#2#{}",
}
},
credits = {
sug = {"Evil Sand"},
idea = {"Emuz"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 3, 
cost = 8, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true, 
pos = {x = 7, y = 2},
config = { extra = { min = 1 , max = 40} },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.min/10,center.ability.extra.max/10}}
end,
calculate = function(self,card,context)
if context.joker_main then
return {xmult = pseudorandom("seed",card.ability.extra.min,card.ability.extra.max) / 10 }
end
end,
in_pool = function(self,wawa,wawa2)
return true
end
}
SMODS.Joker{
key = "corpa",
loc_txt = {
name = "Corpa",
text = {
"When {C:attention}leaving the shop{},",
"gain {C:money}$#1#{} for every {C:money}$#2#{} {C:attention}spent{} in that shop.",
"{C:inactive}(You have spent: {C:money}$#3#{C:inactive})"
}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 9, 
credits = {
idea = {"1srscx4"},
art = {"Etzyio+"},
code = {"1srscx4"}
},
unlocked = true, 
discovered = false, 
blueprint_compat = false, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 7, y = 3 },
in_pool = function(self, args) 
return true
end,
config = { extra = { goal = 5, gain = 2, current = 0, triggers = false} },
loc_vars = function(self,info_queue,center)
return { vars = {center.ability.extra.gain, center.ability.extra.goal,center.ability.extra.current} }
end,
calculate = function(self,card,context)
if context.buying_card or context.open_booster and not context.retrigger_joker then
card.ability.extra.current = card.ability.extra.current + context.card.cost
end
if context.end_of_round and G.GAME.current_round.free_rerolls == 0 and not context.retrigger_joker then
card.ability.extra.triggers = true
end
if context.reroll_shop and G.GAME.current_round.free_rerolls == 0 and not context.retrigger_joker then
if card.ability.extra.triggers then
card.ability.extra.current = card.ability.extra.current + G.GAME.current_round.reroll_cost - 1
end 
card.ability.extra.triggers = true
end
if context.ending_shop and not context.retrigger_joker then
card.ability.extra.triggers = false
end
if context.ending_shop then
local money = 0
while card.ability.extra.current >= card.ability.extra.goal do
card.ability.extra.current = card.ability.extra.current - card.ability.extra.goal
money = money + card.ability.extra.gain
end
card.ability.extra.current = 0
return{dollars = money}
end
end
}
SMODS.Joker{
key = "schedule",
loc_txt = {
name = "Schedule",
text = {
"When {C:attention}blind is selected,",
"{C:green,E:1}#1# in #2#{} chance to create",
"a {C:attention}wheel of fortune {C:tarot}tarot.",
"All probabilities are added {C:green}1",
"{C:inactive}(Ex: {C:green}2 in 7 {C:inactive}-> {C:green}3 in 7{C:inactive})"
}
},
credits = {
sug = {"Mr. Jdk"},
idea = {"Evil Sand"},
art = {"None"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = false, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 9, y = 7 },
config = { extra = { odds = 3 , base = 1, oa6added = "0" } },
add_to_deck = function (self, card, from_debuff)
G.GAME.probabilities.normal = G.GAME.probabilities.normal + 1
end,
remove_from_deck = function (self, card, from_debuff)
local multiplier = 1
local to_do = tonumber(card.ability.extra.oa6added)
local done = 0
for pos,joker in ipairs(G.jokers.cards) do
if done < to_do then
if joker.config.center.key == "j_oops" then
multiplier = multiplier * 2
done = done + 1
end
end
end
if done < to_do then
for pos,joker in ipairs(G.playbook_extra.cards) do
if joker.config.center.key == "j_oops" then
if done < to_do then
multiplier = multiplier * 2
done = done + 1
end
end
end
end
G.GAME.probabilities.normal = G.GAME.probabilities.normal - (1 * multiplier)
end,
loc_vars = function(self,info_queue,card)
info_queue[#info_queue+1] = G.P_CENTERS.c_wheel_of_fortune
return { vars = { (G.GAME and G.GAME.probabilities.normal or 1) * card.ability.extra.base, card.ability.extra.odds} }
end,
calculate = function (self, card, context)
if context.setting_blind and  pseudorandom("schedule") <= ((G.GAME and G.GAME.probabilities.normal or 1) * card.ability.extra.base)/card.ability.extra.odds and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
G.E_MANAGER:add_event(Event({
func = (function()
G.E_MANAGER:add_event(Event({
  func = function()
      SMODS.add_card {
          set = "Tarot",
          key = "c_wheel_of_fortune"
      }
      G.GAME.consumeable_buffer = 0
      return true
  end
}))
return true
end)
}))
end
if context.card_added and context.card.config.center.key == "j_oops" then
card.ability.extra.oa6added = tostring(tonumber(card.ability.extra.oa6added) + 1)
end
end
}
SMODS.Joker{
key = "mod_purge",
loc_txt = {
name = "Mod Purge",
text = {
"Prevent death and",
"{C:red,E:1}destroy self and another random joker."
}
},
credits = {
sug = {"Emuz"},
idea = {"1srscx4"},
art = {"None"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = false, 
eternal_compat = false, 
perishable_compat = true,
pos = { x = 1, y = 0 },
calculate = function(self, card, context)
if context.end_of_round and context.game_over and context.main_eval and not context.blueprint then
local valid_index = {}
for pos,joker in ipairs(G.jokers.cards) do
if not joker.ability.eternal and joker ~= card then
valid_index[#valid_index+1] = pos
end
end
print(valid_index)
G.E_MANAGER:add_event(Event({
func = function()
G.hand_text_area.blind_chips:juice_up()
G.hand_text_area.game_chips:juice_up()
play_sound('tarot1')
card:start_dissolve()
local victim = nil
if #valid_index > 0 then 
victim = G.jokers.cards[pseudorandom_element(valid_index,pseudoseed("purge"))]
victim:start_dissolve()
end
return true
end
}))
return {
message = "'Saved'",
saved = "modpurgesave",
colour = G.C.RED
}
end
end,
}
SMODS.Joker{
key = "nwooper",
loc_txt = {
name = "Neurooper",
text = {
"She's just a silly lil fella",
"{C:inactive,s:0.8}(Does nothing?)"
}
},
credits = {
idea = {"Evil Sand"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 1, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 8, y = 4 },
add_to_deck = function (self, card, from_debuff)
  for _,joker in ipairs(G.jokers.cards) do
    if joker.config.center.key == "j_Ermfish" then
      joker.children.center:set_sprite_pos({x = 1, y = 7})
    end
  end
  for _,joker in ipairs(G.playbook_extra.cards) do
    if joker.config.center.key == "j_Ermfish" then
      joker.children.center:set_sprite_pos({x = 1, y = 7})
    end
  end
end,
remove_from_deck = function (self, card, from_debuff)
  for _,joker in ipairs(G.jokers.cards) do
    if joker.config.center.key == "j_nwooper" then
      return
    end
  end
  for _,joker in ipairs(G.playbook_extra.cards) do
    if joker.config.center.key == "j_nwooper" then
      return
    end
  end
  for _,joker in ipairs(G.jokers.cards) do
    if joker.config.center.key == "j_Ermfish" then
      joker.children.center:set_sprite_pos({x = 0, y = 7})
    end
  end
  for _,joker in ipairs(G.playbook_extra.cards) do
    if joker.config.center.key == "j_Ermfish" then
      joker.children.center:set_sprite_pos({x = 0, y = 7})
    end
  end
end,
in_pool = function(self, args) 
return true
end,
}
SMODS.Joker{
key = "Ermfish",
loc_txt = {
name = "Erm Fish",
text = {
"Gives {X:dark_edition,C:white}^#1#{} mult if",
"you have {C:attention}neurooper{}"
}
},
credits = {
idea = {"Evil Sand"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 10, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 0, y = 7 },
in_pool = function(self, args) 
return true
end,
add_to_deck = function (self, card, from_debuff)
  for _,joker in ipairs(G.jokers.cards) do
    if joker.config.center.key == "j_nwooper" then
      card.children.center:set_sprite_pos({x = 1, y = 7})
    end
  end
  for _,joker in ipairs(G.playbook_extra.cards) do
    if joker.config.center.key == "j_nwooper" then
      card.children.center:set_sprite_pos({x = 1, y = 7})
    end
  end
end,
config = { extra = {power = 2}},
loc_vars = function (self, info_queue, card)
info_queue[#info_queue+1] = G.P_CENTERS.j_nwooper
return {vars = {card.ability.extra.power}}
end,
calculate = function (self, card, context)
if context.joker_main then
for _,pcard in ipairs(G.jokers.cards) do 
if pcard.config.center.key == "j_nwooper" then
return {remove_default_message = true, mult = (mult ^ card.ability.extra.power) - mult, message = {"^"..tostring(card.ability.extra.power)},colour = G.C.DARK_EDITION, sound = "emultsfx"}
end
end
for _,pcard in ipairs(G.playbook_extra.cards) do 
if pcard.config.center.key == "j_nwooper" then
return {remove_default_message = true, mult = (mult ^ card.ability.extra.power) - mult, message = {"^"..tostring(card.ability.extra.power)},colour = G.C.DARK_EDITION, sound = "emultsfx"}
end
end
end
end
}
SMODS.Joker{
  key = "schizoedm",
  loc_txt = {
    name = "SCHIZO",
    text = {
      "At {C:attention}start{} of round create ", "a random {C:dark_edition}negative{} joker.",
      "At {C:attention}end{} of round {C:red,E:1}destroy{} the created joker."
    }
  },
credits = {
  idea = {"1srscx4"},
  art = {"None"},
  code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 1, 
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 1, y = 0 },
in_pool = function(self, args) 
  return true
end,
calculate = function (self, card, context)
  if context.setting_blind then
    G.GAME.schizo = true
    local joker = SMODS.add_card({set = "Joker", edition = "e_negative", stickers = {"schizo_sticker"}})
    for _,sticker in ipairs(SMODS.Sticker.obj_buffer) do
      if sticker ~= "schizo_sticker" and joker.ability[sticker] then
          joker:remove_sticker(sticker)
      end
    end
    joker.sell_cost = 0
    G.GAME.schizo = false
  end
end
}

--Other 
SMODS.Joker{
key = 'argirl', --joker key
loc_txt = { -- local text
name = '{C:dark_edition}Study-Sama{}',
text = {
'{C:dark_edition,E:2}A R{}{E:2}andom played card gets',
"{E:2}retri{}{C:dark_edition,E:2}G{}{E:2}gered between #1# and #2# times.{}"
},},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
credits = {
sug = {"Flashfire8"},
idea = {"2nd Umbrella"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
rarity = 3,
cost = 8,
unlocked = true,  
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true, 
pos = {x = 0, y = 0},
config = { extra = {
sel_card = 1,
min = 1,
max = 10
}
},
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.min,center.ability.extra.max}} --#1# is replaced with card.ability.extra.Xmult
end,

calculate = function(self,card,context)
if context.before and not context.retrigger_joker then
card.ability.extra.sel_card = pseudorandom("seed",1,#context.scoring_hand) 
end
if not context.end_of_round and context.repetition and context.other_card == context.scoring_hand[card.ability.extra.sel_card] then

return {repetitions = pseudorandom("seed", card.ability.extra.min, card.ability.extra.max)}

end
end,
in_pool = function(self,wawa,wawa2)
--whether or not this card is in the pool, return true if it is, return false if its not
return true
end,
}
SMODS.Joker{
key = "hiyori",
loc_txt = {
name = "Hiyori",
text = {
"Give {X:chips,C:white}x#1#{} + {X:chips,C:white}x#2#{} chips.",
"per {C:hearts}heart{} card in {C:attention}full deck{}",
"{C:red,E:1}All heart cards are debuffed."}},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 3, 
cost = 8, 
credits = {
idea = {"1srscx4"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 5, y = 0},
config = { extra = { mult = 1 , increase = 0.15} },
loc_vars = function(self,info_queue,center)
return {vars = {center.ability.extra.mult,center.ability.extra.increase}}
end,
calculate = function(self,card,context)
if context.setting_blind and not context.retrigger_joker then
for _,playing_card in ipairs(G.playing_cards) do
if playing_card.base.suit == "Hearts" then
G.E_MANAGER:add_event(Event({
func = function()
playing_card:set_debuff(true)
return true
end
})) 
end
end
end
if context.joker_main then
for _,playing_card in ipairs(G.playing_cards) do
if playing_card.base.suit == "Hearts" then
G.E_MANAGER:add_event(Event({
func = function()
playing_card:set_debuff(false)
return true
end
})) 
end
end
local mult = card.ability.extra.mult
for _,playing_card in ipairs(G.playing_cards) do
if playing_card.base.suit == "Hearts" then
mult = mult + card.ability.extra.increase
G.E_MANAGER:add_event(Event({
func = function()
playing_card:set_debuff(true)
return true
end
})) 
end
end
return { xchips = mult }
end

end,
in_pool = function(self,args)
return true
end
}
SMODS.Joker{
key = "filtersister",
loc_txt = {
name = "Nere",
text = {
"Gains {X:mult,C:white}x#1#{} mult when a",
"{V:1}filtered card{} gets debuffed.",
"{C:inactive}(Currently {X:mult,C:white}x#2#{C:inactive})"
}
},
credits = {
sug = {"Flashfire8"},
idea = {"1srscx4"},
art = {"Kloovree"},
code = {"1srscx4"}
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = false,
pos = { x = 7, y = 6 },
in_pool = function(self, args) 
local inpool = false
for _,joker in ipairs(G.jokers.cards) do
if joker.edition and joker.edition.key == "e_filtered" then
inpool = true
break
end
end
for _,joker in ipairs(G.playbook_extra.cards) do
if joker.edition and joker.edition.key == "e_filtered" then
inpool = true
break
end
end
return inpool
end,
config = { extra = {upg = 0.25, xmult = 1} },
loc_vars = function(self,info_queue,center)
info_queue[#info_queue+1] = G.P_CENTERS.e_filtered
return {vars = {center.ability.extra.upg,center.ability.extra.xmult, colours = {HEX("589c4b")} } }
end,
calculate = function (self, card, context)
if context.joker_main then
return {xmult = card.ability.extra.xmult}
end
end
}
SMODS.Joker {
key = "anteater",
loc_txt = {
name = "Anteater",
text = { "Each scored {C:attention}2{} or {C:attention}3{}", 
"has a {C:green,E:1}#1# in #2#{} chance",
"of being {C:red,E:1}destroyed{}." },
},
atlas = "neuroCustomJokers", pools = { ["neurJoker"] = true}, 
rarity = 2, 
credits = {
sug = {"Evil Sand"},
idea = {"Evil Sand"},
art = {"None"},
code = {"PaulaMarina"}
},
cost = 6, 
unlocked = true, 
discovered = false, 
blueprint_compat = false, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 8, y = 7 },
config = { extra = { odds = 2 , base = 1 } },
loc_vars = function(self,info_queue,card)
return { vars = { (G.GAME and G.GAME.probabilities.normal or 1) * self.config.extra.base, self.config.extra.odds} }
end,
calculate = function(self,card,context)
if context.destroy_card and not context.repetition and not context.blueprint then
if context.destroy_card:get_id() == 2 or context.destroy_card:get_id() == 3 then
for _key,val in ipairs(context.scoring_hand) do 
if context.destroy_card == val and pseudorandom("anteater") < ((G.GAME and G.GAME.probabilities.normal or 1) * card.ability.extra.base) / self.config.extra.odds then
return { remove = true }
end
end
end
end
end,
in_pool = function(self, args) 
return true
end
}

--Dev
SMODS.Joker{
key = "me!",
loc_txt = {
name = "1srscx4",
text = {
"At {C:attention}end of round{}, multiplies most values of {C:attention}neuratro{}",
"joker to the right by {X:attention,C:white}x#1#{}.",
"{X:attention,C:white}#2#"
}},
atlas = "neuroCustomJokers",
rarity = "dev",
credits = {
idea = {"1srscx4"},
art = {"Kloovree"},
code = {"1srscx4"}
},
cost = 20, 
unlocked = true, 
discovered = false, 
blueprint_compat = false, 
eternal_compat = false, 
perishable_compat = false,
rental_compat = false,
pos = { x = 4, y = 7},
config = { extra = { multiplier = 1.5}},
loc_vars = function(self,info_queue,center)
local compatible = true
local text = "Incompatible"
local self_pos = 0
local area = center.area
if G.GAME and area and #area.cards > 0 then
for key,playing_card in ipairs(area.cards) do
if playing_card == center then
self_pos = key
end
end
if area.cards[self_pos + 1] ~= nil then
for _,valid in ipairs(neuro_jokers) do
if area.cards[self_pos + 1].config.center.key == valid then 
text = "Compatible"
break
end
end
end
end
return {vars = {center.ability.extra.multiplier, text }}
end,
calculate = function(self,card,context)
  if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
  local works = false
  local self_pos = 0
  local area = card.area
  for key,playing_card in ipairs(area.cards) do
  if playing_card == card then
  self_pos = key
  end
  end
  if area.cards[self_pos + 1] ~= nil then
  for _,valid in ipairs(neuro_jokers) do
  if area.cards[self_pos + 1].config.center.key == valid then 
  works = true
  break
  end
  end
  end
  if works then
  local success, err = pcall(function()
  for key, effect in pairs(area.cards[self_pos + 1].ability.extra) do
  if type(effect) == "number" then
  area.cards[self_pos + 1].ability.extra[key] = effect * card.ability.extra.multiplier
  end
  end
  end)
  if not success then
  return { message = "Failed to Upgrade" }
  end
  return {message = "Upgrade!"}
  end
  if not works then
  return {message = "Cannot upgrade"}
  end
  end
end,
in_pool = function(self,args)
return true
end
}
SMODS.Joker{
key = "Emuz",
loc_txt = {
name = "Noriko",
text = {{
"{C:dark_edition}Negative{} cards give ",
"{C:attention}#1#x{} their base {C:chips}chip{} value and {C:mult}+#1#{} mult.",
"and cannot be debuffed nor flipped"},
{"First {C:red}discarded{} card turns {C:dark_edition}negative{}",
"If you discard exactly 3 {C:dark_edition}negative{}",
"cards, {C:attention}destroy{} them and",
"gain a {E:1}random{} {C:dark_edition}negative{} joker."}
}},
atlas = "neuroCustomJokers", 
rarity = "dev",
credits = {
idea = {"Emuz","1srscx4"},
art = {"Ramen"},
code = {"1srscx4"}
},
cost = 20, 
unlocked = true, 
discovered = false, 
blueprint_compat = false, 
eternal_compat = false, 
perishable_compat = false,
rental_compat = false,
pos = { x = 3, y = 1},
config = { extra = { joker = 0 , mult = 10} },
loc_vars = function(self,info_queue,center)
info_queue[#info_queue+1] = G.P_CENTERS.e_negative
return {vars = {center.ability.extra.mult }}
end,
calculate = function(self,card,context)
if context.pre_discard and not context.blueprint and G.GAME.current_round.discards_used <= 0 and not context.retrigger_joker then
sea(
function ()
context.full_hand[1]:flip()
context.full_hand[1]:juice_up(0.3, 0.3)
return true
end,0.35,"after")
sea(
function ()
context.full_hand[1]:set_edition("e_negative",true)
return true
end,0.55,"after"
)
sea(
function ()
context.full_hand[1]:flip()
context.full_hand[1]:juice_up(0.3, 0.3)
return true
end,0.35,"after")
end
if context.individual and context.cardarea == G.play and not context.blueprint and not context.retrigger_joker then
if context.other_card.edition and context.other_card.edition.key == "e_negative" then
if context.other_card:get_id() < 11 and context.other_card.edition and context.other_card.edition.key == "e_negative" then
return { chips = context.other_card:get_id() * card.ability.extra.mult , mult = card.ability.extra.mult }
end
if context.other_card:is_face() and context.other_card.edition and context.other_card.edition.key == "e_negative"  then
return { chips = 10 * card.ability.extra.mult , mult = card.ability.extra.mult }
end
if context.other_card:get_id() == 14 and context.other_card.edition and context.other_card.edition.key == "e_negative"  then
return { chips = 11 * card.ability.extra.mult , mult = card.ability.extra.mult }
end
end
end
if context.discard and #context.full_hand == 3 and context.full_hand[1].edition and context.full_hand[1].edition.key == "e_negative" and context.full_hand[2].edition and context.full_hand[2].edition.key == "e_negative" and context.full_hand[3].edition and context.full_hand[3].edition.key == "e_negative" and not context.blueprint and not context.retrigger_joker then
for _, playing_card in ipairs(context.full_hand) do 
SMODS.destroy_cards(context.other_card)
end
card.ability.extra.joker = card.ability.extra.joker + 1
if card.ability.extra.joker >= 3 then
G.E_MANAGER:add_event(Event({
trigger = 'after',
delay = 0.4,
func = function()
play_sound('timpani')
SMODS.add_card({ set = 'Joker' , edition = "e_negative" })
card:juice_up(0.3, 0.5)
return true
end
}))
card.ability.extra.joker = 0
end
end
if context.hand_drawn and not context.blueprint and not context.retrigger_joker then
for i = 1, #G.hand.cards do
if G.hand.cards[i].edition and G.hand.cards[i].edition.key == "e_negative" and G.hand.cards[i].debuff then 
SMODS.debuff_card(G.hand.cards[i], 'prevent_debuff',"any")
G.hand:change_size(1)
end
if G.hand.cards[i].edition and G.hand.cards[i].edition.key == "e_negative" and G.hand.cards[i].facing == 'back' then
G.hand.cards[i]:flip()
end
end
end
end,
in_pool = function(self,args)
return true
end
}
SMODS.Joker{
key = "emojiman",
loc_txt = {
name = "EmojiMan",
text = {
"{C:attention}Smiley face{} gives",
"{X:mult,C:white}x#1#{} mult instead.",
"{C:attention}Smiley face{} may",
"appear multiple times."}},
atlas = "neuroCustomJokers",
rarity = "dev", 
credits = {
idea = {"Evil Sand","Emojiman","1srscx4"},
art = {"Evil Sand"},
code = {"1srscx4"}
},
cost = 20, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = false, 
perishable_compat = false,
pos = { x = 5, y = 1 },
in_pool = function(self, args) 
return true
end,
config = { extra = {xmult = 3} },
loc_vars = function(self,info_queue,center)
info_queue[#info_queue+1] = G.P_CENTERS.j_smiley
return { vars = {center.ability.extra.xmult} }
end
}
-- Part of the code from the next joker is also done by Aikoyori, again, check them out!
SMODS.Joker{
  key = "j_evilsand",
  unlocked = true,
  discovered = false,
  blueprint_compat = true,
  eternal_compat = false,
  perishable_compat = false,
  rental_compat = false,
  in_pool = function (self, args)
    return true
  end,
  config = {extra = {card1 = nil, card2 = nil, turn = "1", sold = 0, goal = 50}, extras = {}},
  add_to_deck = function (self, card, from_debuff)
    for pos, joker in ipairs(G.jokers.cards) do
      if joker.config.center.key == "j_evilsand" and joker ~= card then
        G.playbook_extra.config.card_limit = ((G.playbook_extra.config.card_limit - 2) * 2) + 2
        SMODS.destroy_cards(card)
        return true
      end
    end
    G.playbook_extra.states.collide.can = true
    G.playbook_extra.states.visible = false
    G.playbook_extra.config.card_limit = 4
    sea(
      function()
        G.GAME.playbook_hph = #SMODS.find_card("j_evilsand", true)
        return true
      end,
    0)
  end,
  remove_from_deck = function (self, card, from_debuff)
    local rst = true
    for pos, joker in ipairs(G.jokers.cards) do
      if joker.config.center.key == "j_evilsand" and joker ~= card then
        rst = false
      end
    end
    if rst then
      for _, v in ipairs(G.playbook_extra.cards) do
        if v.ability and v.ability.set == "Default" then
          v:start_dissolve()
        end
      end
    end
    sea(
      function()
        G.GAME.playbook_hph = #SMODS.find_card("j_evilsand", true)
        if G.GAME.playbook_hph < 1 then
          G.playbook_extra.states.collide.can = false
          G.playbook_extra.states.visible = false
        for _, cr in ipairs(G.playbook_extra.cards) do
          if cr.ability.consumeable then
            draw_card(G.playbook_extra, G.consumeables, nil, nil, false, cr)
          elseif cr.ability.set == "Joker" then
            draw_card(G.playbook_extra, G.jokers, nil, nil, false, cr)
          else
            draw_card(G.playbook_extra, G.deck, nil, nil, false, cr)
          end
        end
      end
      return true
      end,
    0)
  end,
  credits = {
    idea = {"Evil Sand"},
    art = {"Evil Sand"},
  code = {"Aikoyori", "1srscx4", "Aikoyori"}
  },
  rarity = "dev",
  cost = 20,
  atlas = "neuroCustomJokers",
  pos = {x = 0, y = 1},
  soul_pos = {x = 1, y = 1},
  loc_vars = function (self, info_queue, card)
    local yes = false
    if G.jokers and #G.jokers.cards > 0 then
      for _, joker in ipairs(G.jokers.cards) do
        if joker.config.center.key == "j_evilsand" then
          yes = true
          break
        end
      end
    end
    return {
      vars = {
        G.playbook_extra and yes and (G.playbook_extra.config.card_limit - 2) or 2,
        card.ability.extra.goal, 
        card.ability.extra.goal - card.ability.extra.sold
      },
      key = (card.edition and card.edition.key == "e_negative" and "j_goodsand") or "j_evilsand" 
    }
  end,
  calculate = function (self, card, context)
    if context.selling_card and context.card ~= card and context.card.area == G.jokers and not context.blueprint and not context.retrigger_joker then
      card.ability.extra.sold = card.ability.extra.sold + context.card.sell_cost
      if card.ability.extra.sold >= card.ability.extra.goal then
        card.ability.extra.sold = card.ability.extra.sold - card.ability.extra.goal
        G.playbook_extra.config.card_limit = G.playbook_extra.config.card_limit + 1
      end
      local thing = copy_card(context.card)
      G.playbook_extra:emplace(thing)
      local def_cards = 0
      for _, v in ipairs(G.playbook_extra.cards) do
        if v.ability and v.ability.set == "Default" then
          def_cards = def_cards + 1
        end
      end
      if #G.playbook_extra.cards - def_cards > G.playbook_extra.config.card_limit - 2 then
        for _, v in ipairs(G.playbook_extra.cards) do
          if v.ability and v.ability.set == "Joker" then
            SMODS.destroy_cards(v, true)
            break
          end
        end
      end
    end
    if context.remove_playing_cards and not context.blueprint and not context.retrigger_joker then
      for _, cards in ipairs(context.removed) do
        if tonumber(card.ability.extra.turn) == 1 then
          card.ability.extra.turn = "2"
          local pcard = copy_card(cards)
          SMODS.debuff_card(pcard, true, "sand")
          G.playbook_extra:emplace(pcard)
          card.ability.extra.card1 = true
        elseif tonumber(card.ability.extra.turn) == 2 then
          card.ability.extra.turn = "1"
          local pcard = copy_card(cards)
          SMODS.debuff_card(pcard, true, "sand")
          G.playbook_extra:emplace(pcard)
          card.ability.extra.card2 = true
        end
      end
      local def_cards = 0
      for _, v in ipairs(G.playbook_extra.cards) do
        if v.ability and v.ability.set == "Default" then
          def_cards = def_cards + 1
        end
      end
      if def_cards > 2 then
        for _, v in ipairs(G.playbook_extra.cards) do
          if v.ability and v.ability.set == "Default" then
            v:start_dissolve()
            def_cards = def_cards - 1
            if def_cards <= 2 then
              break
            end
          end
        end
      end
    end
    if context.before and not context.blueprint and not context.retrigger_joker then
      for _, pcard in ipairs(G.playbook_extra.cards) do
        print(pcard.ability.set)
        if pcard.ability.set == "Default" then
          local added = copy_card(pcard)
          SMODS.debuff_card(added, false, "sand")
          table.insert(G.playing_cards, added)
          G.play:emplace(added)
          table.insert(context.scoring_hand, added)
        end
      end
    end
    if context.after and not context.blueprint and not context.retrigger_joker then
      if card.ability.extra.card1 then
        SMODS.destroy_cards(context.full_hand[card.ability.extra.card2 ~= nil and #context.full_hand - 1 or #context.full_hand])
      end
      if card.ability.extra.card2 then
        SMODS.destroy_cards(context.full_hand[#context.full_hand])
      end
    end
  end,
}
--
SMODS.Joker:take_ownership('smiley', {
config = { extra = { mult = 5}},
loc_vars = function(self,info_queue,card)
return { vars = {card.ability.extra.mult}}
end,
calculate = function(self, card, context)
if context.individual and context.cardarea == G.play then
local deved = false
local emoji_pos = 0
local area = nil
for pos,joker in ipairs(G.jokers.cards) do
if joker.config.center.key == "j_emojiman" then
emoji_pos = pos
deved = true
area = G.jokers.cards
end
end
if not deved then
for pos,joker in ipairs(G.playbook_extra.cards) do
if joker.config.center.key == "j_emojiman" then
emoji_pos = pos
deved = true
area = G.playbook_extra.cards
end
end
end
if context.other_card:is_face() then
if deved then
return { xmult = area[emoji_pos].ability.extra.xmult}
else
return { mult = card.ability.extra.mult}
end
end
end
end},true)
--Legendaries
local vedals_items = {
  ["j_vedalsdrink"] = true, 
  ["j_tutel_credit"] = true, 
  ["j_tutelsoup"] = true, 
  ["j_vedds"] = true, 
  ["j_abandonedarchive"] = true
}
SMODS.Joker{
key = "anny",
loc_txt = {
name = "Anny",
text = {
"For every {C:attention}Unique card{} in {C:attention}deck{}.",
"gives {X:mult,C:white}x#1#{} Mult.",
"{C:inactive}(Currently: {X:mult,C:white}x#2#{C:inactive} Mult)"
}
},
credits = {
idea = {"Adesi","Evil Sand"},
art = {"Tony7268"},
code = {"Adesi"}
},
atlas = "neuroCustomJokers",
rarity = 4, 
cost = 20, 
unlocked = true, 
discovered = false, 
blueprint_compat = true, 
eternal_compat = true, 
perishable_compat = true,
pos = { x = 3, y = 8 },
soul_pos = { x = 3, y = 9 },
in_pool = function(self, args) 
return true
end,
loc_vars = function (self, info_queue, card)
info_queue[#info_queue+1] = {set = "Other", key = "Unique_card_desc"}
local uniquecardsTable = {}
local xmult = 1
if G.GAME and G.deck and #G.deck.cards > 0 then
for index, value in ipairs(G.deck.cards) do
local edition = ""
if value.config.card.edition == nil then 
edition = "0" 
else 
edition = value.config.card.edition.type
end
local sealname = ""
if value.seal then
sealname = value.seal..""
end
local uniqueID = sealname .."_".. value.base.value..value.base.suit..value.base.name.."_"..value.label.."_"..edition
local oldval = uniquecardsTable[uniqueID] or 0
uniquecardsTable[uniqueID] = oldval + 1
end
local amount_of_uniques = table_length(uniquecardsTable)
xmult = math.max(amount_of_uniques * card.ability.extra.upg,card.ability.extra.upg)
end
return {vars = {card.ability.extra.upg,xmult}}
end,
config = { extra = {upg = 0.2, xmult = 1} },
calculate = function(self,card,context)
if context.before then
local uniquecardsTable = {}
for index, value in ipairs(G.deck.cards) do
local edition = ""
if value.config.card.edition == nil then 
edition = "0" 
else 
edition = value.config.card.edition.type
end
local sealname = ""
if value.seal then
sealname = value.seal..""
end
local uniqueID = sealname .."_".. value.base.value..value.base.suit..value.base.name.."_"..value.label.."_"..edition
local oldval = uniquecardsTable[uniqueID] or 0
uniquecardsTable[uniqueID] = oldval + 1
end
local amount_of_uniques = table_length(uniquecardsTable)
card.ability.extra.xmult = math.max(amount_of_uniques * card.ability.extra.upg,card.ability.extra.upg)
return 
{
message = amount_of_uniques.." Unique!",
colour = G.C.YELLOW
}
end
if context.joker_main then
return {
xmult = card.ability.extra.xmult
}
end
end
}
SMODS.Joker{
  key = "neuro",
  loc_txt = {
    name = "Neuro",
    text = {
      "Gives {X:mult,C:white}X#1#{} Mult for every {C:attention}#2#%{} overkill",
      "chips scored in the {C:attention}previous{} blind",
      "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult out of {X:mult,C:white}X#4#{C:inactive} Mult){}){}"
    }
  },
  credits = {
    idea = {"Evil Sand"},
    art = {"Kloovree"},
    code = {"luq"}
  },
  rarity = 4,
  cost = 20,
  unlocked = true,
  discovered = false,
  blueprint_compat = true,
  eternal_compat = true, 
  perishable_compat = true,
  atlas = "neuroCustomJokers",
  pos = { x = 1, y = 8 },
  soul_pos = { x = 1, y = 9 },
  config = { extra = {xmult = 1, xmult_gain = 0.1, overkill = 1, cap = 100}},
  loc_vars = function(self, info_queue, card) 
    return { vars = { card.ability.extra.xmult_gain, card.ability.extra.overkill, card.ability.extra.xmult >= card.ability.extra.cap and card.ability.extra.cap or card.ability.extra.xmult, card.ability.extra.cap}}
  end,
  calculate = function(self, card, context) 
    if context.blind_defeated then
      if G.GAME.chips / G.GAME.blind.chips >= 1.0 then
        card.ability.extra.xmult = (G.GAME.chips / G.GAME.blind.chips - 1) * 100 / card.ability.extra.overkill * card.ability.extra.xmult_gain
      else 
        card.ability.extra.xmult = 1
      end
    end
    if context.joker_main then
      return {xmult = card.ability.extra.xmult >= card.ability.extra.cap and card.ability.extra.cap or card.ability.extra.xmult}
    end
  end
}
SMODS.Joker{
  key = "evil",
  loc_txt = {
    name = "Evil",
    text = {
      "This joker gains {X:mult,C:white}X#1#{} Mult",
      "for every {C:attention}playing card{} destroyed",
      "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}"
    }
  },
  credits = {
    idea = {"Evil Sand"},
    art = {"Evil Sand"},
    code = {"luq"}
  },
  rarity = 4,
  cost = 20,
  unlocked = true,
  discovered = false,
  blueprint_compat = true,
  eternal_compat = true, 
  perishable_compat = true,
  atlas = "neuroCustomJokers",
  pos = { x = 2, y = 8 },
  soul_pos = { x = 2, y = 9 },
  config = { extra = {xmult = 1, upg = 0.2}},
  loc_vars = function(self, info_queue, card) 
    return { vars = {card.ability.extra.upg, card.ability.extra.xmult}}
  end,
  calculate = function(self, card, context) 
    if context.remove_playing_cards and not context.blueprint then
      card.ability.extra.xmult = card.ability.extra.xmult + (card.ability.extra.upg * #context.removed)
      return { message = "Upgrade!"}
    end
    if context.joker_main then
      return {xmult = card.ability.extra.xmult}
    end
  end
}
SMODS.Joker{
  key = "vedal",
  loc_txt = {
    name = "Vedal",
    text = {
      "Gives {X:mult,C:white}X#1#{} Mult for every {C:money}$#2#{} gained this {C:attention}run{}.",
      "Each {C:attention}Vedal Item {C:inactive}(Currently owned: #5#){}",
      "increases the base amount by {X:mult,C:white}X#3#{} Mult",
      "{C:inactive}(Currently {X:mult,C:white}X#4#{} {C:inactive}Mult){}"
    }
  },
  credits = {
    idea = {"Evil Sand"},
    art = {"None"},
    code = {"luq"}
  },
  rarity = 4,
  cost = 20,
  unlocked = true,
  discovered = false,
  blueprint_compat = true,
  eternal_compat = true, 
  perishable_compat = true,
  atlas = "neuroCustomJokers",
  pos = {x = 1, y = 0},
  config = {extra = { dollars = 1, upg = 0.01, vedal_bonus = 0.01}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = {set = "Other", key = "Vedal_items_desc"} 
    local ved_cards = 0
    if G and G.jokers then
      for _,area in ipairs({G.jokers.cards,G.playbook_extra.cards}) do 
        for _, v in ipairs(area) do
          if vedals_items[v.config.center.key] then ved_cards = ved_cards + 1 end
        end
      end
    end
    local mult = math.floor(MONEY_EARNED / card.ability.extra.dollars) * (ved_cards * card.ability.extra.vedal_bonus + card.ability.extra.upg) 
    return {vars = {card.ability.extra.upg, 
                    card.ability.extra.dollars, 
                    card.ability.extra.vedal_bonus,
                    mult + 1,
                    ved_cards}}
  end,
  calculate = function(self, card, context) 
    local ved_cards = 0
    if context.joker_main then
      for _,area in ipairs({G.jokers.cards,G.playbook_extra.cards}) do 
        for _, v in ipairs(area) do
          if vedals_items[v.config.center.key] then ved_cards = ved_cards + 1 end
        end
      end
      local mult = math.floor(MONEY_EARNED / card.ability.extra.dollars) * (ved_cards * card.ability.extra.vedal_bonus + card.ability.extra.upg) 
      return {xmult = mult + 1}
    end
  end
}

