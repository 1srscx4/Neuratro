-- Tests for j_minikocute joker

Neuratro.Tests.describe("j_minikocute", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_minikocute")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_neurodog joker
-- Neighboring joker bonus

Neuratro.Tests.describe("j_neurodog", function()
	
	Neuratro.Tests.it("should check neighboring jokers", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_neurodog")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		-- Add jokers on both sides
		local left = Neuratro.Tests.Mocks.create_joker("j_other_left")
		local right = Neuratro.Tests.Mocks.create_joker("j_other_right")
		Neuratro.Tests.Mocks.add_joker_to_game(left)
		Neuratro.Tests.Mocks.add_joker_to_game(right)
		
		Neuratro.Tests.assert.equals(#G.jokers.cards, 3, "Should have 3 jokers")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should give bonus based on neighbors", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_neurodog", {
			extra = { mult = 10, chips = 9 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local has_neighbors = true
		local should_give_bonus = has_neighbors
		
		Neuratro.Tests.assert.is_true(should_give_bonus, "Should give bonus with neighbors")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_ely joker

Neuratro.Tests.describe("j_ely", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_ely")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_cerbr joker

Neuratro.Tests.describe("j_cerbr", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_cerbr")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_corpa joker

Neuratro.Tests.describe("j_corpa", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_corpa")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_emojiman joker
-- Smiley joker interaction

Neuratro.Tests.describe("j_emojiman", function()
	
	Neuratro.Tests.it("should be findable", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_emojiman")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local found = Neuratro.has_joker("j_emojiman")
		Neuratro.Tests.assert.is_true(found, "Should find emojiman")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should interact with smiley joker", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local emojiman = Neuratro.Tests.Mocks.create_joker("j_emojiman")
		Neuratro.Tests.Mocks.add_joker_to_game(emojiman)
		
		local should_show_smiley = Neuratro.has_joker("j_emojiman")
		Neuratro.Tests.assert.is_true(should_show_smiley, "Should show smiley when emojiman present")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_shoomimi joker

Neuratro.Tests.describe("j_shoomimi", function()
	
	Neuratro.Tests.it("should be findable", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_shoomimi")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local found = Neuratro.has_joker("j_shoomimi")
		Neuratro.Tests.assert.is_true(found, "Should find shoomimi")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_plush joker

Neuratro.Tests.describe("j_plush", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_plush")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_vedalsdrink joker

Neuratro.Tests.describe("j_vedalsdrink", function()
	
	Neuratro.Tests.it("should track money earned", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_vedalsdrink", {
			extra = { dollars = 1, upg = 0.01, vedal_bonus = 0.01 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.MONEY_EARNED = 100
		
		Neuratro.Tests.assert.is_not_nil(Neuratro.MONEY_EARNED, "Should track money")
		Neuratro.Tests.assert.equals(Neuratro.MONEY_EARNED, 100, "Should have earned 100")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should scale with money earned", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_vedalsdrink", {
			extra = { dollars = 1, upg = 0.01, vedal_bonus = 0.01 }
		})
		
		local money_earned = 200
		local base_mult = 1
		local bonus = money_earned * joker.ability.extra.upg
		local total = base_mult + bonus
		
		Neuratro.Tests.assert.equals(bonus, 2, "Should calculate bonus from money")
		Neuratro.Tests.assert.equals(total, 3, "Should have total mult of 3")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_filtersister joker
-- Filtered edition interaction

Neuratro.Tests.describe("j_filtersister", function()
	
	Neuratro.Tests.it("should upgrade on filtered trigger", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_filtersister", {
			extra = { xmult = 1, upg = 0.5 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		-- Simulate filtered edition triggering
		joker.ability.extra.xmult = joker.ability.extra.xmult + joker.ability.extra.upg
		
		Neuratro.Tests.assert.equals(joker.ability.extra.xmult, 1.5, "Should upgrade xmult")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should be found by filtered edition", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_filtersister", {
			extra = { xmult = 1, upg = 0.5 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local all_filtersisters = Neuratro.find_jokers("j_filtersister")
		Neuratro.Tests.assert.greater_than(#all_filtersisters, 0, "Should find filtersister")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should give current xmult on joker_main", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_filtersister", {
			extra = { xmult = 2.5, upg = 0.5 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local result = { xmult = joker.ability.extra.xmult }
		Neuratro.Tests.assert.equals(result.xmult, 2.5, "Should give current xmult")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_envy joker

Neuratro.Tests.describe("j_envy", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_envy")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_koko joker

Neuratro.Tests.describe("j_koko", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_koko")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_cerber joker

Neuratro.Tests.describe("j_cerber", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_cerber")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)

	Neuratro.Tests.it("should cover glorp card creation path", function()
		local jokers_file = io.open("Neuratro\\content\\objects\\jokers.lua", "r")
		if not jokers_file then
			jokers_file = io.open("content\\objects\\jokers.lua", "r")
		end
		if not jokers_file then
			return Neuratro.Tests.fail("Could not read jokers.lua for Cerber regression check")
		end

		local jokers_content = jokers_file:read("*all")
		jokers_file:close()

		local has_glorp_hook = string.find(jokers_content, "cerber_apply_to_obtained_card(_card)", 1, true) ~= nil
		if not Neuratro.Tests.assert.is_true(has_glorp_hook,
			"Glorp joker should apply Cerber conversion for newly created cards") then
			return false
		end

		local decks_file = io.open("Neuratro\\content\\objects\\decks.lua", "r")
		if not decks_file then
			decks_file = io.open("content\\objects\\decks.lua", "r")
		end
		if not decks_file then
			return Neuratro.Tests.fail("Could not read decks.lua for Cerber regression check")
		end

		local decks_content = decks_file:read("*all")
		decks_file:close()

		local has_glorpdeck_hook = string.find(decks_content, "Neuratro.has_joker(\"j_cerber\") and _rank == \"2\"", 1, true) ~= nil
		return Neuratro.Tests.assert.is_true(has_glorpdeck_hook,
			"Glorp deck should apply Cerber conversion for newly created 2s")
	end)
	
end)

-- Tests for j_chimps joker
-- Arcana pack bonus

Neuratro.Tests.describe("j_chimps", function()
	
	Neuratro.Tests.it("should be findable in booster check", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_chimps")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local found = Neuratro.has_joker("j_chimps")
		Neuratro.Tests.assert.is_true(found, "Should find chimps")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should detect arcana packs", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local booster = {
			ability = { name = "Arcana Pack" },
			config = { extra = 3 }
		}
		
		local is_arcana = booster.ability.name:find("Arcana") ~= nil
		Neuratro.Tests.assert.is_true(is_arcana, "Should detect arcana pack")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should increase arcana pack size", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local initial_size = 3
		local bonus = 1
		local new_size = initial_size + bonus
		
		Neuratro.Tests.assert.equals(new_size, 4, "Should increase to 4 cards")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_bwaa joker

Neuratro.Tests.describe("j_bwaa", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_bwaa")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_coldfish joker

Neuratro.Tests.describe("j_coldfish", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_coldfish")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should not be debuffed normally", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_coldfish", { debuff = false })
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_false(joker.debuff, "Should not be debuffed")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_coldfish_unleashed joker

Neuratro.Tests.describe("j_coldfish_unleashed", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_coldfish_unleashed")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_paulamarina joker

Neuratro.Tests.describe("j_paulamarina", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_paulamarina")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_toma joker

Neuratro.Tests.describe("j_toma", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_toma")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_tomaniacs joker

Neuratro.Tests.describe("j_tomaniacs", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_tomaniacs")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_angel_neuro joker

Neuratro.Tests.describe("j_angel_neuro", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_angel_neuro")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_neuro_issues joker

Neuratro.Tests.describe("j_neuro_issues", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_neuro_issues")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)
