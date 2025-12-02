-- Mega Dragonite 149-1
local mega_dragonite = {
  name = "mega_dragonite",
  agar_inject_prefix = "poke",
  pos = { x = 0, y = 1 },
  soul_pos = { x = 1, y = 1 },
  config = { extra = { Xmult_multi = 2 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_multi } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Dragon",
  gen = 1,
  atlas = "AgarmonsJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.end_of_round
        and context.scoring_hand and context.scoring_name == "High Card" then
      return {
        Xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
}

local function init()
  AG.append_to_family("dragonite", "mega_dragonite")
  SMODS.Joker:take_ownership("poke_dragonite", { megas = { "mega_dragonite" } }, true)

  AG.hookafterfunc(_G, 'applies_splash', function()
    return next(SMODS.find_card("j_poke_mega_dragonite"))
  end)
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_dragonite }
}
