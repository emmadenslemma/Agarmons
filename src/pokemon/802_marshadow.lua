-- Marshadow 898
local marshadow = {
  name = "marshadow",
  config = { extra = { effect_multiplier = 1.5 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local main_end
    if center.area and center.area == G.jokers then
      local other_joker
      for i = 2, #G.jokers.cards do
        if G.jokers.cards[i] == center then other_joker = G.jokers.cards[i - 1] end
      end
      local compatible = other_joker and other_joker ~= center and other_joker.config.center.blueprint_compat
      local colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8)
      local text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' '
      ---@format disable-next
      main_end = {
        { n = G.UIT.C, config = { align = "bm", minh = 0.4 }, nodes = {
          { n = G.UIT.C, config = { ref_table = center, align = "m", colour = colour, r = 0.05, padding = 0.06 }, nodes = {
            { n = G.UIT.T, config = { text = text, colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
          }}
        }}
      }
    end
    return { vars = { (center.ability.extra.effect_multiplier - 1) * 100 }, main_end = main_end }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Fighting",
  gen = 7,
  designer = "ERIX",
  blueprint_compat = true,
  calculate = function(self, card, context)
    local other_joker = nil
    for i = 2, #G.jokers.cards do
      if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i - 1] end
    end
    -- Increase values
    local pre_boost_values = {}
    if other_joker and other_joker.ability and type(other_joker.ability.extra) == 'table' then
      local values = other_joker.ability.extra
      for k, _ in pairs(energy_values) do
        if values[k] then
          pre_boost_values[k] = values[k]
          values[k] = values[k] * card.ability.extra.effect_multiplier
        end
      end
    end
    local ret = SMODS.blueprint_effect(card, other_joker, context)
    -- Decrease values
    if other_joker and other_joker.ability and type(other_joker.ability.extra) == 'table' then
      for k, v in pairs(pre_boost_values) do
        other_joker.ability.extra[k] = v
      end
    end
    return ret
  end,
}

return {
  enabled = agarmons_config.marshadow or false,
  list = { marshadow }
}
