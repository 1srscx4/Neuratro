-- NEURATRO BACKGROUND TEST RUNNER
-- Run this and it saves all bugs to bug_report.txt
-- Usage: lua run_all_bg.lua

local log_file = io.open("bug_report.txt", "w")
local function log(msg)
    print(msg)
    if log_file then
        log_file:write(msg .. "\n")
        log_file:flush()
    end
end

log(string.rep("=", 70))
log("NEURATRO FULL TEST SUITE - BACKGROUND RUN")
log("Started: " .. os.date("%Y-%m-%d %H:%M:%S"))
log(string.rep("=", 70))

-- Load tests
log("\n[LOADING TESTS...]")
local ok, err = pcall(function()
    assert(SMODS.load_file("./tests/utils/test_framework.lua"))()
    assert(SMODS.load_file("./tests/utils/mocks.lua"))()
    assert(SMODS.load_file("./tests/utils/combination_generator.lua"))()
    assert(SMODS.load_file("./tests/jokers/test_plasma_globe.lua"))()
    assert(SMODS.load_file("./tests/jokers/test_roulette.lua"))()
    assert(SMODS.load_file("./tests/jokers/test_3heart.lua"))()
    assert(SMODS.load_file("./tests/jokers/test_batch_01.lua"))()
    assert(SMODS.load_file("./tests/jokers/test_batch_02.lua"))()
    assert(SMODS.load_file("./tests/jokers/test_batch_03.lua"))()
    assert(SMODS.load_file("./tests/jokers/test_batch_04.lua"))()
    assert(SMODS.load_file("./tests/jokers/test_batch_05.lua"))()
    assert(SMODS.load_file("./tests/combinations/test_basic_combinations.lua"))()
    assert(SMODS.load_file("./tests/combinations/test_all_combinations.lua"))()
    assert(SMODS.load_file("./tests/test_edge_cases.lua"))()
end)

if not ok then
    log("[FATAL] Failed to load tests: " .. tostring(err))
    if log_file then log_file:close() end
    return false
end

log(string.format("[OK] Loaded %d test cases", #Neuratro.Tests.tests))

-- Run all tests
log("\n" .. string.rep("=", 70))
log("RUNNING TESTS...")
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
        table.insert(errors, {
            test = test.name,
            error = result,
            type = "ERROR"
        })
        log(string.format("[%d/%d] [ERROR] %s", i, #Neuratro.Tests.tests, test.name))
        log(string.format("  -> %s", tostring(result)))
    elseif result == false then
        Neuratro.Tests.failed = Neuratro.Tests.failed + 1
        table.insert(errors, {
            test = test.name,
            error = Neuratro.Tests.current_error or "Assertion failed",
            type = "FAIL"
        })
        log(string.format("[%d/%d] [FAIL] %s", i, #Neuratro.Tests.tests, test.name))
        log(string.format("  -> %s", Neuratro.Tests.current_error or "Assertion failed"))
    else
        Neuratro.Tests.passed = Neuratro.Tests.passed + 1
        if i % 50 == 0 then
            log(string.format("[%d/%d] Progress... (last: %s)", i, #Neuratro.Tests.tests, test.name))
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
log(string.format("Finished: %s", os.date("%Y-%m-%d %H:%M:%S")))

-- Bug report
if #errors > 0 then
    log("\n" .. string.rep("=", 70))
    log("BUG REPORT - FAILED TESTS")
    log(string.rep("=", 70))
    
    for _, err in ipairs(errors) do
        log(string.format("\n[%s] %s", err.type, err.test))
        log(string.format("Error: %s", err.error))
    end
    
    log("\n" .. string.rep("=", 70))
    log(string.format("TOTAL BUGS: %d", #errors))
    log(string.rep("=", 70))
else
    log("\n" .. string.rep("=", 70))
    log("✓ ALL TESTS PASSED - NO BUGS FOUND")
    log(string.rep("=", 70))
end

if log_file then
    log_file:close()
end

print("\n[COMPLETE] Results saved to: bug_report.txt")
return Neuratro.Tests.failed == 0
