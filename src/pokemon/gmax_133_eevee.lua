-- G-Max Eevee 133
local gmax_eevee = {
  name = "gmax_eevee",
  pos = { x = 0, y = 8 },
  soul_pos = { x = 1, y = 8 },
  config = { extra = { Xmult_mod = 1.5 } },
  loc_txt = {
    name = "Gigantamax Eevee",
    text = {
      "{C:white,X:mult}X#3#{} Mult for each",
      "adjacent Joker",
      "{C:inactive}(Currently {C:white,X:mult}X#4#{C:inactive})",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local current_Xmult = 0
    -- No way to count adjacent jokers in the collection screen
    if center.area and center.area.config and not center.area.config.collection then
      current_Xmult = center.ability.extra.Xmult_mod * #poke_get_adjacent_jokers(center)
    end
    return { vars = { center.ability.extra.Xmult_mod, current_Xmult } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Colorless",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      local current_Xmult = card.ability.extra.Xmult_mod * #poke_get_adjacent_jokers(card)
      if current_Xmult > 1 then
        return {
          message = localize("agar_gmax_cuddle_ex"),
          Xmult = current_Xmult,
        }
      end
    end
  end,
}

local init = function()
  GMAX.evos["j_poke_eevee"] = "j_agar_gmax_eevee"
end

return {
  name = "Agarmons G-Max Eevee",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_eevee }
}
