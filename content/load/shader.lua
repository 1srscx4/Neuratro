SMODS.Shader({ key = 'filtered', path = 'filtered.fs', 
send_vars = function (sprite, card)
        return {
            seed = card and card.edition.filtered_seed or 0
        }
end,})
SMODS.Shader({ key = 'arg', path = 'arg.fs' })