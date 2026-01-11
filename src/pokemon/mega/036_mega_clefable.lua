-- Mega Clefable 036-1
local mega_clefable = {
  name = "mega_clefable",
  agar_inject_prefix = "poke",
  pos = { x = 6, y = 2 },
  soul_pos = { x = 7, y = 2 },
  config = { extra = { Xmult_multi = 0.1 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_multi } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Fairy",
  gen = 1,
  atlas = "AgarmonsJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.end_of_round
        and context.other_card:is_suit("Clubs") then
      local clubs = #AG.list_utils.filter(context.scoring_hand, function(c) return c:is_suit('Clubs') end)
      return {
        Xmult = 1 + card.ability.extra.Xmult_multi * clubs
      }
    end
  end,
  designer = "Fox",
  artist = "KingOfThe-X-Roads",
}

local function init()
  pokermon.add_family { "clefable", "mega_clefable" }
  SMODS.Joker:take_ownership("poke_clefable", { megas = { "mega_clefable" } }, true)
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_clefable }
}
