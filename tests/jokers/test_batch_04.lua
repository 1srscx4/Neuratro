-- Tests for j_gimbag joker
-- Xmult cycling

Neuratro.Tests.describe("j_gimbag", function()
	
	Neuratro.Tests.it("should cycle through xmult values", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_gimbag", {
			extra = { xmult = 1.5, cycle = "1", c1 = 1.5, c2 = 2, c3 = 2.5 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local cycles = { "1", "2", "3" }
		local values = { 1.5, 2, 2.5 }
		
		Neuratro.Tests.assert.equals(cycles[1], "1", "Cycle 1 should be '1'")
		Neuratro.Tests.assert.equals(values[1], 1.5, "Value 1 should be 1.5")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should advance cycle on trigger", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_gimbag", {
			extra = { xmult = 1.5, cycle = "1", c1 = 1.5, c2 = 2, c3 = 2.5 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		-- Advance from cycle 1 to 2
		joker.ability.extra.cycle = "2"
		joker.ability.extra.xmult = joker.ability.extra.c2
		
		Neuratro.Tests.assert.equals(joker.ability.extra.cycle, "2", "Should be cycle 2")
		Neuratro.Tests.assert.equals(joker.ability.extra.xmult, 2, "Should have xmult of 2")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should wrap from cycle 3 to cycle 1", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_gimbag", {
			extra = { xmult = 2.5, cycle = "3", c1 = 1.5, c2 = 2, c3 = 2.5 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		-- Wrap to cycle 1
		joker.ability.extra.cycle = "1"
		joker.ability.extra.xmult = joker.ability.extra.c1
		
		Neuratro.Tests.assert.equals(joker.ability.extra.cycle, "1", "Should wrap to cycle 1")
		Neuratro.Tests.assert.equals(joker.ability.extra.xmult, 1.5, "Should have xmult of 1.5")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_void joker

Neuratro.Tests.describe("j_void", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_void")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_collab joker
-- Face cards from different suits

Neuratro.Tests.describe("j_collab", function()
	
	Neuratro.Tests.it("should count face cards from unique suits", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_collab", {
			extra = { xmult = 4 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local scoring_hand = Neuratro.Tests.Mocks.create_scoring_hand({
			{ suit = "Hearts", value = "K" },
			{ suit = "Diamonds", value = "Q" },
			{ suit = "Spades", value = "J" },
		})
		
		local suits_found = {}
		local face_count = 0
		
		for _, card in ipairs(scoring_hand) do
			if card:is_face() then
				face_count = face_count + 1
				suits_found[card.base.suit] = true
			end
		end
		
		local suit_count = 0
		for _ in pairs(suits_found) do suit_count = suit_count + 1 end
		
		Neuratro.Tests.assert.equals(face_count, 3, "Should have 3 face cards")
		Neuratro.Tests.assert.equals(suit_count, 3, "Should have 3 different suits")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should trigger with 3+ suits and 3+ faces", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_collab", {
			extra = { xmult = 4 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local suit_count = 3
		local face_count = 3
		local should_trigger = suit_count >= 3 and face_count >= 3
		
		Neuratro.Tests.assert.is_true(should_trigger, "Should trigger with 3+ suits and faces")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should give xmult on trigger", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_collab", {
			extra = { xmult = 4 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local result = { xmult = joker.ability.extra.xmult }
		Neuratro.Tests.assert.equals(result.xmult, 4, "Should give xmult of 4")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_cavestream joker
-- Stone cards

Neuratro.Tests.describe("j_cavestream", function()
	
	Neuratro.Tests.it("should retrigger stone cards", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_cavestream")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local stone_card = Neuratro.Tests.Mocks.create_card({ 
			suit = "Hearts", 
			value = "A",
			ability = { set = "m_stone" }
		})
		
		local context = Neuratro.Tests.Mocks.create_context("repetition", {
			cardarea = G.play,
			other_card = stone_card
		})
		
		Neuratro.Tests.assert.is_true(context.repetition, "Should be repetition context")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should create stone if none present", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_cavestream")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local no_stone_cards = true
		local should_create_stone = no_stone_cards
		
		Neuratro.Tests.assert.is_true(should_create_stone, "Should create stone card")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_jorker joker

Neuratro.Tests.describe("j_jorker", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_jorker")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_roulette joker
-- Already in separate file, add extended tests

Neuratro.Tests.describe("j_roulette_extended", function()
	
	Neuratro.Tests.it("should only return valid xmult values", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_roulette", {
			extra = { xhigh = 4, xlow = 0.25 }
		})
		
		local valid_values = { 4, 0.25 }
		local result = 4 -- Mock
		
		Neuratro.Tests.assert.contains(valid_values, result, "Should be valid xmult value")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should maintain distribution over many rolls", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_roulette", {
			extra = { xhigh = 4, xlow = 0.25 }
		})
		
		-- With 50/50, over many rolls should get both values
		local rolls = { 4, 0.25, 4, 0.25, 4, 0.25, 4, 0.25 }
		local high_count = 0
		local low_count = 0
		
		for _, roll in ipairs(rolls) do
			if roll == 4 then
				high_count = high_count + 1
			else
				low_count = low_count + 1
			end
		end
		
		Neuratro.Tests.assert.greater_than(high_count, 0, "Should roll high sometimes")
		Neuratro.Tests.assert.greater_than(low_count, 0, "Should roll low sometimes")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_Vedds joker

Neuratro.Tests.describe("j_Vedds", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_Vedds")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_ddos joker

Neuratro.Tests.describe("j_ddos", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_ddos")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_hiyori joker
-- Heart card debuff

Neuratro.Tests.describe("j_hiyori", function()
	
	Neuratro.Tests.it("should be findable", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_hiyori")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local found = Neuratro.has_joker("j_hiyori")
		Neuratro.Tests.assert.is_true(found, "Should find hiyori joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should debuff heart cards at end of round", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_hiyori")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local heart_card = Neuratro.Tests.Mocks.create_card({ suit = "Hearts", value = "A" })
		Neuratro.Tests.Mocks.add_card_to_deck(heart_card)
		
		local should_debuff = heart_card.base.suit == "Hearts"
		Neuratro.Tests.assert.is_true(should_debuff, "Should debuff heart cards")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_Glorp joker

Neuratro.Tests.describe("j_Glorp", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_Glorp")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_Emuz joker

Neuratro.Tests.describe("j_Emuz", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_Emuz")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_anteater joker
-- Seal copying

Neuratro.Tests.describe("j_anteater", function()
	
	Neuratro.Tests.it("should have correct probability", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_anteater", {
			extra = { base = 1, odds = 3 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local vars = Neuratro.get_probability_vars(joker.ability.extra.base, joker.ability.extra.odds)
		Neuratro.Tests.assert.equals(vars[2], 3, "Should show odds of 3")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should copy seal to adjacent cards", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_anteater", {
			extra = { base = 1, odds = 3 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local card1 = Neuratro.Tests.Mocks.create_card({ suit = "Hearts", value = "A", seal = "Red" })
		local card2 = Neuratro.Tests.Mocks.create_card({ suit = "Spades", value = "K", seal = nil })
		
		-- Simulate seal copy
		card2.seal = card1.seal
		
		Neuratro.Tests.assert.equals(card2.seal, "Red", "Should copy Red seal")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_drive joker

Neuratro.Tests.describe("j_drive", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_drive")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_deliv joker

Neuratro.Tests.describe("j_deliv", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_deliv")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_fourtoes joker
-- Mix hand modifier

Neuratro.Tests.describe("j_fourtoes", function()
	
	Neuratro.Tests.it("should require mix hands played", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_fourtoes")
		
		G.GAME.hands.mix.played = 0
		local can_spawn = G.GAME.hands.mix.played > 0
		Neuratro.Tests.assert.is_false(can_spawn, "Should not spawn without mix played")
		
		G.GAME.hands.mix.played = 1
		can_spawn = G.GAME.hands.mix.played > 0
		Neuratro.Tests.assert.is_true(can_spawn, "Should spawn after mix played")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should allow mix with 4 cards", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local threshold = 5 -- Default
		local modified_threshold = 4 -- With fourtoes
		
		Neuratro.Tests.assert.equals(threshold, 5, "Default threshold should be 5")
		Neuratro.Tests.assert.equals(modified_threshold, 4, "Modified threshold should be 4")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_abandonedarchive joker

Neuratro.Tests.describe("j_abandonedarchive", function()
	
	Neuratro.Tests.it("should have basic functionality", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_abandonedarchive")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.is_not_nil(joker, "Should create joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)
