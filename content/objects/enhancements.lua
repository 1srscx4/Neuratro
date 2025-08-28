--Enhancement
SMODS.Enhancement {
    key = "m_twin",
    loc_txt = {
      name = "Twin",
      text = {
        "{C:chips}+15{} extra chips",
        "{C:mult}+2{} mult"
      }},
    discovered = false, 
    atlas = "neuroEnh",
    pos = { x = 0, y = 0 },
    config = { bonus = 15 , mult = 2 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.bonus } }
    end,
}
SMODS.Enhancement{
  key = "m_dono",
  loc_txt = {
    name = "Donation",
    text = {
      "Gives {C:money}$2{} when scored"}},
  atlas = "neuroEnh",
  pos = { x = 1 , y = 0},
  config = { extra = {money = 2}},
      calculate = function (self, card, context)
    if context.main_scoring and context.cardarea == G.play then
      local msg = false
      local msg_pos = 1
      local area = nil
      for pos,joker in ipairs(G.jokers.cards) do
        if joker.config.center.key == "j_highlighted" and not joker.debuff then
          msg = true
          msg_pos = pos
          area = joker.area
          break
        end
      end
      if not msg then
        for pos,joker in ipairs(G.playbook_extra.cards) do
          if joker.config.center.key == "j_highlighted" and not joker.debuff then
            msg = true
            msg_pos = pos
            area = joker.area
            break
          end
        end
      end
      if msg then
        return {xmult = area.cards[msg_pos].ability.extra.xmult}
      else
        return {dollars = card.ability.extra.money}
      end
    end
  end
}
SMODS.Enhancement{
  key = "m_glorp",
  loc_txt = {
    name = "Glorpy",
    text = {
      "{C:red,E:2}Break on end of round"
    }},
  atlas = "neuroEnh",
  config = { extra = {can_break = false}},
  pos = { x = 2 , y = 0},
  weight = 0,
  in_pool = function(self, args)
    args = false
    return
  end,
  calculate = function(self, card, context)
    if context.before then
      card.ability.extra.can_break = true
    end
    if context.end_of_round and card.ability.extra.can_break then
      card.ability.extra.can_break = false
      SMODS.destroy_cards(card)
    end
  end}
SMODS.Enhancement{
  key = "m_blood",
  loc_txt = {
    name = "Bloody",
    text = {
      "{C:green}#1# in #2#{} chance to spread", "to {C:attention}adjacent{} cards", "after {C:attention}played{}",}},
  atlas = "neuroEnh",
  pos = { x = 6 , y = 1},
  config = { extra = {base = 1, odds = 3}},
  loc_vars = function (self, info_queue, card)
    return{vars= {card.ability.extra.base * (G.GAME.probabilities.normal or 1), card.ability.extra.odds}}
  end,
  calculate = function (self, card, context)
    if context.after then
      local trg = false
      for pos,pcard in ipairs(context.full_hand) do 
        if pcard == card and pseudorandom("blood") < (card.ability.extra.base * (G.GAME.probabilities.normal or 1))/(card.ability.extra.odds) then
          if context.full_hand[pos - 1] then
            sea(
            function ()
              if context.full_hand[pos - 1] then
                context.full_hand[pos - 1]:set_ability(G.P_CENTERS["m_blood"], nil, true)  
              end
              return true
            end)
          end
          if context.full_hand[pos + 1] then
            sea(
            function ()
              if context.full_hand[pos + 1] then
                context.full_hand[pos + 1]:set_ability(G.P_CENTERS["m_blood"], nil, true)
              end
              return true
            end)
          end
          trg = true
        end
      end
      if trg then
        return {message = "Spread!"}
      end
    end
  end
}
--Seal
SMODS.Seal{
  key = "shoomiminion_seal",
  loc_txt = {
    name = "Shoominion seal",
    label = "Shominion seal",
    text = {
      "When this card is {C:attention}destroyed{},",
      "create {C:attention}two{} copies of it"}},
  atlas = "neuroEnh",
  pos = {x = 7, y = 0},
  badge_colour = HEX('8CE6BD'),
  config = {mimi = false,},
  discovered = false,
  unlocked = true,
  calculate = function(self,card,context)
    if context.remove_playing_cards then
      for i = 1, #context.removed do
        local _suit = context.removed[i].base.suit
        local _rank = tostring(context.removed[i]:get_id())
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
                end
            }))
            SMODS.calculate_context({ playing_card_added = true, cards = { copy_card } })
          end
        end
      end
    end
  end}
