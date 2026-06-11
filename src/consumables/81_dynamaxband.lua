-- activate auto-gmax feature
if agarmons_config.gmax then
  AG.hookafterfunc(SMODS.current_mod, 'calculate', function(self, context)
    if context.first_hand_drawn then
      for _, card in pairs(SMODS.find_card("c_agar_dynamaxband")) do
        local target = card.config.center:get_target(card)
        if target and not target.getting_sliced and not target.agar_gmax_evolving then
          target.agar_gmax_evolving = true
          AG.gmax.evolve(target)
          -- Event to fix dynamax band losing its charge but the target
          -- not being gmaxed if you quit to main menu after starting blind
          G.E_MANAGER:add_event(Event({
            func = function()
              card.ability.extra.usable = false
              target.agar_gmax_evolving = nil
              return true
            end
          }))
        end
      end
    end
  end)
end

local dynamaxband = {
  name = "dynamaxband",
  key = "dynamaxband",
  set = "Spectral",
  pos = { x = 0, y = 0 },
  soul_pos = { x = 1, y = 0 },
  helditem = true,
  saveable = true,
  config = { extra = { usable = true, target = nil } },
  loc_txt = {
    name = "Dynamax Band",
    text = {
      "{C:attention}Reusable{}",
      "{br:2}ERROR - CONTACT STEAK",
      "{C:attention}Dynamaxes{} a Pokemon",
      "for the next {C:attention}3{} hands",
    }
  },
  loc_vars = function(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = { set = 'Other', key = 'endless' }
    end
    local target = self:get_target(card)
    if target then
      return {
        key = "c_agar_dynamaxband_targeting",
        vars = { localize { type = "name_text", set = "Joker", key = target.config.center.key } }
      }
    end
  end,
  atlas = "AgarmonsConsumables",
  cost = 4,
  hidden = true,
  soul_set = "poke_item",
  soul_rate = .0066,
  get_target = function(self, card)
    if card.ability.extra.target then
      local target = pokermon.find_card(function(joker) return joker.unique_val == card.ability.extra.target end)
      if not target then card.ability.extra.target = nil end
      return target
    end
  end,
  use = function(self, card)
    local target = pokermon.find_leftmost_or_highlighted(AG.gmax.get_gmax_key)
    card.ability.extra.usable = false
    if G.GAME.blind.in_blind then
      AG.gmax.evolve(target)
    end
    card.ability.extra.target = target.unique_val
    card.ability.extra.target__ID = target.unique_val__saved_ID or target.ID
  end,
  can_use = function(self, card)
    return (#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit or card.area ~= G.pack_cards)
        and card.ability.extra.usable
        and pokermon.find_leftmost_or_highlighted(AG.gmax.get_gmax_key)
  end,
  calculate = function(self, card, context)
    if context.end_of_round and not card.ability.extra.usable then
      card.ability.extra.usable = true
      return {
        message = localize("k_reset")
      }
    end
    if context.selling_card and card.ability.extra.target then
      if context.card.unique_val == card.ability.extra.target then
        card.ability.extra.target = nil
      end
    end
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return pokermon.find_leftmost_or_highlighted(AG.gmax.get_gmax_key)
  end,
  update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN then
      card.children.center:set_sprite_pos(card.ability.extra.usable and { x = 0, y = 0 } or { x = 0, y = 1 })
      card.children.floating_sprite:set_sprite_pos(card.ability.extra.target and { x = 1, y = 1 } or { x = 1, y = 0 })
    end
  end,
  load = function(self, card, card_table, other_card)
    local target__ID = card_table.ability.extra.target__ID
    if target__ID and G.ID <= target__ID then
      G.ID = target__ID + 1
    end
  end,
}

return {
  can_load = agarmons_config.gmax,
  list = { dynamaxband }
}
