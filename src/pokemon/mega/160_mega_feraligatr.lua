-- Mega Feraligatr 160-1
local mega_feraligatr = {
  name = "mega_feraligatr",
  agar_inject_prefix = "poke",
  pos = { x = 4, y = 2 },
  soul_pos = { x = 5, y = 2 },
  config = { extra = { chip_mod = 13 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.chip_mod } }
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
  designer = "Fox",
}

local function init()
  AG.append_to_family("feraligatr", "mega_feraligatr")
  SMODS.Joker:take_ownership("poke_feraligatr", { megas = { "mega_feraligatr" } }, true)
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_feraligatr }
}
