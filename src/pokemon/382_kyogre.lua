-- Kyogre 382
local kyogre = {
  name = "kyogre",
  config = { extra = { retriggers = 2, type_req = 3, bonus_retriggers = 1 } },
  loc_vars = function(self, info_queue, card)
    local total_retriggers = self:get_retriggers(card)
    local retrigger_loc_key = 'b_retrigger_' .. (total_retriggers == 1 and 'single' or 'plural')
    return { vars = { card.ability.extra.type_req, self:get_retriggers(card), localize(retrigger_loc_key) } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Water",
  gen = 3,
  blueprint_compat = true,
  get_retriggers = function(self, card)
    if not G.jokers then return 1 end
    local bonus_joker_mod = math.floor(#pokermon.find_pokemon_type('Water') / card.ability.extra.type_req)
    return card.ability.extra.retriggers + bonus_joker_mod * card.ability.extra.bonus_retriggers
  end,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) then
      return {
        repetitions = self:get_retriggers(card)
      }
    end
  end,
}

-- Primal Kyogre 382-1
local primal_kyogre = {
  name = "primal_kyogre",
  rarity = "agar_primal",
  cost = 30,
  stage = "Primal",
  ptype = "Water",
  gen = 3,
  aux_poke = true, -- Required for Transformation
  calculate = function(self, card, context)
    if context.final_scoring_step and not G.GAME.desolate_land then
      mult = 1
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.primordial_sea = true
    if G.hand and G.hand.cards then
      G.hand:parse_highlighted() -- For immediate feedback on the Poker Hand mult values
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    if not next(SMODS.find_card('j_agar_primal_kyogre')) then
      G.GAME.primordial_sea = false
      if G.hand and G.hand.cards then
        G.hand:parse_highlighted()
      end
    end
    for _, orb in pairs(SMODS.find_card("c_agar_blueorb", true)) do
      if orb.ability.extra.active then
        orb.ability.extra.active = false
        break
      end
    end
  end,
}

local init = function()
  AG.hookbeforefunc(_G, 'update_hand_text', function(config, vals)
    if G.GAME.primordial_sea and not G.GAME.desolate_land and vals.mult and vals.mult ~= 0 then
      vals.mult = 1
    end
  end)
end

return {
  config_key = "kyogre",
  -- init = init,
  list = { kyogre } --, primal_kyogre }
}
