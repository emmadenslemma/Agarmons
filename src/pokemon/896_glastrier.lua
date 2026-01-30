-- Glastrier 896
local glastrier = {
  name = "glastrier",
  config = { extra = { Xmult = 1, Xmult_mod = 0.4 } },
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
    local key = pokermon_config.pokemon_aprilfools and (self.key .. '_aprilfools') or self.key
    return { key = key, vars = { card.ability.extra.Xmult_mod, Xmult_total } }
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
  in_pool = function(self)
    return (next(SMODS.find_card("j_poke_pokedex")) or not next(SMODS.find_card("j_agar_calyrex_ice")))
  end,
  -- fuses = { with = "j_agar_calyrex", into = "j_agar_calyrex_ice" }
}

return {
  config_key = "glastrier",
  list = { glastrier }
}
