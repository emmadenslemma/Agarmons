-- Palkia 484
local palkia = {
  name = "palkia",
  config = { extra = { joker_slot_mod = 1, bosses_defeated = 0, upgrade_rqmt = 1, upgrade_rqmt_increase = 1 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {
      vars = {
        center.ability.extra.joker_slot_mod,
        center.ability.extra.upgrade_rqmt,
        center.ability.extra.upgrade_rqmt - center.ability.extra.bosses_defeated,
        center.ability.extra.upgrade_rqmt == 1 and localize("boss_blind_singular") or localize("boss_blind_plural"),
        center.ability.extra.upgrade_rqmt_increase,
      }
    }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Water",
  gen = 4,
  calculate = function(self, card, context)
    if context.end_of_round
        and context.game_over == false and context.main_eval and context.beat_boss
        and not context.blueprint and not card.debuff then
      card.ability.extra.bosses_defeated = card.ability.extra.bosses_defeated + 1
      if card.ability.extra.bosses_defeated == card.ability.extra.upgrade_rqmt then
        card.ability.extra.bosses_defeated = 0
        card.ability.extra.upgrade_rqmt = card.ability.extra.upgrade_rqmt + card.ability.extra.upgrade_rqmt_increase
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        return {
          message = localize { type = 'variable', key = 'a_joker_slot', vars = { card.ability.extra.joker_slot_mod } },
          colour = G.C.DARK_EDITION
        }
      end
    end
  end,
}

return {
  name = "Agarmons Palkia",
  enabled = agarmons_config.palkia or false,
  list = { palkia }
}
