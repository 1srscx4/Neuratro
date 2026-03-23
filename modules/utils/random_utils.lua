
Neuratro = Neuratro or {}

-- Select a random element from a list
function Neuratro.random_from_list(list, seed)
	if not list or #list == 0 then
		return nil
	end
	return pseudorandom_element(list, pseudoseed(seed))
end

-- Get a random integer in a range
function Neuratro.random_range(seed, min_val, max_val)
	return pseudorandom(seed, min_val, max_val)
end

-- Roll a random chance
function Neuratro.random_chance(seed, chance)
	return pseudorandom(seed) <= chance
end

-- Get a random suit
function Neuratro.random_suit(seed)
	local suits = Neuratro.CONSTANTS.get_all_suits()
	return Neuratro.random_from_list(suits, seed)
end

-- Get a random suit abbreviation
function Neuratro.random_suit_abbrev(seed)
	local abbrevs = Neuratro.CONSTANTS.get_all_suit_abbrev()
	return Neuratro.random_from_list(abbrevs, seed)
end

-- Get a random rank
function Neuratro.random_rank(seed, face_only)
	local ranks
	if face_only then
		ranks = Neuratro.CONSTANTS.RANKS.FACE
	else
		ranks = Neuratro.CONSTANTS.RANKS.ALL
	end
	return Neuratro.random_from_list(ranks, seed)
end

-- Get a random song name for queenpb
function Neuratro.random_song(seed)
	local songs = Neuratro.CONSTANTS.get_all_songs()
	return Neuratro.random_from_list(songs, seed)
end

-- Roll a random xmult value from options
-- Commonly used for jokers that randomly select between xmult values
function Neuratro.random_xmult(options, seed)
	return Neuratro.random_from_list(options, seed)
end

-- Roll between high and low xmult values (50/50 chance)
function Neuratro.random_xmult_high_low(high, low, seed)
	local options = {high, low}
	return Neuratro.random_from_list(options, seed)
end

-- Get random chip value in range
function Neuratro.random_chips(seed, min_val, max_val)
	return pseudorandom(seed, min_val, max_val)
end

-- Generate random card properties
-- Returns suit, rank, seal type, enhancement type, and edition type
function Neuratro.random_card_properties(seed)
	return {
		suit = Neuratro.random_suit_abbrev(seed),
		rank = Neuratro.random_rank(seed),
		seal = pseudorandom(seed),
		enhancement = pseudorandom(seed),
		edition = pseudorandom(seed),
	}
end

-- Pick a random effect from weighted options
function Neuratro.random_weighted(options, seed)
	local total_weight = 0
	for _, opt in ipairs(options) do
		total_weight = total_weight + (opt.weight or 1)
	end
	
	local roll = pseudorandom(seed) * total_weight
	local current = 0
	
	for _, opt in ipairs(options) do
		current = current + (opt.weight or 1)
		if roll <= current then
			return opt.effect
		end
	end
	
	return options[#options].effect
end
