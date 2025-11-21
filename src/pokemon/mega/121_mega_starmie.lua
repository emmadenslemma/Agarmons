-- Mega Starmie 121-1
local mega_starmie = {
  name = "mega_starmie",
  agar_inject_prefix = "poke",
  pos = { x = 6, y = 1 },
  soul_pos = { x = 7, y = 1 },
  config = { extra = { mult_mod = 1, money_mod = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.mult_mod, center.ability.extra.money_mod } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Water",
  gen = 1,
  atlas = "AgarmonsJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers
        and context.scoring_hand then
      for _, scoring_card in pairs(context.scoring_hand) do
        if scoring_card:is_suit('Diamonds') then
          scoring_card.ability.perma_p_dollars = scoring_card.ability.perma_p_dollars or 0
          scoring_card.ability.perma_p_dollars = scoring_card.ability.perma_p_dollars + card.ability.extra.money_mod
          scoring_card.ability.perma_mult = scoring_card.ability.perma_mult or 0
          scoring_card.ability.perma_mult = scoring_card.ability.perma_mult + card.ability.extra.mult_mod
          SMODS.calculate_effect({ message = localize('k_upgrade_ex'), colour = G.C.MULT }, scoring_card)
        end
      end
    end
  end,
  designer = "Fox",
  artist = "KingOfThe-X-Roads",
}

local function init()
  AG.append_to_family("starmie", "mega_starmie")
  AG.add_megas_to_center("j_poke_starmie", "mega_starmie")
end

return {
  enabled = agarmons_config.new_megas,
  init = init,
  list = { mega_starmie }
}
