-- Neuratro Test Mocks
-- Mock objects and utilities for testing

Neuratro = Neuratro or {}
Neuratro.Tests = Neuratro.Tests or {}
Neuratro.Tests.Mocks = {}

-- Mock game state (G)
function Neuratro.Tests.Mocks.create_game_state()
	return {
		GAME = {
			dollars = 0,
			probabilities = {
				normal = 1,
			},
			pool_flags = {},
			current_round = {
				hands_played = 0,
				discards_left = 0,
			},
			hands = {
				mix = { played = 0 },
			},
		},
		jokers = {
			cards = {},
			config = { card_limit = 5 },
		},
		playbook_extra = {
			cards = {},
			config = { card_limit = 2 },
			states = { collide = { can = false }, visible = false },
		},
		playing_cards = {},
		deck = {
			cards = {},
			config = { card_limit = 52 },
		},
		hand = {
			cards = {},
			config = { card_limit = 8 },
		},
		E_MANAGER = {
			events = {},
			add_event = function(self, event)
				table.insert(self.events, event)
			end,
		},
		C = {
			MULT = { r = 1, g = 0, b = 0 },
			CHIPS = { r = 0, g = 0.5, b = 1 },
			WHITE = { r = 1, g = 1, b = 1 },
			UI = { TEXT_DARK = { r = 0.2, g = 0.2, b = 0.2 } },
		},
		LANG = {
			font = {
				FONT = { getWidth = function() return 10 end },
				FONTSCALE = 1,
			},
		},
		TILESCALE = 1,
		TILESIZE = 1,
	}
end

