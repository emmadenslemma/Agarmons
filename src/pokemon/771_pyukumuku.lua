local total_mult = function(card)
  local total_mult = (card.ability.perma_mult or 0)
  if not SMODS.has_enhancement(card, "m_lucky") or card.lucky_mult_trigger then
    total_mult = total_mult + card.ability.mult
  end
  if card.edition then
    total_mult = total_mult + (card.edition.mult or 0)
  end
  return total_mult
end

local total_Xmult = function(card)
  local card_Xmult = card.ability.x_mult + (card.ability.perma_x_mult or 0)
  local total_Xmult = card_Xmult > 1 and card_Xmult or 0
  if card.edition then
    total_Xmult = total_Xmult + (card.edition.x_mult or 0)
  end
  return total_Xmult
end

local total_money = function(card)
  local total_money = 0
  if not SMODS.has_enhancement(card, "m_lucky") or card.lucky_money_trigger then
    total_money = card.ability.p_dollars
  end
  if card.seal == "Gold" then
    total_money = total_money + 3
  end
  return total_money
end

-- Pyukumuku 771
local pyukumuku = {
  name = "pyukumuku",
  config = { extra = { stored = { chips = 0, mult = 0, Xmult = 0, money = 0 }, volatile = "left" } },
  loc_txt = {
    name = "Pyukumuku",
    text = {
      "Accumulates the effects",
      "of all cards played",
      "{br:2}ERROR - CONTACT STEAK",
      "{C:attention}Volatile Left{} unleash the stored",
      "effects, then debuff self this round",
      "{C:inactive}(Currently {C:chips}+#1#{}, {C:mult}+#2#{}, {X:mult,C:white}X#3#{}, {C:money}$#4#{C:inactive})"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue + 1] = { set = "Other", key = "poke_volatile_" .. center.ability.extra.volatile }
    end
    return { vars = { center.ability.extra.stored.chips, center.ability.extra.stored.mult, center.ability.extra.stored.Xmult, center.ability.extra.stored.money } }
  end,
  rarity = 3,
  cost = 8,
  stage = "Basic",
  ptype = "Water",
  gen = 7,
  perishable_compat = false,
  calculate = function(self, card, context)
    if not context.blueprint then
      if context.individual and context.cardarea == G.play then
        -- Effect: Eat every trigger effect (chips, mult, xmult (additively), and money from seals and lucky cards)
        card.ability.extra.stored.chips = card.ability.extra.stored.chips + poke_total_chips(context.other_card)
        card.ability.extra.stored.mult = card.ability.extra.stored.mult + total_mult(context.other_card)
        card.ability.extra.stored.Xmult = card.ability.extra.stored.Xmult + total_Xmult(context.other_card)
        -- is this too much? have we gone too far?
        card.ability.extra.stored.money = card.ability.extra.stored.money + total_money(context.other_card)
      end
      if context.cardarea == G.jokers and context.scoring_hand
          and context.joker_main and volatile_active(self, card, card.ability.extra.volatile) then
        G.E_MANAGER:add_event(Event({
          func = function()
            card.ability.extra.stored.chips = 0
            card.ability.extra.stored.mult = 0
            card.ability.extra.stored.Xmult = 0
            card.ability.extra.stored.money = 0

            card.ability.fainted = G.GAME.round
            card:set_debuff()
            return true
          end
        }))

        local effect = {
          chips = card.ability.extra.stored.chips,
          mult = card.ability.extra.stored.mult,
          message = localize("agar_innards_out_ex"),
        }

        if card.ability.extra.stored.Xmult ~= 0 then
          effect.Xmult = card.ability.extra.stored.Xmult
        end
        if card.ability.extra.stored.money ~= 0 then
          effect.dollars = card.ability.extra.stored.money
        end

        return effect
      end
    end
  end,
}

return {
  name = "Agarmons Pyukumuku",
  enabled = agarmons_config.pyukumuku or false,
  list = { pyukumuku }
}
