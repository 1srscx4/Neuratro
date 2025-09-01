SMODS.Sound{
  key = "Yippee",
  path = "yippee-tbh.ogg",
pitch = 1,
volume = 1
}
SMODS.Sound{
  key = "pipe_sfx",
  path = "pipes.ogg",
pitch = 1,
volume = 0.7
}
SMODS.Sound({
    vol = 0.6,
    pitch = 1,
    key = "music_BOOM",
    path = "BOOM.ogg",
    select_music_track = function()
    return G.GAME.pool_flags.BOOM and 100 or false
    end,
})
SMODS.Sound({
    vol = 0.6,
    pitch = 1,
    key = "music_LIFE",
    path = "LIFE.ogg",
    select_music_track = function()
    return G.GAME.pool_flags.LIFE and 98 or false
    end,
})
SMODS.Sound({
    vol = 0.6,
    pitch = 1,
    key = "music_NEVER",
    path = "NEVER.ogg",
    select_music_track = function()
    return G.GAME.pool_flags.NEVER and 99 or false
    end,
})
SMODS.Sound({
  key = "emultsfx",
  path = "exponentialmult.wav"
  --Sound taken from Talisman for consistency between mods. Not used Talisman so the mod doesnt have dependecies.
})
SMODS.Sound{
  key = "filter_sfx",
  path = "filtered.ogg",
  pitch = 1,
  volume = 1
}
SMODS.Sound{
  key = "erm_sfx",
  path = "annyErm.ogg",
  pitch = 1,
  volume = 1
}