-- Galarian Weezing 110-1
local galarian_weezing = {
  name = "galarian_weezing",
  agar_inject_prefix = "poke",
  config = { extra = { mult_mod = 6, volatile = 'left' } },
  loc_vars = function(self, info_queue, card)
    pokermon.type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult_mod * G.GAME.skips } }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Fairy",
  gen = 8,
  calculate = function(self, card, context)
    if context.joker_main and pokermon.volatile_active(self, card, card.ability.extra.volatile) then
      AG.defer(function()
        card.ability.fainted = G.GAME.round
        card:set_debuff()
      end)
      return {
        message = localize("poke_explosion_ex"),
        colour = G.C.MULT,
        mult_mod = card.ability.extra.mult_mod * G.GAME.skips
      }
    end
    if context.skip_blind and not context.blueprint then
      AG.defer(function()
        SMODS.calculate_effect({
          message = localize({ type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_mod } }),
          colour = G.C.MULT,
        }, card)
      end)
    end
  end
}

local init = function()
  pokermon.add_to_family("weezing", "galarian_weezing")

  local evo_skip_req = 2

  local orig_loc_vars = assert(SMODS.Centers.j_poke_koffing.loc_vars)
  local orig_calculate = assert(SMODS.Centers.j_poke_koffing.calculate)

  SMODS.Joker:take_ownership('poke_koffing', {
    loc_vars = function(self, info_queue, card)
      local ret = assert(orig_loc_vars(self, info_queue, card))
      if agarmons_config.galarian_weezing then
        ret.key = self.key .. '_alt'
        ret.vars[#ret.vars+1] = math.max(0, evo_skip_req - (card.ability.extra.skips or 0))
      end
      return ret
    end,
    calculate = function(self, card, context)
      local ret1, ret2 = orig_calculate(self, card, context)
      if context.skip_blind then
        card.ability.extra.skips = (card.ability.extra.skips or 0) + 1
        if card.ability.extra.skips >= evo_skip_req then
          -- Evolve immediately so we get to skip the current Boss Blind
          pokermon.evolve(card, 'j_poke_galarian_weezing')
        end
      end
      return ret1, ret2
    end,
    load = function(self, card, card_table, other_card)
      -- Workaround for the game not saving during Booster Packs
      AG.defer(function()
        if card.ability.extra.skips >= evo_skip_req then
          pokermon.evolve(card, 'j_poke_galarian_weezing')
        end
      end)
    end
  }, true)

  -- Fixes Transformation
  AG.hookaroundfunc(pokermon, 'evolve', function(orig, card, to_key, ...)
    if not agarmons_config.galarian_weezing and to_key == 'j_poke_galarian_weezing' then
      to_key = 'j_poke_weezing'
    end
    return orig(card, to_key, ...)
  end)
end

return {
  can_load = false,
  config_key = 'galarian_weezing',
  init = init,
  list = { galarian_weezing }
}
