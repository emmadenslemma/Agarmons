local gmax = AGAR.GMAX

local sprite_pos = {
  base = {
    usable = { x = 0, y = 0 },
    recharging = { x = 0, y = 1 },
  },
  soul = {
    inactive = { x = 1, y = 0 },
    active = { x = 1, y = 1 },
  },
}

local function update_sprite(card)
  if card.ability.extra.usable then
    card.children.center:set_sprite_pos(sprite_pos.base.usable)
    if card.targeting then
      card.children.floating_sprite:set_sprite_pos(sprite_pos.soul.active)
    else
      card.children.floating_sprite:set_sprite_pos(sprite_pos.soul.inactive)
    end
  else
    card.children.center:set_sprite_pos(sprite_pos.base.recharging)
    card.children.floating_sprite:set_sprite_pos(sprite_pos.soul.inactive)
  end
end

local calculate_ref = SMODS.current_mod.calculate

SMODS.current_mod.calculate = function(self, context)
  if calculate_ref then
    calculate_ref(self, context)
  end
  if context.first_hand_drawn then
    SMODS.find_card("c_agar_dynamaxband")
    for _, dynamaxband in pairs(SMODS.find_card("c_agar_dynamaxband")) do
      local target = dynamaxband.targeting
      if target and not target.getting_sliced then
        poke_evolve(target, gmax.get_gmax_key(target), false, localize("agar_dynamax_ex"))
        dynamaxband.ability.extra.usable = false
        dynamaxband:juice_up()
      else
        dynamaxband.targeting = nil
      end

      update_sprite(dynamaxband)
    end
  end
end

-- Activate to """mega evolve""" to a Gmax pokemon for 3 ~~turns~~ hands
-- once per round use
-- Issues: Gmax pokemon revert before you can stake sticker them. Bummer.
local dynamaxband = {
  name = "dynamaxband",
  key = "dynamaxband",
  set = "Spectral",
  helditem = true,
  config = { extra = { usable = true } },
  pos = sprite_pos.base.usable,
  soul_pos = sprite_pos.soul.inactive,
  loc_txt = {
    name = "Dynamax Band",
    text = {
      "{C:attention}Reusable{}",
      "{br:2}ERROR - CONTACT STEAK",
      "{C:attention}Dynamaxes{} a Pokemon",
      "for the next {C:attention}3{} hands",
      "{br:2}ERROR - CONTACT STEAK",
      "Targets a Joker to",
      "{C:attention}Dynamax{} automatically if",
      "used outside of a blind",
      "{C:inactive}(Usable once per round)",
    },
  },
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue + 1] = { set = 'Other', key = 'endless' }
    if center.targeting then
      return {
        key = "c_agar_dynamaxband_targeting",
        vars = { localize { type = "name_text", set = "Joker", key = center.targeting.config.center.key } }
      }
    end
  end,
  atlas = "AgarmonsConsumables",
  cost = 4,
  hidden = true,
  soul_set = "Item",
  soul_rate = .01,
  unlocked = true,
  discovered = true,
  use = function(self, card)
    if card.targeting then
      card.targeting = nil
    else
      local target
      if #G.jokers.highlighted == 1 then
        target = G.jokers.highlighted[1]
      else
        for _, _card in pairs(G.jokers.cards) do
          if gmax.get_gmax_key(_card) then
            target = _card
            break
          end
        end
      end

      if not G.GAME.blind.in_blind then
        card.targeting = target
      else
        poke_evolve(target, gmax.get_gmax_key(target), false, localize("agar_dynamax_ex"))
        card.ability.extra.usable = false
      end
    end

    update_sprite(card)
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
      return gmax.get_gmax_key(G.jokers.highlighted[1]) ~= nil
    else
      for _, _card in pairs(G.jokers.cards) do
        if gmax.get_gmax_key(_card) then
          return true
        end
      end

      return false
    end
  end,
  calculate = function(self, card, context)
    if context.end_of_round and not card.ability.extra.usable then
      card.ability.extra.usable = true
      update_sprite(card)
      card_eval_status_text(card, "extra", nil, nil, nil, { message = localize("k_reset") })
    end
    if context.selling_card then
      if card.targeting == context.card then
        card.targeting = nil
        update_sprite(card)
      end
    end
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    for _, card in pairs(G.jokers.cards) do
      if gmax.get_gmax_key(card) then
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
