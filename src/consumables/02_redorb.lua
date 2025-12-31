local redorb = {
  name = "redorb",
  key = "redorb",
  set = "Spectral",
  pos = { x = 2, y = 0 },
  helditem = true,
  saveable = true,
  config = { extra = { usable = true, active = false } },
  loc_txt = {
    name = "Red Orb",
    text = {
      "Awaken {C:attention}Groudon{}'s",
      "true potential",
      "{C:inactive}(Usable once per round)",
    },
  },
  loc_vars = function(self, info_queue, center)
    if center.ability.extra.active then
      return { key = "c_agar_redorb_active" }
    end
  end,
  atlas = "AgarmonsConsumables",
  cost = 4,
  hidden = true,
  soul_set = "Item",
  soul_rate = .005,
  use = function(self, card)
    local target_key = card.ability.extra.active and "j_agar_primal_groudon" or "j_agar_groudon"
    local evolve_to = card.ability.extra.active and "j_agar_groudon" or "j_agar_primal_groudon"

    local target = poke_find_leftmost_or_highlighted(target_key)

    poke_evolve(target, evolve_to)

    card.ability.extra.active = not card.ability.extra.active
    card.ability.extra.usable = false
  end,
  can_use = function(self, card)
    if not card.ability.extra.usable then return false end

    local target_key = card.ability.extra.active and "j_agar_primal_groudon" or "j_agar_groudon"

    return poke_find_leftmost_or_highlighted(target_key)
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
    return next(SMODS.find_card("j_agar_groudon"))
  end,
  remove_from_deck = function(self, card, from_debuff)
    if card.ability.extra.active then
      local target = SMODS.find_card("j_agar_primal_groudon")[1]
      if target then
        poke_evolve(target, "j_agar_groudon")
      end
    end
  end
}

return {
  can_load = agarmons_config.groudon,
  list = { redorb }
}
