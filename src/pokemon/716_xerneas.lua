-- Xerneas 716
local xerneas = {
  name = "xerneas",
  pos = { x = 4, y = 0 },
  soul_pos = { x = 5, y = 0 },
  config = { extra = { energy_limit_mod = 1, energy_mod = 1, Xmult = 1, Xmult_mod = 1, hands = 4, hands_remaining = 4 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = { set = 'Other', key = 'energize' }
    end
    return {
      vars = {
        center.ability.extra.energy_limit_mod,
        center.ability.extra.energy_mod,
        center.ability.extra.Xmult_mod,
        center.ability.extra.hands,
        center.ability.extra.hands_remaining,
        center.ability.extra.Xmult
      }
    }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Fairy",
  gen = 6,
  atlas = "AgarmonsJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        Xmult = card.ability.extra.Xmult
      }
    end
    if not context.blueprint then
      -- Gain XMult per Hand
      if context.before and context.cardarea == G.jokers then
        card.ability.extra.hands_remaining = card.ability.extra.hands_remaining - 1
        if card.ability.extra.hands_remaining > 0 then
          return {
            message = localize("agar_geomancy_charging")
          }
        else
          card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
          card.ability.extra.hands_remaining = card.ability.extra.hands
          return {
            message = localize("agar_geomancy_ex"),
            colour = G.ARGS.LOC_COLOURS.fairy,
            sound = "tarot1",
          }
        end
      end
      -- Energize new Fairy type Jokers
      if context.card_added and context.cardarea == G.jokers
          and not context.card.ability.consumeable
          and energy_matches(context.card, "Fairy") then
        AG.energy.increase(context.card, card.ability.extra.energy_mod)
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    AG.energy.increase_limit(card.ability.extra.energy_limit_mod)
    AG.energy.increase_all("Fairy", card.ability.extra.energy_mod)
    -- Make the Sprite change pop alongside the Energy increase
    G.E_MANAGER:add_event(Event({
      func = function()
        card.children.floating_sprite:set_sprite_pos { x = 7, y = 0 }
        return true
      end
    }))
    AG.energy.increase(card, "Fairy", card.ability.extra.energy_mod, true)
  end,
  remove_from_deck = function(self, card, from_debuff)
    AG.energy.decrease_limit(card.ability.extra.energy_limit_mod)
    AG.energy.decrease_all("Fairy", card.ability.extra.energy_mod)
  end,
  load = function(self, card, card_table, other_card)
    -- Load Active Form Sprite
    G.E_MANAGER:add_event(Event({
      func = function()
        card.children.floating_sprite:set_sprite_pos { x = 7, y = 0 }
        return true
      end
    }))
  end,
}

local init = function()
  -- Energize/De-Energize when using Tera Orb in and out of Fairy Aura
  local apply_type_sticker_orig = apply_type_sticker
  apply_type_sticker = function(card, ...)
    local xerneas_present = next(SMODS.find_card('j_agar_xerneas', true))
    if xerneas_present and energy_matches(card, "Fairy") then
      AG.energy.decrease(card, "Fairy")
    end
    apply_type_sticker_orig(card, ...)
    if xerneas_present and energy_matches(card, "Fairy") then
      AG.energy.increase(card, "Fairy")
    end
  end
end

return {
  config_key = "xerneas",
  init = init,
  list = { xerneas }
}
