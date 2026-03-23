local REPALETTE_KEYS = {
	"RED", "BLUE", "PURPLE", "GREEN", "GOLD", "ORANGE", "YELLOW",
	"BLACK", "L_BLACK", "GREY", "WHITE", "JOKER_GREY",
	"MULT", "CHIPS", "XMULT", "UI_MULT", "UI_CHIPS",
	"MONEY", "BOOSTER", "EDITION", "DARK_EDITION",
	"IMPORTANT", "FILTER", "VOUCHER", "CHANCE", "PALE_GREEN",
	"ETERNAL", "PERISHABLE", "RENTAL",
}

local NESTED_KEYS = {
	BACKGROUND    = { "L", "D", "C" },
	BLIND         = { "Small", "Big", "Boss", "won" },
	DYN_UI        = { "MAIN", "DARK", "BOSS_MAIN", "BOSS_DARK", "BOSS_PALE" },
	UI            = { "TEXT_LIGHT", "TEXT_DARK", "TEXT_INACTIVE",
	                  "BACKGROUND_LIGHT", "BACKGROUND_WHITE", "BACKGROUND_DARK",
	                  "BACKGROUND_INACTIVE", "OUTLINE_LIGHT", "OUTLINE_LIGHT_TRANS",
	                  "OUTLINE_DARK", "TRANSPARENT_LIGHT", "TRANSPARENT_DARK", "HOVER" },
	SET           = { "Default", "Enhanced", "Joker", "Tarot", "Planet", "Spectral", "Voucher" },
	SECONDARY_SET = { "Default", "Enhanced", "Joker", "Tarot", "Planet", "Spectral", "Voucher", "Edition" },
}

