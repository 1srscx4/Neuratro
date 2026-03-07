-- Test Suite Index
-- Complete registry of all 72 Neuratro jokers and their tests

Neuratro = Neuratro or {}
Neuratro.Tests = Neuratro.Tests or {}

Neuratro.Tests.Suite = {
	-- Framework Tests
	framework = {
		name = "Test Framework",
		path = "tests.utils.test_framework",
		description = "Core testing infrastructure",
		tests = {
			"Test result tracking",
			"Assertion helpers",
			"Test execution",
		},
	},
	
	-- Mock Tests
	mocks = {
		name = "Mock Utilities",
		path = "tests.utils.mocks",
		description = "Mock objects for testing",
		tests = {
			"Game state mocking",
			"Card creation",
			"Context creation",
			"Environment setup/teardown",
		},
	},
	
	-- All 72 Jokers
	jokers = {
		-- Batch 01
		plasma_globe = {
			name = "Plasma Globe",
			path = "tests.jokers.test_batch_01",
			description = "Mult addition with heart bonus",
			key = "j_plasma_globe",
			tests = { "Basic mult", "Heart bonus", "Area restrictions", "End of round" },
		},
		btmc = {
			name = "BTMC",
			path = "tests.jokers.test_batch_01",
			description = "Xmult after rounds played",
			key = "j_btmc",
			tests = { "Round tracking", "Upgrade at goal", "Base xmult" },
		},
		highlighted = {
			name = "Highlighted",
			path = "tests.jokers.test_batch_01",
			description = "Interaction with m_dono enhancement",
			key = "j_highlighted",
			tests = { "Findability", "Debuff handling" },
		},
		anny = {
			name = "Anny",
			path = "tests.jokers.test_batch_01",
			description = "Erm... card transformation",
			key = "j_anny",
			tests = { "High Card trigger", "Card transformation" },
		},
		kyoto = {
			name = "Kyoto",
			path = "tests.jokers.test_batch_01",
			description = "Miss messages",
			key = "j_kyoto",
			tests = { "Probability trigger", "Miss messages" },
		},
		pipes = {
			name = "Pipes",
			path = "tests.jokers.test_batch_01",
			description = "Steel card interaction",
			key = "j_pipes",
			tests = { "Findability", "Steel xmult modification" },
		},
		milc = {
			name = "Milc",
			path = "tests.jokers.test_batch_01",
			description = "Jack of Diamonds retrigger",
			key = "j_milc",
			tests = { "Jack tracking", "Retrigger based on 2s" },
		},
		teru = {
			name = "Teru",
			path = "tests.jokers.test_batch_01",
			description = "Face card destruction",
			key = "j_teru",
			tests = { "Face card counting", "Mult upgrade", "Self destruction" },
		},
		
		-- Batch 02
		schedule = {
			name = "Schedule",
			path = "tests.jokers.test_batch_02",
			description = "Time-based cycle rewards",
			key = "j_schedule",
			tests = { "Cycle tracking", "Different rewards per cycle" },
		},
		lavalamp = {
			name = "Lava Lamp",
			path = "tests.jokers.test_batch_02",
			description = "Xmult heating on specific hands",
			key = "j_lavalamp",
			tests = { "Xmult increase", "Specific hand triggers" },
		},
		lucy = {
			name = "Lucy",
			path = "tests.jokers.test_batch_02",
			description = "Chip accumulation",
			key = "j_lucy",
			tests = { "Chip accumulation" },
		},
		queenpb = {
			name = "QueenPB",
			path = "tests.jokers.test_batch_02",
			description = "Song pooling and music system",
			key = "j_queenpb",
			tests = { "Random song selection", "Pool flags", "Round upgrade", "Song sharing", "Flag clearing" },
		},
		tutelsoup = {
			name = "Tutel Soup",
			path = "tests.jokers.test_batch_02",
			description = "Random effect selector",
			key = "j_tutelsoup",
			tests = { "Random effect", "Correct bonuses", "Self destruction" },
		},
		layna = {
			name = "Layna",
			path = "tests.jokers.test_batch_02",
			description = "Layna functionality",
			key = "j_layna",
			tests = { "Basic functionality" },
		},
		forghat = {
			name = "Forg Hat",
			path = "tests.jokers.test_batch_02",
			description = "Forg hat functionality",
			key = "j_forghat",
			tests = { "Basic functionality" },
		},
		three_heart = {
			name = "3Heart",
			path = "tests.jokers.test_3heart",
			description = "Xmult upgrade on three of a kind hearts",
			key = "j_3heart",
			tests = { "Base xmult", "Three of a kind hearts upgrade", "Mixed suits", "Other hands", "Blueprint", "Multiple upgrades" },
		},
		argirl = {
			name = "Argirl",
			path = "tests.jokers.test_batch_02",
			description = "Argirl functionality",
			key = "j_argirl",
			tests = { "Basic functionality" },
		},
		tiredtutel = {
			name = "Tired Tutel",
			path = "tests.jokers.test_batch_02",
			description = "Tired tutel functionality",
			key = "j_tiredtutel",
			tests = { "Basic functionality" },
		},
		
		-- Batch 03
		hype = {
			name = "Hype",
			path = "tests.jokers.test_batch_03",
			description = "Scaling mult per joker",
			key = "j_hype",
			tests = { "Mult per joker", "Playbook extra inclusion" },
		},
		recbin = {
			name = "Recbin",
			path = "tests.jokers.test_batch_03",
			description = "Recbin functionality",
			key = "j_recbin",
			tests = { "Basic functionality" },
		},
		harpoon = {
			name = "Get Harpooned!",
			path = "tests.jokers.test_batch_03",
			description = "Discard removal with Xmult",
			key = "j_harpoon",
			tests = { "Probability", "Discard removal", "Xmult" },
		},
		cfrb = {
			name = "CFRB",
			path = "tests.jokers.test_batch_03",
			description = "CFRB functionality",
			key = "j_cfrb",
			tests = { "Basic functionality" },
		},
		sispace = {
			name = "Sispace",
			path = "tests.jokers.test_batch_03",
			description = "Sispace functionality",
			key = "j_sispace",
			tests = { "Basic functionality" },
		},
		allin = {
			name = "All In",
			path = "tests.jokers.test_batch_03",
			description = "Random mult",
			key = "j_allin",
			tests = { "Random mult", "Range display" },
		},
		camila = {
			name = "Camila",
			path = "tests.jokers.test_batch_03",
			description = "Sixes retrigger with Xmult",
			key = "j_camila",
			tests = { "Six retrigger", "Xmult on six" },
		},
		jokr = {
			name = "Jokr",
			path = "tests.jokers.test_batch_03",
			description = "Jokr functionality",
			key = "j_jokr",
			tests = { "Basic functionality" },
		},
		xdx = {
			name = "xdx",
			path = "tests.jokers.test_batch_03",
			description = "xdx functionality",
			key = "j_xdx|",
			tests = { "Basic functionality" },
		},
		bday1 = {
			name = "Evil's Birthday",
			path = "tests.jokers.test_batch_03",
			description = "Evil's birthday functionality",
			key = "j_bday1",
			tests = { "Basic functionality" },
		},
		bday2 = {
			name = "Evil's Second Birthday",
			path = "tests.jokers.test_batch_03",
			description = "Xmult upgrade on face card addition",
			key = "j_bday2",
			tests = { "Xmult upgrade", "Current Xmult" },
		},
		sistream = {
			name = "Sistream",
			path = "tests.jokers.test_batch_03",
			description = "Sistream functionality",
			key = "j_sistream",
			tests = { "Basic functionality" },
		},
		donowall = {
			name = "Donowall",
			path = "tests.jokers.test_batch_03",
			description = "Donowall functionality",
			key = "j_donowall",
			tests = { "Basic functionality" },
		},
		stocks = {
			name = "Stocks",
			path = "tests.jokers.test_batch_03",
			description = "Economy based price changes",
			key = "j_stocks",
			tests = { "Price tracking", "Money giving" },
		},
		techhard = {
			name = "Tech Hard",
			path = "tests.jokers.test_batch_03",
			description = "Tech hard functionality",
			key = "j_techhard",
			tests = { "Basic functionality" },
		},
		
		-- Batch 04
		gimbag = {
			name = "Gym Bag",
			path = "tests.jokers.test_batch_04",
			description = "Xmult cycling through values",
			key = "j_gimbag",
			tests = { "Cycle tracking", "Advance cycle", "Wrap cycle" },
		},
		void = {
			name = "Void",
			path = "tests.jokers.test_batch_04",
			description = "Void functionality",
			key = "j_void",
			tests = { "Basic functionality" },
		},
		collab = {
			name = "Collab",
			path = "tests.jokers.test_batch_04",
			description = "Face cards from different suits",
			key = "j_collab",
			tests = { "Face suit counting", "Trigger condition", "Xmult" },
		},
		cavestream = {
			name = "Cave Stream",
			path = "tests.jokers.test_batch_04",
			description = "Stone cards retrigger/creation",
			key = "j_cavestream",
			tests = { "Stone retrigger", "Stone creation" },
		},
		jorker = {
			name = "Jorker",
			path = "tests.jokers.test_batch_04",
			description = "Jorker functionality",
			key = "j_jorker",
			tests = { "Basic functionality" },
		},
		roulette = {
			name = "Neuro Roulette",
			path = "tests.jokers.test_roulette",
			description = "Random xhigh/xlow selection",
			key = "j_roulette",
			tests = { "Random selection", "Context filtering", "Loc vars", "Valid values", "Distribution" },
		},
		vedds = {
			name = "Vedds",
			path = "tests.jokers.test_batch_04",
			description = "Vedds functionality",
			key = "j_Vedds",
			tests = { "Basic functionality" },
		},
		ddos = {
			name = "DDOS",
			path = "tests.jokers.test_batch_04",
			description = "DDOS functionality",
			key = "j_ddos",
			tests = { "Basic functionality" },
		},
		hiyori = {
			name = "Hiyori",
			path = "tests.jokers.test_batch_04",
			description = "Heart card debuff",
			key = "j_hiyori",
			tests = { "Findability", "Heart debuff" },
		},
		glorp = {
			name = "Glorp",
			path = "tests.jokers.test_batch_04",
			description = "Glorp functionality",
			key = "j_Glorp",
			tests = { "Basic functionality" },
		},
		emuz = {
			name = "Emuz",
			path = "tests.jokers.test_batch_04",
			description = "Emuz functionality",
			key = "j_Emuz",
			tests = { "Basic functionality" },
		},
		anteater = {
			name = "Anteater",
			path = "tests.jokers.test_batch_04",
			description = "Seal copying",
			key = "j_anteater",
			tests = { "Probability", "Seal copying" },
		},
		drive = {
			name = "Drive",
			path = "tests.jokers.test_batch_04",
			description = "Drive functionality",
			key = "j_drive",
			tests = { "Basic functionality" },
		},
		deliv = {
			name = "Deliv",
			path = "tests.jokers.test_batch_04",
			description = "Deliv functionality",
			key = "j_deliv",
			tests = { "Basic functionality" },
		},
		fourtoes = {
			name = "Four Toes",
			path = "tests.jokers.test_batch_04",
			description = "Mix hand with 4 cards",
			key = "j_fourtoes",
			tests = { "Mix requirement", "4-card threshold" },
		},
		abandonedarchive = {
			name = "Abandoned Archive",
			path = "tests.jokers.test_batch_04",
			description = "Abandoned archive functionality",
			key = "j_abandonedarchive",
			tests = { "Basic functionality" },
		},
		
		-- Batch 05
		minikocute = {
			name = "Miniko Cute",
			path = "tests.jokers.test_batch_05",
			description = "Miniko cute functionality",
			key = "j_minikocute",
			tests = { "Basic functionality" },
		},
		neurodog = {
			name = "Neurodog",
			path = "tests.jokers.test_batch_05",
			description = "Neighboring joker bonus",
			key = "j_neurodog",
			tests = { "Neighbor checking", "Neighbor bonus" },
		},
		ely = {
			name = "Ely",
			path = "tests.jokers.test_batch_05",
			description = "Ely functionality",
			key = "j_ely",
			tests = { "Basic functionality" },
		},
		cerbr = {
			name = "Cerbr",
			path = "tests.jokers.test_batch_05",
			description = "Cerbr functionality",
			key = "j_cerbr",
			tests = { "Basic functionality" },
		},
		corpa = {
			name = "Corpa",
			path = "tests.jokers.test_batch_05",
			description = "Corpa functionality",
			key = "j_corpa",
			tests = { "Basic functionality" },
		},
		emojiman = {
			name = "Emojiman",
			path = "tests.jokers.test_batch_05",
			description = "Smiley joker interaction",
			key = "j_emojiman",
			tests = { "Findability", "Smiley interaction" },
		},
		shoomimi = {
			name = "Shoomimi",
			path = "tests.jokers.test_batch_05",
			description = "Shoomimi functionality",
			key = "j_shoomimi",
			tests = { "Findability" },
		},
		plush = {
			name = "Plush",
			path = "tests.jokers.test_batch_05",
			description = "Plush functionality",
			key = "j_plush",
			tests = { "Basic functionality" },
		},
		vedalsdrink = {
			name = "Vedal's Drink",
			path = "tests.jokers.test_batch_05",
			description = "Money earned scaling",
			key = "j_vedalsdrink",
			tests = { "Money tracking", "Money scaling" },
		},
		filtersister = {
			name = "Filter Sister",
			path = "tests.jokers.test_batch_05",
			description = "Filtered edition interaction",
			key = "j_filtersister",
			tests = { "Upgrade on filtered", "Findability", "Current xmult" },
		},
		envy = {
			name = "Envy",
			path = "tests.jokers.test_batch_05",
			description = "Envy functionality",
			key = "j_envy",
			tests = { "Basic functionality" },
		},
		koko = {
			name = "Koko",
			path = "tests.jokers.test_batch_05",
			description = "Koko functionality",
			key = "j_koko",
			tests = { "Basic functionality" },
		},
		cerber = {
			name = "Cerber",
			path = "tests.jokers.test_batch_05",
			description = "Cerber functionality",
			key = "j_cerber",
			tests = { "Basic functionality" },
		},
		chimps = {
			name = "Chimps",
			path = "tests.jokers.test_batch_05",
			description = "Arcana pack bonus",
			key = "j_chimps",
			tests = { "Findability", "Arcana detection", "Pack size increase" },
		},
		bwaa = {
			name = "Bwaa",
			path = "tests.jokers.test_batch_05",
			description = "Bwaa functionality",
			key = "j_bwaa",
			tests = { "Basic functionality" },
		},
		coldfish = {
			name = "Coldfish",
			path = "tests.jokers.test_batch_05",
			description = "Coldfish functionality",
			key = "j_coldfish",
			tests = { "Basic functionality", "Not debuffed" },
		},
		coldfish_unleashed = {
			name = "Coldfish Unleashed",
			path = "tests.jokers.test_batch_05",
			description = "Coldfish unleashed functionality",
			key = "j_coldfish_unleashed",
			tests = { "Basic functionality" },
		},
		paulamarina = {
			name = "Paulamarina",
			path = "tests.jokers.test_batch_05",
			description = "Paulamarina functionality",
			key = "j_paulamarina",
			tests = { "Basic functionality" },
		},
		toma = {
			name = "Toma",
			path = "tests.jokers.test_batch_05",
			description = "Toma functionality",
			key = "j_toma",
			tests = { "Basic functionality" },
		},
		tomaniacs = {
			name = "Tomaniacs",
			path = "tests.jokers.test_batch_05",
			description = "Tomaniacs functionality",
			key = "j_tomaniacs",
			tests = { "Basic functionality" },
		},
		angel_neuro = {
			name = "Angel Neuro",
			path = "tests.jokers.test_batch_05",
			description = "Angel neuro functionality",
			key = "j_angel_neuro",
			tests = { "Basic functionality" },
		},
		neuro_issues = {
			name = "Neuro Issues",
			path = "tests.jokers.test_batch_05",
			description = "Neuro issues functionality",
			key = "j_neuro_issues",
			tests = { "Basic functionality" },
		},
	},
	
	-- Combination Tests
	combinations = {
		basic = {
			name = "Basic Combinations",
			path = "tests.combinations.test_basic_combinations",
			description = "Joker interaction tests",
			tests = {
				"Mult and xmult stacking",
				"Hiyori with heart cards",
				"Filtersister interactions",
				"QueenPB song pooling",
				"Playbook extra area",
				"Collab requirements",
			},
		},
	},
	
	-- Edge Cases
	edge_cases = {
		name = "Edge Cases",
		path = "tests.test_edge_cases",
		description = "Boundary conditions and error handling",
		tests = {
			"Nil G handling",
			"Nil game state",
			"Empty joker areas",
			"Zero probability",
			"Debuffed jokers",
			"Empty scoring hand",
			"High probability scale",
			"Missing config",
			"Card ID edge cases",
			"Multiple same-type jokers",
			"Invalid odds",
		},
	},
}

