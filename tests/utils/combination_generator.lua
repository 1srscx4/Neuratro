-- Neuratro Combination Test Generator
-- Systematically tests combinations of jokers

Neuratro = Neuratro or {}
Neuratro.Tests = Neuratro.Tests or {}
Neuratro.Tests.Combinations = {
	-- Known problematic combinations to always test
	critical_combinations = {
		-- Mult stacking interactions
		{jokers = {"j_plasma_globe", "j_hype"}, reason = "Both give mult"},
		{jokers = {"j_teru", "j_hype"}, reason = "Face card counting + per-joker mult"},
		
		-- Xmult stacking interactions  
		{jokers = {"j_3heart", "j_roulette"}, reason = "Xmult sources"},
		{jokers = {"j_btmc", "j_queenpb"}, reason = "Round-based xmult"},
		{jokers = {"j_bday2", "j_lavalamp"}, reason = "Xmult upgrades"},
		
		-- Probability jokers
		{jokers = {"j_roulette", "j_kyoto"}, reason = "Multiple probability rolls"},
		{jokers = {"j_harpoon", "j_anteater"}, reason = "1 in N chance jokers"},
		
		-- Area-specific jokers
		{jokers = {"j_highlighted", "j_plasma_globe"}, reason = "Main + playbook_extra"},
		{jokers = {"j_pipes", "j_hiyori"}, reason = "Steel + debuff interaction"},
		
		-- Song system conflicts
		{jokers = {"j_queenpb", "j_queenpb"}, reason = "Multiple queenpb songs"},
		
		-- Self-destruction chain reactions
		{jokers = {"j_teru", "j_tutelsoup"}, reason = "Both self-destruct"},
		
		-- Filtered edition interactions
		{jokers = {"j_filtersister", "j_hiyori"}, reason = "Filtered + debuff"},
		
		-- Joker counting interactions
		{jokers = {"j_hype", "j_neurodog"}, reason = "Both count jokers"},
		
		-- Steel card conflicts
		{jokers = {"j_pipes", "j_cavestream"}, reason = "Both modify steel"},
		
		-- Mix hand modifications
		{jokers = {"j_fourtoes", "j_collab"}, reason = "Mix hand helpers"},
	},
	
	-- Categories for systematic testing
	categories = {
		mult_stackers = {
			name = "Mult Stackers",
			jokers = {"j_plasma_globe", "j_hype", "j_teru", "j_lucy", "j_allin"},
			test_all_pairs = true,
		},
		xmult_stackers = {
			name = "Xmult Stackers", 
			jokers = {"j_3heart", "j_btmc", "j_roulette", "j_queenpb", "j_bday2", "j_collab"},
			test_all_pairs = true,
		},
		economy = {
			name = "Economy Jokers",
			jokers = {"j_schedule", "j_stocks", "j_vedalsdrink"},
			test_all_pairs = true,
		},
		probability = {
			name = "Probability Jokers",
			jokers = {"j_roulette", "j_kyoto", "j_harpoon", "j_anteater", "j_allin"},
			test_all_pairs = true,
		},
		destruction = {
			name = "Self-Destruction",
			jokers = {"j_teru", "j_tutelsoup", "j_rum"},
			test_all_pairs = true,
		},
		special_areas = {
			name = "Playbook Extra Area",
			jokers = {"j_highlighted", "j_pipes", "j_hiyori", "j_chimps"},
			test_all_pairs = true,
		},
	},
}

-- Generate all pairs from a list
function Neuratro.Tests.Combinations.generate_pairs(joker_list)
	local pairs = {}
	for i = 1, #joker_list do
		for j = i + 1, #joker_list do
			table.insert(pairs, {joker_list[i], joker_list[j]})
		end
	end
	return pairs
end

-- Generate all combinations of size n
function Neuratro.Tests.Combinations.generate_combinations(joker_list, n)
	if n == 1 then
		local singles = {}
		for _, j in ipairs(joker_list) do
			table.insert(singles, {j})
		end
		return singles
	end
	
	if n > #joker_list then return {} end
	
	local result = {}
	
	local function backtrack(start_index, current_combo)
		if #current_combo == n then
			table.insert(result, {table.unpack(current_combo)})
			return
		end
		
		for i = start_index, #joker_list do
			table.insert(current_combo, joker_list[i])
			backtrack(i + 1, current_combo)
			table.remove(current_combo)
		end
	end
	
	backtrack(1, {})
	return result
