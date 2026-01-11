-- Mega Lucario 448-1
local mega_lucario = {
  name = "mega_lucario",
  agar_inject_prefix = "poke",
  config = { extra = { Xmult_multi = 1.3, Xmult_multi1 = 0.2 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_multi, card.ability.extra.Xmult_multi1 } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Fighting",
  gen = 4,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.hand and not context.end_of_round
        and context.other_card.edition then
      if context.other_card.debuff then
        return {
          message = localize('k_debuffed'),
          colour = G.C.RED,
        }
      else
        local unique_editions = AG.list_utils.count_unique(G.hand.cards,
          function(c) return c.edition and c.edition.type end)
        return {
          Xmult = card.ability.extra.Xmult_multi + unique_editions * card.ability.extra.Xmult_multi1
        }
      end
    end
  end,
}

local function init()
  pokermon.add_family { "lucario", "mega_lucario" }
  SMODS.Joker:take_ownership("poke_lucario", { megas = { "mega_lucario" } }, true)
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_lucario }
}