-- Get test info by joker key
function Neuratro.Tests.Suite.get_joker_tests(joker_key)
	for _, joker_test in pairs(Neuratro.Tests.Suite.jokers) do
		if joker_test.key == joker_key then
			return joker_test
		end
	end
	return nil
end

-- List all available tests
function Neuratro.Tests.Suite.list_all()
	print("\n" .. string.rep("=", 60))
	print("NEURATRO TEST SUITE INDEX")
	print(string.rep("=", 60))
	
	print("\nFramework:")
	print(string.format("  - %s (%s)", Neuratro.Tests.Suite.framework.name, Neuratro.Tests.Suite.framework.path))
	
	print("\nJoker Tests (72 total):")
	for key, info in pairs(Neuratro.Tests.Suite.jokers) do
		print(string.format("  - %s (%s)", info.name, info.key))
		print(string.format("    Path: %s", info.path))
		print(string.format("    Tests: %d", #info.tests))
	end
	
	print("\nCombination Tests:")
	for key, info in pairs(Neuratro.Tests.Suite.combinations) do
		print(string.format("  - %s", info.name))
		print(string.format("    Tests: %d", #info.tests))
	end
	
	print("\nEdge Cases:")
	print(string.format("  Total: %d", #Neuratro.Tests.Suite.edge_cases.tests))
	
	print("\n" .. string.rep("=", 60))
end

-- Count total tests
function Neuratro.Tests.Suite.count_tests()
	local count = 0
	
	-- Count joker tests
	for _, joker_info in pairs(Neuratro.Tests.Suite.jokers) do
		count = count + #joker_info.tests
	end
	
	-- Count combination tests
	for _, combo_info in pairs(Neuratro.Tests.Suite.combinations) do
		count = count + #combo_info.tests
	end
	
	-- Count edge cases
	count = count + #Neuratro.Tests.Suite.edge_cases.tests
	
	return count
end

-- Print summary
function Neuratro.Tests.Suite.summary()
	print(string.format("\nTest Suite Summary:"))
	print(string.format("  Total Jokers: %d", #Neuratro.Tests.Suite.jokers))
	print(string.format("  Total Test Cases: %d", Neuratro.Tests.Suite.count_tests()))
	print(string.format("  Framework Tests: %d", #Neuratro.Tests.Suite.framework.tests))
	print(string.format("  Edge Case Tests: %d", #Neuratro.Tests.Suite.edge_cases.tests))
end

-- Run tests for specific joker
function Neuratro.Tests.Suite.run_joker_tests(joker_key)
	local joker_info = Neuratro.Tests.Suite.get_joker_tests(joker_key)
	if not joker_info then
		print(string.format("No tests found for joker: %s", joker_key))
		return false
	end
	
	print(string.format("\nRunning tests for %s...", joker_info.name))
	-- Load and run specific batch
	local success, err = pcall(function()
		assert(SMODS.load_file("./" .. joker_info.path:gsub("%.", "/") .. ".lua"))()
	end)
	
	if not success then
		print(string.format("Error loading tests: %s", tostring(err)))
		return false
	end
	
	return Neuratro.Tests.run()
end
