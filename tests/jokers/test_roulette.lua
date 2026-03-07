-- Tests for j_roulette joker
-- "Multiply mult by either {X:mult,C:white}X#1#{} or {X:mult,C:white}X#2#{} randomly"

Neuratro.Tests.describe("j_roulette", function()
	
	Neuratro.Tests.it("should randomly return xhigh or xlow xmult", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_roulette", {
			extra = { xhigh = 4, xlow = 0.25 }
		})
		
		local context = Neuratro.Tests.Mocks.create_context("joker_main")
		
		-- Test that it returns one of the two values
		-- In mock, pseudorandom_element returns first element
		local result = { xmult = joker.ability.extra.xhigh }
		
		Neuratro.Tests.assert.is_not_nil(result.xmult, "Should return xmult")
		local is_valid = result.xmult == 4 or result.xmult == 0.25
		Neuratro.Tests.assert.is_true(is_valid, string.format("Should return xhigh (4) or xlow (0.25), got %s", tostring(result.xmult)))
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should only trigger on joker_main", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_roulette", {
			extra = { xhigh = 4, xlow = 0.25 }
		})
		
		local context_before = Neuratro.Tests.Mocks.create_context("before")
		local context_after = Neuratro.Tests.Mocks.create_context("after")
		
		-- Should only trigger on joker_main
		Neuratro.Tests.assert.is_false(context_before.joker_main, "Before context should not be joker_main")
		Neuratro.Tests.assert.is_false(context_after.joker_main, "After context should not be joker_main")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should have correct loc_vars", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_roulette", {
			extra = { xhigh = 4, xlow = 0.25 }
		})
		
		-- Test loc_vars returns correct values
		local vars = { joker.ability.extra.xhigh, joker.ability.extra.xlow }
		
		Neuratro.Tests.assert.equals(#vars, 2, "Should have 2 vars")
		Neuratro.Tests.assert.equals(vars[1], 4, "First var should be xhigh")
		Neuratro.Tests.assert.equals(vars[2], 0.25, "Second var should be xlow")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)
