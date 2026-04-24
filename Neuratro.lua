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
assert(SMODS.load_file("./modules/utils/joker_utils.lua"))()
assert(SMODS.load_file("./modules/utils/probability.lua"))()
--

-- Config defaults
SMODS.current_mod.config = SMODS.current_mod.config or {}
SMODS.current_mod.config.palette = SMODS.current_mod.config.palette or "default"

assert(SMODS.load_file("./modules/utils/palette.lua"))()

-- Palette cycle callback
G.FUNCS.Neurocards_set_palette = function(args)
	local palette_keys = { "default", "neuro", "evil" }
	local key = palette_keys[args.to_key] or "default"
	AKYRS.apply_palette(key)
	AKYRS.config.palette = key
	AKYRS.save_palette_pref(key)
end

-- Config tab shown in Steamodded mod settings
SMODS.current_mod.config_tab = function()
	local palette_options = { "Default", "Neuro-sama", "Evil Neuro" }
	local palette_keys = { "default", "neuro", "evil" }
	local saved = AKYRS.config.palette or "default"
	local current = 1
	for i, k in ipairs(palette_keys) do
		if k == saved then
			current = i
			break
		end
	end
	return {
		n = G.UIT.ROOT,
		config = { align = "cm", padding = 0.2, colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.1 },
				nodes = {
					{ n = G.UIT.T, config = { text = "Palette  ", scale = 0.4, colour = G.C.UI.TEXT_LIGHT } },
					create_option_cycle({
						options = palette_options,
						current_option = current,
						opt_callback = "Neurocards_set_palette",
						w = 3.5,
						scale = 0.8,
						colour = AKYRS.palette.primary or G.C.RED,
					}),
				},
			},
		},
	}
end

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

--This will be deleted at some point
jokers = {
	j_gros_michel = { pos = 0 },
	j_joker = { pos = 1 },
}
SMODS.Atlas({
	key = "neuroJokers",
	path = "neuroJokers.png",
	px = 71,
	py = 95,
})
for jkr, data in pairs(jokers) do
	SMODS["Joker"]:take_ownership(
		jkr,
		{ atlas = "neuroJokers", pos = { x = 0 + data.pos, y = 0 }, soul_pos = { x = 0 + data.pos, y = 1 } },
		true
	)
end
--

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
