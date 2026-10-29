local ref_value_map = {
  ['chips'] = '_chips',
  ['chips1'] = '_chips',
  ['chips2'] = '_chips',
  ['chip_mod'] = '_chips',
  ['chip_mod1'] = '_chips',
  ['chip_mod2'] = '_chips',
  ['mult'] = '_mult',
  ['mult1'] = '_mult',
  ['mult2'] = '_mult',
  ['mult_mod'] = '_mult',
  ['mult_mod1'] = '_mult',
  ['mult_mod2'] = '_mult',
  ['Xmult'] = '_Xmult',
  ['Xmult1'] = '_Xmult',
  ['Xmult2'] = '_Xmult',
  ['Xmult_mod'] = '_Xmult',
  ['Xmult_mod1'] = '_Xmult',
  ['Xmult_mod2'] = '_Xmult',
  ['Xmult_multi'] = '_Xmult',
  ['Xmult_multi1'] = '_Xmult',
  ['Xmult_multi2'] = '_Xmult',
  -- Non-Pokermon values:
  ['xmult'] = '_Xmult',
  ['x_mult'] = '_Xmult',
}

-- Flamigo 937
local flamigo = {
  name = "flamigo",
  -- Prevents us from energizing Flamigo and also prevents Flamigo from copying eachother
  config = { extra = { _chips = 0, _mult = 0, _Xmult = 1 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra._chips, card.ability.extra._mult, card.ability.extra._Xmult } }
  end,
  rarity = 3,
  cost = 10,
  stage = "Basic",
  ptype = "Fighting",
  gen = 9,
  calculate = function(self, card, context)
    if context.scaling_card and not context.blueprint
        and context.operation ~= '-'
        and context.scalar > 0
        and ref_value_map[context.ref_value]
        and not context.card:has_attribute('reset') then
      local args = SMODS.shallow_copy(context)

      args.ref_table = card.ability.extra
      args.ref_value = ref_value_map[args.ref_value]

      if args.ref_value then
        return {
          post = {
            func = function()
              SMODS.scale_card(card, args)
            end
          }
        }
      end
    end

    if context.joker_main then
      return {
        chips = card.ability.extra._chips,
        mult = card.ability.extra._mult,
        Xmult = card.ability.extra._Xmult,
      }
    end
  end,
}

return {
  config_key = "flamigo",
  list = { flamigo }
}
