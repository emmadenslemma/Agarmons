-- Beta Arceus 493?
local beta_arceus = {
  name = "beta_arceus",
  pos = { x = 8, y = 0 },
  soul_pos = { x = 9, y = 0 },
  config = { extra = { Emult = 2 } },
  loc_txt = {
    name = "Arceus?",
    text = {
      "{C:white,X:dark_edition}^#1#{} Mult",
    }
  },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Emult } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Colorless",
  gen = 4,
  atlas = "AgarmonsJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        message = localize { type = 'variable', key = 'agar_a_powmult', vars = { card.ability.extra.Emult } },
        colour = G.C.DARK_EDITION,
        Emult_mod = card.ability.extra.Emult,
      }
    end
  end,
}

local init = function()
  pokermon.energy.values.Emult = 0.01
end

return {
  can_load = pokermon_config.pokemon_aprilfools and next(SMODS.find_mod('Talisman')) or false,
  init = init,
  list = { beta_arceus },
}
