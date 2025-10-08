local energy = {}

energy.increase_limit = function(amount)
  G.GAME.energy_plus = G.GAME.energy_plus
      and G.GAME.energy_plus + amount
      or amount
end

energy.decrease_limit = function(amount)
  G.GAME.energy_plus = G.GAME.energy_plus and G.GAME.energy_plus > 0
      and G.GAME.energy_plus - amount
      or 0
end

energy.decrease = function(card, etype, amount) end

energy.increase = function(card, etype, amount, no_silent)
  if etype == "Colorless" then
    card.ability.extra.c_energy_count = card.ability.extra.c_energy_count
        and card.ability.extra.c_energy_count + 1
        or 1
  else
    card.ability.extra.energy_count = card.ability.extra.energy_count
        and card.ability.extra.energy_count + 1
        or 1
  end
  energize(card, etype, false, not no_silent)
end

energy.increase_all = function(etype, amount)
  for _, card in pairs(G.jokers.cards) do
    if not etype or is_type(card, etype) then
      energy.increase(card, etype, amount)
    end
  end
end

energy.decrease_all = function(etype, amount)
  for _, card in pairs(G.jokers.cards) do
    if not etype or is_type(card, etype) then
      energy.decrease(card, etype, amount)
    end
  end
end

return {
  name = "Agarmons Energy Functions",
  key = "ENERGY",
  value = energy
}
