SMODS.Edition{
  shader = "filtered",
  key = 'filtered',
  loc_txt = {
    name = "Filtered",
    label = "Filtered",
    text = {
      "{C:green,E:1}50/50{} chance to retrigger",
      "the {C:attention}scored{} card or debuff it ",
      "until {C:attention}end of round"
    }
  },
  credits = {
      sug = {"Emuz","1srscx4"},
      idea = {"1srscx4"},
      art = {"pers"},
      code = {"1srscx4"}
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
    if context.repetition and context.cardarea == (G.play or G.hand or G.deck) and context.other_card == card then
      if pseudorandom("filter",1,2) == 1 then
          for _,area in ipairs({G.jokers.cards,G.playbook_extra.cards}) do
            for pos,joker in ipairs(area) do
              if joker.config.center.key == "j_filtersister" then
                area[pos].ability.extra.xmult = area[pos].ability.extra.xmult + area[pos].ability.extra.upg
              end
            end
          end
        SMODS.debuff_card(card,true,"filter")
        return{repetitions = 0, message = "[Filtered]"}
      end
      return {repetitions = 1}
    end
    if context.retrigger_joker_check and not context.retrigger_joker and context.other_card == card then
        if pseudorandom("filter",1,2) == 1 then
          for _,area in ipairs({G.jokers.cards,G.playbook_extra.cards}) do
            for pos,joker in ipairs(area) do
              if joker.config.center.key == "j_filtersister" then
                area[pos].ability.extra.xmult = area[pos].ability.extra.xmult + area[pos].ability.extra.upg
              end
            end
          end
        SMODS.debuff_card(card,true,"filter")
        return{repetitions = 0, message = "[Filtered]"}
      end
      return {repetitions = 1, message = "Again!"}
    end
  end,
  on_apply = function (card) --adds randomness to the filtered effect so they aren't uniform
        card.edition.filtered_seed = (pseudorandom('filtered_seed') * 2 - 1) * 1000
  end
}