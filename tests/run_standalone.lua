-- NEURATRO STANDALONE TEST RUNNER
-- Works without SMODS/Balatro - for background testing
-- Compatible with Lua 5.1

-- Lua 5.1 compatibility
local load_func = loadstring or load

-- Mock SMODS if not present
if not SMODS then
    SMODS = {
        load_file = function(path)
            -- Remove leading ./ and convert to proper path
            local lua_path = path:gsub("^%./", ""):gsub("/", "\\")
            local full_path = "Neuratro\\" .. lua_path
            
            local file = io.open(full_path, "r")
            if not file then
                -- Try alternative paths
                file = io.open(lua_path, "r")
                if not file then
                    file = io.open(".\\" .. lua_path, "r")
                end
            end
            
            if file then
                local content = file:read("*all")
                file:close()
                -- Use loadstring for Lua 5.1 compatibility
                local chunk, err = load_func(content, path)
                if chunk then
                    return chunk
                else
                    error("Failed to load " .. path .. ": " .. tostring(err))
                end
            else
                error("File not found: " .. path .. " (tried: " .. full_path .. ")")
            end
        end
    }
end

-- Mock print for logging
local log_file = io.open("bug_report.txt", "w")
local function log(msg)
    print(msg)
    if log_file then
        log_file:write(msg .. "\n")
        log_file:flush()
    end
end

log(string.rep("=", 70))
log("NEURATRO FULL TEST SUITE - STANDALONE RUN")
log("Started: " .. os.date("%Y-%m-%d %H:%M:%S"))
log("Lua Version: " .. (type(_VERSION) == "string" and _VERSION or "unknown"))
log(string.rep("=", 70))

-- Load tests one by one
log("\n[LOADING TESTS...]")

local test_files = {
    "./tests/utils/test_framework.lua",
    "./tests/utils/mocks.lua",
    "./tests/utils/combination_generator.lua",
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

local loaded_count = 0
for _, file in ipairs(test_files) do
    local ok, err = pcall(function()
        local loader = SMODS.load_file(file)
        if loader then loader() end
    end)
    
    if ok then
        loaded_count = loaded_count + 1
        log(string.format("  [OK] %s", file))
    else
        log(string.format("  [FAIL] %s: %s", file, tostring(err)))
    end
end

log(string.format("\n[OK] Loaded %d/%d test modules", loaded_count, #test_files))

-- Check if we have tests
if not Neuratro or not Neuratro.Tests or not Neuratro.Tests.tests then
    log("[ERROR] No tests loaded! Check file paths.")
    if log_file then log_file:close() end
    return false
end

log(string.format("Total test cases: %d", #Neuratro.Tests.tests))

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
