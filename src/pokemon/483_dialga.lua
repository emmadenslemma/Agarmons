local list_utils = AGAR.LIST_UTILS

-- Dialga 483
local dialga = {
  name = "dialga",
  pos = { x = 10, y = 2 },
  soul_pos = { x = 11, y = 2 },
  config = { extra = { joker_retriggers = 1, bosses_defeated = 0, upgrade_rqmt = 1, retrigger_joker_list = nil } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {
      vars = {
        center.ability.extra.joker_retriggers,
        center.ability.extra.joker_retriggers == 1 and localize("joker_singular") or localize("joker_plural"),
        center.ability.extra.upgrade_rqmt,
        center.ability.extra.upgrade_rqmt - center.ability.extra.bosses_defeated,
        center.ability.extra.upgrade_rqmt == 1 and localize("boss_blind_singular") or localize("boss_blind_plural"),
      }
    }
  end,
  designer = "Gem",
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Dragon",
  gen = 4,
  atlas = "AtlasJokersBasicGen04",
  calculate = function(self, card, context)
    if not context.blueprint then
      -- Loop through jokers to select them from retriggers
      if context.before then
        local joker_list = list_utils.filter(G.jokers.cards, function(joker) return joker ~= card end)
        local retrigger_joker_list = {}
        for i = 1, card.ability.extra.joker_retriggers do
          if #joker_list == 0 then break end
          local random_idx = math.floor(pseudorandom(pseudoseed('dialga')) * #joker_list) + 1
          retrigger_joker_list[#retrigger_joker_list + 1] = joker_list[random_idx]
          table.remove(joker_list, random_idx)
        end
        card.ability.extra.retrigger_joker_list = retrigger_joker_list
      end
      -- Clear the list to stop retriggering
      if context.after then
        card.ability.extra.retrigger_joker_list = nil
      end
      -- Retrigger everything in the list
      if context.retrigger_joker_check and not context.before and not context.after
          and card.ability.extra.retrigger_joker_list
          and list_utils.elem(card.ability.extra.retrigger_joker_list, context.other_card) then
        return {
          repetitions = 1
        }
      end
      -- Upgrade after boss blinds are defeated
      if context.end_of_round
          and context.game_over == false and context.main_eval and context.beat_boss
          and not card.debuff then
        card.ability.extra.bosses_defeated = card.ability.extra.bosses_defeated + 1
        if card.ability.extra.bosses_defeated == card.ability.extra.upgrade_rqmt then
          card.ability.extra.bosses_defeated = 0
          card.ability.extra.upgrade_rqmt = card.ability.extra.upgrade_rqmt + 1
          card.ability.extra.joker_retriggers = card.ability.extra.joker_retriggers + 1
          return {
            message = localize('k_upgrade_ex'),
          }
        end
      end
    end
  end,
}

return {
  name = "Agarmons Dialga",
  enabled = agarmons_config.dialga or false,
  list = { dialga }
}