local NEURO_COLORS = {
	RED          = { 1.000, 0.302, 0.580, 1 },
	BLUE         = { 0.275, 0.847, 0.812, 1 },
	PURPLE       = { 0.608, 0.447, 0.902, 1 },
	GREEN        = { 0.482, 0.769, 0.565, 1 },
	GOLD         = { 1.000, 0.843, 0.000, 1 },
	ORANGE       = { 1.000, 0.502, 0.400, 1 },
	YELLOW       = { 1.000, 0.878, 0.200, 1 },
	BLACK        = { 0.098, 0.086, 0.118, 1 },
	L_BLACK      = { 0.157, 0.141, 0.184, 1 },
	GREY         = { 0.490, 0.467, 0.557, 1 },
	WHITE        = { 0.984, 0.984, 1.000, 1 },
	JOKER_GREY   = { 0.745, 0.725, 0.800, 1 },
	MULT         = { 1.000, 0.651, 0.788, 1 },
	CHIPS        = { 0.275, 0.847, 0.812, 1 },
	XMULT        = { 1.000, 0.302, 0.580, 1 },
	UI_MULT      = { 1.000, 0.651, 0.788, 1 },
	UI_CHIPS     = { 0.275, 0.847, 0.812, 1 },
	MONEY        = { 1.000, 0.843, 0.000, 1 },
	BOOSTER      = { 1.000, 0.420, 0.540, 1 },
	EDITION      = { 0.855, 0.835, 0.925, 1 },
	DARK_EDITION = { 0.530, 0.490, 0.680, 1 },
	IMPORTANT    = { 1.000, 0.302, 0.580, 1 },
	FILTER       = { 1.000, 0.302, 0.580, 1 },
	VOUCHER      = { 1.000, 0.843, 0.000, 1 },
	CHANCE       = { 1.000, 0.420, 0.540, 1 },
	PALE_GREEN   = { 0.580, 0.820, 0.630, 1 },
	ETERNAL      = { 1.000, 0.302, 0.580, 1 },
	PERISHABLE   = { 0.590, 0.565, 0.690, 1 },
	RENTAL       = { 0.780, 0.750, 0.620, 1 },
	BACKGROUND = {
		L = { 1.000, 0.780, 0.855, 1 },
		D = { 0.980, 0.650, 0.780, 1 },
		C = { 0.960, 0.580, 0.720, 1 },
	},
	BLIND = {
		Small = { 0.960, 0.580, 0.720, 1 },
		Big   = { 1.000, 0.780, 0.855, 1 },
		Boss  = { 1.000, 0.302, 0.580, 1 },
		won   = { 1.000, 0.420, 0.540, 1 },
	},
	DYN_UI = {
		MAIN      = { 0.118, 0.106, 0.145, 1 },
		DARK      = { 0.082, 0.075, 0.110, 1 },
		BOSS_MAIN = { 0.180, 0.160, 0.210, 1 },
		BOSS_DARK = { 0.120, 0.108, 0.155, 1 },
		BOSS_PALE = { 0.310, 0.290, 0.380, 1 },
	},
	UI = {
		TEXT_LIGHT          = { 0.984, 0.984, 1.000, 1 },
		TEXT_DARK           = { 0.098, 0.086, 0.118, 1 },
		TEXT_INACTIVE       = { 0.600, 0.575, 0.690, 0.66 },
		BACKGROUND_LIGHT    = { 1.000, 0.780, 0.855, 1 },
		BACKGROUND_WHITE    = { 0.984, 0.984, 1.000, 1 },
		BACKGROUND_DARK     = { 0.098, 0.086, 0.118, 1 },
		BACKGROUND_INACTIVE = { 0.170, 0.155, 0.200, 1 },
		OUTLINE_LIGHT       = { 1.000, 0.420, 0.540, 1 },
		OUTLINE_LIGHT_TRANS = { 1.000, 0.420, 0.540, 0.45 },
		OUTLINE_DARK        = { 0.098, 0.086, 0.118, 1 },
		TRANSPARENT_LIGHT   = { 0.984, 0.984, 1.000, 0.18 },
		TRANSPARENT_DARK    = { 0.098, 0.086, 0.118, 0.16 },
		HOVER               = { 1.000, 0.420, 0.540, 0.28 },
	},
	SET = {
		Default  = { 0.975, 0.960, 0.975, 1 },
		Enhanced = { 0.975, 0.960, 0.975, 1 },
		Joker    = { 0.140, 0.125, 0.165, 1 },
		Tarot    = { 0.140, 0.125, 0.165, 1 },
		Planet   = { 0.140, 0.125, 0.165, 1 },
		Spectral = { 0.140, 0.125, 0.165, 1 },
		Voucher  = { 0.140, 0.125, 0.165, 1 },
	},
	SECONDARY_SET = {
		Default  = { 1.000, 0.780, 0.855, 1 },
		Enhanced = { 1.000, 0.420, 0.540, 1 },
		Joker    = { 1.000, 0.302, 0.580, 1 },
		Tarot    = { 0.608, 0.447, 0.902, 1 },
		Planet   = { 0.275, 0.847, 0.812, 1 },
		Spectral = { 0.608, 0.447, 0.902, 1 },
		Voucher  = { 1.000, 0.843, 0.000, 1 },
		Edition  = { 0.275, 0.847, 0.812, 1 },
	},
}

