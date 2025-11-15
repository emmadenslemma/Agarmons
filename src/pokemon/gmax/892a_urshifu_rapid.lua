-- GMax Rapid Strike
local gmax_urshifu_rapid_strike={
  name = "gmax_urshifu_rapid_strike", 
  pos = {x = 14, y = 13}, 
  soul_pos = {x = 15, y = 13}, 
  config = {extra = {Xmult_mod = 0.1}},
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Urshifu Rapid Strike",
    text = {
        "Scored cards give {X:mult,C:white} X#3# {} Mult",
        "for every {C:chips}5 chips{} they have",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {vars = {center.ability.extra.Xmult_mod}}
  end,
  rarity = "agar_gmax",
  cost = 30,
  stage = "Gigantamax",
  ptype = "Water",
  atlas = "AtlasJokersBasicGen08",
  gen = 8,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.end_of_round then
      local total_chips = poke_total_chips(context.other_card)
      local Xmult = (total_chips)*(card.ability.extra.Xmult_mod)/5+1
      if Xmult > 0 then
        return {
          x_mult = Xmult,
          card = card
        }
      end
    end
  end,
}

local init = function()
  AGAR.GMAX.evos["j_Gem_urshifu_rapid_strike"] = "j_agar_gmax_urshifu_rapid_strike"
  AGAR.FAMILY_UTILS.init_gmax(gmax_urshifu_rapid_strike, "Gem")
end

return {
  name = "Agarmons G-Max Urshifu",
  enabled = (SMODS.Mods["GemPokermon"] or {}).can_load and agarmons_config.gmax or false,
  init = init,
  list = { gmax_urshifu_rapid_strike }
}
