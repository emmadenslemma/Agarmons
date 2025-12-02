-- Mega Dragonite 149-1
local mega_dragonite = {
  name = "mega_dragonite",
  agar_inject_prefix = "poke",
  pos = { x = 0, y = 1 },
  soul_pos = { x = 1, y = 1 },
  config = { extra = { retriggers = 2 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local other_joker_count = 0
    if G.jokers and G.jokers.cards then
      other_joker_count = #G.jokers.cards - 1
    end
    return { vars = { card.ability.extra.retriggers, other_joker_count * card.ability.extra.retriggers } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Dragon",
  gen = 1,
  atlas = "AgarmonsJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play
        and #G.play.cards == 1 then
      local other_joker_count = #G.jokers.cards - 1
      if other_joker_count > 0 then
        return {
          repetitions = other_joker_count * card.ability.extra.retriggers
        }
      end
    end
  end,
  designer = "Gem"
}

local function init()
  AG.append_to_family("dragonite", "mega_dragonite")
  AG.add_megas_to_center("j_poke_dragonite", "mega_dragonite")
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_dragonite }
}
