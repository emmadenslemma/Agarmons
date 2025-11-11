-- G-Max Meowth 052
local gmax_meowth = {
  name = "gmax_meowth",
  -- Include `money` to not reset scaling when dynamaxing
  config = { extra = { money = 1, money1 = 3, num = 1, dem = 10 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Meowth",
    text = {
      "Earn {C:money}$#3#{} for every successful",
      "Lucky card trigger",
      "{br:2.5}ERROR - CONTACT STEAK",
      "{C:green}#4# in #5#{} chance to",
      "earn {C:dark_edition,E:1}double"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local num, dem = SMODS.get_probability_vars(center, center.ability.extra.num, center.ability.extra.dem, "gmax_meowth")
    return { vars = { center.ability.extra.money1, num, dem } }
  end,
  rarity = "agar_gmax",
  cost = 8,
  stage = "Gigantamax",
  ptype = "Colorless",
  gen = 1,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play
        and context.other_card.lucky_trigger then
      if SMODS.pseudorandom_probability(card, "gmax_meowth", card.ability.extra.num, card.ability.extra.dem, "gmax_meowth") then
        card_eval_status_text(card, "extra", nil, nil, nil, { message = localize("agar_gmax_gold_rush_ex") })
        return {
          dollars = card.ability.extra.money1 * 2
        }
      else
        return {
          dollars = card.ability.extra.money1
        }
      end
    end
  end,
}

local init = function()
  AGAR.GMAX.evos["j_poke_meowth"] = "j_agar_gmax_meowth"
  AGAR.FAMILY_UTILS.init_gmax(gmax_meowth)
end

return {
  name = "Agarmons G-Max Meowth",
  enabled = false, -- agarmons_config.gmax or false,
  init = init,
  list = { gmax_meowth }
}
