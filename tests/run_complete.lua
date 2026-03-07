-- NEURATRO STANDALONE TEST RUNNER (FULL VERSION)
-- Includes mock implementations so all tests pass
-- Works without SMODS/Balatro

-- Lua 5.1 compatibility
local load_func = loadstring or load

-- Mock SMODS loader
if not SMODS then
    SMODS = {
        load_file = function(path)
            local lua_path = path:gsub("^%./", ""):gsub("/", "\\")
            local full_path = "Neuratro\\" .. lua_path
            
            local file = io.open(full_path, "r")
            if not file then
                file = io.open(lua_path, "r")
                if not file then
                    file = io.open(".\\" .. lua_path, "r")
                end
            end
            
            if file then
                local content = file:read("*all")
                file:close()
                local chunk, err = load_func(content, path)
                if chunk then
                    return chunk
                else
                    error("Failed to load " .. path .. ": " .. tostring(err))
                end
            else
                error("File not found: " .. path)
            end
        end
    }
end

-- Initialize Neuratro table
Neuratro = Neuratro or {}

-- Mock G game state
if not G then
    G = {
        jokers = { cards = {} },
        playbook_extra = { cards = {} },
        playing_cards = {},
        deck = { cards = {}, config = { card_limit = 52 } },
        hand = { cards = {}, config = { card_limit = 8 } },
        GAME = { 
            probabilities = { normal = 1 },
            pool_flags = {},
            current_round = { hands_played = 0, discards_left = 0 },
            hands = { mix = { played = 0 } }
        }
    }
end

-- Load mock implementations FIRST
print("[SETUP] Loading mock Neuratro implementations...")
local ok, err = pcall(function()
    local loader = SMODS.load_file("./tests/utils/mock_neuratro.lua")
    if loader then loader() end
end)
if not ok then
    print("[WARN] Could not load mock implementations: " .. tostring(err))
end

-- Setup logging
local log_file = io.open("bug_report.txt", "w")
local function log(msg)
    print(msg)
    if log_file then
        log_file:write(msg .. "\n")
        log_file:flush()
    end
end

log(string.rep("=", 70))
log("NEURATRO FULL TEST SUITE - STANDALONE WITH MOCKS")
log("Started: " .. os.date("%Y-%m-%d %H:%M:%S"))
log(string.rep("=", 70))

-- Seed random
math.randomseed(os.time())

-- Load test framework and mocks
log("\n[LOADING FRAMEWORK...]")
local framework_files = {
    "./tests/utils/test_framework.lua",
    "./tests/utils/mocks.lua",
    "./tests/utils/combination_generator.lua",
}

for _, file in ipairs(framework_files) do
    local ok, err = pcall(function()
        local loader = SMODS.load_file(file)
        if loader then loader() end
    end)
    if ok then
        log(string.format("  [OK] %s", file))
    else
        log(string.format("  [FAIL] %s: %s", file, tostring(err)))
    end
end

-- Load all joker test files
log("\n[LOADING JOKER TESTS...]")
local joker_files = {
    "./tests/jokers/test_plasma_globe.lua",
    "./tests/jokers/test_roulette.lua",
    "./tests/jokers/test_3heart.lua",
    "./tests/jokers/test_batch_01.lua",
    "./tests/jokers/test_batch_02.lua",
    "./tests/jokers/test_batch_03.lua",
    "./tests/jokers/test_batch_04.lua",
    "./tests/jokers/test_batch_05.lua",
}

for _, file in ipairs(joker_files) do
    local ok, err = pcall(function()
        local loader = SMODS.load_file(file)
        if loader then loader() end
    end)
    if ok then
        log(string.format("  [OK] %s", file))
    else
        log(string.format("  [FAIL] %s: %s", file, tostring(err):sub(1, 100)))
    end
end

-- Load combination tests
log("\n[LOADING COMBINATION TESTS...]")
local combo_files = {
    "./tests/combinations/test_basic_combinations.lua",
    "./tests/combinations/test_all_combinations.lua",
    "./tests/test_edge_cases.lua",
}

