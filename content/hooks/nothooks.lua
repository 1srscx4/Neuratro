-- Sorry for misleading file name, i didn't know where to put this.

Neuratro = Neuratro or {}

Neuratro.sea = function(func, delay, trigger, queue)
	if not (G and G.E_MANAGER) then
		return false
	end
	G.E_MANAGER:add_event(
		Event({
			trigger = trigger or "after",
			delay = delay or 0.1,
			func = func,
		}),
		queue
	)
	return true
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
