local toedscool = {
  name = "toedscool",
  config = { extra = { mult_mod = 5, rounds = 5 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.rounds } }
  end,
  rarity = 1,
  cost = 4,
  stage = "Basic",
  ptype = "Grass",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and
        context.other_card:get_id() == 4 then
      return {
        mult = card.ability.extra.mult_mod
      }
    end
    return level_evo(self, card, context, 'j_agar_toedscruel')
  end
}

local toedscruel = {
  name = "toedscruel",
  config = { extra = { mult_mod = 8 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod } }
  end,
  rarity = "poke_safari",
  cost = 6,
  stage = "One",
  ptype = "Grass",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and
        context.other_card:get_id() == 4 then
      return {
        mult = card.ability.extra.mult_mod
      }
    end
    -- Toggles Xmult deferral
    if context.before then
      AG.mycelium_might = true
      AG.stored_xmult_effects = AG.stored_xmult_effects or {}
    end
    -- Cashes in the stored Xmult effects
    if context.final_scoring_step then
      if AG.mycelium_might then -- Only do this for the first Toedscruel
        AG.mycelium_might = false
        for _, args in ipairs(AG.stored_xmult_effects) do
          SMODS.calculate_effect(table.unpack(args))
        end
        AG.stored_xmult_effects = nil
      end
    end
  end
}

local init = function()
  -- This is to account for using Xmult_mod and returning a localized a_x_mult message manually (i.e. Gyarados)
  -- or using Xmult_mod to return a message instead of 2 separate effect messages (i.e. Kingdra)
  local move_xmult_effects = function(from, to)
    to['x_mult'] = from['x_mult']
    to['Xmult'] = from['Xmult']
    to['xmult'] = from['xmult']
    to['x_mult_mod'] = from['x_mult_mod']
    to['Xmult_mod'] = from['Xmult_mod']

    from['x_mult'] = nil
    from['Xmult'] = nil
    from['xmult'] = nil
    from['x_mult_mod'] = nil
    from['Xmult_mod'] = nil

    -- We assume that if you have a message it's for the Xmult part
    to['message'] = from['message']
    to['colour'] = from['colour']

    from['message'] = nil
    from['colour'] = nil

    -- If you've previously had a message for 2 effects, make them appear without a standalone message
    if to['message'] and to['Xmult_mod'] and (from['mult_mod'] or from['chip_mod']) then
      if not to['Xmult'] then
        -- We don't need a specific message for one Xmult value
        to['message'] = nil
        to['colour'] = nil
        to['Xmult'] = to['Xmult_mod']
        to['Xmult_mod'] = nil
      end

      if not from['mult'] then
        from['mult'] = from['mult_mod']
        from['mult_mod'] = nil
      end
      if not from['chips'] then
        from['chips'] = from['chip_mod']
        from['chip_mod'] = nil
      end
    end
  end

  local effect_has_xmult = function(effect)
    return (effect['x_mult']
      or effect['Xmult']
      or effect['xmult']
      or effect['x_mult_mod']
      or effect['Xmult_mod'])
  end

  AG.hookaroundfunc(SMODS, 'calculate_effect', function(orig, effect, ...)
    if AG.mycelium_might and effect_has_xmult(effect) then
      local stored_effect = {}

      move_xmult_effects(effect, stored_effect)

      table.insert(AG.stored_xmult_effects, { stored_effect, ... })
    end
    return orig(effect, ...)
  end)
end

return {
  config_key = "toedscool",
  init = init,
  list = { toedscool, toedscruel }
}
