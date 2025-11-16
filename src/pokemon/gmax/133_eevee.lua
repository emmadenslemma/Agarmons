-- G-Max Eevee 133
local gmax_eevee = {
  name = "gmax_eevee",
  inject_prefix = "poke",
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
  AG.append_to_family("eevee", "gmax_eevee")
  AG.gmax.evos["j_poke_eevee"] = "j_poke_gmax_eevee"
end

return {
  name = "Agarmons G-Max Eevee",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_eevee }
}
