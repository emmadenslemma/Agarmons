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
    if context.before then
      if context.scoring_name == "Four of a Kind" then
        local _4oaks = get_X_same(4, context.scoring_hand)
        local _1st_4oak = _4oaks[1] or {}
        local _1st_card = _1st_4oak[1]
        -- yes this is defensive programming but apparently you can't trust localthunk
        if _1st_card then
          card.ability.megagross_rank = _1st_card:get_id() -- we don't need this to persist
        else
          card.ability.megagross_rank = nil
        end
      else
        card.ability.megagross_rank = nil
      end
    end
    if context.individual and (context.cardarea == G.play or context.cardarea == G.hand) and not context.end_of_round
        and card.ability.megagross_rank and context.other_card:get_id() == card.ability.megagross_rank then
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
  pokermon.add_family { "metagross", "mega_metagross" }
  SMODS.Joker:take_ownership("poke_metagross", { megas = { "mega_metagross" } }, true)
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_metagross }
}
