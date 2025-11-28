-- G-Max Meowth 052
local gmax_meowth = {
  name = "gmax_meowth",
  agar_inject_prefix = "poke",
  -- Include `money` to not reset scaling when dynamaxing
  config = { extra = { money = 1, money1 = 3 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Meowth",
    text = {
      "Add a {C:attention}Gold Seal{} to every",
      "{C:green}successfully{} triggered {C:attention}Lucky Card",
      "{br:2.5}ERROR - CONTACT STEAK",
      "If it already has a {C:attention}Gold Seal{},",
      "earn {C:money}$#3#{} instead",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.money1 } }
  end,
  rarity = "agar_gmax",
  cost = 8,
  stage = "Gigantamax",
  ptype = "Colorless",
  gen = 1,
  blueprint_compat = true,
  poke_custom_values_to_keep = { "money" },
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play
        and context.other_card.lucky_trigger then
      if context.other_card:get_seal() ~= "Gold" then
        context.other_card:set_seal("Gold")
        G.E_MANAGER:add_event(Event({
          func = function()
            card:juice_up()
            return true
          end
        }))
      else
        return {
          dollars = card.ability.extra.money1
        }
      end
    end
  end,
}

local init = function()
  AG.append_to_family("meowth", "gmax_meowth")

  SMODS.Joker:take_ownership("poke_meowth", { gmax = "gmax_meowth", poke_custom_values_to_keep = { "money" } }, true)
end

return {
  can_load = agarmons_config.gmax,
  init = init,
  list = { gmax_meowth }
}