local EVIL_COLORS = {
	RED          = { 0.92, 0.18, 0.22, 1 },
	BLUE         = { 0.45, 0.28, 0.55, 1 },
	PURPLE       = { 0.62, 0.18, 0.35, 1 },
	GREEN        = { 0.35, 0.62, 0.38, 1 },
	GOLD         = { 0.88, 0.62, 0.20, 1 },
	ORANGE       = { 0.92, 0.48, 0.12, 1 },
	YELLOW       = { 0.92, 0.78, 0.25, 1 },
	BLACK        = { 0.14, 0.10, 0.12, 1 },
	L_BLACK      = { 0.24, 0.18, 0.20, 1 },
	GREY         = { 0.38, 0.30, 0.32, 1 },
	WHITE        = { 0.92, 0.88, 0.88, 1 },
	JOKER_GREY   = { 0.62, 0.55, 0.56, 1 },
	MULT         = { 0.92, 0.18, 0.22, 1 },
	CHIPS        = { 0.45, 0.28, 0.55, 1 },
	XMULT        = { 1.00, 0.22, 0.28, 1 },
	UI_MULT      = { 0.92, 0.18, 0.22, 1 },
	UI_CHIPS     = { 0.45, 0.28, 0.55, 1 },
	MONEY        = { 0.88, 0.62, 0.20, 1 },
	BOOSTER      = { 0.50, 0.22, 0.38, 1 },
	EDITION      = { 0.78, 0.68, 0.62, 1 },
	DARK_EDITION = { 0.52, 0.44, 0.42, 1 },
	IMPORTANT    = { 1.00, 0.50, 0.15, 1 },
	FILTER       = { 1.00, 0.50, 0.15, 1 },
	VOUCHER      = { 0.72, 0.38, 0.25, 1 },
	CHANCE       = { 0.35, 0.62, 0.38, 1 },
	PALE_GREEN   = { 0.30, 0.52, 0.35, 1 },
	ETERNAL      = { 0.68, 0.22, 0.38, 1 },
	PERISHABLE   = { 0.35, 0.25, 0.50, 1 },
	RENTAL       = { 0.62, 0.45, 0.22, 1 },
	BACKGROUND = {
		L = { 0.80, 0.15, 0.12, 1 },
		D = { 0.12, 0.06, 0.08, 1 },
		C = { 0.15, 0.08, 0.10, 1 },
	},
	BLIND = {
		Small = { 0.55, 0.20, 0.25, 1 },
		Big   = { 0.55, 0.20, 0.25, 1 },
		Boss  = { 0.90, 0.15, 0.18, 1 },
		won   = { 0.40, 0.30, 0.32, 1 },
	},
	DYN_UI = {
		MAIN      = { 0.18, 0.10, 0.12, 1 },
		DARK      = { 0.12, 0.06, 0.08, 1 },
		BOSS_MAIN = { 0.50, 0.12, 0.15, 1 },
		BOSS_DARK = { 0.35, 0.08, 0.10, 1 },
		BOSS_PALE = { 0.60, 0.25, 0.28, 1 },
	},
	UI = {
		TEXT_LIGHT          = { 1.00, 0.92, 0.90, 1 },
		TEXT_DARK           = { 0.10, 0.05, 0.06, 1 },
		TEXT_INACTIVE       = { 0.85, 0.68, 0.68, 0.55 },
		BACKGROUND_LIGHT    = { 0.68, 0.30, 0.32, 1 },
		BACKGROUND_WHITE    = { 0.92, 0.88, 0.88, 1 },
		BACKGROUND_DARK     = { 0.48, 0.20, 0.22, 1 },
		BACKGROUND_INACTIVE = { 0.38, 0.28, 0.28, 1 },
		OUTLINE_LIGHT       = { 0.75, 0.48, 0.45, 1 },
		OUTLINE_LIGHT_TRANS = { 0.75, 0.48, 0.45, 0.40 },
		OUTLINE_DARK        = { 0.48, 0.20, 0.22, 1 },
		TRANSPARENT_LIGHT   = { 0.72, 0.40, 0.38, 0.13 },
		TRANSPARENT_DARK    = { 0.14, 0.08, 0.08, 0.13 },
		HOVER               = { 0.12, 0.04, 0.05, 0.33 },
	},
	SET = {
		Default  = { 0.65, 0.38, 0.38, 1 },
		Enhanced = { 0.65, 0.38, 0.38, 1 },
		Joker    = { 0.32, 0.16, 0.18, 1 },
		Tarot    = { 0.32, 0.16, 0.18, 1 },
		Planet   = { 0.32, 0.16, 0.18, 1 },
		Spectral = { 0.32, 0.16, 0.18, 1 },
		Voucher  = { 0.32, 0.16, 0.18, 1 },
	},
	SECONDARY_SET = {
		Default  = { 0.58, 0.32, 0.35, 1 },
		Enhanced = { 0.52, 0.28, 0.48, 1 },
		Joker    = { 0.52, 0.32, 0.38, 1 },
		Tarot    = { 0.62, 0.28, 0.52, 1 },
		Planet   = { 0.38, 0.52, 0.58, 1 },
		Spectral = { 0.38, 0.32, 0.68, 1 },
		Voucher  = { 0.90, 0.42, 0.20, 1 },
		Edition  = { 0.38, 0.58, 0.48, 1 },
	},
}

