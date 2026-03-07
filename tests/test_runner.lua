-- Neuratro Test Suite
-- Main test runner and test loader

Neuratro = Neuratro or {}
Neuratro.Tests = Neuratro.Tests or {}

-- Test module registry
Neuratro.Tests.modules = {
	-- Framework
	"tests.utils.test_framework",
	"tests.utils.mocks",
	"tests.utils.combination_generator",
	
	-- Individual Joker Tests - Batch files (72 jokers total)
	"tests.jokers.test_plasma_globe",
	"tests.jokers.test_roulette",
	"tests.jokers.test_3heart",
	"tests.jokers.test_batch_01",  -- plasma_globe, btmc, highlighted, anny, kyoto, pipes, milc, teru
	"tests.jokers.test_batch_02",  -- schedule, lavalamp, lucy, queenpb, tutelsoup, layna, forghat, 3heart_extended, argirl, tiredtutel
	"tests.jokers.test_batch_03",  -- hype, recbin, harpoon, cfrb, sispace, allin, camila, jokr, xdx, bday1, bday2, sistream, donowall, stocks, techhard
	"tests.jokers.test_batch_04",  -- gimbag, void, collab, cavestream, jorker, roulette_extended, Vedds, ddos, hiyori, Glorp, Emuz, anteater, drive, deliv, fourtoes, abandonedarchive
	"tests.jokers.test_batch_05",  -- minikocute, neurodog, ely, cerbr, corpa, emojiman, shoomimi, plush, vedalsdrink, filtersister, envy, koko, cerber, chimps, bwaa, coldfish, coldfish_unleashed, paulamarina, toma, tomaniacs, angel_neuro, neuro_issues
	
	-- Combination Tests
	"tests.combinations.test_basic_combinations",
	"tests.combinations.test_all_combinations",
	
	-- Edge Cases
	"tests.test_edge_cases",
}

