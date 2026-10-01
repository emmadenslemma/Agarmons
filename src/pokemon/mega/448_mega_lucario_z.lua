-- Mega Lucario Z 448-2
local mega_lucario_z = {
  name = "mega_lucario_z",
  agar_inject_prefix = "poke",
  config = { extra = { retriggers = 1 } },
  loc_txt = {
    name = "Mega Lucario Z",
    text = {
      "Retrigger each {C:attention}Editioned",
      "card held in hand",
      "{br:2}ERROR - CONTACT STEAK",
      "Retrigger each {C:attention}Steel",
      "{C:attention}Card{} held in hand",
    }
  },
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Fighting",
  gen = 4,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) then
      local retriggers = 0

      if context.other_card.edition then retriggers = retriggers + 1 end
      if SMODS.has_enhancement(context.other_card, 'm_steel') then retriggers = retriggers + 1 end

      if retriggers > 0 then
        return {
          repetitions = retriggers
        }
      end
    end
  end,
}

local function init()
  pokermon.add_family { "lucario", "mega_lucario_z" }
  SMODS.Joker:take_ownership("poke_lucario", { megas = { "mega_lucario", "mega_lucario_z" } }, true)
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_lucario_z }
}
