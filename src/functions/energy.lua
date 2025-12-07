AG.energy = {}

AG.energy.increase_limit = function(amount)
    G.GAME.energy_plus = G.GAME.energy_plus
        and G.GAME.energy_plus + amount
        or amount
end

AG.energy.decrease_limit = function(amount)
    G.GAME.energy_plus = G.GAME.energy_plus and G.GAME.energy_plus > 0
        and G.GAME.energy_plus - amount
        or 0
end

AG.energy.increase_all = function(etype, amount)
    for _, card in pairs(G.jokers.cards) do
        if not etype or is_type(card, etype) then
            increment_energy(card, etype, amount)
        end
    end
end

AG.energy.decrease_all = function(etype, amount)
    for _, card in pairs(G.jokers.cards) do
        if not etype or is_type(card, etype) then
            increment_energy(card, etype, -amount)
        end
    end
end
