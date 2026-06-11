-- Galarian Mr. Mime 122-1
local galarian_mrmime = {
  name = "galarian_mrmime",
  agar_inject_prefix = "poke",
  config = { extra = { rounds = 5, scored_cards = 1 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.rounds } }
  end,
  rarity = 3,
  cost = 8,
  stage = "Basic",
  ptype = "Water",
  gen = 8,
  blueprint_compat = false,
  calculate = function(self, card, context)
    return level_evo(self, card, context, "j_poke_mrrime")
  end
}

-- Mr. Rime 866
local mrrime = {
  name = "mrrime",
  agar_inject_prefix = "poke",
  config = { extra = { scored_cards = 2 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.scored_cards } }
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "One",
  ptype = "Water",
  gen = 8,
  blueprint_compat = false,
}

local init = function()
  pokermon.add_to_family("mrmime", { "galarian_mrmime", "mrrime" })
end

return {
  config_key = 'galarian_mrmime',
  init = init,
  list = { galarian_mrmime, mrrime }
}
