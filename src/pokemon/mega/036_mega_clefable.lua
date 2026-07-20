-- Mega Clefable 036-1
local mega_clefable = {
  name = "mega_clefable",
  agar_inject_prefix = "poke",
  config = { extra = { Xmult_multi = 0.03, Xmult_multi1 = 0, Xmult_multi2 = 1 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_multi, card.ability.extra.Xmult_multi1 + card.ability.extra.Xmult_multi2 } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Fairy",
  gen = 1,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.hand_drawn and not context.blueprint then
      local club_count = #AG.list_utils.filter(SMODS.drawn_cards, function(c) return c:is_suit('Clubs') end)
      if club_count > 0 then
        SMODS.scale_card(card, {
          ref_value = 'Xmult_multi1',
          scalar_value = 'Xmult_multi',
          operation = function(ref_table, ref_value, initial, change)
            ref_table[ref_value] = initial + change * club_count
          end,
          message_colour = G.C.MULT
        })
      end
    end
    if context.individual and context.cardarea == G.play and context.other_card:is_suit("Clubs") then
      return {
        Xmult = card.ability.extra.Xmult_multi1 + card.ability.extra.Xmult_multi2
      }
    end
    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
      card.ability.extra.Xmult_multi1 = 0
      return {
        message = localize("k_reset")
      }
    end
  end,
}

local function init()
  pokermon.add_family { "clefable", "mega_clefable" }
  SMODS.Joker:take_ownership("poke_clefable", { megas = { "mega_clefable" } }, true)
end

return {
  can_load = false, -- agarmons_config.new_megas,
  init = init,
  list = { mega_clefable }
}
