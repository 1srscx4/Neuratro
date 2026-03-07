-- NEURATRO MOCK IMPLEMENTATIONS
-- Provides standalone versions of Neuratro utilities for testing
-- This allows tests to run without Balatro

Neuratro = Neuratro or {}

-- Only define if not already present
if not Neuratro.find_joker then
    
    -- Mock G if not present
    if not G then
        G = {
            jokers = { cards = {} },
            playbook_extra = { cards = {} },
            playing_cards = {},
            GAME = { probabilities = { normal = 1 } }
        }
    end
    
    -- CONSTANTS
    Neuratro.CONSTANTS = {
        SONGS = { BOOM = "BOOM", LIFE = "LIFE", NEVER = "NEVER" },
        SUITS = { HEARTS = "Hearts", DIAMONDS = "Diamonds", SPADES = "Spades", CLUBS = "Clubs" },
    }
    
    function Neuratro.CONSTANTS.get_all_songs()
        return { "BOOM", "LIFE", "NEVER" }
    end
    
    -- Joker utilities
    function Neuratro.find_joker(joker_key)
        local areas = { G.jokers and G.jokers.cards or {}, G.playbook_extra and G.playbook_extra.cards or {} }
        for _, area in ipairs(areas) do
            for _, joker in ipairs(area) do
                if joker.config and joker.config.center and joker.config.center.key == joker_key then
                    return joker
                end
            end
        end
        return nil
    end
    
    function Neuratro.find_jokers(joker_key)
        local results = {}
        local areas = { G.jokers and G.jokers.cards or {}, G.playbook_extra and G.playbook_extra.cards or {} }
        for _, area in ipairs(areas) do
            for _, joker in ipairs(area) do
                if joker.config and joker.config.center and joker.config.center.key == joker_key then
                    table.insert(results, joker)
                end
            end
        end
        return results
    end
    
    function Neuratro.has_joker(joker_key)
        return Neuratro.find_joker(joker_key) ~= nil
    end
    
    function Neuratro.find_joker_undebuffed(joker_key)
        local joker = Neuratro.find_joker(joker_key)
        return joker and not joker.debuff and joker
    end
    
    function Neuratro.count_cards(condition_fn)
        if not G.playing_cards then return 0 end
        local count = 0
        for _, card in ipairs(G.playing_cards) do
            if condition_fn(card) then
                count = count + 1
            end
        end
        return count
    end
    
    -- Probability utilities
    function Neuratro.get_probability_scale()
        return (G and G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal) or 1
    end
    
    function Neuratro.get_probability_vars(base, odds)
        return {
            (base or 1) * Neuratro.get_probability_scale(),
            odds or 1
        }
    end
    
    function Neuratro.roll_with_odds(base, odds, seed)
        local safe_odds = tonumber(odds) or 0
        if safe_odds <= 0 then return false end
        local chance = (math.max(0, base or 0) * Neuratro.get_probability_scale()) / safe_odds
        return math.random() <= math.min(chance, 1)
    end
    
    function Neuratro.coin_flip(seed)
        return math.random(1, 2) == 1
    end
    
    -- Card analysis
    function Neuratro.count_unique_suits(cards)
        local suits = {}
        for _, card in ipairs(cards) do
            if card.base and card.base.suit then
                suits[card.base.suit] = true
            end
        end
        local count = 0
        for _ in pairs(suits) do count = count + 1 end
        return count
    end
    
    function Neuratro.count_face_cards(cards, max)
        local count = 0
        for _, card in ipairs(cards) do
            if card.is_face and card:is_face() then
                count = count + 1
                if max and count >= max then break end
            end
        end
        return count
    end
    
    function Neuratro.count_suit(cards, suit, count_wild)
        local count = 0
        for _, card in ipairs(cards) do
            if card:is_suit(suit, count_wild) then
                count = count + 1
            end
        end
        return count
    end
    
    function Neuratro.is_flush(cards)
        if #cards < 2 then return true end
        local first_suit = nil
        for _, card in ipairs(cards) do
            if not first_suit then
                first_suit = card.base and card.base.suit
            elseif card.base and card.base.suit ~= first_suit then
                return false
            end
        end
        return true
    end
    
    -- Random utilities
    function Neuratro.random_song(seed)
        local songs = Neuratro.CONSTANTS.get_all_songs()
        return songs[math.random(1, #songs)]
    end
    
    function Neuratro.random_suit(seed)
        local suits = { "Hearts", "Diamonds", "Spades", "Clubs" }
        return suits[math.random(1, #suits)]
    end
    
    function Neuratro.random_xmult_high_low(high, low, seed)
        return math.random(1, 2) == 1 and high or low
    end
    
    -- Safety utilities
    function Neuratro.safe_access(...)
        local args = {...}
        local default = args[#args]
        local path_length = #args - 1
        
        if path_length == 0 then return default end
        
        local current = args[1]
        if current == nil then return default end
        
        for i = 2, path_length do
            local key = args[i]
            if type(current) ~= "table" or current[key] == nil then
                return default
            end
            current = current[key]
        end
        
        return current
    end
    
    function Neuratro.is_game_ready()
        return G ~= nil and G.GAME ~= nil
    end

    Neuratro.Tests = Neuratro.Tests or {}
    Neuratro.Tests.assert = Neuratro.Tests.assert or {}
    
    -- Assertion helper for tests
    function Neuratro.Tests.assert.is_table(value, message)
        if type(value) ~= "table" then
            Neuratro.Tests.current_error = message or string.format("Expected table, got %s", type(value))
            return false
        end
        return true
    end
    
    print("[INFO] Loaded mock Neuratro implementations for standalone testing")
end
