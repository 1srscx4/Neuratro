SMODS.Suit{
  key = "Glorpsuit",
  card_key = "G",
  loc_txt = "Gleebs",
  pos = { y = 1 },
  ui_pos = { x = 0 , y = 0},
  pos = {x=0,y=0},
  loc_vars = function (self, info_queue, card)
    info_queue[#info_queue+1] = { set = "Other", key = "Gleeb_desc"}
  end,
  lc_atlas = "neurosuit",
  hc_atlas ="neurosuit",
  hc_ui_atlas = "neurosuitui",
  lc_ui_atlas = "neurosuitui",
  in_pool = function(self, args)
    return G.GAME.pool_flags.glorpdeck
  end
}