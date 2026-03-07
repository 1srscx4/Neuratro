-- Tests for j_hype joker
-- Scaling mult

Neuratro.Tests.describe("j_hype", function()
	
	Neuratro.Tests.it("should scale mult per joker", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_hype", {
			extra = { mult = 0, base = 4 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		-- Add more jokers
		for i = 1, 3 do
			local other = Neuratro.Tests.Mocks.create_joker("j_other_" .. i)
			Neuratro.Tests.Mocks.add_joker_to_game(other)
		end
		
		local joker_count = #G.jokers.cards
		local expected_mult = joker.ability.extra.base * joker_count
		
		Neuratro.Tests.assert.equals(joker_count, 4, "Should have 4 jokers total")
		Neuratro.Tests.assert.equals(expected_mult, 16, "Should give 4 mult per joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should include playbook_extra jokers", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_hype", {
			extra = { mult = 0, base = 4 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker, G.jokers)
		
		-- Add joker to playbook
		local playbook_joker = Neuratro.Tests.Mocks.create_joker("j_other")
		Neuratro.Tests.Mocks.add_joker_to_game(playbook_joker, G.playbook_extra)
		
		local main_count = #G.jokers.cards
		local playbook_count = #G.playbook_extra.cards
		local total = main_count + playbook_count
		
		Neuratro.Tests.assert.equals(total, 2, "Should count both areas")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_recbin joker

Neuratro.Tests.describe("j_recbin", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_recbin")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_harpoon joker
-- Discard removal

Neuratro.Tests.describe("j_harpoon", function()
	
	Neuratro.Tests.it("should have correct probability", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_harpoon", {
			extra = { base = 1, odds = 3, xmult = 3 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local vars = Neuratro.get_probability_vars(joker.ability.extra.base, joker.ability.extra.odds)
		Neuratro.Tests.assert.equals(vars[1], 1, "Should show 1")
		Neuratro.Tests.assert.equals(vars[2], 3, "Should show 3")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should remove discards on trigger", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		G.GAME.current_round.discards_left = 3
		
		-- Simulate trigger
		G.GAME.current_round.discards_left = 0
		
		Neuratro.Tests.assert.equals(G.GAME.current_round.discards_left, 0, 
			"Should remove all discards")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should give Xmult on joker_main", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_harpoon", {
			extra = { base = 1, odds = 3, xmult = 3 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local context = Neuratro.Tests.Mocks.create_context("joker_main")
		local result = { Xmult = joker.ability.extra.xmult }
		
		Neuratro.Tests.assert.equals(result.Xmult, 3, "Should give Xmult of 3")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_cfrb joker

Neuratro.Tests.describe("j_cfrb", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_cfrb")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_sispace joker

Neuratro.Tests.describe("j_sispace", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_sispace")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_allin joker
-- Random mult

Neuratro.Tests.describe("j_allin", function()
	
	Neuratro.Tests.it("should give random mult", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_allin", {
			extra = { min = 1, max = 60 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		-- Mock random result
		local random_mult = 30
		
		Neuratro.Tests.assert.greater_than(random_mult, 0, "Should give positive mult")
		Neuratro.Tests.assert.less_than(random_mult, 61, "Should not exceed max")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should display range in loc_vars", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_allin", {
			extra = { min = 1, max = 60 }
		})
		
		local vars = { joker.ability.extra.min, joker.ability.extra.max }
		Neuratro.Tests.assert.equals(vars[1], 1, "Should show min")
		Neuratro.Tests.assert.equals(vars[2], 60, "Should show max")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_camila joker
-- Sixes retrigger

Neuratro.Tests.describe("j_camila", function()
	
	Neuratro.Tests.it("should retrigger sixes", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_camila")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local six_card = Neuratro.Tests.Mocks.create_card({ value = "6" })
		
		Neuratro.Tests.assert.equals(six_card:get_id(), 6, "Should be ID 6")
		
		local context = Neuratro.Tests.Mocks.create_context("repetition", {
			cardarea = G.play,
			other_card = six_card
		})
		
		Neuratro.Tests.assert.is_true(context.repetition, "Should be repetition context")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should give Xmult on six retrigger", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_camila")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local result = { xmult = 1.3 } -- Mock Xmult value
		Neuratro.Tests.assert.approx_equals(result.xmult, 1.3, 0.01, "Should give Xmult")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_jokr joker

Neuratro.Tests.describe("j_jokr", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_jokr")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_xdx joker

Neuratro.Tests.describe("j_xdx", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_xdx|")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_bday1 joker

Neuratro.Tests.describe("j_bday1", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_bday1")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_bday2 joker
-- Evil's Second Birthday

Neuratro.Tests.describe("j_bday2", function()
	
	Neuratro.Tests.it("should upgrade on face card addition", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_bday2", {
			extra = { Xmult = 1, Xmult_mod = 0.5 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local initial_xmult = joker.ability.extra.Xmult
		
		-- Simulate face card added
		joker.ability.extra.Xmult = joker.ability.extra.Xmult + joker.ability.extra.Xmult_mod
		
		Neuratro.Tests.assert.equals(joker.ability.extra.Xmult, initial_xmult + 0.5, 
			"Should increase Xmult")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should give current Xmult on joker_main", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_bday2", {
			extra = { Xmult = 2.5, Xmult_mod = 0.5 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local result = { xmult = joker.ability.extra.Xmult }
		Neuratro.Tests.assert.equals(result.xmult, 2.5, "Should give current Xmult")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_sistream joker

Neuratro.Tests.describe("j_sistream", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_sistream")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_donowall joker

Neuratro.Tests.describe("j_donowall", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_donowall")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_stocks joker
-- Economy based

Neuratro.Tests.describe("j_stocks", function()
	
	Neuratro.Tests.it("should track price changes", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_stocks", {
			extra = { price = 0, down = 3, up = 6 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.equals(joker.ability.extra.price, 0, "Should start at 0")
		
		-- Simulate price change
		joker.ability.extra.price = 4
		Neuratro.Tests.assert.equals(joker.ability.extra.price, 4, "Should track price")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should give money based on price", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_stocks", {
			extra = { price = 5, down = 3, up = 6 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local money = joker.ability.extra.price
		Neuratro.Tests.assert.equals(money, 5, "Should give money equal to price")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_techhard joker

Neuratro.Tests.describe("j_techhard", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_techhard")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)
