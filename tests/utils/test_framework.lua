-- Neuratro Test Framework
-- Lightweight testing framework for Balatro/Steamodded mods

Neuratro = Neuratro or {}
Neuratro.Tests = {
	tests = {},
	passed = 0,
	failed = 0,
	errors = {},
	current_suite = nil,
}

-- Test result structure
local TestResult = {
	PASSED = "PASSED",
	FAILED = "FAILED",
	ERROR = "ERROR",
}

-- Define a test suite
function Neuratro.Tests.describe(suite_name, fn)
	Neuratro.Tests.current_suite = suite_name
	local success, err = pcall(fn)
	Neuratro.Tests.current_suite = nil
	
	if not success then
		print(string.format("[ERROR] Suite '%s' failed to load: %s", suite_name, tostring(err)))
	end
end

-- Define a test case
function Neuratro.Tests.it(test_name, fn)
	local full_name = Neuratro.Tests.current_suite 
		and string.format("%s: %s", Neuratro.Tests.current_suite, test_name)
		or test_name
	
	table.insert(Neuratro.Tests.tests, {
		name = full_name,
		fn = fn,
	})
end

-- Run all tests
function Neuratro.Tests.run()
	print("\n" .. string.rep("=", 60))
	print("NEURATRO TEST SUITE")
	print(string.rep("=", 60))
	
	Neuratro.Tests.passed = 0
	Neuratro.Tests.failed = 0
	Neuratro.Tests.errors = {}
	
	for i, test in ipairs(Neuratro.Tests.tests) do
		print(string.format("\n[%d/%d] %s", i, #Neuratro.Tests.tests, test.name))
		
		-- Reset test state
		Neuratro.Tests.current_test = test.name
		Neuratro.Tests.current_error = nil
		
		local success, result = pcall(test.fn)
		
		if not success then
			Neuratro.Tests.failed = Neuratro.Tests.failed + 1
			table.insert(Neuratro.Tests.errors, {
				test = test.name,
				error = result,
				type = TestResult.ERROR,
			})
			print(string.format("  [ERROR] %s", tostring(result)))
		elseif result == false then
			Neuratro.Tests.failed = Neuratro.Tests.failed + 1
			local error_msg = Neuratro.Tests.current_error or "Assertion failed"
			table.insert(Neuratro.Tests.errors, {
				test = test.name,
				error = error_msg,
				type = TestResult.FAILED,
			})
			print(string.format("  [FAIL] %s", error_msg))
		else
			Neuratro.Tests.passed = Neuratro.Tests.passed + 1
			print("  [PASS]")
		end
	end
	
	-- Print summary
	print("\n" .. string.rep("=", 60))
	print("TEST SUMMARY")
	print(string.rep("=", 60))
	print(string.format("Total:  %d", #Neuratro.Tests.tests))
	print(string.format("Passed: %d", Neuratro.Tests.passed))
	print(string.format("Failed: %d", Neuratro.Tests.failed))
	print(string.format("Success Rate: %.1f%%", (Neuratro.Tests.passed / #Neuratro.Tests.tests) * 100))
	
	if Neuratro.Tests.failed > 0 then
		print("\nFailed Tests:")
		for _, err in ipairs(Neuratro.Tests.errors) do
			print(string.format("  - %s (%s)", err.test, err.type))
			print(string.format("    %s", err.error))
		end
	end
	
	return Neuratro.Tests.failed == 0
end

-- Assertion helpers
Neuratro.Tests.assert = {}

-- Assert equality
function Neuratro.Tests.assert.equals(actual, expected, message)
	if actual ~= expected then
		local msg = string.format("%s\nExpected: %s\nActual: %s", 
			message or "Values not equal",
			tostring(expected),
			tostring(actual))
		Neuratro.Tests.current_error = msg
		return false
	end
	return true
end

-- Assert truthy
function Neuratro.Tests.assert.is_true(value, message)
	if not value then
		Neuratro.Tests.current_error = message or string.format("Expected true, got %s", tostring(value))
		return false
	end
	return true
end

-- Assert falsy
function Neuratro.Tests.assert.is_false(value, message)
	if value then
		Neuratro.Tests.current_error = message or string.format("Expected false, got %s", tostring(value))
		return false
	end
	return true
end

-- Assert nil
function Neuratro.Tests.assert.is_nil(value, message)
	if value ~= nil then
		Neuratro.Tests.current_error = message or string.format("Expected nil, got %s", tostring(value))
		return false
	end
	return true
end

-- Assert not nil
function Neuratro.Tests.assert.is_not_nil(value, message)
	if value == nil then
		Neuratro.Tests.current_error = message or "Expected non-nil value"
		return false
	end
	return true
end

-- Assert greater than
function Neuratro.Tests.assert.greater_than(value, threshold, message)
	if value <= threshold then
		Neuratro.Tests.current_error = message or string.format("Expected %s > %s", tostring(value), tostring(threshold))
		return false
	end
	return true
end

-- Assert less than
function Neuratro.Tests.assert.less_than(value, threshold, message)
	if value >= threshold then
		Neuratro.Tests.current_error = message or string.format("Expected %s < %s", tostring(value), tostring(threshold))
		return false
	end
	return true
end

-- Assert table contains value
function Neuratro.Tests.assert.contains(tbl, value, message)
	for _, v in ipairs(tbl) do
		if v == value then
			return true
		end
	end
	Neuratro.Tests.current_error = message or string.format("Table does not contain %s", tostring(value))
	return false
end

-- Assert string contains substring
function Neuratro.Tests.assert.string_contains(str, substr, message)
	if not string.find(str, substr, 1, true) then
		Neuratro.Tests.current_error = message or string.format("String '%s' does not contain '%s'", str, substr)
		return false
	end
	return true
end

-- Assert type
function Neuratro.Tests.assert.is_type(value, expected_type, message)
	if type(value) ~= expected_type then
		Neuratro.Tests.current_error = message or string.format("Expected type %s, got %s", expected_type, type(value))
		return false
	end
	return true
end

-- Assert is table (convenience wrapper for is_type)
function Neuratro.Tests.assert.is_table(value, message)
	return Neuratro.Tests.assert.is_type(value, "table", message or "Expected table")
end

-- Assert function throws error
function Neuratro.Tests.assert.throws(fn, expected_error, message)
	local success, err = pcall(fn)
	if success then
		Neuratro.Tests.current_error = message or "Expected function to throw error"
		return false
	end
	if expected_error and not string.find(tostring(err), expected_error, 1, true) then
		Neuratro.Tests.current_error = message or string.format("Expected error containing '%s', got '%s'", expected_error, tostring(err))
		return false
	end
	return true
end

-- Assert approximate equality (for floating point)
function Neuratro.Tests.assert.approx_equals(actual, expected, tolerance, message)
	tolerance = tolerance or 0.0001
	if math.abs(actual - expected) > tolerance then
		Neuratro.Tests.current_error = message or string.format("Expected ~%s, got %s (tolerance: %s)", 
			tostring(expected), tostring(actual), tostring(tolerance))
		return false
	end
	return true
end

-- Mark test as failed with custom message
function Neuratro.Tests.fail(message)
	Neuratro.Tests.current_error = message or "Test failed"
	return false
end

-- Mark test as passed
function Neuratro.Tests.pass()
	return true
end