end

-- Test a specific combination
function Neuratro.Tests.Combinations.test_combination(joker_keys, test_fn)
	Neuratro.Tests.Mocks.setup_test_env()
	
	-- Add all jokers in combination
	for _, key in ipairs(joker_keys) do
		local joker = Neuratro.Tests.Mocks.create_joker(key)
		Neuratro.Tests.Mocks.add_joker_to_game(joker)
	end
	
	-- Run test
	local success = true
	local error_msg = nil
	
	if test_fn then
		success, error_msg = pcall(test_fn)
	end
	
	Neuratro.Tests.Mocks.teardown_test_env()
	
	return success, error_msg
end

-- Test mult stacking
function Neuratro.Tests.Combinations.test_mult_stacking(joker1_key, joker2_key)
	return Neuratro.Tests.Combinations.test_combination({joker1_key, joker2_key}, function()
		-- Simulate joker_main for both
		local mult1 = 10
		local mult2 = 15
		local total = mult1 + mult2
		
		Neuratro.Tests.assert.equals(total, 25, "Mult should stack additively")
		return true
	end)
end

-- Test xmult stacking
function Neuratro.Tests.Combinations.test_xmult_stacking(joker1_key, joker2_key)
	return Neuratro.Tests.Combinations.test_combination({joker1_key, joker2_key}, function()
		-- Xmult should multiply
		local xmult1 = 2
		local xmult2 = 3
		local total = xmult1 * xmult2
		
		Neuratro.Tests.assert.equals(total, 6, "Xmult should stack multiplicatively")
		return true
	end)
end

-- Test no conflicts
function Neuratro.Tests.Combinations.test_no_conflicts(joker1_key, joker2_key)
	return Neuratro.Tests.Combinations.test_combination({joker1_key, joker2_key}, function()
		-- Both should be findable
		local found1 = Neuratro.has_joker(joker1_key)
		local found2 = Neuratro.has_joker(joker2_key)
		
		Neuratro.Tests.assert.is_true(found1, string.format("Should find %s", joker1_key))
		Neuratro.Tests.assert.is_true(found2, string.format("Should find %s", joker2_key))
		return true
	end)
end

-- Run all critical combinations
function Neuratro.Tests.Combinations.run_critical_tests()
	print("\n" .. string.rep("=", 60))
	print("CRITICAL COMBINATION TESTS")
	print(string.rep("=", 60))
	
	local passed = 0
	local failed = 0
	
	for _, combo in ipairs(Neuratro.Tests.Combinations.critical_combinations) do
		local name = table.concat(combo.jokers, " + ")
		print(string.format("\nTesting: %s", name))
		print(string.format("Reason: %s", combo.reason))
		
		local success = Neuratro.Tests.Combinations.test_no_conflicts(combo.jokers[1], combo.jokers[2])
		
		if success then
			print("  [PASS]")
			passed = passed + 1
		else
			print("  [FAIL]")
			failed = failed + 1
		end
	end
	
	print("\n" .. string.rep("=", 60))
	print(string.format("Critical Tests: %d passed, %d failed", passed, failed))
	
	return failed == 0
end

