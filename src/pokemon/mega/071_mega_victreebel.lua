-- Mega Victreebel 071-1
local mega_victreebel = {
  name = "mega_victreebel",
  inject_prefix = "poke",
  pos = { x = 2, y = 1 },
  soul_pos = { x = 3, y = 1 },
  config = { extra = { retriggers = 2 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.retriggers } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Grass",
  gen = 1,
  atlas = "AgarmonsJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play
        and poke_is_even(context.other_card) then
      return {
        repetitions = card.ability.extra.retriggers
      }
    end
  end,
  designer = "Alber_Pro",
  artist = "KingOfThe-X-Roads",
}

local function init()
  AG.append_to_family("victreebel", "mega_victreebel")
  AG.add_megas_to_center("j_poke_victreebel", "mega_victreebel")
end

return {
  enabled = agarmons_config.new_megas,
  init = init,
  list = { mega_victreebel }
}
