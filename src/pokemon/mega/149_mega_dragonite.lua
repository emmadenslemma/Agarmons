local function is_high_card(hand)
  local results = evaluate_poker_hand(hand)
  for _, v in ipairs(G.handlist) do
    if next(results[v]) then
      return v == 'High Card'
    end
  end
end

-- Mega Dragonite 149-1
local mega_dragonite = {
  name = "mega_dragonite",
  agar_inject_prefix = "poke",
  config = { extra = { Xmult_multi = 2.5 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_multi } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Dragon",
  gen = 1,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.modify_scoring_hand and not context.blueprint and is_high_card(context.full_hand) then
      return {
        add_to_hand = true
      }
    end
    if context.individual and context.cardarea == G.play and context.scoring_name == "High Card" then
      return {
        Xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
}

local function init()
  pokermon.add_family { "dragonite", "mega_dragonite" }
  SMODS.Joker:take_ownership("poke_dragonite", { megas = { "mega_dragonite" } }, true)
end

return {
  can_load = false, -- agarmons_config.new_megas,
  init = init,
  list = { mega_dragonite }
}
