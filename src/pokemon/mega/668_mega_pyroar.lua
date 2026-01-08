-- Mega Pyroar 668-1
local mega_pyroar = {
  name = "mega_pyroar",
  agar_inject_prefix = "poke",
  pos = { x = 8, y = 1 },
  soul_pos = { x = 9, y = 1 },
  config = { extra = { create_energy_mod = 2 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = { key = 'e_negative_consumable', set = 'Edition', config = { extra = 1 } }
      info_queue[#info_queue+1] = G.P_CENTERS.c_poke_fire_energy
    end
    return { vars = { card.ability.extra.create_energy_mod } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Fire",
  gen = 1,
  atlas = "AgarmonsJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main and next(context.poker_hands['Flush']) then
      return {
        message = localize { type = 'variable', key = 'a_poke_plus_energy', vars = { card.ability.extra.create_energy_mod } },
        colour = G.ARGS.LOC_COLOURS.pink,
        func = function()
          G.E_MANAGER:add_event(Event({
            func = function()
              for _ = 1, card.ability.extra.create_energy_mod do
                SMODS.add_card { key = 'c_poke_fire_energy', edition = 'e_negative' }
              end
              return true
            end
          }))
        end,
      }
    end
  end,
}

local function init()
  poke_add_to_family("pyroar", "mega_pyroar")
  SMODS.Joker:take_ownership("poke_pyroar", { megas = { "mega_pyroar" } }, true)
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_pyroar }
}
