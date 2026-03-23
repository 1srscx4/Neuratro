
Neuratro = Neuratro or {}
if not Neuratro.build_config then Neuratro.build_config = {} end

-- Build config for xmult cycler joker (cycles between multiple xmult values)
function Neuratro.build_config.xmult_cycler(base, values)
	return {
		xmult = base,
		cycle = "1",
		c1 = values[1],
		c2 = values[2],
		c3 = values[3],
	}
end

-- Build config for random xmult joker (randomly picks between high and low)
function Neuratro.build_config.random_xmult(high, low)
	return {
		xhigh = high,
		xlow = low,
	}
end

-- Build config for probability-based xmult joker
function Neuratro.build_config.odds_xmult(odds, xmult_val, base)
	return {
		odds = odds,
		xmult = xmult_val,
		base = base or 1,
	}
end

-- Build config for scaling mult joker (mult decreases/increases)
function Neuratro.build_config.scaling_mult(mult, decrement)
	return {
		mult = mult,
		decr = decrement,
	}
end

-- Build config for probability-based upgrade joker
function Neuratro.build_config.probability_upgrade(odds, upgrade_amount, current, goal)
	return {
		odds = odds,
		xmult = current,
		base = 1,
		upg = upgrade_amount,
		goal = goal or 0,
	}
end

-- Build config for accumulating bonus joker
function Neuratro.build_config.accumulating_bonus(bonus_name, base_value, upgrade)
	local config = {
		upg = upgrade,
	}
	config[bonus_name] = base_value
	return config
end

-- Build config for round-based joker (tracks rounds until effect)
function Neuratro.build_config.round_based(rounds, goal)
	return {
		rounds = rounds or 0,
		goal = goal or 4,
		chosen = "",
	}
end

-- Build config for price/economy joker
function Neuratro.build_config.economy(base_price, down_range, up_range)
	return {
		price = base_price or 0,
		down = down_range or 3,
		up = up_range or 6,
	}
end

-- Build config for chips bonus joker
function Neuratro.build_config.chips_bonus(base_chips)
	return {
		chip_bonus = base_chips,
	}
end

-- Build config for random range joker
function Neuratro.build_config.random_range(min_val, max_val)
	return {
		min = min_val,
		max = max_val,
	}
end

-- Build config for tracking joker (tracks some state)
function Neuratro.build_config.tracker(track_name, initial, max)
	local config = {}
	config[track_name] = initial or 0
	config.goal = max
	return config
end

-- Build config for xmult that increases on condition
function Neuratro.build_config.scaling_xmult(base_xmult, increase)
	return {
		xmult = base_xmult,
		upg = increase,
	}
end

-- Build config for multi-effect joker
function Neuratro.build_config.multi_effect(effects)
	local config = {}
	for key, value in pairs(effects) do
		config[key] = value
	end
	return config
end