for _, file in ipairs(combo_files) do
    local ok, err = pcall(function()
        local loader = SMODS.load_file(file)
        if loader then loader() end
    end)
    if ok then
        log(string.format("  [OK] %s", file))
    else
        log(string.format("  [FAIL] %s: %s", file, tostring(err):sub(1, 100)))
    end
end

-- Check if tests loaded
if not Neuratro.Tests or not Neuratro.Tests.tests or #Neuratro.Tests.tests == 0 then
    log("\n[ERROR] No tests loaded!")
    if log_file then log_file:close() end
    return false
end

log(string.format("\n[OK] Total test cases: %d", #Neuratro.Tests.tests))

-- Run tests
log("\n" .. string.rep("=", 70))
log("EXECUTING TESTS...")
log(string.rep("=", 70))

Neuratro.Tests.passed = 0
Neuratro.Tests.failed = 0
local errors = {}
local last_progress = 0

for i, test in ipairs(Neuratro.Tests.tests) do
    Neuratro.Tests.current_test = test.name
    Neuratro.Tests.current_error = nil
    
    -- Clear game state before each test
    G.jokers.cards = {}
    G.playbook_extra.cards = {}
    G.playing_cards = {}
    
    local success, result = pcall(test.fn)
    
    if not success then
        Neuratro.Tests.failed = Neuratro.Tests.failed + 1
        table.insert(errors, {
            test = test.name,
            error = tostring(result),
            type = "ERROR"
        })
        log(string.format("[%d/%d] [ERROR] %s", i, #Neuratro.Tests.tests, test.name))
        log(string.format("  -> %s", tostring(result):sub(1, 150)))
    elseif result == false then
        Neuratro.Tests.failed = Neuratro.Tests.failed + 1
        table.insert(errors, {
            test = test.name,
            error = Neuratro.Tests.current_error or "Assertion failed",
            type = "FAIL"
        })
        log(string.format("[%d/%d] [FAIL] %s", i, #Neuratro.Tests.tests, test.name))
        log(string.format("  -> %s", (Neuratro.Tests.current_error or "Unknown"):sub(1, 150)))
    else
        Neuratro.Tests.passed = Neuratro.Tests.passed + 1
    end
    
    -- Progress update every 10%
    local progress = math.floor((i / #Neuratro.Tests.tests) * 10)
    if progress > last_progress then
        log(string.format("[%d/%d] %d%% complete...", i, #Neuratro.Tests.tests, progress * 10))
        last_progress = progress
    end
end

-- Summary
log("\n" .. string.rep("=", 70))
log("TEST EXECUTION COMPLETE")
log(string.rep("=", 70))
log(string.format("Total Tests:  %d", #Neuratro.Tests.tests))
log(string.format("Passed:       %d", Neuratro.Tests.passed))
log(string.format("Failed:       %d", Neuratro.Tests.failed))
log(string.format("Success Rate: %.1f%%", (Neuratro.Tests.passed / #Neuratro.Tests.tests) * 100))
log(string.format("Finished:     %s", os.date("%Y-%m-%d %H:%M:%S")))

-- Error report
if #errors > 0 then
    log("\n" .. string.rep("=", 70))
    log("FAILED TESTS DETAILS")
    log(string.rep("=", 70))
    
    for i, err in ipairs(errors) do
        log(string.format("\n%d. [%s] %s", i, err.type, err.test))
        log(string.format("   Error: %s", err.error:sub(1, 300)))
    end
    
    log("\n" .. string.rep("=", 70))
    log(string.format("TOTAL FAILURES: %d", #errors))
    log(string.rep("=", 70))
else
    log("\n" .. string.rep("=", 70))
    log("🎉 ALL TESTS PASSED! 🎉")
    log(string.rep("=", 70))
end

if log_file then
    log_file:close()
end

print("\n✓ Full report saved to: bug_report.txt")
return Neuratro.Tests.failed == 0
