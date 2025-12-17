-- Mega Feraligatr 160-1
local mega_feraligatr = {
  name = "mega_feraligatr",
  agar_inject_prefix = "poke",
  pos = { x = 4, y = 2 },
  soul_pos = { x = 5, y = 2 },
  config = { extra = { Xmult = 1, Xmult1 = 0, Xmult_mod = 0.4 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult + card.ability.extra.Xmult1 } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Water",
  gen = 2,
  atlas = "AgarmonsJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult1
      }
    end
    if context.before and not context.blueprint then
      card.ability.extra.Xmult1 = card.ability.extra.Xmult1 + card.ability.extra.Xmult_mod * #context.scoring_hand
      return {
        message = localize('k_upgrade_ex'),
        colour = G.C.MULT,
      }
    end
    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
      card.ability.extra.Xmult1 = 0
      return {
        message = localize('k_reset'),
        colour = G.C.MULT,
      }
    end
  end,
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
