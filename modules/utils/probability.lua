Neuratro = Neuratro or {}

function Neuratro.get_probability_scale()
	return (G and G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal) or 1
end

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

function Neuratro.roll_simple_odds(odds, seed)
	return Neuratro.roll_with_odds(1, odds, seed)
end

function Neuratro.coin_flip(seed)
	return pseudorandom(seed, 1, 2) == 1
end
