-- Poltchageist 1012
local poltchageist = {
  name = "poltchageist",
  config = { extra = { chips = 0, chip_mod = 2, num = 1, dem = 5, rounds = 3 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local num, dem = SMODS.get_probability_vars(center, center.ability.extra.num, center.ability.extra.dem, "poltchageist")
    return { vars = { center.ability.extra.chip_mod, num, dem, center.ability.extra.chips, center.ability.extra.rounds } }
  end,
  rarity = 1,
  cost = 8,
  stage = "Basic",
  ptype = "Grass",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
      return {
        func = function()
          SMODS.calculate_effect({ message = localize("k_upgrade_ex"), colour = G.C.CHIPS }, card)
        end
      }
    end
    if context.joker_main then
      return {
        chips = card.ability.extra.chips
      }
    end
    if context.pre_discard and not context.blueprint
        and SMODS.pseudorandom_probability(card, "poltchageist", card.ability.extra.num, card.ability.extra.dem, "poltchageist") then
      SMODS.destroy_cards(card, nil, nil, true)
      return {
        message = localize('k_eaten_ex'),
      }
    end
    return level_evo(self, card, context, "j_agar_sinistcha")
  end,
}

-- Sinistcha 1013
local sinistcha = {
  name = "sinistcha",
  config = { extra = { chips = 0, chip_mod = 3, num = 1, dem = 5 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local num, dem = SMODS.get_probability_vars(center, center.ability.extra.num, center.ability.extra.dem, "sinistcha")
    return { vars = { center.ability.extra.chip_mod, num, dem, center.ability.extra.chips } }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Grass",
  gen = 10,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
      return {
        func = function()
          SMODS.calculate_effect({ message = localize("k_upgrade_ex"), colour = G.C.CHIPS }, card)
        end
      }
    end
    if context.joker_main then
      return {
        chips = card.ability.extra.chips
      }
    end
    if context.pre_discard and not context.blueprint
        and SMODS.pseudorandom_probability(card, "sinistcha", card.ability.extra.num, card.ability.extra.dem, "sinistcha") then
      SMODS.destroy_cards(card, nil, nil, true)
      return {
        message = localize('k_eaten_ex'),
        func = function()
          -- From Vanilla Remade 8 Ball
          G.E_MANAGER:add_event(Event({
            func = function()
              if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                SMODS.add_card { set = 'Spectral' }
                G.GAME.consumeable_buffer = 0
              end
              return true
            end
          }))
        end
      }
    end
  end,
}

return {
  enabled = agarmons_config.poltchageist or false,
  list = { poltchageist, sinistcha }
}
