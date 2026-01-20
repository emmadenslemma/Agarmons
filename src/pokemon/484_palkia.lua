-- Palkia 484
local palkia = {
  name = "palkia",
  config = { extra = { joker_slot_mod = 1, bosses_defeated = 0, upgrade_rqmt = 1, upgrade_rqmt_increase = 1 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.joker_slot_mod,
        card.ability.extra.upgrade_rqmt,
        card.ability.extra.upgrade_rqmt - card.ability.extra.bosses_defeated,
        card.ability.extra.upgrade_rqmt == 1 and localize("boss_blind_singular") or localize("boss_blind_plural"),
        card.ability.extra.upgrade_rqmt_increase,
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
        G.jokers.config.card_limits.mod = (G.jokers.config.card_limits.mod or 0) + 1
        return {
          message = localize { type = 'variable', key = 'a_joker_slot', vars = { card.ability.extra.joker_slot_mod } },
          colour = G.C.DARK_EDITION
        }
      end
    end
  end,
}

return {
  config_key = "palkia",
  list = { palkia }
}
