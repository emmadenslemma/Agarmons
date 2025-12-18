-- G-Max Copperajah 879
local gmax_copperajah = {
  name = "gmax_copperajah",
  agar_inject_prefix = "maelmc",
  config = { extra = { Xmult_mod = 1 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Copperajah",
    text = {
      "{X:red,C:white}X#3#{} Mult for every {C:attention}Steel",
      "{C:attention}Card{} in your full deck",
      "{C:inactive}(Currently {X:red,C:white}X#4#{C:inactive} Mult)",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)

    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    end

    local steel_count = 0
    if G.playing_cards then
      for _, v in pairs(G.playing_cards) do
        if SMODS.has_enhancement(v, "m_steel") then
          steel_count = steel_count + 1
        end
      end
    end

    return { vars = { card.ability.extra.Xmult_mod, 1 + card.ability.extra.Xmult_mod * steel_count } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Metal",
  gen = 8,
  designer = "Maelmc",
  blueprint_compat = true,
  calculate = function(self, card, context)
    -- Ripped directly from Maelmc's code
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        local steel_count = 0
        for _, v in pairs(G.playing_cards) do
          if SMODS.has_enhancement(v, "m_steel") then
            steel_count = steel_count + 1
          end
        end
        return {
          colour = G.C.XMULT,
          Xmult = 1 + card.ability.extra.Xmult_mod * steel_count
        }
      end
    end
    -- standard GMAX QoL to let you have end of round effects when you win in 1-2 hands
    return G.P_CENTERS.j_maelmc_copperajah.calculate(self, card, context)
  end,
}

local init = function()
  AG.append_to_family("copperajah", "gmax_copperajah", true)

  SMODS.Joker:take_ownership("maelmc_copperajah", { gmax = "gmax_copperajah", megas = false }, true)

  SMODS.Joker:take_ownership("maelmc_mega_copperajah", { no_collection = true }, true)
  -- Remove "Mega Copperajah" from the family listing
  for _, family in ipairs(pokermon.family) do
    for i, member in ipairs(family) do
      if (type(member) == 'table' and member.key == "mega_copperajah") or member == "mega_copperajah" then
        table.remove(family, i)
        return
      end
    end
  end
end

return {
  can_load = (SMODS.Mods["PokermonMaelmc"] or {}).can_load and agarmons_config.gmax,
  init = init,
  list = { gmax_copperajah }
}
