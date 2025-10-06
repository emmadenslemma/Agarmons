-- Activate to """mega evolve""" to a Gmax pokemon for 3 ~~turns~~ hands
-- once per round use
-- Issues: Having to use it on the same mon repeatedly - have it auto-use on entering blind?
--   what happens if it's already Gmaxed? can we un-gmax at the end of blind? test if stake stickers still apply
local dynamaxband = {
  name = "dynamaxband",
  key = "dynamaxband",
  set = "Spectral",
  helditem = true,
  config = { extra = { usable = true } },
  pos = { x = 0, y = 0 },
  loc_txt = {
    name = "Dynamax Band",
    text = {
      "{C:attention}Reusable{}",
      "{br:2}ERROR - CONTACT STEAK",
      "{C:attention}Dynamaxes{} a Pokemon",
      "for the next {C:attention}3{} hands",
      "{C:inactive}(Usable once per round)",
    },
  },
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue + 1] = { set = 'Other', key = 'endless' }
  end,
  atlas = "AgarmonsConsumables",
  cost = 4,
  hidden = true,
  soul_set = "Item",
  soul_rate = .01,
  unlocked = true,
  discovered = true,
  use = function(self, card)
    local target
    if #G.jokers.highlighted == 1 then
      target = G.jokers.highlighted[1]
    else
      for _, _card in pairs(G.jokers) do
        if GMAX.get_gmax_key(_card) then
          target = _card
          break
        end
      end
    end

    poke_evolve(target, GMAX.get_gmax_key(target), false, localize("agar_dynamax_ex"))

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

    if G.jokers.highlighted and #G.jokers.highlighted == 1 then
      return GMAX.get_gmax_key(G.jokers.highlighted[1]) ~= nil
    else
      for _, _card in pairs(G.jokers) do
        if GMAX.get_gmax_key(_card) then
          return true
        end
      end

      return false
    end
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
    for _, card in pairs(G.jokers) do
      if GMAX.get_gmax_key(card) then
        return true
      end
    end
    return false
  end,
}

return {
  name = "Agarmons Dynamax Band",
  enabled = agarmons_config.gmax or false,
  list = { dynamaxband }
}