SMODS.Seal{
  key = "osu_seal",
  loc_txt = {
    name = "Osu! seal",
    label = "Osu! seal",
    text = {
      "Gains {C:mult}+#1#{} Mult when played.",
      "{C:attention}Resets{} if the card is {C:red}discarded{}.",
      "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"}},
  atlas = "neuroEnh",
  pos = {x = 1, y = 1},
  badge_colour = HEX('DB5893'),
  config = {mult = 0,upg = 5},
  discovered = false,
  unlocked = true,
  loc_vars = function (self, info_queue, card)
    return{vars= {card.ability.seal.upg , card.ability.seal.mult}}
  end,
  calculate = function (self, card, context)
    if context.before then
      for _,pcard in ipairs(context.full_hand) do 
        if pcard == card then 
          card.ability.seal.mult = card.ability.seal.mult + card.ability.seal.upg
          return{message = "Upgrade!"}
        end
      end
    end
    if context.main_scoring and context.cardarea == G.play then
      return{mult = card.ability.seal.mult}
    end
    if context.discard and context.other_card == card then
      card.ability.seal.mult = 0
    end
  end
}
--Sticker
SMODS.Sticker{
  key = "schizo_sticker",
  loc_txt = {
    name = "Schizo",
    text = {"{C:red,E:1}Self-destructs{} at {C:attention}end of round{}."},
    label = "Schizo"
  },
  atlas = "neuroEnh",
  pos = {x = 7,y = 1},
  badge_colour = HEX("7A3FD6"),
  sets = {Joker = true},
  rate = 0,
  needs_enabled_flag = false,
  calculate = function (self, card, context)
    if context.end_of_round then
      SMODS.destroy_cards(card,true)
    end
  end,
  should_apply = function (self, card, center, area, bypass_reroll)
    return G.GAME.schizo
  end
}
--Modifications
SMODS.Enhancement:take_ownership("m_steel",{
  config = { extra = {xmult = 1.5}},
  loc_vars = function (self, info_queue, card)
    return {vars = {card.ability.extra.xmult}}
  end,
  calculate = function (self, card, context)
    if context.main_scoring and context.cardarea == G.hand then
      local pipes = false
      local pipes_pos = 1
      local area = nil
      for pos,joker in ipairs(G.jokers.cards) do
        if joker.config.center.key == "j_pipes" and not joker.debuff then
          pipes = true
          pipes_pos = pos
          area = joker.area
          break
        end
      end
      for pos,joker in ipairs(G.playbook_extra.cards) do
        if joker.config.center.key == "j_pipes" and not joker.debuff then
          pipes = true
          pipes_pos = pos
          area = joker.area
          break
        end
      end
      if pipes then
        return {xmult = area.cards[pipes_pos].ability.extra.xmult,message = "Pipe!", sound = "pipe_sfx"}
      else
        return {xmult = card.ability.extra.xmult}
      end
    end
  end
},true)
SMODS.Enhancement:take_ownership("m_stone", {
  config = {extra = {chips = 50}},
  loc_vars = function (self, info_queue, card)
    return{ vars = {card.ability.extra.chips}}
  end,
  replace_base_card = true, 
  calculate = function (self, card, context)
    if context.main_scoring and context.cardarea == G.play then
      for _, area in ipairs{G.jokers.cards, G.playbook_extra.cards} do 
        for _,joker in ipairs(area) do
          if joker.config.center.key == "j_breadge" then
            return {mult = joker.ability.extra.mult or 21}
          end
        end
      end
      return{chips = card.ability.extra.chips}
    end
  end
},true)