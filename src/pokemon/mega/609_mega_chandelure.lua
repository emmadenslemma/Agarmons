-- Mega Chandelure 609-1
local mega_chandelure = {
  name = "mega_chandelure",
  agar_inject_prefix = "poke",
  pos = { x = 0, y = 2 },
  soul_pos = { x = 1, y = 2 },
  config = { extra = { Xmult_multi = 1, Xmult_multi1 = 0.03 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local current_Xmult = card.ability.extra.Xmult_multi + card.ability.extra.Xmult_multi1 * card.sell_cost
    return { vars = { card.ability.extra.Xmult_multi1, current_Xmult } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Fire",
  gen = 5,
  designer = "Gem",
  atlas = "AgarmonsJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.other_joker and context.other_joker.sell_cost < 2 then
      return {
        Xmult = card.ability.extra.Xmult_multi + card.ability.extra.Xmult_multi1 * card.sell_cost
      }
    end
  end,
  artist = "KingOfThe-X-Roads",
}

local function init()
  AG.append_to_family("chandelure", "mega_chandelure")
  AG.add_megas_to_center("j_poke_chandelure", "mega_chandelure")
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_chandelure }
}
