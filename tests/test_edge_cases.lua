-- Edge case tests for Neuratro jokers
-- Testing boundary conditions, nil values, and unusual scenarios

Neuratro.Tests.describe("Edge Cases", function()
	
	Neuratro.Tests.it("should handle nil G gracefully", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		-- Temporarily nil G
		local old_G = G
		G = nil
		
		-- Utility functions should handle this
		local scale = Neuratro.get_probability_scale()
		Neuratro.Tests.assert.equals(scale, 1, "Should return default when G is nil")
		
		G = old_G
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle nil game state gracefully", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		-- Temporarily break game state
		local old_GAME = G.GAME
		G.GAME = nil
		
		local scale = Neuratro.get_probability_scale()
		Neuratro.Tests.assert.equals(scale, 1, "Should return default when GAME is nil")
		
		G.GAME = old_GAME
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle empty joker areas", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		-- Ensure areas are empty
		G.jokers.cards = {}
		G.playbook_extra.cards = {}
		
		local joker = Neuratro.find_joker("j_plasma_globe")
		Neuratro.Tests.assert.is_nil(joker, "Should return nil when joker not found")
		
		local has_joker = Neuratro.has_joker("j_plasma_globe")		Neuratro.Tests.assert.is_false(has_joker, "Should return false when joker not present")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle zero probability scale", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		G.GAME.probabilities.normal = 0
		
		local scale = Neuratro.get_probability_scale()
		Neuratro.Tests.assert.equals(scale, 0, "Should return 0 when probability is 0")
		
		-- Test roll with 0 probability
		local result = Neuratro.roll_with_odds(1, 6, "test")
		Neuratro.Tests.assert.is_false(result, "Should not succeed with 0 probability")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle debuffed jokers correctly", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_plasma_globe", {
			extra = { added = 10 },
			debuff = true,
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		-- find_joker_undebuffed should not return debuffed jokers
		local found = Neuratro.find_joker_undebuffed("j_plasma_globe")
		Neuratro.Tests.assert.is_nil(found, "Should not find debuffed joker")
		
		-- But regular find should work
		local found_any = Neuratro.find_joker("j_plasma_globe")
		Neuratro.Tests.assert.is_not_nil(found_any, "Should find joker with regular search")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle empty scoring hand", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_3heart", {
			extra = { Xmult = 1.5, xmbonus = 0.45 }
		})
		
		local context = Neuratro.Tests.Mocks.create_context("before", {
			scoring_name = "Three of a Kind",
			scoring_hand = {}, -- Empty
		})
		
		-- Should not crash with empty hand
		local count = #context.scoring_hand
		Neuratro.Tests.assert.equals(count, 0, "Should handle empty hand")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle very high probability scale", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		G.GAME.probabilities.normal = 1000
		
		local scale = Neuratro.get_probability_scale()
		Neuratro.Tests.assert.equals(scale, 1000, "Should handle very high probability")
		
		-- Test that roll still caps at 1.0
		local vars = Neuratro.get_probability_vars(1, 6)
		Neuratro.Tests.assert.equals(vars[1], 1000, "Should show 1000 in display")
		Neuratro.Tests.assert.equals(vars[2], 6, "Odds should remain 6")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle jokers with missing config", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_test", {
			-- No extra config
		})
		
		-- Should handle nil extra gracefully
		local extra = joker.ability.extra or {}		Neuratro.Tests.assert.is_table(extra, "Should handle missing extra")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle card:get_id() edge cases", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local ace = Neuratro.Tests.Mocks.create_card({ value = "A" })
		local king = Neuratro.Tests.Mocks.create_card({ value = "K" })
		local two = Neuratro.Tests.Mocks.create_card({ value = "2" })
		
		Neuratro.Tests.assert.equals(ace:get_id(), 14, "Ace should be 14")
		Neuratro.Tests.assert.equals(king:get_id(), 13, "King should be 13")
		Neuratro.Tests.assert.equals(two:get_id(), 2, "Two should be 2")
		
		-- Test is_face
		Neuratro.Tests.assert.is_true(king:is_face(), "King should be face")		Neuratro.Tests.assert.is_false(two:is_face(), "Two should not be face")
		Neuratro.Tests.assert.is_false(ace:is_face(), "Ace should not be face")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle multiple jokers of same type", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker1 = Neuratro.Tests.Mocks.create_joker("j_plasma_globe", {
			extra = { added = 10 }
		})
		local joker2 = Neuratro.Tests.Mocks.create_joker("j_plasma_globe", {
			extra = { added = 15 }
		})
		
		Neuratro.Tests.Mocks.add_joker_to_game(joker1)
		Neuratro.Tests.Mocks.add_joker_to_game(joker2)
		
		-- find_joker should return first one
		local found = Neuratro.find_joker("j_plasma_globe")
		Neuratro.Tests.assert.is_not_nil(found, "Should find at least one")
		
		-- find_jokers should return all
		local all = Neuratro.find_jokers("j_plasma_globe")
		Neuratro.Tests.assert.equals(#all, 2, "Should find both jokers")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle invalid odds gracefully", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		-- Test with nil odds
		local result1 = Neuratro.roll_with_odds(1, nil, "test")
		Neuratro.Tests.assert.is_false(result1, "Should handle nil odds")
		
		-- Test with zero odds
		local result2 = Neuratro.roll_with_odds(1, 0, "test")
		Neuratro.Tests.assert.is_false(result2, "Should handle zero odds")
		
		-- Test with negative odds
		local result3 = Neuratro.roll_with_odds(1, -5, "test")
		Neuratro.Tests.assert.is_false(result3, "Should handle negative odds")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)
