-- Mega Pyroar 668-1
local mega_pyroar = {
  name = "mega_pyroar",
  inject_prefix = "poke",
  pos = { x = 8, y = 1 },
  soul_pos = { x = 9, y = 1 },
  config = { extra = { chips = 180, create_energy_mod = 2 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.chips, center.ability.extra.create_energy_mod } }
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
      for _, scoring_card in ipairs(context.scoring_hand) do
        if scoring_card:get_id() == 12 or scoring_card:get_id() == 13 then
          local energies_to_create = 0

          for _ = 1, card.ability.extra.create_energy_mod do
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
              G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
              energies_to_create = energies_to_create + 1
            end
          end

          if energies_to_create > 0 then
            return {
              chips = card.ability.extra.chips,
              extra = {
                message = localize { type = 'variable', key = 'a_poke_plus_energy', vars = { energies_to_create } },
                colour = G.ARGS.LOC_COLOURS.pink,
                func = function()
                  G.E_MANAGER:add_event(Event({
                    func = function()
                      for _ = 1, energies_to_create do
                        SMODS.add_card { set = 'Energy' }
                      end
                      G.GAME.consumeable_buffer = 0
                      return true
                    end
                  }))
                end,
              }
            }
          end
        end
      end
      return {
        chips = card.ability.extra.chips
      }
    end
  end,
  designer = "Thor's Girdle",
  artist = "KingOfThe-X-Roads",
}

local function init()
  AG.append_to_family("pyroar", "mega_pyroar")
  AG.add_megas_to_center("j_poke_pyroar", "mega_pyroar")
end

return {
  enabled = agarmons_config.new_megas,
  init = init,
  list = { mega_pyroar }
}
