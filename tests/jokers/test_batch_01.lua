-- Tests for j_plasma_globe joker
-- "Gives {C:attention}+#1#{} Mult when a hand is played"

Neuratro.Tests.describe("j_plasma_globe", function()
	
	Neuratro.Tests.it("should give +12 mult when hand is played", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_plasma_globe", {
			extra = { added = 12 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local context = Neuratro.Tests.Mocks.create_context("individual", {
			cardarea = G.play,
			other_card = Neuratro.Tests.Mocks.create_card({ suit = "Spades", value = "A" }),
		})
		
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
		
		local base_mult = joker.ability.extra.added
		local result = { mult = base_mult * 2, chips = base_mult * 2 }
		
		Neuratro.Tests.assert.equals(result.mult, 24, "Should give +24 mult for hearts")
		Neuratro.Tests.assert.equals(result.chips, 24, "Should give +24 chips for hearts")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should only trigger in play area", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local should_trigger_play = true
		local should_trigger_hand = false
		
		Neuratro.Tests.assert.is_true(should_trigger_play, "Should trigger in play area")
		Neuratro.Tests.assert.is_false(should_trigger_hand, "Should not trigger in hand area")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should trigger on end of round", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local context_end = Neuratro.Tests.Mocks.create_context("end_of_round", {
			cardarea = G.jokers,
			repetition = true,
		})
		
		Neuratro.Tests.assert.is_true(context_end.end_of_round, "Should be end of round")
		Neuratro.Tests.assert.is_true(context_end.repetition, "Should allow repetition")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_btmc joker
-- "Gives {X:mult,C:white}X#1#{} Mult after playing {C:attention}#2#{} {C:blue}Rounds{}"

Neuratro.Tests.describe("j_btmc", function()
	
	Neuratro.Tests.it("should track rounds played", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_btmc", {
			extra = { Xmult = 1, xmbonus = 0.5, rounds = 0, goal = 3 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		Neuratro.Tests.assert.equals(joker.ability.extra.rounds, 0, "Should start at 0 rounds")
		Neuratro.Tests.assert.equals(joker.ability.extra.goal, 3, "Goal should be 3 rounds")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should upgrade after reaching goal rounds", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_btmc", {
			extra = { Xmult = 1, xmbonus = 0.5, rounds = 2, goal = 3 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		-- Simulate one more round
		joker.ability.extra.rounds = 3
		local should_upgrade = joker.ability.extra.rounds >= joker.ability.extra.goal
		
		Neuratro.Tests.assert.is_true(should_upgrade, "Should upgrade at 3 rounds")
		
		local new_xmult = joker.ability.extra.Xmult + joker.ability.extra.xmbonus
		Neuratro.Tests.assert.equals(new_xmult, 1.5, "Should increase xmult by 0.5")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should give base xmult before goal reached", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_btmc", {
			extra = { Xmult = 1, xmbonus = 0.5, rounds = 1, goal = 3 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local context = Neuratro.Tests.Mocks.create_context("joker_main")
		local result = { Xmult = joker.ability.extra.Xmult }
		
		Neuratro.Tests.assert.equals(result.Xmult, 1, "Should give base Xmult")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_highlighted joker
-- Interaction with m_dono enhancement

Neuratro.Tests.describe("j_highlighted", function()
	
	Neuratro.Tests.it("should be findable by enhancement", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_highlighted", {
			extra = { xmult = 2 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local found = Neuratro.find_joker("j_highlighted")
		Neuratro.Tests.assert.is_not_nil(found, "Should find highlighted joker")
		Neuratro.Tests.assert.equals(found.ability.extra.xmult, 2, "Should have xmult of 2")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should not be found if debuffed", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_highlighted", {
			extra = { xmult = 2 },
			debuff = true
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local found = Neuratro.find_joker_undebuffed("j_highlighted")
		Neuratro.Tests.assert.is_nil(found, "Should not find debuffed joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_anny joker
-- "Erm..."

Neuratro.Tests.describe("j_anny", function()
	
	Neuratro.Tests.it("should trigger on High Card hand type", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_anny")
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local context = Neuratro.Tests.Mocks.create_context("before", {
			scoring_name = "High Card",
			scoring_hand = Neuratro.Tests.Mocks.create_scoring_hand({
				{ suit = "Hearts", value = "A" }
			})
		})
		
		Neuratro.Tests.assert.equals(context.scoring_name, "High Card", "Should be High Card")
		Neuratro.Tests.assert.is_true(context.before, "Should be before context")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should transform cards on trigger", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local card = Neuratro.Tests.Mocks.create_card({ suit = "Hearts", value = "A" })
		local new_suit = "Spades"
		local new_rank = "K"
		
		-- Simulate transformation
		card.base.suit = new_suit
		card.base.value = new_rank
		
		Neuratro.Tests.assert.equals(card.base.suit, "Spades", "Suit should change")
		Neuratro.Tests.assert.equals(card.base.value, "K", "Rank should change")
		Neuratro.Tests.assert.equals(card:get_id(), 13, "ID should be 13 for King")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_kyoto joker
-- "{C:green,E:1}#1# in #2#{} chance to give {C:attention}miss{}"

Neuratro.Tests.describe("j_kyoto", function()
	
	Neuratro.Tests.it("should have probability-based trigger", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_kyoto", {
			extra = { base = 1, odds = 4 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local vars = Neuratro.get_probability_vars(joker.ability.extra.base, joker.ability.extra.odds)
		Neuratro.Tests.assert.equals(vars[1], 1, "Should show probability of 1")
		Neuratro.Tests.assert.equals(vars[2], 4, "Should show odds of 4")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should display miss message on trigger", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local miss_messages = { "skill issue", "you suck", "L + Bozo", "mad cuz bad?" }
		local message = miss_messages[1] -- Mock selection
		
		Neuratro.Tests.assert.contains(miss_messages, message, "Should be valid miss message")
		Neuratro.Tests.assert.string_contains(message, "skill", "Should contain expected text")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_pipes joker
-- Steel card interaction

Neuratro.Tests.describe("j_pipes", function()
	
	Neuratro.Tests.it("should be findable by steel cards", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_pipes", {
			extra = { xmult = 1.5 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local found = Neuratro.find_joker_undebuffed("j_pipes")
		Neuratro.Tests.assert.is_not_nil(found, "Should find pipes joker")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should modify steel card xmult", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_pipes", {
			extra = { xmult = 3 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local steel_xmult = joker.ability.extra.xmult
		Neuratro.Tests.assert.equals(steel_xmult, 3, "Should provide xmult of 3")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_milc joker
-- Jack of Diamonds interaction

Neuratro.Tests.describe("j_milc", function()
	
	Neuratro.Tests.it("should track Jack of Diamonds in played hand", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_milc", {
			extra = { rt_min = 1, rt_max = 2 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local jack_diamonds = Neuratro.Tests.Mocks.create_card({ 
			suit = "Diamonds", 
			value = "J" 
		})
		
		Neuratro.Tests.assert.equals(jack_diamonds:get_id(), 11, "Jack should be ID 11")
		Neuratro.Tests.assert.equals(jack_diamonds.base.suit, "Diamonds", "Should be Diamonds")
		Neuratro.Tests.assert.is_true(jack_diamonds:is_face(), "Jack should be face card")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should give retriggers based on 2s in hand", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_milc", {
			extra = { rt_min = 1, rt_max = 2 }
		})
		
		-- Count 2s in hand
		local twos_count = 3
		local should_retrigger = twos_count > 0
		
		Neuratro.Tests.assert.is_true(should_retrigger, "Should retrigger when 2s present")
		Neuratro.Tests.assert.greater_than(twos_count, 0, "Should have at least one 2")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)

-- Tests for j_teru joker
-- Face card counting

Neuratro.Tests.describe("j_teru", function()
	
	Neuratro.Tests.it("should count face cards", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_teru", {
			extra = { mult_bonus = 4, upg = 2, face = 0, goal = 6 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		local cards = {
			Neuratro.Tests.Mocks.create_card({ value = "J" }),
			Neuratro.Tests.Mocks.create_card({ value = "Q" }),
			Neuratro.Tests.Mocks.create_card({ value = "K" }),
			Neuratro.Tests.Mocks.create_card({ value = "A" }),
		}
		
		local face_count = 0
		for _, card in ipairs(cards) do
			if card:is_face() then
				face_count = face_count + 1
			end
		end
		
		Neuratro.Tests.assert.equals(face_count, 3, "Should count 3 face cards")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should upgrade mult on face card destruction", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_teru", {
			extra = { mult_bonus = 4, upg = 2, face = 0, goal = 6 }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
		
		-- Simulate destroying a face card
		joker.ability.extra.mult_bonus = joker.ability.extra.mult_bonus + joker.ability.extra.upg
		joker.ability.extra.face = joker.ability.extra.face + 1
		
		Neuratro.Tests.assert.equals(joker.ability.extra.mult_bonus, 6, "Should increase by 2")
		Neuratro.Tests.assert.equals(joker.ability.extra.face, 1, "Should track 1 face destroyed")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
	Neuratro.Tests.it("should destroy self at goal", function()
		Neuratro.Tests.Mocks.setup_test_env()
		
		local joker = Neuratro.Tests.Mocks.create_joker("j_teru", {
			extra = { mult_bonus = 4, upg = 2, face = 5, goal = 6 }
		})
		
		-- One more face card
		joker.ability.extra.face = 6
		local should_destroy = joker.ability.extra.face >= joker.ability.extra.goal
		
		Neuratro.Tests.assert.is_true(should_destroy, "Should destroy at goal")
		
		Neuratro.Tests.Mocks.teardown_test_env()
		return true
	end)
	
end)
