-- NEURATRO TEST WRAPPER
-- Loads actual Neuratro code so tests work properly
-- Run this inside Balatro or with the full mod loaded

print("\n" .. string.rep("=", 70))
print("NEURATRO TEST SUITE - WITH FULL MOD LOADING")
print(string.rep("=", 70))

-- First, ensure Neuratro is loaded
if not Neuratro then
    print("\n[LOADING NEURATRO MOD...]")
    
    -- Load all Neuratro modules in order
    local mod_files = {
        "./modules/utils/constants.lua",
        "./modules/utils/joker_utils.lua",
        "./modules/utils/probability.lua",
        "./modules/utils/card_analysis.lua",
        "./modules/utils/random_utils.lua",
        "./modules/utils/config_builder.lua",
        "./modules/utils/joker_patterns.lua",
        "./modules/utils/safety.lua",
    }
    
    for _, file in ipairs(mod_files) do
        local ok, err = pcall(function()
            assert(SMODS.load_file(file))()
        end)
        if ok then
            print(string.format("  [OK] %s", file))
        else
            print(string.format("  [WARN] %s: %s", file, tostring(err)))
        end
    end
end

-- Check if Neuratro is now available
if not Neuratro then
    print("\n[FATAL] Could not load Neuratro!")
    print("Make sure you're running this inside Balatro with the mod installed.")
    return false
end

print("\n[OK] Neuratro loaded successfully")
print(string.format("  Found %d utility functions", 
    Neuratro.find_joker and 1 or 0 +
    Neuratro.get_probability_scale and 1 or 0 +
    Neuratro.count_cards and 1 or 0
))

-- Now load test framework
print("\n[LOADING TEST FRAMEWORK...]")
assert(SMODS.load_file("./tests/utils/test_framework.lua"))()
assert(SMODS.load_file("./tests/utils/mocks.lua"))()
print("  [OK] Test framework loaded")

-- Load all test files
print("\n[LOADING TEST FILES...]")
local test_files = {
    "./tests/jokers/test_plasma_globe.lua",
    "./tests/jokers/test_roulette.lua",
    "./tests/jokers/test_3heart.lua",
    "./tests/jokers/test_batch_01.lua",
    "./tests/jokers/test_batch_02.lua",
    "./tests/jokers/test_batch_03.lua",
    "./tests/jokers/test_batch_04.lua",
    "./tests/jokers/test_batch_05.lua",
    "./tests/combinations/test_basic_combinations.lua",
    "./tests/combinations/test_all_combinations.lua",
    "./tests/test_edge_cases.lua",
}

local loaded = 0
for _, file in ipairs(test_files) do
    local ok = pcall(function()
        assert(SMODS.load_file(file))()
    end)
    if ok then
        loaded = loaded + 1
        print(string.format("  [OK] %s", file))
    else
        print(string.format("  [FAIL] %s", file))
    end
end

print(string.format("\n[OK] Loaded %d/%d test files", loaded, #test_files))
print(string.format("Total test cases: %d", #Neuratro.Tests.tests))

-- Save results to file
local log_file = io.open("bug_report_full.txt", "w")
local function log(msg)
    print(msg)
    if log_file then
        log_file:write(msg .. "\n")
        log_file:flush()
    end
end

-- Run tests
log("\n" .. string.rep("=", 70))
log("RUNNING ALL TESTS")
log(string.rep("=", 70))

Neuratro.Tests.passed = 0
Neuratro.Tests.failed = 0
local errors = {}

for i, test in ipairs(Neuratro.Tests.tests) do
    Neuratro.Tests.current_test = test.name
    Neuratro.Tests.current_error = nil
    
    local success, result = pcall(test.fn)
    
    if not success then
        Neuratro.Tests.failed = Neuratro.Tests.failed + 1
        table.insert(errors, {test = test.name, error = result, type = "ERROR"})
        log(string.format("[%d/%d] [ERROR] %s", i, #Neuratro.Tests.tests, test.name))
        log(string.format("  -> %s", tostring(result):sub(1, 200)))
    elseif result == false then
        Neuratro.Tests.failed = Neuratro.Tests.failed + 1
        table.insert(errors, {test = test.name, error = Neuratro.Tests.current_error or "Failed", type = "FAIL"})
        log(string.format("[%d/%d] [FAIL] %s", i, #Neuratro.Tests.tests, test.name))
        log(string.format("  -> %s", Neuratro.Tests.current_error or "Assertion failed"))
    else
        Neuratro.Tests.passed = Neuratro.Tests.passed + 1
        if i % 20 == 0 then
            log(string.format("[%d/%d] Progress... (%d passed)", i, #Neuratro.Tests.tests, Neuratro.Tests.passed))
        end
    end
end

-- Summary
log("\n" .. string.rep("=", 70))
log("TEST SUMMARY")
log(string.rep("=", 70))
log(string.format("Total:  %d", #Neuratro.Tests.tests))
log(string.format("Passed: %d", Neuratro.Tests.passed))
log(string.format("Failed: %d", Neuratro.Tests.failed))
log(string.format("Success Rate: %.1f%%", (Neuratro.Tests.passed / #Neuratro.Tests.tests) * 100))

if #errors > 0 then
    log("\n" .. string.rep("=", 70))
    log("FAILED TESTS")
    log(string.rep("=", 70))
    for _, err in ipairs(errors) do
        log(string.format("\n[%s] %s", err.type, err.test))
        log(string.format("Error: %s", err.error:sub(1, 500)))
    end
    log(string.format("\nTOTAL FAILED: %d", #errors))
else
    log("\n" .. string.rep("=", 70))
    log("✓✓✓ ALL TESTS PASSED! ✓✓✓")
    log(string.rep("=", 70))
end

if log_file then log_file:close() end

print("\n[COMPLETE] Full results saved to: bug_report_full.txt")
return Neuratro.Tests.failed == 0
