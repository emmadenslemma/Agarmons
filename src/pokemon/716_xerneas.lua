-- Xerneas 716
local xerneas = {
  name = "xerneas",
  pos = { x = 4, y = 0 },
  soul_pos = { x = 5, y = 0 },
  config = { extra = { Xmult = 1, Xmult_mod = 1, hands = 4, hands_remaining = 4 } },
  loc_vars = function(self, info_queue, card)
    pokermon.type_tooltip(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = { set = 'Other', key = 'fairy_aura' }
    end
    return {
      vars = {
        card.ability.extra.Xmult_mod,
        card.ability.extra.hands,
        card.ability.extra.hands_remaining,
        card.ability.extra.Xmult
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
    -- Gain XMult per Hand
    if context.before and context.cardarea == G.jokers and not context.blueprint then
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
          colour = pokermon.colours.fairy,
          sound = "tarot1",
        }
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    AG.effects.activate_type_aura("Fairy")
    -- Make the Sprite change pop alongside the Energy increase
    G.E_MANAGER:add_event(Event({
      func = function()
        card.children.floating_sprite:set_sprite_pos { x = 7, y = 0 }
        return true
      end
    }))
  end,
  remove_from_deck = function(self, card, from_debuff)
    AG.effects.deactivate_type_aura("Fairy")
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

return {
  config_key = "xerneas",
  list = { xerneas }
}