-- Load all test modules
function Neuratro.Tests.load_all()
	print("Loading Neuratro test modules...")
	
	for _, module_path in ipairs(Neuratro.Tests.modules) do
		local success, err = pcall(function()
			assert(SMODS.load_file("./" .. module_path:gsub("%.", "/") .. ".lua"))()
		end)
		
		if not success then
			print(string.format("[WARNING] Failed to load test module '%s': %s", module_path, tostring(err)))
		else
			print(string.format("  [OK] Loaded %s", module_path))
		end
	end
	
	print(string.format("\nLoaded %d test modules\n", #Neuratro.Tests.modules))
end

-- Run all loaded tests
function Neuratro.Tests.run_all()
	if #Neuratro.Tests.tests == 0 then
		print("No tests loaded! Call Neuratro.Tests.load_all() first.")
		return false
	end
	
	return Neuratro.Tests.run()
end

-- Quick smoke test - runs a subset of critical tests
function Neuratro.Tests.smoke_test()
	print("\n" .. string.rep("=", 60))
	print("NEURATRO SMOKE TEST")
	print(string.rep("=", 60))
	
	-- Test that utilities load correctly
	local tests_to_run = {
		"Neuratro Test Framework: should track test results",
		"Edge Cases: should handle nil G gracefully",
		"Edge Cases: should handle empty joker areas",
	}
	
	local passed = 0
	for _, test_name in ipairs(tests_to_run) do
		for _, test in ipairs(Neuratro.Tests.tests) do
			if test.name == test_name then
				print(string.format("\n[SMOKE] %s", test_name))
				local success = pcall(test.fn)
				if success then
					passed = passed + 1
					print("  [PASS]")
				else
					print("  [FAIL]")
				end
			end
		end
	end
	
	print(string.format("\nSmoke test: %d/%d passed", passed, #tests_to_run))
	return passed == #tests_to_run
end

-- Integration test - tests actual game scenarios
function Neuratro.Tests.integration_test()
	print("\n" .. string.rep("=", 60))
	print("NEURATRO INTEGRATION TEST")
	print(string.rep("=", 60))
	
	Neuratro.Tests.Mocks.setup_test_env()
	
	-- Scenario 1: Full round with multiple jokers
	print("\nScenario 1: Full round simulation")
	
	-- Add jokers
	local joker1 = Neuratro.Tests.Mocks.create_joker("j_3heart", {
		extra = { Xmult = 1.5, xmbonus = 0.45 }
	})
	local joker2 = Neuratro.Tests.Mocks.create_joker("j_roulette", {
		extra = { xhigh = 4, xlow = 0.25 }
	})
	
	Neuratro.Tests.Mocks.add_joker_to_game(joker1)
	Neuratro.Tests.Mocks.add_joker_to_game(joker2)
	
	-- Verify setup
	Neuratro.Tests.assert.equals(#G.jokers.cards, 2, "Should have 2 jokers")
	
	-- Scenario 2: Test probability system
	print("Scenario 2: Probability calculations")
	
	G.GAME.probabilities.normal = 2
	local scale = Neuratro.get_probability_scale()
	Neuratro.Tests.assert.equals(scale, 2, "Probability scale should be 2")
	
	local vars = Neuratro.get_probability_vars(1, 6)
	Neuratro.Tests.assert.equals(vars[1], 2, "Display should show 2")
	Neuratro.Tests.assert.equals(vars[2], 6, "Odds should be 6")
	
	-- Scenario 3: Test card utilities
	print("Scenario 3: Card analysis")
	
	local cards = Neuratro.Tests.Mocks.create_scoring_hand({
		{ suit = "Hearts", value = "A" },
		{ suit = "Hearts", value = "K" },
		{ suit = "Diamonds", value = "Q" },
	})
	
	local unique_suits = Neuratro.count_unique_suits(cards)
	Neuratro.Tests.assert.equals(unique_suits, 2, "Should count 2 unique suits")
	
	local face_count = Neuratro.count_face_cards(cards)
	Neuratro.Tests.assert.equals(face_count, 2, "Should count 2 face cards")
	
	Neuratro.Tests.Mocks.teardown_test_env()
	
	print("\nIntegration test completed successfully!")
	return true
end

-- Performance benchmark
function Neuratro.Tests.benchmark()
	print("\n" .. string.rep("=", 60))
	print("NEURATRO PERFORMANCE BENCHMARK")
	print(string.rep("=", 60))
	
	Neuratro.Tests.Mocks.setup_test_env()
	
	-- Add many jokers
	for i = 1, 50 do
		local joker = Neuratro.Tests.Mocks.create_joker("j_test_" .. i, {
			extra = { value = i }
		})
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
	end
	
	-- Benchmark find_joker
	local start = os.clock()
	for i = 1, 1000 do
		Neuratro.find_joker("j_test_25")
	end
	local duration = os.clock() - start
	
	print(string.format("find_joker (1000 calls): %.4f seconds", duration))
	print(string.format("Average per call: %.6f seconds", duration / 1000))
	
	-- Benchmark count_cards
	for i = 1, 100 do
		local card = Neuratro.Tests.Mocks.create_card({ suit = "Hearts", value = "A" })
		Neuratro.Tests.Mocks.add_card_to_deck(card)
	end
	
	start = os.clock()
	for i = 1, 1000 do
		Neuratro.count_cards(function(c) return c.base.suit == "Hearts" end)
	end
	duration = os.clock() - start
	
	print(string.format("count_cards (1000 calls, 100 cards): %.4f seconds", duration))
	print(string.format("Average per call: %.6f seconds", duration / 1000))
	
	Neuratro.Tests.Mocks.teardown_test_env()
	
	print("\nBenchmark completed!")
end

-- Command line interface for tests
function Neuratro.Tests.cli(args)
	args = args or {}
	
	-- Load tests first
	Neuratro.Tests.load_all()
	
	-- Parse command
	local command = args[1] or "run"
	
	if command == "run" or command == "all" then
		return Neuratro.Tests.run_all()
	elseif command == "smoke" then
		return Neuratro.Tests.smoke_test()
	elseif command == "integration" then
		return Neuratro.Tests.integration_test()
	elseif command == "benchmark" then
		Neuratro.Tests.benchmark()
		return true
	elseif command == "combinations" or command == "combo" then
		return Neuratro.Tests.Combinations.run_smart_tests()
	elseif command == "critical" then
		return Neuratro.Tests.Combinations.run_critical_tests()
	elseif command == "stats" then
		Neuratro.Tests.Combinations.print_stats()
		return true
	elseif command == "monte-carlo" then
		local num_tests = tonumber(args[2]) or 100
		return Neuratro.Tests.Combinations.run_monte_carlo(num_tests)
	elseif command == "help" then
		print([[
Neuratro Test Suite Commands:
  run         - Run all tests (default)
  smoke       - Run quick smoke tests
  integration - Run integration tests
  benchmark   - Run performance benchmarks
  combinations - Run critical combination tests
  critical    - Run only critical joker combinations
  stats       - Show combination statistics
  monte-carlo [n] - Run n random combination tests (default 100)
  help        - Show this help message

Usage:
  Neuratro.Tests.cli({"run"})
  Neuratro.Tests.cli({"smoke"})
  Neuratro.Tests.cli({"combinations"})
  Neuratro.Tests.cli({"monte-carlo", "50"})
  Neuratro.Tests.Combinations.run_critical_tests()
  Neuratro.Tests.Combinations.print_stats()
		]])
		return true
	else
		print(string.format("Unknown command: %s", command))
		print("Use 'help' for available commands")
		return false
	end
end

-- Auto-run tests if this file is loaded directly
-- (commented out to prevent auto-running during normal game load)
--[[
if not G or not G.GAME then
	-- We're in test mode, not in game
	Neuratro.Tests.load_all()
	Neuratro.Tests.run_all()
end
--]]