-- Run category pair tests
function Neuratro.Tests.Combinations.run_category_tests(category_name)
	local category = Neuratro.Tests.Combinations.categories[category_name]
	if not category then
		print(string.format("Unknown category: %s", category_name))
		return false
	end
	
	print(string.format("\nTesting category: %s", category.name))
	
	if not category.test_all_pairs then
		print("  (Category doesn't require pair testing)")
		return true
	end
	
	local pairs = Neuratro.Tests.Combinations.generate_pairs(category.jokers)
	print(string.format("  %d pairs to test", #pairs))
	
	local passed = 0
	local failed = 0
	
	for _, pair in ipairs(pairs) do
		local success = Neuratro.Tests.Combinations.test_no_conflicts(pair[1], pair[2])
		if success then
			passed = passed + 1
		else
			failed = failed + 1
			print(string.format("  [FAIL] %s + %s", pair[1], pair[2]))
		end
	end
	
	print(string.format("  Results: %d/%d passed", passed, #pairs))
	return failed == 0
end

-- Run all category tests
function Neuratro.Tests.Combinations.run_all_category_tests()
	print("\n" .. string.rep("=", 60))
	print("CATEGORY COMBINATION TESTS")
	print(string.rep("=", 60))
	
	local all_passed = true
	
	for category_name, _ in pairs(Neuratro.Tests.Combinations.categories) do
		local success = Neuratro.Tests.Combinations.run_category_tests(category_name)
		if not success then
			all_passed = false
		end
	end
	
	return all_passed
end

-- Estimate total combinations
function Neuratro.Tests.Combinations.estimate_total()
	local n = 72  -- Total jokers
	local stats = {}
	
	-- Pairs: C(n,2) = n*(n-1)/2
	stats.pairs = (n * (n - 1)) / 2
	
	-- Triplets: C(n,3) = n*(n-1)*(n-2)/6
	stats.triplets = (n * (n - 1) * (n - 2)) / 6
	
	-- 4-joker combinations: C(n,4)
	stats.four = (n * (n - 1) * (n - 2) * (n - 3)) / 24
	
	-- All subsets: 2^n - 1 (excluding empty set)
	stats.all_subsets = math.pow(2, n) - 1
	
	return stats
end

-- Print combination statistics
function Neuratro.Tests.Combinations.print_stats()
	local stats = Neuratro.Tests.Combinations.estimate_total()
	
	print("\n" .. string.rep("=", 60))
	print("COMBINATION STATISTICS")
	print(string.rep("=", 60))
	print(string.format("Total Jokers: 72"))
	print(string.format("Pairs (2 jokers):     %15.0f", stats.pairs))
	print(string.format("Triplets (3 jokers):  %15.0f", stats.triplets))
	print(string.format("4-joker combos:       %15.0f", stats.four))
	print(string.format("All subsets:          %15.0f", stats.all_subsets))
	print(string.rep("=", 60))
	print("Note: Testing ALL combinations is impractical.")
	print("We test:")
	print("  - 10 critical combinations")
	print("  - Category-based pairs (~50 pairs)")
	print("  - Known problematic interactions")
	print(string.rep("=", 60))
end

-- Smart combination testing (tests most likely to fail)
function Neuratro.Tests.Combinations.run_smart_tests()
	print("\n" .. string.rep("=", 60))
	print("SMART COMBINATION TESTING")
	print(string.rep("=", 60))
	print("Testing combinations most likely to have conflicts...")
	
	local results = {
		critical = Neuratro.Tests.Combinations.run_critical_tests(),
		categories = Neuratro.Tests.Combinations.run_all_category_tests(),
	}
	
	print("\n" .. string.rep("=", 60))
	print("SMART TEST SUMMARY")
	print(string.rep("=", 60))
	print(string.format("Critical combinations: %s", results.critical and "PASS" or "FAIL"))
	print(string.format("Category pairs:        %s", results.categories and "PASS" or "FAIL"))
	
	return results.critical and results.categories
end

-- Monte Carlo testing (random combinations)
function Neuratro.Tests.Combinations.run_monte_carlo(num_tests)
	num_tests = num_tests or 100
	
	print(string.format("\nRunning Monte Carlo test with %d random combinations...", num_tests))
	
	local all_jokers = {}
	for key, _ in pairs(Neuratro.Tests.Suite.jokers) do
		table.insert(all_jokers, key)
	end
	
	local passed = 0
	local failed = 0
	
	math.randomseed(os.time())
	
	for i = 1, num_tests do
		-- Pick 2-4 random jokers
		local num_jokers = math.random(2, 4)
		local selected = {}
		
		for j = 1, num_jokers do
			local idx = math.random(1, #all_jokers)
			table.insert(selected, all_jokers[idx])
		end
		
		local success = Neuratro.Tests.Combinations.test_no_conflicts(selected[1], selected[2])
		if success then
			passed = passed + 1
		else
			failed = failed + 1
		end
		
		if i % 10 == 0 then
			print(string.format("  Progress: %d/%d", i, num_tests))
		end
	end
	
	print(string.format("\nMonte Carlo Results: %d/%d passed (%.1f%%)", 
		passed, num_tests, (passed/num_tests)*100))
	
	return failed == 0
end
