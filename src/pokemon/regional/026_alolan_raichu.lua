-- Alolan Raichu 26-1
local alolan_raichu = {
  name = "alolan_raichu",
  agar_inject_prefix = "poke",
  config = { extra = { chips = 0, chip_mod = 1, per_money = 1, money = 2, money_mod = 1 } },
  loc_vars = function(self, info_queue, card)
    pokermon.type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.chip_mod, card.ability.extra.per_money, card.ability.extra.chips, card.ability.extra.money, card.ability.extra.money_mod } }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Psychic",
  gen = 7,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.setting_blind then
      local lightning_jokers = #find_pokemon_type("Lightning")
      local amount = card.ability.extra.money + lightning_jokers * card.ability.extra.money_mod
      card:juice_up()
      pokermon.ease_poke_dollars(card, "alolan_raichu", amount)
    end
    if context.joker_main and card.ability.extra.chips > 0 then
      return {
        chips = card.ability.extra.chips
      }
    end
    if context.money_altered and context.from_shop then
      local amount_spent = context.amount
      if next(SMODS.find_mod("Talisman")) then amount_spent = to_number(amount_spent) end
      if amount_spent < 0 then
        card.ability.extra.chips = card.ability.extra.chips +
            card.ability.extra.chip_mod / card.ability.extra.per_money * (-amount_spent)
        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.CHIPS,
        }
      end
    end
  end,
}

local init = function()
  pokermon.add_to_family("raichu", "alolan_raichu")

  local orig_loc_vars = assert(SMODS.Centers.j_poke_pikachu.loc_vars)

  SMODS.Joker:take_ownership('poke_pikachu', {
    item_req = { 'thunderstone', 'sunstone' }, -- This is going to have some weird side effects but it's *fine*
    evo_list = { thunderstone = 'j_poke_raichu', sunstone = 'j_poke_alolan_raichu' },
    loc_vars = function(self, info_queue, card)
      local ret = orig_loc_vars(self, info_queue, card)
      if agarmons_config.alolan_raichu then
        if pokermon_config.detailed_tooltips then
          info_queue[#info_queue+1] = G.P_CENTERS.c_poke_sunstone
        end
        ret.key = self.key .. '_alt'
      end
      return ret
    end,
    add_to_deck = function(self, card, from_debuff)
      if agarmons_config.alolan_raichu and not from_debuff then
        -- Since the evolution code checks `ability.extra.item_req` and not `config.center.item_req` we have to do extra work.
        card.ability.extra.item_req = copy_table(card.config.center.item_req)
        card.ability.extra.evo_list = copy_table(card.config.center.evo_list)
      end
    end
  }, true)

  -- Fixes Transformation
  AG.hookaroundfunc(pokermon, 'evolve', function(orig, card, to_key, ...)
    if not agarmons_config.alolan_raichu and to_key == 'j_poke_alolan_raichu' then
      to_key = 'j_poke_raichu'
    end
    return orig(card, to_key, ...)
  end)
end

return {
  config_key = 'alolan_raichu',
  init = init,
  list = { alolan_raichu }
}
