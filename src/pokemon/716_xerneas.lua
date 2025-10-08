local energy = AGAR.ENERGY

-- Xerneas 716
local xerneas = {
  name = "xerneas",
  pos = { x = 4, y = 0 },
  soul_pos = { x = 5, y = 0 },
  config = { extra = { energy_limit_mod = 1, energy_mod = 1, Xmult = 1, Xmult_mod = 1, hands = 4, hands_remaining = 4 } },
  loc_txt = {
    name = "Xerneas",
    text = {
      "{C:pink}+#1#{} Energy Limit",
      "Energize {C:white,X:fairy}Fairy{} Jokers by {C:pink}#2#",
      "{br:2}ERROR - CONTACT STEAK",
      "Gains {C:white,X:mult}X#3#{} Mult for every",
      "{C:attention}#4#{C:inactive} [#5#]{} hands played",
      "{C:inactive}(Currently {C:white,X:mult}X#6#{C:inactive} Mult)",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue + 1] = { set = 'Other', key = 'energize' }
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
    if context.joker_main
        and card.ability.extra.Xmult > 1 then
      return {
        Xmult = card.ability.extra.Xmult
      }
    end
    -- Gain XMult per Hand
    if context.after and context.cardarea == G.jokers then
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
        and not context.card.ability.consumeable then
      energy.increase(context.card, card.ability.extra.energy_mod)
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    energy.increase_limit(card.ability.extra.energy_limit_mod)
    energy.increase_all("Fairy", card.ability.extra.energy_mod)
    -- Make the Sprite change pop alongside the Energy increase
    G.E_MANAGER:add_event(Event({
      func = function()
        card.children.floating_sprite:set_sprite_pos { x = 7, y = 0 }
        return true
      end
    }))
    energy.increase(card, "Fairy", card.ability.extra.energy_mod, true)
  end,
  remove_from_deck = function(self, card, from_debuff)
    energy.decrease_limit(card.ability.extra.energy_limit_mod)
    energy.decrease_all("Fairy", card.ability.extra.energy_mod)
  end,
}

return {
  name = "Agarmons Xerneas",
  enabled = agarmons_config.xerneas or false,
  list = { xerneas }
}
