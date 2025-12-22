-- Spectrier 897
local spectrier = {
  name = "spectrier",
  config = { extra = { Xmult = 1, Xmult_mod = 0.4 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local wraith_name_text = localize { type = 'name_text', set = 'Spectral', key = 'c_wraith' }
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = { set = 'Other', key = 'holding', vars = { wraith_name_text } }
      info_queue[#info_queue+1] = G.P_CENTERS.c_wraith
    end
    local spectrals_used = G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.spectral or 0
    return { vars = { wraith_name_text, card.ability.extra.Xmult_mod, card.ability.extra.Xmult + card.ability.extra.Xmult_mod * spectrals_used } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Psychic",
  gen = 8,
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
    if context.joker_main then
      local spectrals_used = G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.spectral or 0
      return {
        Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod * spectrals_used
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if not from_debuff
        and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
      local wraith = SMODS.add_card { key = 'c_wraith' }
      SMODS.calculate_effect({ message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral }, wraith)
    end
  end,
  in_pool = function(self)
    return (next(SMODS.find_card("j_poke_pokedex")) or not next(SMODS.find_card("j_agar_calyrex_shadow")))
        and pokemon_in_pool(self)
  end,
  fuses = { with = "j_agar_calyrex", into = "j_agar_calyrex_shadow", evo_this = true },
}

return {
  config_key = "spectrier",
  list = { spectrier }
}
