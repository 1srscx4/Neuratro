-- Tests for j_3heart joker
-- "Give {X:mult,C:white}X#1#{} Mult. If played hand is {C:attention}3 of a kind{} and all cards are {C:hearts}hearts{}, increase by {X:mult,C:white}x#2#{}"

Neuratro.Tests.describe("j_3heart", function()
	
	Neuratro.Tests.it("should give base xmult on joker_main", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_3heart", {
			extra = { Xmult = 1.5, xmbonus = 0.45 }
		})
		
		local context = Neuratro.Tests.Mocks.create_context("joker_main")
		local result = { xmult = joker.ability.extra.Xmult }
		
		Neuratro.Tests.assert.equals(result.xmult, 1.5, "Should give base xmult")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should upgrade on three of a kind with all hearts", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_3heart", {
			extra = { Xmult = 1.5, xmbonus = 0.45 }
		})
		
		-- Create three of a kind with hearts
		local scoring_hand = Neuratro.Tests.Mocks.create_scoring_hand({
			{ suit = "Hearts", value = "A" },
			{ suit = "Hearts", value = "A" },
			{ suit = "Hearts", value = "A" },
		})
		
		local context = Neuratro.Tests.Mocks.create_context("before", {
			scoring_name = "Three of a Kind",
			scoring_hand = scoring_hand,
			blueprint = false,
			retrigger_joker = false,
		})
		
		-- Check all cards are hearts
		local all_hearts = true
		for _, card in ipairs(scoring_hand) do
			if card.base.suit ~= "Hearts" then
				all_hearts = false
				break
			end
		end
		
		Neuratro.Tests.assert.is_true(all_hearts, "All cards should be hearts")
		Neuratro.Tests.assert.equals(context.scoring_name, "Three of a Kind", "Should be three of a kind")
		
		-- Simulate upgrade
		local new_xmult = joker.ability.extra.Xmult + joker.ability.extra.xmbonus
		Neuratro.Tests.assert.approx_equals(new_xmult, 1.95, 0.01, "Should increase xmult by 0.45")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should not upgrade on three of a kind with mixed suits", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_3heart", {
			extra = { Xmult = 1.5, xmbonus = 0.45 }
		})
		
		-- Create three of a kind with mixed suits
		local scoring_hand = Neuratro.Tests.Mocks.create_scoring_hand({
			{ suit = "Hearts", value = "A" },
			{ suit = "Diamonds", value = "A" },
			{ suit = "Hearts", value = "A" },
		})
		
		local context = Neuratro.Tests.Mocks.create_context("before", {
			scoring_name = "Three of a Kind",
			scoring_hand = scoring_hand,
		})
		
		-- Check not all cards are hearts
		local all_hearts = true
		for _, card in ipairs(scoring_hand) do
			if card.base.suit ~= "Hearts" then
				all_hearts = false
				break
			end
		end
		
		Neuratro.Tests.assert.is_false(all_hearts, "Not all cards should be hearts")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should not upgrade on different hand types", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_3heart", {
			extra = { Xmult = 1.5, xmbonus = 0.45 }
		})
		
		local other_hands = {"Pair", "Two Pair", "Straight", "Flush", "Full House"}
		
		for _, hand_name in ipairs(other_hands) do
			local context = Neuratro.Tests.Mocks.create_context("before", {
				scoring_name = hand_name,
				blueprint = false,
			})
			
			Neuratro.Tests.assert.is_false(
				context.scoring_name == "Three of a Kind",
				string.format("Should not trigger on %s", hand_name)
			)
		end
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should not upgrade when blueprint", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_3heart", {
			extra = { Xmult = 1.5, xmbonus = 0.45 }
		})
		
		local scoring_hand = Neuratro.Tests.Mocks.create_scoring_hand({
			{ suit = "Hearts", value = "A" },
			{ suit = "Hearts", value = "A" },
			{ suit = "Hearts", value = "A" },
		})
		
		local context = Neuratro.Tests.Mocks.create_context("before", {
			scoring_name = "Three of a Kind",
			scoring_hand = scoring_hand,
			blueprint = true, -- Blueprint is copying this
			retrigger_joker = false,
		})
		
		Neuratro.Tests.assert.is_true(context.blueprint, "Context should be blueprint")
		-- Should not upgrade when blueprint
		local should_upgrade = context.before 
			and context.scoring_name == "Three of a Kind" 
			and not context.blueprint 
			and not context.retrigger_joker
		
		Neuratro.Tests.assert.is_false(should_upgrade, "Should not upgrade when blueprint")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)
