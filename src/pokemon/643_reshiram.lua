-- Reshiram 643
local reshiram = {
  name = "reshiram",
  config = { extra = {} },
  loc_txt = {
    name = "Reshiram",
    text = {
      "{C:dark_edition}???",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = {} }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Fire",
  gen = 5,
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
    if context.joker_main
        and (G.GAME.current_round.hands_left >= G.GAME.current_round.discards_left) then
      return {
        Xmult = 9001,
      }
    end
  end,
  in_pool = function(self)
    return (next(SMODS.find_card("j_poke_pokedex")) or not next(SMODS.find_card("j_agar_kyurem_white")))
        and pokemon_in_pool(self)
  end,
  fuses = { with = "j_agar_kyurem", into = "j_agar_kyurem_white" },
}

return {
  can_load = false,
  config_key = "reshiram",
  list = { reshiram }
}
