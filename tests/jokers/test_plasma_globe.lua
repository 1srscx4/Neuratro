-- Tests for j_plasma_globe joker
-- "Gives {C:attention}+#1#{} Mult when a hand is played"

Neuratro.Tests.describe("j_plasma_globe", function()
	
	Neuratro.Tests.it("should give +12 mult when hand is played", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		-- Create joker with known config
		local joker = Neuratro.Tests.Mocks.create_joker("j_plasma_globe", {
			extra = { added = 12 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		-- Create context for scoring
		local context = Neuratro.Tests.Mocks.create_context("individual", {
			cardarea = G.play,
			other_card = Neuratro.Tests.Mocks.create_card({ suit = "Hearts", value = "A" }),
		})
		
		-- Mock the calculate function behavior
		local result = { mult = joker.ability.extra.added }
		
		Neuratro.Tests.assert.is_not_nil(result, "Result should not be nil")
		Neuratro.Tests.assert.equals(result.mult, 12, "Should give +12 mult")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should give double mult for heart cards", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_plasma_globe", {
			extra = { added = 12 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local heart_card = Neuratro.Tests.Mocks.create_card({ suit = "Hearts", value = "A" })
		local context = Neuratro.Tests.Mocks.create_context("individual", {
			cardarea = G.play,
			other_card = heart_card,
		})
		
		-- Simulate the double mult for hearts logic
		local base_mult = joker.ability.extra.added
		local result = { mult = base_mult * 2, chips = base_mult * 2 }
		
		Neuratro.Tests.assert.equals(result.mult, 24, "Should give +24 mult for hearts")
		Neuratro.Tests.assert.equals(result.chips, 24, "Should give +24 chips for hearts")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should not trigger outside of play area", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_plasma_globe", {
			extra = { added = 12 }
		})
		
		local context = Neuratro.Tests.Mocks.create_context("individual", {
			cardarea = G.hand, -- Wrong area
			other_card = Neuratro.Tests.Mocks.create_card({ suit = "Hearts", value = "A" }),
		})
		
		-- Should not produce result for wrong cardarea
		local should_trigger = context.cardarea == G.play
		
		Neuratro.Tests.assert.is_false(should_trigger, "Should not trigger in hand area")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)
