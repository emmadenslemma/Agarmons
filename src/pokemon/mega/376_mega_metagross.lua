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
        and context.scoring_name == "Four of a Kind" then
      local total_chips = poke_total_chips(context.other_card)
      local Xmult = (total_chips) ^ (1 / 4)
      if Xmult > 0 then
        return {
          Xmult = Xmult,
          card = card
        }
      end
    end
  end,
  designer = "Gem",
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