-- Simple palette values for mod-specific UI (popup colors etc.)
local SIMPLE = {
	default = {
		primary = { 0.996, 0.373, 0.333, 1 }, -- G.C.RED default (#FE5F55)
		deep    = { 0.478, 0.000, 0.000, 1 }, -- #7a0000
		glow    = { 0.996, 0.373, 0.333, 1 },
		accent  = { 0.996, 0.373, 0.333, 1 },
	},
	neuro = {
		primary = { 0.120, 0.500, 0.480, 1 },
		deep    = { 0.040, 0.090, 0.085, 1 },
		glow    = { 1.000, 0.420, 0.540, 1 },
		accent  = { 0.878, 0.271, 0.341, 1 },
	},
	evil = {
		primary = { 1.0,  0.15, 0.22, 1 },
		deep    = { 0.75, 0.08, 0.14, 1 },
		glow    = { 1.0,  0.30, 0.35, 1 },
		accent  = { 1.0,  0.15, 0.22, 1 },
	},
}

-- Neuro accent keys that follow the boss hue when a boss is active
local NEURO_BOSS_KEYS = {
	"RED", "MULT", "XMULT", "UI_MULT",
	"IMPORTANT", "FILTER", "BOOSTER", "CHANCE", "ETERNAL",
}
local NEURO_BOSS_NESTED = {
	BACKGROUND    = { "L", "D", "C" },
	BLIND         = { "Small", "Big", "Boss", "won" },
	UI            = { "BACKGROUND_LIGHT", "OUTLINE_LIGHT", "OUTLINE_LIGHT_TRANS", "HOVER" },
	SECONDARY_SET = { "Default", "Enhanced", "Joker" },
}

-- Evil accent keys that follow the boss hue when a boss is active
local EVIL_BOSS_KEYS = {
	"RED", "MULT", "XMULT", "UI_MULT",
	"BOOSTER", "ETERNAL",
}

local _palette_baseline = nil
local _applied_key      = nil

local function cc(c) return { c[1], c[2], c[3], c[4] } end

local function rgb_to_hsv(c)
	local r, g, b = c[1], c[2], c[3]
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local d = max - min
	local h, s, v = 0, 0, max
	if max > 0 then s = d / max end
	if d > 0 then
		if     max == r then h = (g - b) / d + (g < b and 6 or 0)
		elseif max == g then h = (b - r) / d + 2
		else                 h = (r - g) / d + 4 end
		h = h / 6
	end
	return h, s, v
end

local function hsv_to_rgb(h, s, v, a)
	h = h % 1
	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p, q, t = v*(1-s), v*(1-f*s), v*(1-(1-f)*s)
	local r, g, b
	local m = i % 6
	if     m == 0 then r, g, b = v, t, p
	elseif m == 1 then r, g, b = q, v, p
	elseif m == 2 then r, g, b = p, v, t
	elseif m == 3 then r, g, b = p, q, v
	elseif m == 4 then r, g, b = t, p, v
	else               r, g, b = v, p, q end
	return { r, g, b, a or 1 }
end

local function recolor_to_hue(orig, boss_hue)
	local _, s, v = rgb_to_hsv(orig)
	return hsv_to_rgb(boss_hue, s, v, orig[4])
end

local function live_boss_hue()
	if not (G and G.C and G.C.DYN_UI and G.C.DYN_UI.BOSS_MAIN) then return nil end
	if not (G.GAME and G.GAME.blind and G.GAME.blind.boss) then return nil end
	local bm = G.C.DYN_UI.BOSS_MAIN
	local r, g, b = bm[1], bm[2], bm[3]
	local max, min = math.max(r, g, b), math.min(r, g, b)
	if max == min then return nil end
	local d = max - min
	local h
	if     max == r then h = (g - b) / d + (g < b and 6 or 0)
	elseif max == g then h = (b - r) / d + 2
	else                 h = (r - g) / d + 4 end
	return h / 6
end

local function neuro_boss_override()
	local bh = live_boss_hue()
	if not bh then return nil end
	local ov = {}
	for _, k in ipairs(NEURO_BOSS_KEYS) do
		local orig = NEURO_COLORS[k]
		if orig then ov[k] = recolor_to_hue(orig, bh) end
	end
	for tbl, subs in pairs(NEURO_BOSS_NESTED) do
		local src_tbl = NEURO_COLORS[tbl]
		if src_tbl then
			for _, sk in ipairs(subs) do
				local orig = src_tbl[sk]
				if orig then
					ov[tbl] = ov[tbl] or {}
					ov[tbl][sk] = recolor_to_hue(orig, bh)
				end
			end
		end
	end
	return ov
end

local function evil_boss_override()
	local bh = live_boss_hue()
	if not bh then return nil end
	local ov = {}
	for _, k in ipairs(EVIL_BOSS_KEYS) do
		local orig = EVIL_COLORS[k]
		if orig then ov[k] = recolor_to_hue(orig, bh) end
	end
	local bb = EVIL_COLORS.BLIND and EVIL_COLORS.BLIND.Boss
	if bb then ov.BLIND = { Boss = recolor_to_hue(bb, bh) } end
	return ov
end

local function apply_color_inplace(target, source)
	if not target or not source then return end
	target[1] = source[1]
	target[2] = source[2]
	target[3] = source[3]
	if source[4] ~= nil then target[4] = source[4] end
end

local function snapshot_baseline()
	if _palette_baseline or not (G and G.C) then return end
	local snap = { flat = {}, nested = {} }
	for _, k in ipairs(REPALETTE_KEYS) do
		if type(G.C[k]) == "table" then
			snap.flat[k] = cc(G.C[k])
		end
	end
	for tbl, subs in pairs(NESTED_KEYS) do
		if type(G.C[tbl]) == "table" then
			snap.nested[tbl] = {}
			for _, sk in ipairs(subs) do
				if type(G.C[tbl][sk]) == "table" then
					snap.nested[tbl][sk] = cc(G.C[tbl][sk])
				end
			end
		end
	end
	_palette_baseline = snap
end

local function apply_gc_table(palette)
	if not palette or not G or not G.C or not _palette_baseline then return end
	for _, k in ipairs(REPALETTE_KEYS) do
		local src = palette[k] or (_palette_baseline.flat and _palette_baseline.flat[k])
		if src and G.C[k] then apply_color_inplace(G.C[k], src) end
	end
	for tbl, subs in pairs(NESTED_KEYS) do
		if G.C[tbl] then
			for _, sk in ipairs(subs) do
				local src = (palette[tbl] and palette[tbl][sk])
					or (_palette_baseline.nested and _palette_baseline.nested[tbl] and _palette_baseline.nested[tbl][sk])
				if src and G.C[tbl][sk] then apply_color_inplace(G.C[tbl][sk], src) end
			end
		end
	end
end

local function apply_partial_gc(palette)
	if not palette or not G or not G.C then return end
	for _, k in ipairs(REPALETTE_KEYS) do
		if palette[k] and G.C[k] then apply_color_inplace(G.C[k], palette[k]) end
	end
	for tbl, subs in pairs(NESTED_KEYS) do
		if palette[tbl] and G.C[tbl] then
			for _, sk in ipairs(subs) do
				if palette[tbl][sk] and G.C[tbl][sk] then
					apply_color_inplace(G.C[tbl][sk], palette[tbl][sk])
				end
			end
		end
	end
end

AKYRS.palette = {}

function AKYRS.apply_palette(key)
	local s = SIMPLE[key] or SIMPLE["default"]
	AKYRS.palette.primary = s.primary
	AKYRS.palette.deep    = s.deep
	AKYRS.palette.glow    = s.glow
	AKYRS.palette.accent  = s.accent
	_applied_key = key
end

local _orig_draw     = love.draw
local _draw_key_last = nil
local _was_boss      = false

love.draw = function(...)
	if G and G.C then
		snapshot_baseline()
		local key      = _applied_key or "default"
		local is_boss  = not not (G.GAME and G.GAME.blind and G.GAME.blind.boss)

		if key ~= _draw_key_last or (_was_boss and not is_boss) then
			_draw_key_last = key
			if key == "neuro" then
				apply_gc_table(NEURO_COLORS)
			elseif key == "evil" then
				apply_gc_table(EVIL_COLORS)
			else
				apply_gc_table({})
			end
		end
		_was_boss = is_boss

		if is_boss then
			local ov = (key == "neuro" and neuro_boss_override())
			        or (key == "evil"  and evil_boss_override())
			if ov then apply_partial_gc(ov) end
		end
	end
	return _orig_draw(...)
end

local _PREF_FILE = "Neurocards_palette.txt"

function AKYRS.save_palette_pref(key)
	love.filesystem.write(_PREF_FILE, key)
end

local _saved_pref = nil
if love.filesystem.getInfo(_PREF_FILE) then
	local data = love.filesystem.read(_PREF_FILE)
	if data then _saved_pref = data:match("^%s*(.-)%s*$") end
end
if _saved_pref then AKYRS.config.palette = _saved_pref end

AKYRS.apply_palette(AKYRS.config.palette or "default")
