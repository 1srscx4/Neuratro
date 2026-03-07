--- STEAMODDED HEADER
--- MOD_NAME: Neuratro
--- MOD_ID: Neurocards
--- MOD_AUTHOR: [Evil Sand, Ramen, WindSketchy, Banjofries, Etzyio+, 2nd Umbrella, Pers, Emuz, 1srscx4, That one guy, Emojiman, luq, PaulaMarina, Mr JDK, luq]
--- MOD_DESCRIPTION: meowmeowlol

----------------------------------------------
------------MOD CODE -------------------------

-- To do list:
-- -Custom game over text
-- -Staz
-- -Put the debuff from filtered cards inside of an event
-- -Mod purge hates me
-- -Make the neurocards version a deckskin
-- -arg arg arg arg
-- -Mod Menu to deactivate Life and BOOM, once it's made the music system will have to be reworked
-- -fix negatives in G.playbook

-- These 5 lines of code are from the mod aikoyori's playbook made by aikoyori. Check their mods out!
if not SMODS.current_mod.lovely then
	print("[Neuratro] Warning: Lovely patches were not loaded. Some features may not work correctly.")
end
AKYRS = SMODS.current_mod
AKYRS.emplace_funcs = {}
assert(SMODS.load_file("./modules/hooks/general.lua"))()
assert(SMODS.load_file("./modules/content/cardarea.lua"))()

-- Load utility modules (order matters - constants first, then utilities)
assert(SMODS.load_file("./modules/utils/constants.lua"))()
assert(SMODS.load_file("./modules/utils/joker_utils.lua"))()
assert(SMODS.load_file("./modules/utils/probability.lua"))()
assert(SMODS.load_file("./modules/utils/card_analysis.lua"))()
assert(SMODS.load_file("./modules/utils/random_utils.lua"))()
assert(SMODS.load_file("./modules/utils/config_builder.lua"))()
assert(SMODS.load_file("./modules/utils/joker_patterns.lua"))()
assert(SMODS.load_file("./modules/utils/safety.lua"))()
--

function SMODS.INIT.DecColors()
	local dec_mod = SMODS.findModByID("Neurocards")
	local sprite_deck1 = SMODS.Sprite:new("cards_1", dec_mod.path, "neuroCards.png", 71, 95, "asset_atli")
	local sprite_deck2 = SMODS.Sprite:new("cards_2", dec_mod.path, "neuroCards2.png", 71, 95, "asset_atli")
	local sprite_logo = SMODS.Sprite:new("balatro", dec_mod.path, "neuratro.png", 333, 216, "asset_atli")
	local sprite_enhancers = SMODS.Sprite:new("centers", dec_mod.path, "neuroEnhancers.png", 71, 95, "asset_atli")

sprite_deck1:register()
	sprite_deck2:register()
	sprite_logo:register()
	sprite_enhancers:register()
end

assert(SMODS.load_file("./content/hooks/hooks.lua"))()
assert(SMODS.load_file("./content/hooks/nothooks.lua"))()

assert(SMODS.load_file("./content/load/atlas.lua"))()
assert(SMODS.load_file("./content/load/sound.lua"))()
assert(SMODS.load_file("./content/load/shader.lua"))()

assert(SMODS.load_file("./content/objects/rarity.lua"))()
assert(SMODS.load_file("./content/objects/booster.lua"))()
assert(SMODS.load_file("./content/objects/challenges.lua"))()
assert(SMODS.load_file("./content/objects/consumables.lua"))()
assert(SMODS.load_file("./content/objects/decks.lua"))()
assert(SMODS.load_file("./content/objects/editions.lua"))()
assert(SMODS.load_file("./content/objects/enhancements.lua"))()
assert(SMODS.load_file("./content/objects/handtype.lua"))()
assert(SMODS.load_file("./content/objects/suit.lua"))()
assert(SMODS.load_file("./content/objects/tags.lua"))()
assert(SMODS.load_file("./content/objects/blind.lua"))()
assert(SMODS.load_file("./content/objects/jokers.lua"))()

----------------------------------------------
------------MOD CODE END----------------------
