-- Mega Meganium 154-1
local mega_meganium = {
  name = "mega_meganium",
  agar_inject_prefix = "poke",
  pos = { x = 2, y = 2 },
  soul_pos = { x = 3, y = 2 },
  config = { extra = { money = 4 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.money } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Grass",
  gen = 2,
  atlas = "AgarmonsJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.hand and not context.end_of_round then
      local suits, total = {}, 0
      for _, hand_card in ipairs(G.hand.cards) do
        if total == 4 then return end
        if SMODS.has_any_suit(hand_card) then
          total = total + 1
          if context.other_card == hand_card then
            return {
              dollars = card.ability.extra.money
            }
          end
        else
          for _, suit in pairs(SMODS.Suits) do
            if (not suits[suit.key]) and hand_card:is_suit(suit.key) then
              total = total + 1
              suits[suit.key] = true
              if context.other_card == hand_card then
                return {
                  dollars = card.ability.extra.money
                }
              end
              break
            end
          end
        end
      end
    end
  end,
  artist = "KingOfThe-X-Roads",
}

local function init()
  AG.append_to_family("meganium", "mega_meganium")
  AG.add_megas_to_center("j_poke_meganium", "mega_meganium")
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_meganium }
}
