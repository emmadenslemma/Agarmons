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
  if card.ability.extra and type(card.ability.extra) == 'table' then
    card_Xmult = card_Xmult + (card.ability.extra.toxicXMult or 1) - 1
  end
  local total_Xmult = card_Xmult > 1 and card_Xmult or 0
  if card.edition then
    total_Xmult = total_Xmult + (card.edition.x_mult or 0)
  end
  return total_Xmult
end

local total_money = function(card)
  local total_money = card.ability.perma_p_dollars or 0
  if not SMODS.has_enhancement(card, "m_lucky") or card.lucky_money_trigger then
    total_money = total_money + card.ability.p_dollars
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
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = { set = "Other", key = "poke_volatile_" .. card.ability.extra.volatile }
    end
    return { vars = { card.ability.extra.stored.chips, card.ability.extra.stored.mult, card.ability.extra.stored.Xmult, card.ability.extra.stored.money } }
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
  config_key = "pyukumuku",
  list = { pyukumuku }
}
