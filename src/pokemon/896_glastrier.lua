-- Glastrier 896
local glastrier = {
  name = "glastrier",
  config = { extra = { Xmult = 1, Xmult_mod = 0.25 } },
  loc_vars = function(self, info_queue, card)
    local key = pokermon_config.pokemon_aprilfools and (self.key .. '_aprilfools') or self.key
    return { key = key, vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Water",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        Xmult = card.ability.extra.Xmult
      }
    end
  end,
  in_pool = function(self)
    return (next(SMODS.find_card("j_poke_pokedex")) or not next(SMODS.find_card("j_agar_calyrex_ice")))
  end,
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
      pokermon.create_held_item("c_poke_icestone")
    end
  end,
  designer = 'Eternalnacho'
  -- fuses = { with = "j_agar_calyrex", into = "j_agar_calyrex_ice" }
}

return {
  config_key = "glastrier",
  list = { glastrier }
}
