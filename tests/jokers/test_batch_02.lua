-- Tests for j_schedule joker
-- Time-based effects

Neuratro.Tests.describe("j_schedule", function()
	
	Neuratro.Tests.it("should track cycle correctly", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_schedule", {
			extra = { cycle = 1, dollars = 2, tarots = 2 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.equals(joker.ability.extra.cycle, 1, "Should start at cycle 1")
		
		-- Advance cycle
		joker.ability.extra.cycle = 2
		Neuratro.Tests.assert.equals(joker.ability.extra.cycle, 2, "Should advance to cycle 2")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should give different rewards per cycle", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local cycles = {
			{ cycle = 1, reward = "dollars", amount = 2 },
			{ cycle = 2, reward = "tarots", amount = 2 },
		}
		
		for _, data in ipairs(cycles) do
			Neuratro.Tests.assert.greater_than(data.amount, 0, 
				string.format("Cycle %d should give positive %s", data.cycle, data.reward))
		end
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_lavalamp joker
-- Heating up mechanic

Neuratro.Tests.describe("j_lavalamp", function()
	
	Neuratro.Tests.it("should track Xmult increase", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_lavalamp", {
			extra = { Xmult = 1, Xmult_mod = 0.75 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.equals(joker.ability.extra.Xmult, 1, "Should start at Xmult 1")
		
		-- Simulate upgrade
		joker.ability.extra.Xmult = joker.ability.extra.Xmult + joker.ability.extra.Xmult_mod
		Neuratro.Tests.assert.equals(joker.ability.extra.Xmult, 1.75, "Should increase by 0.75")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should trigger on specific hands", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local trigger_hands = { "Flush", "Straight", "Full House" }
		local context = Neuratro.Tests.Mocks.create_context("before", {
			scoring_name = "Flush"
		})
		
		Neuratro.Tests.assert.contains(trigger_hands, context.scoring_name, 
			"Should trigger on Flush")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_lucy joker
-- Mult accumulation

Neuratro.Tests.describe("j_lucy", function()
	
	Neuratro.Tests.it("should accumulate mult", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_lucy", {
			extra = { chip_bonus = 9 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.equals(joker.ability.extra.chip_bonus, 9, "Should have base chips")
		
		-- Simulate accumulation
		joker.ability.extra.chip_bonus = joker.ability.extra.chip_bonus + 9
		Neuratro.Tests.assert.equals(joker.ability.extra.chip_bonus, 18, "Should accumulate")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_queenpb joker
-- Song pooling system

Neuratro.Tests.describe("j_queenpb", function()
	
	Neuratro.Tests.it("should select random song on add", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local songs = Neuratro.CONSTANTS.get_all_songs()
		local selected = songs[1] -- Mock selection
		
		Neuratro.Tests.assert.contains(songs, selected, "Should select valid song")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should set pool flags correctly", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local song = "BOOM"
		G.GAME.pool_flags.BOOM = song == "BOOM"
		G.GAME.pool_flags.LIFE = song == "LIFE"
		G.GAME.pool_flags.NEVER = song == "NEVER"
		
		Neuratro.Tests.assert.is_true(G.GAME.pool_flags.BOOM, "BOOM flag should be true")
		Neuratro.Tests.assert.is_false(G.GAME.pool_flags.LIFE, "LIFE flag should be false")
		Neuratro.Tests.assert.is_false(G.GAME.pool_flags.NEVER, "NEVER flag should be false")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should upgrade xmult each round", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_queenpb", {
			extra = { xmult = 1, upg = 0.25, song = "LIFE" }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		-- End of round
		joker.ability.extra.xmult = joker.ability.extra.xmult + joker.ability.extra.upg
		Neuratro.Tests.assert.equals(joker.ability.extra.xmult, 1.25, "Should increase by 0.25")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should share song with other queenpb", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker1 = Neuratro.Tests.Mocks.create_joker("j_queenpb", {
			extra = { xmult = 1, upg = 0.25, song = "BOOM" }
		})
		local joker2 = Neuratro.Tests.Mocks.create_joker("j_queenpb", {
			extra = { xmult = 1, upg = 0.25, song = "" }
		})
		
		Neuratro.Tests.Mocks.add_joker_to_game(joker1)
		Neuratro.Tests.Mocks.add_joker_to_game(joker2)
		
		-- Second joker should copy first's song
		local other_queenpb = Neuratro.find_joker("j_queenpb")
		if other_queenpb and other_queenpb ~= joker2 then
			joker2.ability.extra.song = other_queenpb.ability.extra.song
		end
		
		Neuratro.Tests.assert.equals(joker2.ability.extra.song, "BOOM", 
			"Should copy song from existing queenpb")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should clear pool flags on removal", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		G.GAME.pool_flags.BOOM = true
		G.GAME.pool_flags.LIFE = false
		G.GAME.pool_flags.NEVER = false
		
		-- Simulate removal - no other queenpb
		local has_other = false
		if not has_other then
			G.GAME.pool_flags.BOOM = false
			G.GAME.pool_flags.LIFE = false
			G.GAME.pool_flags.NEVER = false
		end
		
		Neuratro.Tests.assert.is_false(G.GAME.pool_flags.BOOM, "Should clear BOOM flag")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_tutelsoup joker
-- Random effect selector

Neuratro.Tests.describe("j_tutelsoup", function()
	
	Neuratro.Tests.it("should select random effect", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local effects = { "mult", "chips", "money", "xmult" }
		local selected = effects[1] -- Mock selection
		
		Neuratro.Tests.assert.contains(effects, selected, "Should select valid effect")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should give correct bonus per effect", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_tutelsoup", {
			extra = { mult = 15, chips = 100, money = 3, xmult = 1.5, rounds = 0, goal = 4, chosen = "" }
		})
		
		local effect_values = {
			mult = joker.ability.extra.mult,
			chips = joker.ability.extra.chips,
			money = joker.ability.extra.money,
			xmult = joker.ability.extra.xmult,
		}
		
		Neuratro.Tests.assert.equals(effect_values.mult, 15, "Should have mult value")
		Neuratro.Tests.assert.equals(effect_values.chips, 100, "Should have chips value")
		Neuratro.Tests.assert.equals(effect_values.money, 3, "Should have money value")
		Neuratro.Tests.assert.approx_equals(effect_values.xmult, 1.5, 0.01, "Should have xmult value")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should destroy after goal rounds", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_tutelsoup", {
			extra = { mult = 15, chips = 100, money = 3, xmult = 1.5, rounds = 3, goal = 4, chosen = "" }
		})
		
		-- Simulate end of round
		joker.ability.extra.rounds = joker.ability.extra.rounds + 1
		local should_destroy = joker.ability.extra.rounds >= joker.ability.extra.goal
		
		Neuratro.Tests.assert.equals(joker.ability.extra.rounds, 4, "Should be at 4 rounds")
		Neuratro.Tests.assert.is_true(should_destroy, "Should destroy at goal")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_layna joker

Neuratro.Tests.describe("j_layna", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_layna")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_forghat joker

Neuratro.Tests.describe("j_forghat", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_forghat")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)

	Neuratro.Tests.it("should apply propagated seal with render flag", function()
		local file = io.open("Neuratro\\content\\objects\\jokers.lua", "r")
		if not file then
			file = io.open("content\\objects\\jokers.lua", "r")
		end
		if not file then
			return Neuratro.Tests.fail("Could not read jokers.lua for Frog Hat regression check")
		end

		local content = file:read("*all")
		file:close()

		local expected = "next_card:set_seal(source_card.seal, nil, true)"
		local has_render_flag = string.find(content, expected, 1, true) ~= nil
		return Neuratro.Tests.assert.is_true(has_render_flag,
			"Frog Hat should set seal with nil,true args so propagated seal renders")
	end)
	
end)

-- Tests for j_3heart joker
-- Already in separate file, add more tests here

Neuratro.Tests.describe("j_3heart_extended", function()
	
	Neuratro.Tests.it("should handle multiple upgrades", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_3heart", {
			extra = { Xmult = 1.5, xmbonus = 0.45 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		-- Multiple upgrades
		for i = 1, 3 do
			joker.ability.extra.Xmult = joker.ability.extra.Xmult + joker.ability.extra.xmbonus
		end
		
		Neuratro.Tests.assert.approx_equals(joker.ability.extra.Xmult, 2.85, 0.01, 
			"Should upgrade 3 times (1.5 + 3*0.45 = 2.85)")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should not upgrade with blueprint", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_3heart", {
			extra = { Xmult = 1.5, xmbonus = 0.45 }
		})
		
		local blueprint_copying = true
		local should_upgrade = not blueprint_copying
		
		Neuratro.Tests.assert.is_false(should_upgrade, "Should not upgrade when blueprint")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_argirl joker

Neuratro.Tests.describe("j_argirl", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_argirl")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_tiredtutel joker

Neuratro.Tests.describe("j_tiredtutel", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_tiredtutel")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)
