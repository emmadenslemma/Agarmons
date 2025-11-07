-- G-Max Eevee 133
local gmax_eevee = {
  name = "gmax_eevee",
  pos = { x = 0, y = 8 },
  soul_pos = { x = 1, y = 8 },
  config = { extra = { Xmult = 2.66 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Eevee",
    text = {
      "{C:white,X:mult}X#3#{} Mult",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.Xmult } }
  end,
  rarity = "agar_gmax",
  cost = 8,
  stage = "Gigantamax",
  ptype = "Colorless",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        Xmult = card.ability.extra.Xmult,
      }
    end
  end,
}

local init = function()
  AGAR.GMAX.evos["j_poke_eevee"] = "j_agar_gmax_eevee"
  AGAR.FAMILY_UTILS.init_gmax(gmax_eevee)
end

return {
  name = "Agarmons G-Max Eevee",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_eevee }
}
