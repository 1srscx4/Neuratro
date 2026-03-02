-- Sorry for misleading file name, i didn't know where to put this.

sea = function(func, delay, trigger, queue)
	G.E_MANAGER:add_event(
		Event({
			trigger = trigger or "after",
			delay = delay or 0.1,
			func = func,
		}),
		queue
	)
end

SMODS.current_mod.optional_features = function()
	return {
		retrigger_joker = true,
		cardareas = {
			discard = true,
			deck = true,
		},
	}
end
