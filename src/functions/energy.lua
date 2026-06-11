AG.energy = {}

function AG.energy.mod_card_energy_limit(card, amount)
  card.ability.extra = card.ability.extra or {}
  if type(card.ability.extra) ~= 'table' then return end
  card.ability.extra.e_limit_up = (card.ability.extra.e_limit_up or 0) + amount
end

function AG.energy.mod_energy_and_limit(card, etype, amount, silent)
  if not etype or is_type(card, etype) then
    AG.energy.mod_card_energy_limit(card, amount)
    pokermon.energy.modify(card, etype, amount, silent)
  end
end

function AG.energy.mod_all_energy_and_limit(etype, amount, silent)
  for _, card in pairs(G.jokers.cards) do
    AG.energy.mod_energy_and_limit(card, etype, amount, silent)
  end
end
