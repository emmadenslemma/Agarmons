-- Galarian Mr. Mime 122-1
local galarian_mrmime = {
  name = "galarian_mrmime",
  agar_inject_prefix = "poke",
  config = { extra = { rounds = 5 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.rounds } }
  end,
  rarity = 3,
  cost = 8,
  stage = "Basic",
  ptype = "Water",
  gen = 8,
  calculate = function(self, card, context)
    return level_evo(self, card, context, "j_poke_mrrime")
  end
}

-- Mr. Rime 866
local mrrime = {
  name = "mrrime",
  agar_inject_prefix = "poke",
  config = { extra = { retriggers = 2 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.retriggers } }
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "Basic",
  ptype = "Water",
  gen = 8,
  calculate = function(self, card, context)
    if AG.effects.ortalab_statue_card
        and context.repetition and context.cardarea == G.play
        and context.other_card == AG.effects.ortalab_statue_card then
      return {
        repetitions = card.ability.extra.retriggers
      }
    end
  end,
  designer = "Thor's Girdle"
}

local init = function()
  AG.append_to_family("mrmime", "galarian_mrmime")
  AG.append_to_family("galarian_mrmime", "mrrime")
end

return {
  config_key = 'galarian_mrmime',
  init = init,
  list = { galarian_mrmime, mrrime }
}
