-- Neuratro Config Builder
-- Factory functions for common joker configuration patterns

Neuratro = Neuratro or {}
Neuratro.build_config = Neuratro.build_config or {}

-- Build config for xmult cycler joker (cycles between multiple xmult values)
-- @param base The base/current xmult value
-- @param values Table of xmult values to cycle through {c1, c2, c3}
-- @return table Config object
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
-- @param high The high xmult value
-- @param low The low xmult value
-- @return table Config object
function Neuratro.build_config.random_xmult(high, low)
	return {
		xhigh = high,
		xlow = low,
	}
end

-- Build config for probability-based xmult joker
-- @param odds The odds denominator (e.g., 3 for 1 in 3)
-- @param xmult_val The xmult value when successful
-- @param base Optional base chance (default 1)
-- @return table Config object
function Neuratro.build_config.odds_xmult(odds, xmult_val, base)
	return {
		odds = odds,
		xmult = xmult_val,
		base = base or 1,
	}
end

-- Build config for scaling mult joker (mult decreases/increases)
-- @param mult Starting mult value
-- @param decrement Amount to decrease per trigger
-- @return table Config object
function Neuratro.build_config.scaling_mult(mult, decrement)
	return {
		mult = mult,
		decr = decrement,
	}
end

-- Build config for probability-based upgrade joker
-- @param odds The odds denominator
-- @param upgrade_amount Amount to upgrade by on success
-- @param current Current value
-- @param goal Goal value
-- @return table Config object
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
-- @param bonus_name Name of the bonus field
-- @param base_value Base bonus value
-- @param upgrade Amount to increase per upgrade
-- @return table Config object
function Neuratro.build_config.accumulating_bonus(bonus_name, base_value, upgrade)
	local config = {
		upg = upgrade,
	}
	config[bonus_name] = base_value
	return config
end

-- Build config for round-based joker (tracks rounds until effect)
-- @param rounds Number of rounds
-- @param goal Goal rounds
-- @return table Config object
function Neuratro.build_config.round_based(rounds, goal)
	return {
		rounds = rounds or 0,
		goal = goal or 4,
		chosen = "",
	}
end

-- Build config for price/economy joker
-- @param base_price Base price value
-- @param down_range Downward random range
-- @param up_range Upward random range
-- @return table Config object
function Neuratro.build_config.economy(base_price, down_range, up_range)
	return {
		price = base_price or 0,
		down = down_range or 3,
		up = up_range or 6,
	}
end

-- Build config for chips bonus joker
-- @param base_chips Base chip value
-- @return table Config object
function Neuratro.build_config.chips_bonus(base_chips)
	return {
		chip_bonus = base_chips,
	}
end

-- Build config for random range joker
-- @param min_val Minimum value
-- @param max_val Maximum value
-- @return table Config object
function Neuratro.build_config.random_range(min_val, max_val)
	return {
		min = min_val,
		max = max_val,
	}
end

-- Build config for tracking joker (tracks some state)
-- @param track_name Name of tracking field
-- @param initial Initial value
-- @param max Maximum value
-- @return table Config object
function Neuratro.build_config.tracker(track_name, initial, max)
	local config = {}
	config[track_name] = initial or 0
	config.goal = max
	return config
end

-- Build config for xmult that increases on condition
-- @param base_xmult Starting xmult
-- @param increase Amount to increase by
-- @return table Config object
function Neuratro.build_config.scaling_xmult(base_xmult, increase)
	return {
		xmult = base_xmult,
		upg = increase,
	}
end

-- Build config for multi-effect joker
-- @param effects Table of effect configs
-- @return table Combined config object
function Neuratro.build_config.multi_effect(effects)
	local config = {}
	for key, value in pairs(effects) do
		config[key] = value
	end
	return config
end
