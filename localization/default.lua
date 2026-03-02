return {
	descriptions = {
		Other = {
			Gleeb_desc = {
				name = "Gleebs",
				text = {
					"{C:green}Gleebs{} give {C:attention}10{} times",
					"their base {C:chips}chips",
					"{C:inactive}(ex: 3 -> 30)",
				},
			},
			Unique_card_desc = {
				name = "Unique cards",
				text = {
					"{C:attention}Unique cards{} are those with",
					"a {C:attention}different{} rank, suit, edition,",
					"enhancement or seal than the rest.",
				},
			},
			Vedal_items_desc = {
				name = "Vedal's Items",
				text = {
					"Vedal's items are the jokers {C:attention}Banana Rum{},",
					"{C:attention}Vedal's Credit Card{}, {C:attention}Tutel Soup{},",
					"{C:attention}Abandoned Archive 2{}",
				},
			},
		},
		Joker = {
			j_evilsand = {
				name = "Evil Sand",
				text = {
					{
						"Plays the last two {C:attention}destroyed{} cards.",
					},
					{
						"{C:attention}Stores{} the last {C:attention}#1# jokers sold{}.",
						"When you sell a total value of {C:money}$#2#{},",
						"increase this amount by {C:attention}1{}. {C:inactive}({C:money}$#3#{C:inactive} left)",
						"If you get a second copy of this joker,",
						"destroy it and {C:attention}double{} this joker's storage",
						"{C:inactive}Click on the joker to check the jokers stored.",
						"{C:inactive}(This part of the code was done by {C:attention}Aikoyori{C:inactive}, check them out!)",
					},
				},
			},
			j_goodsand = { -- same as above but with a different name
				name = "Good Sand",
				text = {
					{
						"Plays the last two {C:attention}destroyed{} cards.",
					},
					{
						"{C:attention}Stores{} the last {C:attention}#1# jokers sold{}.",
						"When you sell a total value of {C:money}$#2#{},",
						"increase this amount by {C:attention}1{}. {C:inactive}({C:money}$#3#{C:inactive} left)",
						"If you get a second copy of this joker,",
						"destroy it and {C:attention}double{} this joker's storage",
						"{C:inactive}Click on the joker to check the jokers stored.",
						"{C:inactive}(This part of the code was done by {C:attention}Aikoyori{C:inactive}, check them out!)",
					},
				},
			},
		},
	},
	Misc = {
		dictionary = {
			modpurgesave = "'Saved' by mod purge.",
		},
	},
}
