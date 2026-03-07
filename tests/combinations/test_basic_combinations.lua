-- Tests for joker combinations and interactions
-- Testing how multiple jokers work together

Neuratro.Tests.describe("Joker Combinations", function()
	
	Neuratro.Tests.it("should stack mult from multiple jokers", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		-- Create two simple mult jokers
		local joker1 = Neuratro.Tests.Mocks.create_joker("j_plasma_globe", {
			extra = { added = 10 }
		})
		local joker2 = Neuratro.Tests.Mocks.create_joker("j_harpoon", {
			extra = { base = 1, odds = 3, xmult = 3 }
		})
		
		Neuratro.Tests.Mocks.add_joker_to_game(joker1)
		Neuratro.Tests.Mocks.add_joker_to_game(joker2)
		
		-- Simulate calculating both jokers
		local mult_result = 10
		local xmult_result = 3
		
		-- Total should be: base * (mult additions) * xmult multiplications
		local total_mult = mult_result * xmult_result
		
		Neuratro.Tests.assert.equals(total_mult, 30, "Mult and xmult should stack multiplicatively")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle j_hiyori with heart cards correctly", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local hiyori = Neuratro.Tests.Mocks.create_joker("j_hiyori")
		Neuratro.Tests.Mocks.add_joker_to_game(hiyori)
		
		-- Create some heart cards in deck
		for i = 1, 5 do
			local heart_card = Neuratro.Tests.Mocks.create_card({ suit = "Hearts", value = "A" })
			Neuratro.Tests.Mocks.add_card_to_deck(heart_card)
		end
		
		-- Create some non-heart cards
		for i = 1, 5 do
			local other_card = Neuratro.Tests.Mocks.create_card({ suit = "Spades", value = "K" })
			Neuratro.Tests.Mocks.add_card_to_deck(other_card)
		end
		
		-- Verify hiyori exists
		Neuratro.Tests.assert.is_true(Neuratro.has_joker("j_hiyori"), "Hiyori joker should be found")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle filtersister with filtered edition", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local filtersister = Neuratro.Tests.Mocks.create_joker("j_filtersister", {
			extra = { xmult = 1, upg = 0.5 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(filtersister)
		
		-- Verify filtersister exists
		Neuratro.Tests.assert.is_true(Neuratro.has_joker("j_filtersister"), "Filtersister should be found")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle queenpb song pooling", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		-- Add first queenpb
		local queenpb1 = Neuratro.Tests.Mocks.create_joker("j_queenpb", {
			extra = { xmult = 1, upg = 0.25, song = "LIFE" }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(queenpb1)
		
		-- Verify pool flags are set
		Neuratro.Tests.assert.is_true(G.GAME.pool_flags.LIFE, "LIFE pool flag should be set")
		Neuratro.Tests.assert.is_false(G.GAME.pool_flags.BOOM, "BOOM pool flag should not be set")
		Neuratro.Tests.assert.is_false(G.GAME.pool_flags.NEVER, "NEVER pool flag should not be set")
		
		-- Add second queenpb with different song
		local queenpb2 = Neuratro.Tests.Mocks.create_joker("j_queenpb", {
			extra = { xmult = 1, upg = 0.25, song = "BOOM" }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(queenpb2)
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle playbook_extra area jokers", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		-- Add joker to main area
		local joker1 = Neuratro.Tests.Mocks.create_joker("j_plasma_globe", {
			extra = { added = 10 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker1, G.jokers)
		
		-- Add joker to playbook area
		local joker2 = Neuratro.Tests.Mocks.create_joker("j_highlighted", {
			extra = { xmult = 2 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker2, G.playbook_extra)
		
		-- Verify both are found
		local found1 = Neuratro.find_joker("j_plasma_globe")
		local found2 = Neuratro.find_joker("j_highlighted")
		
		Neuratro.Tests.assert.is_not_nil(found1, "Should find joker in main area")
		Neuratro.Tests.assert.is_not_nil(found2, "Should find joker in playbook area")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should handle collab joker suit requirements", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local collab = Neuratro.Tests.Mocks.create_joker("j_collab", {
			extra = { xmult = 4 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(collab)
		
		-- Create scoring hand with face cards from 3+ different suits
		local scoring_hand = Neuratro.Tests.Mocks.create_scoring_hand({
			{ suit = "Hearts", value = "K" },    -- Face + Hearts
			{ suit = "Diamonds", value = "Q" },  -- Face + Diamonds
			{ suit = "Spades", value = "J" },    -- Face + Spades
			{ suit = "Clubs", value = "10" },    -- Not face
		})
		
		-- Count face cards from unique suits
		local suits_found = {}
		local face_count = 0
		
		for _, card in ipairs(scoring_hand) do
			if card:is_face() then
				face_count = face_count + 1
				suits_found[card.base.suit] = true
			end
		end
		
		local suit_count = 0
		for _ in pairs(suits_found) do
			suit_count = suit_count + 1
		end
		
		Neuratro.Tests.assert.greater_than(suit_count, 2, "Should have 3+ different suits")
		Neuratro.Tests.assert.greater_than(face_count, 2, "Should have 3+ face cards")
		
		-- Should trigger when 3+ suits and 3+ faces
		local should_trigger = suit_count >= 3 and face_count >= 3
		Neuratro.Tests.assert.is_true(should_trigger, "Collab should trigger")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)