-- Mock card
function Neuratro.Tests.Mocks.create_card(config)
	config = config or {}
	local card = {
		config = {
			center = {
				key = config.key or "c_base",
			},
		},
		ability = config.ability or { extra = {} },
		base = {
			suit = config.suit or "Hearts",
			value = config.value or "A",
		},
		edition = config.edition or nil,
		seal = config.seal or nil,
		debuff = config.debuff or false,
		area = config.area or nil,
		states = { visible = true },
	}
	
	-- Card methods
	function card:get_id()
		local rank_map = {
			["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5,
			["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9,
			["10"] = 10, ["J"] = 11, ["Q"] = 12, ["K"] = 13, ["A"] = 14,
		}
		return rank_map[self.base.value] or 0
	end
	
	function card:is_suit(suit, count_wild)
		return self.base.suit == suit
	end
	
	function card:is_face()
		local id = self:get_id()
		return id >= 11 and id <= 13
	end
	
	function card:set_ability(ability, immediate, silent)
		self.ability = ability
	end
	
	function card:set_seal(seal, immediate, silent)
		self.seal = seal
		self.last_set_seal = {
			seal = seal,
			immediate = immediate,
			silent = silent,
		}
	end
	
	function card:flip()
		self.states.visible = not self.states.visible
	end
	
	function card:juice_up(scale, amount)
		-- Mock animation
	end
	
	function card:add_sticker(sticker, bypass_roll)
		self.ability[sticker] = true
	end
	
	function card:remove_sticker(sticker)
		self.ability[sticker] = nil
	end
	
	return card
end

-- Mock joker card
function Neuratro.Tests.Mocks.create_joker(joker_key, config)
	config = config or {}
	config.key = joker_key
	local joker = Neuratro.Tests.Mocks.create_card(config)
	joker.config.center.key = joker_key
	joker.ability.extra = config.extra or {}
	return joker
end

-- Mock context for calculate functions
function Neuratro.Tests.Mocks.create_context(context_type, config)
	config = config or {}
	local context = {
		-- Common context flags
		before = context_type == "before",
		after = context_type == "after",
		joker_main = context_type == "joker_main",
		end_of_round = context_type == "end_of_round",
		setting_blind = context_type == "setting_blind",
		cardarea = config.cardarea or G.jokers,
		blueprint = config.blueprint or false,
		retrigger_joker = config.retrigger_joker or false,
		
		-- Hand/scoring info
		scoring_name = config.scoring_name or "High Card",
		scoring_hand = config.scoring_hand or {},
		full_hand = config.full_hand or {},
		other_card = config.other_card or nil,
		
		-- Card being evaluated
		other_context = config.other_context,
	}
	
	return context
end

-- Mock SMODS
Neuratro.Tests.Mocks.SMODS = {
	destroyed_cards = {},
	debuffed_cards = {},
	events_added = {},
	
	destroy_cards = function(card, force)
		table.insert(Neuratro.Tests.Mocks.SMODS.destroyed_cards, {
			card = card,
			force = force,
		})
	end,
	
	debuff_card = function(card, debuff, source)
		table.insert(Neuratro.Tests.Mocks.SMODS.debuffed_cards, {
			card = card,
			debuff = debuff,
			source = source,
		})
	end,
	
	has_enhancement = function(card, enhancement)
		return card.ability and card.ability.set == enhancement
	end,
	
	has_any_suit = function(card)
		return false -- Simplified mock
	end,
	
	calculate_context = function(context)
		return context
	end,
	
	get_enhancements = function(card)
		return {}
	end,
	
	poll_enhancement = function(config)
		return { set = "m_bonus" }
	end,
	
	change_base = function(card, suit, rank)
		card.base.suit = suit
		card.base.value = rank
	end,
}

-- Mock Event
function Event(config)
	return config
end

-- Helper to set up test environment
function Neuratro.Tests.Mocks.setup_test_env()
	-- Save original G if it exists
	Neuratro.Tests.Mocks._original_G = G
	
	-- Create mock G
	G = Neuratro.Tests.Mocks.create_game_state()
	
	-- Mock global functions
	Neuratro.Tests.Mocks._original_pseudorandom = pseudorandom
	Neuratro.Tests.Mocks._original_pseudorandom_element = pseudorandom_element
	Neuratro.Tests.Mocks._original_pseudoseed = pseudoseed
	Neuratro.Tests.Mocks._original_sendDebugMessage = sendDebugMessage
	
	-- Controlled random for testing
	local random_values = {}
	local random_index = 0
	
	pseudorandom = function(seed, min_val, max_val)
		random_index = random_index + 1
		if random_values[random_index] then
			return random_values[random_index]
		end
		
		if min_val and max_val then
			return min_val
		end
		return 0.5
	end
	
	pseudorandom_element = function(list, seed)
		return list and list[1] or nil
	end
	
	pseudoseed = function(seed)
		return seed and #seed or 0
	end
	
	sendDebugMessage = function(msg, tag)
		-- Suppress debug messages during tests
	end
	
	Neuratro.Tests.Mocks.set_random_values = function(values)
		random_values = values
		random_index = 0
	end
	
	Neuratro.Tests.Mocks.reset_random = function()
		random_values = {}
		random_index = 0
	end
end

-- Helper to tear down test environment
function Neuratro.Tests.Mocks.teardown_test_env()
	-- Restore original G
	G = Neuratro.Tests.Mocks._original_G
	
	-- Restore original functions
	pseudorandom = Neuratro.Tests.Mocks._original_pseudorandom
	pseudorandom_element = Neuratro.Tests.Mocks._original_pseudorandom_element
	pseudoseed = Neuratro.Tests.Mocks._original_pseudoseed
	sendDebugMessage = Neuratro.Tests.Mocks._original_sendDebugMessage
	
	-- Clear SMODS mocks
	Neuratro.Tests.Mocks.SMODS.destroyed_cards = {}
	Neuratro.Tests.Mocks.SMODS.debuffed_cards = {}
	Neuratro.Tests.Mocks.SMODS.events_added = {}
end

-- Helper to add joker to game state
function Neuratro.Tests.Mocks.add_joker_to_game(joker, area)
	area = area or G.jokers
	if area and area.cards then
		table.insert(area.cards, joker)
		joker.area = area
	end
end

-- Helper to add card to deck
function Neuratro.Tests.Mocks.add_card_to_deck(card)
	if G.deck and G.deck.cards then
		table.insert(G.deck.cards, card)
	end
	if G.playing_cards then
		table.insert(G.playing_cards, card)
	end
end

-- Helper to create a scoring hand
function Neuratro.Tests.Mocks.create_scoring_hand(cards_config)
	local hand = {}
	for _, config in ipairs(cards_config) do
		table.insert(hand, Neuratro.Tests.Mocks.create_card(config))
	end
	return hand
end
