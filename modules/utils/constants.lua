-- Neuratro Constants Module
-- Centralized configuration constants to avoid magic strings and numbers

Neuratro = Neuratro or {}

Neuratro.CONSTANTS = {
	-- Song names for queenpb joker
	SONGS = {
		BOOM = "BOOM",
		LIFE = "LIFE",
		NEVER = "NEVER",
	},
	
	-- Card suits
	SUITS = {
		HEARTS = "Hearts",
		DIAMONDS = "Diamonds",
		SPADES = "Spades",
		CLUBS = "Clubs",
	},
	
	-- Suit abbreviations for card generation
	SUIT_ABBREVS = {
		HEARTS = "H",
		DIAMONDS = "D",
		SPADES = "S",
		CLUBS = "C",
	},
	
	-- Common multipliers
	MULTIPLIERS = {
		BASE = 1.5,
		LOW = 0.25,
		MID = 1.0,
		HIGH = 2.0,
		VERY_HIGH = 3.0,
		MAX = 4.0,
	},
	
	-- Probability defaults
	PROBABILITY = {
		BASE = 1,
		ODDS_COMMON = 3,
		ODDS_UNCOMMON = 6,
		ODDS_RARE = 10,
		ODDS_VERY_RARE = 20,
	},
	
	-- Joker and game limits
	LIMITS = {
		PLAYBOOK_MAX_CARDS = 64,
		DEFAULT_PLAYBOOK_SIZE = 2,
		STORED_JOKERS = 2,
		MAX_FACE_COUNT = 3,
		MIN_SUIT_COUNT = 3,
	},
	
	-- Chip/Mult defaults
	BONUSES = {
		CHIPS_BASE = 15,
		CHIPS_MID = 50,
		CHIPS_HIGH = 100,
		CHIPS_VERY_HIGH = 150,
		MULT_BASE = 3,
		MULT_MID = 5,
		MULT_HIGH = 10,
	},
	
	-- Game states
	STATES = {
		ACTIVE = true,
		INACTIVE = false,
	},
	
	-- Card ranks
	RANKS = {
		FACE = {"J", "Q", "K"},
		ALL = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"},
		ACE = 14,
	},
}

-- Helper to get all suit names as array
function Neuratro.CONSTANTS.get_all_suits()
	return {
		Neuratro.CONSTANTS.SUITS.HEARTS,
		Neuratro.CONSTANTS.SUITS.DIAMONDS,
		Neuratro.CONSTANTS.SUITS.SPADES,
		Neuratro.CONSTANTS.SUITS.CLUBS,
	}
end

-- Helper to get all suit abbreviations as array
function Neuratro.CONSTANTS.get_all_suit_abbrev()
	return {"S", "H", "D", "C"}
end

-- Helper to get all songs as array
function Neuratro.CONSTANTS.get_all_songs()
	return {
		Neuratro.CONSTANTS.SONGS.BOOM,
		Neuratro.CONSTANTS.SONGS.LIFE,
		Neuratro.CONSTANTS.SONGS.NEVER,
	}
end
