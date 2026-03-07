-- Neuratro Probability Utilities
-- Standardized probability calculations and dice rolls

Neuratro = Neuratro or {}

-- Get the current probability scale factor from game state
-- Returns 1 if probabilities are not available
function Neuratro.get_probability_scale()
	return (G and G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal) or 1
end

-- Check if a random roll succeeds based on odds
-- @param base The base chance value (usually 1)
-- @param odds The odds denominator (e.g., 6 for 1 in 6)
-- @param seed The pseudorandom seed string
-- @return boolean true if roll succeeds
function Neuratro.roll_with_odds(base, odds, seed)
	local safe_odds = tonumber(odds) or 0
	if safe_odds <= 0 then
		return false
	end
	
	local chance = (math.max(0, base or 0) * Neuratro.get_probability_scale()) / safe_odds
	if chance <= 0 then
		return false
	end
	
	return pseudorandom(seed) <= math.min(chance, 1)
end

-- Roll with percentage chance (0-1)
-- @param chance Percentage chance (0.0 to 1.0)
-- @param seed The pseudorandom seed string
-- @return boolean true if roll succeeds
function Neuratro.roll_percentage(chance, seed)
	local scaled_chance = chance * Neuratro.get_probability_scale()
	return pseudorandom(seed) <= math.min(scaled_chance, 1)
end

-- Roll with simple 1/N odds
-- Commonly used pattern: 1 in 6, 1 in 3, etc.
-- @param odds The denominator (e.g., 6 for 1 in 6)
-- @param seed The pseudorandom seed string
-- @return boolean true if roll succeeds (1 comes up)
function Neuratro.roll_simple_odds(odds, seed)
	return Neuratro.roll_with_odds(1, odds, seed)
end

-- Get formatted probability string for display
-- @param base The base value
-- @param odds The odds denominator
-- @return string Formatted as "base in odds"
function Neuratro.format_probability(base, odds)
	local actual_base = (base or 1) * Neuratro.get_probability_scale()
	return string.format("%d", math.floor(actual_base)) .. " in " .. tostring(odds or 1)
end

-- Get probability variables for loc_vars
-- Returns {actual_base, odds} for use in text like "{C:green}#1# in #2#{}"
-- @param base The base value
-- @param odds The odds denominator
-- @return table {base * scale, odds}
function Neuratro.get_probability_vars(base, odds)
	return {
		(base or 1) * Neuratro.get_probability_scale(),
		odds or 1,
	}
end

-- Roll a 50/50 chance
-- @param seed The pseudorandom seed string
-- @return boolean true 50% of the time
function Neuratro.coin_flip(seed)
	return pseudorandom(seed, 1, 2) == 1
end
