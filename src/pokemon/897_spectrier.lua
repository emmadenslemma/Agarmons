-- Spectrier 897
local spectrier = {
  name = "spectrier",
  config = { extra = { Xmult = 1, Xmult_mod = 0.25, active = true } },
  loc_txt = {
    name = "Spectrier",
    text = {
      "{C:attention}Holding {C:spectral}#1#",
      "Gains {C:white,X:mult}X#2#{} Mult whenever",
      "you use a {C:spectral}Spectral{} card",
      "{C:inactive}(Currently {C:white,X:mult}X#3#{C:inactive} Mult)",
      "{br:2}ERROR - CONTACT STEAK",
      "The first time a {C:spectral}Spectral",
      "card is used each round, create",
      "a random {C:spectral}Spectral{} card",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local wraith_name_text = localize { type = 'name_text', set = 'Spectral', key = 'c_wraith' }
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = { set = 'Other', key = 'holding', vars = { wraith_name_text } }
      info_queue[#info_queue+1] = G.P_CENTERS.c_wraith
    end
    return {
      vars = { wraith_name_text, card.ability.extra.Xmult_mod, card.ability.extra.Xmult },
      main_end = AG.active_tooltip(card, card.ability.extra.active),
    }
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
      return {
        Xmult = card.ability.extra.Xmult
      }
    end
    if context.using_consumeable and context.consumeable.ability.set == 'Spectral'
        and not context.consumeable.config.center.helditem then
      if not context.blueprint then
        card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
      end

      if card.ability.extra.active then
        if not context.blueprint then
          G.E_MANAGER:add_event(Event({
            func = function()
              card.ability.extra.active = false
              return true
            end
          }))
        end

        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
          G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

          G.E_MANAGER:add_event(Event({
            func = function()
              SMODS.add_card { set = 'Spectral', key_append = 'spectrier' }
              G.GAME.consumeable_buffer = 0
              return true
            end
          }))

          return {
            message = localize('k_plus_spectral'),
            colour = G.C.SECONDARY_SET.Spectral,
          }
        end
      end
    end
    if context.first_hand_drawn and not context.blueprint then
      card.ability.extra.active = true
      juice_card_until(card, function(_card) return _card.ability.extra.active and not G.RESET_JIGGLES end, true)
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
  config_key = "calyrex",
  list = { spectrier }
}
