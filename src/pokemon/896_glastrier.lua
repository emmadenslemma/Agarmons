-- Glastrier 896
local glastrier = {
  name = "glastrier",
  config = { extra = { Xmult = 1, Xmult_mod = 0.4 } },
  loc_txt = {
    name = "Glastrier",
    text = {
      "{C:attention}Glass{} cards cannot break",
      "{br:2}ERROR - CONTACT STEAK",
      "{C:white,X:mult}X#1#{} Mult for every",
      "{C:attention}Glass Card{} in your full deck",
      "{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult)",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local Xmult_total = card.ability.extra.Xmult
    if G.playing_cards then
      local glass_count = #AG.list_utils.filter(
        G.playing_cards,
        function(c) return SMODS.has_enhancement(c, 'm_glass') end
      )

      Xmult_total = Xmult_total + card.ability.extra.Xmult_mod * glass_count
    end
    return { vars = { card.ability.extra.Xmult_mod, Xmult_total } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Water",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      local glass_count = #AG.list_utils.filter(
        G.playing_cards,
        function(c) return SMODS.has_enhancement(c, 'm_glass') end
      )

      return {
        Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod * glass_count
      }
    end
  end,
  fuses = { with = "j_agar_calyrex", into = "j_agar_calyrex_ice" }
}

return {
  config_key = "glastrier",
  list = { glastrier }
}
