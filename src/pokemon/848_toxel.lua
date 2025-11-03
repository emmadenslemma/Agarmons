-- Toxel 848
local toxel = {
  name = "toxel",
  config = { extra = { Xmult_minus = 0.75, rounds = 2 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue + 1] = { set = 'Other', key = 'baby' }
      info_queue[#info_queue + 1] = { key = 'e_negative_consumable', set = 'Edition', config = { extra = 1 } }
      info_queue[#info_queue + 1] = G.P_CENTERS.c_stall_blacksludge
    end
    return { vars = { center.ability.extra.Xmult_minus, center.ability.extra.rounds } }
  end,
  designer = "Gem",
  rarity = 2,
  cost = 4,
  stage = "Baby",
  ptype = "Lightning",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      faint_baby_poke(self, card, context)
      return {
        Xmult = card.ability.extra.Xmult_minus
      }
    end
    if context.end_of_round and context.cardarea == G.jokers and not card.debuff then
      SMODS.add_card { key = 'c_stall_blacksludge', edition = 'e_negative' }
    end
    return pseudorandom(pseudoseed('toxel')) < .5
        and level_evo(self, card, context, "j_agar_toxtricity_amped")
        or level_evo(self, card, context, "j_agar_toxtricity_lowkey")
  end,
}

local toxtricity_amped = {
  name = "toxtricity_amped",
  pos = { x = 6, y = 0, },
  config = { extra = {} },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = {} }
  end,
  rarity = 3,
  cost = 7,
  stage = "Basic",
  ptype = "Lightning",
  gen = 8,
  atlas = "AtlasJokersBasicGen08",
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
}

local toxtricity_lowkey = {
  name = "toxtricity_lowkey",
  pos = { x = 8, y = 0, },
  config = { extra = {} },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = {} }
  end,
  rarity = 3,
  cost = 7,
  stage = "Basic",
  ptype = "Lightning",
  gen = 8,
  atlas = "AtlasJokersBasicGen08",
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
}

return {
  enabled = (SMODS.Mods["ToxicStall"] or {}).can_load and agarmons_config.toxel,
  list = { toxel, toxtricity_amped, toxtricity_lowkey }
}
