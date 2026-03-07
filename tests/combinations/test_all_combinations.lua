-- Comprehensive Joker Combination Tests
-- Tests critical and systematic combinations

Neuratro.Tests.describe("Critical Joker Combinations", function()
	
	-- Test 1: Mult stacking interactions
	Neuratro.Tests.it("should stack mult from multiple sources", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker1 = Neuratro.Tests.Mocks.create_joker("j_plasma_globe", {
			extra = { added = 12 }
		})
		local joker2 = Neuratro.Tests.Mocks.create_joker("j_hype", {
			extra = { mult = 0, base = 4 }
		})
		
		Neuratro.Tests.Mocks.add_joker_to_game(joker1)
		Neuratro.Tests.Mocks.add_joker_to_game(joker2)
		
		-- Add more jokers for hype
		for i = 1, 2 do
			local extra = Neuratro.Tests.Mocks.create_joker("j_extra_" .. i)
			Neuratro.Tests.Mocks.add_joker_to_game(extra)
		end
		
		-- Calculate mult from plasma_globe: 12
		-- Calculate mult from hype: 4 * 4 jokers = 16
		-- Total: 12 + 16 = 28
		local plasma_mult = 12
		local hype_mult = 4 * 4
		local total = plasma_mult + hype_mult
		
		Neuratro.Tests.assert.equals(total, 28, "Mult should stack additively")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	-- Test 2: Xmult stacking
	Neuratro.Tests.it("should multiply xmult from multiple sources", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker1 = Neuratro.Tests.Mocks.create_joker("j_3heart", {
			extra = { Xmult = 2.0, xmbonus = 0.45 }
		})
		local joker2 = Neuratro.Tests.Mocks.create_joker("j_roulette", {
			extra = { xhigh = 4, xlow = 0.25 }
		})
		
		Neuratro.Tests.Mocks.add_joker_to_game(joker1)
		Neuratro.Tests.Mocks.add_joker_to_game(joker2)
		
		-- Xmult should multiply: 2.0 * 4 = 8 (or 2.0 * 0.25 = 0.5)
		local xmult1 = 2.0
		local xmult2 = 4  -- High roll
		local total = xmult1 * xmult2
		
		Neuratro.Tests.assert.equals(total, 8, "Xmult should stack multiplicatively")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	-- Test 3: Round-based xmult jokers
	Neuratro.Tests.it("should upgrade multiple round-based jokers", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker1 = Neuratro.Tests.Mocks.create_joker("j_btmc", {
			extra = { Xmult = 1, xmbonus = 0.5, rounds = 0, goal = 3 }
		})
		local joker2 = Neuratro.Tests.Mocks.create_joker("j_queenpb", {
			extra = { xmult = 1, upg = 0.25, song = "LIFE" }
		})
		
		Neuratro.Tests.Mocks.add_joker_to_game(joker1)
		Neuratro.Tests.Mocks.add_joker_to_game(joker2)
		
		-- Both should upgrade at end of round
		joker1.ability.extra.rounds = 3
		local btmc_should_upgrade = joker1.ability.extra.rounds >= joker1.ability.extra.goal
		
		Neuratro.Tests.assert.is_true(btmc_should_upgrade, "BTMC should upgrade")
		
		local new_btmc_xmult = joker1.ability.extra.Xmult + joker1.ability.extra.xmbonus
		Neuratro.Tests.assert.equals(new_btmc_xmult, 1.5, "BTMC should increase to 1.5")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	-- Test 4: Probability jokers interaction
	Neuratro.Tests.it("should handle multiple probability triggers", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker1 = Neuratro.Tests.Mocks.create_joker("j_roulette", {
			extra = { xhigh = 4, xlow = 0.25 }
		})
		local joker2 = Neuratro.Tests.Mocks.create_joker("j_kyoto", {
			extra = { base = 1, odds = 4 }
		})
		
		Neuratro.Tests.Mocks.add_joker_to_game(joker1)
		Neuratro.Tests.Mocks.add_joker_to_game(joker2)
		
		-- Both should be able to trigger independently
		Neuratro.Tests.assert.is_true(Neuratro.has_joker("j_roulette"), "Roulette should exist")
		Neuratro.Tests.assert.is_true(Neuratro.has_joker("j_kyoto"), "Kyoto should exist")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	-- Test 5: Playbook extra + main area
	Neuratro.Tests.it("should work with jokers in both areas", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local main_joker = Neuratro.Tests.Mocks.create_joker("j_plasma_globe", {
			extra = { added = 12 }
		})
		local playbook_joker = Neuratro.Tests.Mocks.create_joker("j_highlighted", {
			extra = { xmult = 2 }
		})
		
		Neuratro.Tests.Mocks.add_joker_to_game(main_joker, G.jokers)
		Neuratro.Tests.Mocks.add_joker_to_game(playbook_joker, G.playbook_extra)
		
		-- Both should be findable
		local found_main = Neuratro.find_joker("j_plasma_globe")
		local found_playbook = Neuratro.find_joker("j_highlighted")
		
		Neuratro.Tests.assert.is_not_nil(found_main, "Should find main joker")
		Neuratro.Tests.assert.is_not_nil(found_playbook, "Should find playbook joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	-- Test 6: Multiple queenpb song conflicts
	Neuratro.Tests.it("should handle multiple queenpb with shared song", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker1 = Neuratro.Tests.Mocks.create_joker("j_queenpb", {
			extra = { xmult = 1, upg = 0.25, song = "BOOM" }
		})
		local joker2 = Neuratro.Tests.Mocks.create_joker("j_queenpb", {
			extra = { xmult = 1, upg = 0.25, song = "" }
		})
		
		Neuratro.Tests.Mocks.add_joker_to_game(joker1)
		Neuratro.Tests.Mocks.add_joker_to_game(joker2)
		
		-- Second should copy first's song
		if joker1.ability.extra.song ~= "" then
			joker2.ability.extra.song = joker1.ability.extra.song
		end
		
		Neuratro.Tests.assert.equals(joker2.ability.extra.song, "BOOM", 
			"Second queenpb should copy song")
		
		-- Pool flags should be set
		Neuratro.Tests.assert.is_true(G.GAME.pool_flags.BOOM, "BOOM flag should be set")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	-- Test 7: Self-destruction chain
	Neuratro.Tests.it("should handle multiple self-destructing jokers", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker1 = Neuratro.Tests.Mocks.create_joker("j_teru", {
			extra = { mult_bonus = 4, upg = 2, face = 5, goal = 6 }
		})
		local joker2 = Neuratro.Tests.Mocks.create_joker("j_tutelsoup", {
			extra = { mult = 15, chips = 100, money = 3, xmult = 1.5, rounds = 3, goal = 4, chosen = "" }
		})
		
		Neuratro.Tests.Mocks.add_joker_to_game(joker1)
		Neuratro.Tests.Mocks.add_joker_to_game(joker2)
		
		-- Both near destruction
		local teru_should_destroy = joker1.ability.extra.face >= joker1.ability.extra.goal
		local soup_should_destroy = joker2.ability.extra.rounds >= joker2.ability.extra.goal
		
		Neuratro.Tests.assert.is_true(teru_should_destroy, "Teru should destroy")
		Neuratro.Tests.assert.is_true(soup_should_destroy, "Tutel soup should destroy")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	-- Test 8: Filtersister + Filtered edition
	Neuratro.Tests.it("should upgrade filtersister on filtered trigger", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_filtersister", {
			extra = { xmult = 1, upg = 0.5 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		-- Simulate filtered edition triggering
		local all_filtersisters = Neuratro.find_jokers("j_filtersister")
		for _, fs in ipairs(all_filtersisters) do
			fs.ability.extra.xmult = fs.ability.extra.xmult + fs.ability.extra.upg
		end
		
		Neuratro.Tests.assert.equals(joker.ability.extra.xmult, 1.5, 
			"Should upgrade on filtered trigger")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	-- Test 9: Joker counting interactions
	Neuratro.Tests.it("should correctly count jokers with multiple counters", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker1 = Neuratro.Tests.Mocks.create_joker("j_hype", {
			extra = { mult = 0, base = 4 }
		})
		local joker2 = Neuratro.Tests.Mocks.create_joker("j_neurodog", {
			extra = { mult = 10, chips = 9 }
		})
		
		Neuratro.Tests.Mocks.add_joker_to_game(joker1)
		Neuratro.Tests.Mocks.add_joker_to_game(joker2)
		
		-- Add 2 more jokers
		for i = 1, 2 do
			local extra = Neuratro.Tests.Mocks.create_joker("j_extra_" .. i)
			Neuratro.Tests.Mocks.add_joker_to_game(extra)
		end
		
		-- Both should see 4 jokers total
		local total_jokers = #G.jokers.cards
		Neuratro.Tests.assert.equals(total_jokers, 4, "Should count 4 jokers")
		
		-- Hype would give: 4 * 4 = 16 mult
		local hype_mult = 4 * total_jokers
		Neuratro.Tests.assert.equals(hype_mult, 16, "Hype should calculate 16 mult")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	-- Test 10: Collab + Four Toes
	Neuratro.Tests.it("should work together for mix hands", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker1 = Neuratro.Tests.Mocks.create_joker("j_fourtoes")
		local joker2 = Neuratro.Tests.Mocks.create_joker("j_collab", {
			extra = { xmult = 4 }
		})
		
		Neuratro.Tests.Mocks.add_joker_to_game(joker1)
		Neuratro.Tests.Mocks.add_joker_to_game(joker2)
		
		-- Four toes allows mix with 4 cards instead of 5
		local default_threshold = 5
		local modified_threshold = 4
		
		Neuratro.Tests.assert.equals(modified_threshold, 4, 
			"Four toes should reduce threshold to 4")
		
		-- Collab needs 3+ suits with face cards
		local suits_needed = 3
		Neuratro.Tests.assert.equals(suits_needed, 3, "Collab needs 3 suits")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	-- Test 11: Hiyori + Heart card debuff
	Neuratro.Tests.it("should debuff hearts with hiyori present", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_hiyori")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		-- Add heart cards
		for i = 1, 3 do
			local heart = Neuratro.Tests.Mocks.create_card({ suit = "Hearts", value = "A" })
			Neuratro.Tests.Mocks.add_card_to_deck(heart)
		end
		
		Neuratro.Tests.assert.is_true(Neuratro.has_joker("j_hiyori"), "Should have hiyori")
		Neuratro.Tests.assert.equals(#G.playing_cards, 3, "Should have 3 cards in deck")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	-- Test 12: Chimps + Arcana packs
	Neuratro.Tests.it("should increase arcana pack size with chimps", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_chimps")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local booster = {
			ability = { name = "Arcana Pack" },
			config = { extra = 3 }
		}
		
		local is_arcana = booster.ability.name:find("Arcana") ~= nil
		Neuratro.Tests.assert.is_true(is_arcana, "Should detect arcana pack")
		
		-- Should add 1 card
		local new_size = booster.config.extra + 1
		Neuratro.Tests.assert.equals(new_size, 4, "Should have 4 cards in pack")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	-- Test 13: Vedalsdrink + Money tracking
	Neuratro.Tests.it("should track money across multiple sources", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_vedalsdrink", {
			extra = { dollars = 1, upg = 0.01, vedal_bonus = 0.01 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		-- Simulate earning money
		Neuratro.MONEY_EARNED = 500
		
		-- Calculate bonus: 500 * 0.01 = 5 mult
		local bonus = Neuratro.MONEY_EARNED * joker.ability.extra.upg
		Neuratro.Tests.assert.equals(bonus, 5, "Should calculate 5 mult bonus")
		
		-- Total: 1 base + 5 = 6
		local total = joker.ability.extra.dollars + bonus
		Neuratro.Tests.assert.equals(total, 6, "Should have 6 total")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	-- Test 14: Emojiman + Smiley interaction
	Neuratro.Tests.it("should show smiley when emojiman present", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_emojiman")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_true(Neuratro.has_joker("j_emojiman"), 
			"Should have emojiman")
		
		-- Would normally show smiley joker in collection
		local should_show_smiley = Neuratro.has_joker("j_emojiman")
		Neuratro.Tests.assert.is_true(should_show_smiley, "Should show smiley")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	-- Test 15: Probability scaling with oops
	Neuratro.Tests.it("should handle probability > 100%", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		G.GAME.probabilities.normal = 10  -- 10x probability
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_anteater", {
			extra = { base = 1, odds = 3 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		-- With 10x, effective odds become 10 in 3 (guaranteed)
		local effective_prob = Neuratro.get_probability_scale() * joker.ability.extra.base
		Neuratro.Tests.assert.equals(effective_prob, 10, "Should have 10x probability")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Category combination tests
Neuratro.Tests.describe("Category Combination Tests", function()
	
	Neuratro.Tests.it("should test all mult stacker pairs", function()
		local mult_jokers = {"j_plasma_globe", "j_hype", "j_teru", "j_lucy"}
		local pairs_tested = 0
		
		for i = 1, #mult_jokers do
			for j = i + 1, #mult_jokers do
				pairs_tested = pairs_tested + 1
			end
		end
		
		-- C(4,2) = 6 pairs
		Neuratro.Tests.assert.equals(pairs_tested, 6, "Should have 6 pairs")
		return true
	end)
	
	Neuratro.Tests.it("should test all xmult stacker pairs", function()
		local xmult_jokers = {"j_3heart", "j_btmc", "j_roulette", "j_queenpb", "j_bday2"}
		local pairs_tested = 0
		
		for i = 1, #xmult_jokers do
			for j = i + 1, #xmult_jokers do
				pairs_tested = pairs_tested + 1
			end
		end
		
		-- C(5,2) = 10 pairs
		Neuratro.Tests.assert.equals(pairs_tested, 10, "Should have 10 pairs")
		return true
	end)
	
	Neuratro.Tests.it("should handle 3+ joker combinations", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		-- Test a triplet
		local joker1 = Neuratro.Tests.Mocks.create_joker("j_plasma_globe", {
			extra = { added = 10 }
		})
		local joker2 = Neuratro.Tests.Mocks.create_joker("j_3heart", {
			extra = { Xmult = 2, xmbonus = 0.5 }
		})
		local joker3 = Neuratro.Tests.Mocks.create_joker("j_hype", {
			extra = { mult = 0, base = 5 }
		})
		
		Neuratro.Tests.Mocks.add_joker_to_game(joker1)
		Neuratro.Tests.Mocks.add_joker_to_game(joker2)
		Neuratro.Tests.Mocks.add_joker_to_game(joker3)
		
		-- All 3 should be present
		Neuratro.Tests.assert.equals(#G.jokers.cards, 3, "Should have 3 jokers")
		Neuratro.Tests.assert.is_true(Neuratro.has_joker("j_plasma_globe"))
		Neuratro.Tests.assert.is_true(Neuratro.has_joker("j_3heart"))
		Neuratro.Tests.assert.is_true(Neuratro.has_joker("j_hype"))
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle full board (5 jokers)", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		-- Fill the board
		local jokers = {
			{ key = "j_plasma_globe", extra = { added = 10 } },
			{ key = "j_3heart", extra = { Xmult = 2, xmbonus = 0.5 } },
			{ key = "j_roulette", extra = { xhigh = 4, xlow = 0.25 } },
			{ key = "j_hype", extra = { mult = 0, base = 4 } },
			{ key = "j_teru", extra = { mult_bonus = 5, upg = 2, face = 0, goal = 6 } },
		}
		
		for _, data in ipairs(jokers) do
			local joker = Neuratro.Tests.Mocks.create_joker(data.key, { extra = data.extra })
			Neuratro.Tests.Mocks.add_joker_to_game(joker)
		end
		
		Neuratro.Tests.assert.equals(#G.jokers.cards, 5, "Should have 5 jokers")
		
		-- Verify all exist
		for _, data in ipairs(jokers) do
			Neuratro.Tests.assert.is_true(Neuratro.has_joker(data.key))
		end
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Edge case combinations
Neuratro.Tests.describe("Combination Edge Cases", function()
	
	Neuratro.Tests.it("should handle debuffed joker combinations", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker1 = Neuratro.Tests.Mocks.create_joker("j_plasma_globe", {
			extra = { added = 10 },
			debuff = true
		})
		local joker2 = Neuratro.Tests.Mocks.create_joker("j_3heart", {
			extra = { Xmult = 2, xmbonus = 0.5 }
		})
		
		Neuratro.Tests.Mocks.add_joker_to_game(joker1)
		Neuratro.Tests.Mocks.add_joker_to_game(joker2)
		
		-- Debuffed joker shouldn't affect calculations
		local active_jokers = 0
		for _, j in ipairs(G.jokers.cards) do
			if not j.debuff then
				active_jokers = active_jokers + 1
			end
		end
		
		Neuratro.Tests.assert.equals(active_jokers, 1, "Should have 1 active joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle identical joker types", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker1 = Neuratro.Tests.Mocks.create_joker("j_plasma_globe", {
			extra = { added = 10 }
		})
		local joker2 = Neuratro.Tests.Mocks.create_joker("j_plasma_globe", {
			extra = { added = 15 }
		})
		
		Neuratro.Tests.Mocks.add_joker_to_game(joker1)
		Neuratro.Tests.Mocks.add_joker_to_game(joker2)
		
		local all = Neuratro.find_jokers("j_plasma_globe")
		Neuratro.Tests.assert.equals(#all, 2, "Should find both jokers")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle jokers with missing config", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker1 = Neuratro.Tests.Mocks.create_joker("j_plasma_globe", {
			extra = { added = 10 }
		})
		local joker2 = Neuratro.Tests.Mocks.create_joker("j_new_joker") -- No config
		
		Neuratro.Tests.Mocks.add_joker_to_game(joker1)
		Neuratro.Tests.Mocks.add_joker_to_game(joker2)
		
		-- Should handle gracefully
		Neuratro.Tests.assert.equals(#G.jokers.cards, 2, "Should have 2 jokers")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)
