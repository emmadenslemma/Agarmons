-- Mega Salamence 373-1
local mega_salamence = {
  name = "mega_salamence",
  agar_inject_prefix = "poke",
  config = { extra = { hand_size = 5 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.hand_size } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Dragon",
  gen = 3,
  calculate = function(self, card, context)
    if context.before and context.scoring_name == "Straight" then
      G.hand:change_size(card.ability.extra.hand_size)
      G.GAME.round_resets.temp_handsize = (G.GAME.round_resets.temp_handsize or 0) + card.ability.extra.hand_size
      return {
        message = localize({ type = 'variable', key = 'a_handsize', vars = { card.ability.extra.hand_size } })
      }
    end
  end,
}

local function init()
  pokermon.add_family { "salamence", "mega_salamence" }
  SMODS.Joker:take_ownership("poke_salamence", { megas = { "mega_salamence" } }, true)
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_salamence }
}
