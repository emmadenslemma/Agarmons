-- Mega Metagross 376-1
local mega_metagross = {
  name = "mega_metagross",
  agar_inject_prefix = "poke",
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Metal",
  gen = 3,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and (context.cardarea == G.play or context.cardarea == G.hand) and not context.end_of_round
        and context.scoring_name == "Four of a Kind"
        and context.other_card:get_id() == get_X_same(4, context.scoring_hand)[1][1]:get_id() then
      if context.cardarea == G.hand and context.other_card.debuff then
        return {
          message = localize('k_debuffed'),
          colour = G.C.RED,
        }
      else
        local total_chips = poke_total_chips(context.other_card)
        local Xmult = (total_chips) ^ (1 / 4)
        if Xmult > 0 then
          return {
            Xmult = Xmult
          }
        end
      end
    end
  end,
  designer = "Gem, Maelmc",
}

local function init()
  AG.append_to_family("metagross", "mega_metagross")
  SMODS.Joker:take_ownership("poke_metagross", { megas = { "mega_metagross" } }, true)
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_metagross }
}
