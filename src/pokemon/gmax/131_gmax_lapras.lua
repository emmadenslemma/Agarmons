local function has_first_unique_rank(card, scoring_hand)
  for _, other_card in ipairs(scoring_hand) do
    if other_card == card then return true end
    if other_card:get_id() == card:get_id() then break end
  end
  return false
end

local function has_first_unique_suit(card, scoring_hand, suit_indexes)
  if not suit_indexes then return false end
  local i = get_index(scoring_hand, card)
  for _, j in ipairs(suit_indexes) do
    if i == j then return true end
  end
  return false
end

-- G-Max Lapras 131
local gmax_lapras = {
  name = "gmax_lapras",
  agar_inject_prefix = "poke",
  config = { extra = { chips = 0, retriggers = 1 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.chips } }
  end,
  rarity = "agar_gmax",
  cost = 10,
  stage = "Gigantamax",
  ptype = "Water",
  gen = 1,
  blueprint_compat = true,
  poke_custom_values_to_keep = { "chips" },
  calculate = function(self, card, context)
    if context.before then
      card.suits = AG.n_rooks.solve_suits(context.scoring_hand)
    end
    if context.cardarea == G.play and context.repetition then
      local unique_rank = has_first_unique_rank(context.other_card, context.scoring_hand)
      local unique_suit = has_first_unique_suit(context.other_card, context.scoring_hand, card.suits)
      local retriggers = (unique_rank and 1 or 0) + (unique_suit and 1 or 0)
      if retriggers > 0 then
        return {
          repetitions = retriggers * card.ability.extra.retriggers,
          colour = G.C.RARITY["agar_gmax"]
        }
      end
    end
    -- Keep Lapras's regular Chips scoring
    return G.P_CENTERS['j_poke_lapras'].calculate(self, card, context)
  end,
}

local init = function()
  pokermon.add_family { "lapras", "gmax_lapras" }

  SMODS.Joker:take_ownership("poke_lapras", { gmax = "gmax_lapras", poke_custom_values_to_keep = { "chips" } }, true)
end

return {
  can_load = agarmons_config.gmax,
  init = init,
  list = { gmax_lapras }
}
