-- Mega Feraligatr 160-1
local mega_feraligatr = {
  name = "mega_feraligatr",
  agar_inject_prefix = "poke",
  pos = { x = 4, y = 2 },
  soul_pos = { x = 5, y = 2 },
  config = { extra = { hands = 1, chip_mod = 10 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.hands, center.ability.extra.chip_mod } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Water",
  gen = 2,
  atlas = "AgarmonsJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers
        and context.scoring_hand then
      for _, scoring_card in pairs(context.scoring_hand) do
        scoring_card.ability.perma_bonus = scoring_card.ability.perma_bonus or 0
        scoring_card.ability.perma_bonus = scoring_card.ability.perma_bonus +
            card.ability.extra.chip_mod * G.GAME.current_round.hands_played
        SMODS.calculate_effect({ message = localize('k_upgrade_ex'), colour = G.C.CHIPS }, scoring_card)
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
    if not from_debuff then
      ease_hands_played(card.ability.extra.hands)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
    local to_decrease = math.min(G.GAME.current_round.hands_left - 1, card.ability.extra.hands)
    if to_decrease > 0 then
      ease_hands_played(-to_decrease)
    end
  end,
  designer = "Fox",
  artist = "RetroNC",
}

local function init()
  AG.append_to_family("feraligatr", "mega_feraligatr")
  AG.add_megas_to_center("j_poke_feraligatr", "mega_feraligatr")
end

return {
  enabled = agarmons_config.new_megas,
  init = init,
  list = { mega_feraligatr }
}
