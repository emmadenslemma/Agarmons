-- Wooloo 831
local wooloo = {
  name = "wooloo",
  config = { extra = { money_mod = 2, rerolls_to_evolve = 8 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money_mod, card.ability.extra.rerolls_to_evolve } }
  end,
  rarity = 1,
  cost = 5,
  stage = "Basic",
  ptype = "Colorless",
  gen = 8,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.reroll_shop then
      card.ability.extra.rerolls_to_evolve = math.max(0, card.ability.extra.rerolls_to_evolve - 1)
    end
    return pokermon.scaling_evo(self, card, context, 'j_agar_dubwool', 0, card.ability.extra.rerolls_to_evolve)
  end,
  add_to_deck = function(self, card, from_debuff)
    if G.GAME.current_round.reroll_cost > 0 then
      G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost - card.ability.extra.money_mod)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.current_round.reroll_cost = G.GAME.current_round.reroll_cost + card.ability.extra.money_mod
  end,
}

-- Dubwool 832
local dubwool = {
  name = "dubwool",
  config = { extra = { money_mod = 2, money_mod1 = 1 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money_mod, card.ability.extra.money_mod1, card.ability.extra.money_mod + card.ability.extra.money_mod1 * #pokermon.find_pokemon_type('Colorless') } }
  end,
  rarity = "poke_safari",
  cost = 7,
  stage = "One",
  ptype = "Colorless",
  gen = 8,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.card_added and pokermon.is_type(context.card, 'Colorless') and G.GAME.current_round.reroll_cost > 0 then
      G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost - card.ability.extra.money_mod1)
    end
    if context.selling_card and context.card ~= card and pokermon.is_type(context.card, 'Colorless') then
      G.GAME.current_round.reroll_cost = G.GAME.current_round.reroll_cost + card.ability.extra.money_mod1
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if G.GAME.current_round.reroll_cost > 0 then
      G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost
        - (card.ability.extra.money_mod + card.ability.extra.money_mod1 * #pokermon.find_pokemon_type('Colorless')
          + (pokermon.is_type(card, 'Colorless') and 1 or 0)))
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.current_round.reroll_cost = G.GAME.current_round.reroll_cost
        + card.ability.extra.money_mod + card.ability.extra.money_mod1 * #pokermon.find_pokemon_type('Colorless')
        + (pokermon.is_type(card, 'Colorless') and 1 or 0)
  end,
}

local init = function()
  AG.hookafterfunc(_G, 'calculate_reroll_cost', function()
    local cost = G.GAME.current_round.reroll_cost
    if cost <= 0 then return end
    for _, joker in ipairs(SMODS.find_card('j_agar_wooloo')) do
      cost = math.max(0, cost - joker.ability.extra.money_mod)
    end
    for _, joker in ipairs(SMODS.find_card('j_agar_dubwool')) do
      cost = math.max(0, cost - joker.ability.extra.money_mod)
      cost = math.max(0, cost - joker.ability.extra.money_mod1 * #pokermon.find_pokemon_type('Colorless'))
    end
    G.GAME.current_round.reroll_cost = cost
  end, true)
end

return {
  config_key = "wooloo",
  init = init,
  list = { wooloo, dubwool }
}
