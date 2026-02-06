-- Magearna 801
local magearna = {
  name = "magearna",
  config = { extra = { Xmult = 1, Xmult_mod = 1 } },
  loc_txt = {
    name = "Magearna",
    text = {
      "When {C:attention}Blind{} is selected,",
      "destroys Joker to the right",
      "{br:2}ERROR - CONTACT STEAK",
      "Gains {C:white,X:mult}X#1#{} Mult when",
      "a Joker is destroyed",
      "{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult)",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Metal",
  gen = 7,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.setting_blind and not context.blueprint then
      local idx = get_index(G.jokers.cards, card)
      local to_destroy = G.jokers.cards[idx + 1]
      if to_destroy and not to_destroy.getting_sliced then
        SMODS.destroy_cards(to_destroy)
      end
    end
    if context.joker_main then
      return {
        Xmult = card.ability.extra.Xmult
      }
    end
    if context.joker_type_destroyed and not context.blueprint then
      card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
      return {
        message = localize('agar_soul_heart'),
        colour = G.ARGS.LOC_COLOURS.fairy
      }
    end
  end,
}

return {
  config_key = "magearna",
  list = { magearna }
}
