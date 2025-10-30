local target_utils = AGAR.TARGET_UTILS

local blueorb = {
  name = "blueorb",
  key = "blueorb",
  set = "Spectral",
  pos = { x = 3, y = 0 },
  helditem = true,
  config = { extra = { usable = true, active = false } },
  loc_txt = {
    name = "Blue Orb",
    text = {
      "Awaken {C:attention}Kyogre{}'s",
      "true potential",
      "{C:inactive}(Usable once per round)",
    }
  },
  loc_vars = function(self, info_queue, center)
    if center.ability.extra.active then
      return { key = "c_agar_blueorb_active" }
    end
  end,
  atlas = "AgarmonsConsumables",
  cost = 4,
  hidden = true,
  soul_set = "Item",
  soul_rate = .005,
  use = function(self, card)
    local target_key = card.ability.extra.active and "j_agar_primal_kyogre" or "j_agar_kyogre"
    local evolve_to = card.ability.extra.active and "j_agar_kyogre" or "j_agar_primal_kyogre"

    local target = target_utils.find_leftmost_or_highlighted(target_key)

    poke_evolve(target, evolve_to)

    card.ability.extra.active = not card.ability.extra.active
    card.ability.extra.usable = false
  end,
  can_use = function(self, card)
    -- Conditionals taken from Pokermon's Mega Stone
    if G.STATE == G.STATES.SMODS_BOOSTER_OPENED
        or G.STATE == G.STATES.TAROT_PACK
        or G.STATE == G.STATES.SPECTRAL_PACK
        or G.STATE == G.STATES.PLANET_PACK
        or G.STATE == G.STATES.STANDARD_PACK
        or card.area == G.shop_jokers
        or not (G.jokers and G.jokers.cards)
        or #G.jokers.cards == 0
        or not card.ability.extra.usable then
      return false
    end

    local target_key = card.ability.extra.active and "j_agar_primal_kyogre" or "j_agar_kyogre"

    return target_utils.find_leftmost_or_highlighted(target_key)
  end,
  calculate = function(self, card, context)
    if context.end_of_round and not card.ability.extra.usable then
      card.ability.extra.usable = true
      card_eval_status_text(card, "extra", nil, nil, nil, { message = localize("k_reset") })
    end
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return target_utils.find_leftmost("j_agar_kyogre")
  end,
  remove_from_deck = function(self, card, from_debuff)
    if card.ability.extra.active then
      local target = target_utils.find_leftmost("j_agar_primal_kyogre")
      if target then
        poke_evolve(target, "j_agar_kyogre")
      end
    end
  end
}

return {
  name = "Blue Orb",
  enabled = agarmons_config.kyogre or false,
  list = { blueorb }
}
