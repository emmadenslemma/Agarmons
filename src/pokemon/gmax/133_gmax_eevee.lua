-- G-Max Eevee 133
local gmax_eevee = {
  name = "gmax_eevee",
  agar_inject_prefix = "poke",
  config = { extra = { Xmult = 2.66 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Eevee",
    text = {
      "{C:white,X:mult}X#3#{} Mult",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult } }
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
  poke_add_to_family("eevee", "gmax_eevee")

  SMODS.Joker:take_ownership("poke_eevee", { gmax = "gmax_eevee" }, true)
end

return {
  can_load = agarmons_config.gmax,
  init = init,
  list = { gmax_eevee }
}
