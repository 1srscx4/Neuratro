
Neuratro = Neuratro or {}

-- Check if a card is a specific suit only (not wild)
function Neuratro.is_suit_only(card, suit)
	return not SMODS.has_any_suit(card) and card:is_suit(suit, true)
end

-- Count cards of a specific suit in a hand
function Neuratro.count_suit(cards, suit, count_wild)
	local count = 0
	for _, card in ipairs(cards) do
		if card:is_suit(suit, count_wild or false) then
			count = count + 1
		end
	end
	return count
end

-- Count unique suits in a set of cards
function Neuratro.get_unique_suits(cards)
	local suits = {}
	for _, card in ipairs(cards) do
		for suit, _ in pairs(SMODS.Suits) do
			if card:is_suit(suit, true) then
				suits[suit] = true
				break
			end
		end
	end
	return suits
end

-- Count number of unique suits in cards
function Neuratro.count_unique_suits(cards)
	local suits = Neuratro.get_unique_suits(cards)
	local count = 0
	for _ in pairs(suits) do
		count = count + 1
	end
	return count
end

-- Count face cards in a hand
function Neuratro.count_face_cards(cards, max)
	local count = 0
	for _, card in ipairs(cards) do
		if card:is_face() then
			count = count + 1
			if max and count >= max then
				break
			end
		end
	end
	return count
end

-- Check if hand has at least N face cards from different suits
function Neuratro.has_face_cards_from_suits(cards, min_face, min_suits)
	local suits_found = {}
	local face_count = 0
	
	for _, card in ipairs(cards) do
		if card:is_face() then
			face_count = face_count + 1
			
			-- Track unique suits
			for suit, _ in pairs(SMODS.Suits) do
				if card:is_suit(suit, true) and not suits_found[suit] then
					suits_found[suit] = true
					break
				end
			end
			
			if face_count >= min_face then
				local suit_count = 0
				for _ in pairs(suits_found) do
					suit_count = suit_count + 1
				end
				if suit_count >= min_suits then
					return true
				end
			end
		end
	end
	
	return false
end

-- Check if all cards in hand are same suit (flush-like check)
function Neuratro.is_flush(cards)
	if #cards < 2 then return true end
	
	local first_suit = nil
	for _, card in ipairs(cards) do
		if not first_suit then
			-- Find first card's suit
			for suit, _ in pairs(SMODS.Suits) do
				if card:is_suit(suit, true) then
					first_suit = suit
					break
				end
			end
		else
			-- Check if card matches first suit
			if not card:is_suit(first_suit, true) then
				return false
			end
		end
	end
	return true
end

-- Check if all cards in hand are different suits (mix-like check)
function Neuratro.is_mix(cards, min_suits)
	min_suits = min_suits or 5
	return Neuratro.count_unique_suits(cards) >= min_suits
end

-- Check if card has specific enhancement
function Neuratro.has_enhancement(card, enhancement)
	return SMODS.has_enhancement(card, enhancement)
end

-- Check if card has specific edition
function Neuratro.has_edition(card, edition)
	return card.edition and card.edition.key == edition
end

-- Check if card has specific seal
function Neuratro.has_seal(card, seal)
	return card.seal == seal
end

-- Get card's effective rank value
function Neuratro.get_card_rank(card)
	return card:get_id()
end

-- Check if card is an Ace
function Neuratro.is_ace(card)
	return card:get_id() == 14
end

-- Check if scoring hand meets criteria for Three of a Kind with specific suit
function Neuratro.is_three_of_a_kind_with_suit(cards, suit)
	if #cards ~= 3 then return false end
	
	local rank = nil
	for _, card in ipairs(cards) do
		if not card:is_suit(suit, true) then
			return false
		end
		if not rank then
			rank = card:get_id()
		elseif card:get_id() ~= rank then
			return false
		end
	end
	return true
end
