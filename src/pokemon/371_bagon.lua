-- Bagon 371
local bagon = {
  name = "bagon",
  config = { extra = { chips = 0, chip_mod = 2, straights = 0 }, evo_rqmt = 36 },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.chip_mod, card.ability.extra.straights, card.ability.extra.chips, card.ability.evo_rqmt } }
  end,
  rarity = 2,
  cost = 6,
  stage = "Basic",
  ptype = "Dragon",
  gen = 3,
  pseudol = true,
  blueprint_compat = true,
  perishable_compat = false,
  poke_custom_values_to_keep = { "straights" },
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and not context.blueprint then
      if context.scoring_hand and context.scoring_name == "Straight" then
        card.ability.extra.straights = card.ability.extra.straights + 1
        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.straights * card.ability.extra.chip_mod
      else
        card.ability.extra.straights = 0
      end
    end
    if context.joker_main then
      return {
        chips = card.ability.extra.chips
      }
    end
    return scaling_evo(self, card, context, "j_agar_shelgon", card.ability.extra.chips, self.config.evo_rqmt)
  end,
}

-- Shelgon 372
local shelgon = {
  name = "shelgon",
  config = { extra = { chips = 0, chip_mod = 3, straights = 0 }, evo_rqmt = 186 },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.chip_mod, card.ability.extra.straights, card.ability.extra.chips, card.ability.evo_rqmt } }
  end,
  rarity = "poke_safari",
  cost = 8,
  stage = "One",
  ptype = "Dragon",
  gen = 3,
  blueprint_compat = true,
  perishable_compat = false,
  poke_custom_values_to_keep = { "straights" },
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and not context.blueprint then
      if context.scoring_hand and context.scoring_name == "Straight" then
        card.ability.extra.straights = card.ability.extra.straights + 1
        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.straights * card.ability.extra.chip_mod
      else
        card.ability.extra.straights = 0
      end
    end
    if context.joker_main then
      return {
        chips = card.ability.extra.chips
      }
    end
    return scaling_evo(self, card, context, "j_agar_salamence", card.ability.extra.chips, self.config.evo_rqmt)
  end,
}

-- Salamence 373
local salamence = {
  name = "salamence",
  config = { extra = { Xmult_mod = .25, chips = 186, straights = 0 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue+1] = { set = 'Other', key = 'mega_poke' }
    end
    local current_Xmult = 1 + card.ability.extra.Xmult_mod * card.ability.extra.straights
    return { vars = { card.ability.extra.chips, card.ability.extra.Xmult_mod, current_Xmult } }
  end,
  rarity = "poke_safari",
  cost = 10,
  stage = "Two",
  ptype = "Dragon",
  gen = 3,
  blueprint_compat = true,
  perishable_compat = false,
  poke_custom_values_to_keep = { "straights" },
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and not context.blueprint then
      if context.scoring_hand and context.scoring_name == "Straight" then
        card.ability.extra.straights = card.ability.extra.straights + 1
      else
        card.ability.extra.straights = 0
      end
    end
    if context.joker_main then
      if context.scoring_hand and context.scoring_name == "Straight" then
        local Xmult = 1 + card.ability.extra.Xmult_mod * card.ability.extra.straights
        return {
          message = localize("agar_outrage_ex"),
          Xmult = Xmult,
          chips = card.ability.extra.chips,
        }
      else
        return {
          chips = card.ability.extra.chips,
        }
      end
    end
  end,
  megas = { "mega_salamence" },
}

-- Mega Salamence 373-1
local mega_salamence = {
  name = "mega_salamence",
  pos = { x = 8, y = 6 },
  soul_pos = { x = 9, y = 6 },
  config = { extra = { Xmult_mod = .25, chips = 186, retriggers = 0, straights = 0 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local current_Xmult = 1 + card.ability.extra.Xmult_mod * card.ability.extra.straights
    return { vars = { card.ability.extra.chips, current_Xmult } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Dragon",
  atlas = "AtlasJokersBasicGen03",
  gen = 3,
  blueprint_compat = true,
  perishable_compat = false,
  poke_custom_values_to_keep = { "straights" },
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play
        and context.scoring_hand and context.scoring_name == "Straight" then
      local retriggers = card.ability.extra.retriggers
      for _, v in pairs(context.full_hand) do
        if context.other_card == v then
          break
        end
        retriggers = retriggers + 1
      end
      if retriggers ~= 0 then
        return {
          repetitions = retriggers
        }
      end
      if context.joker_main then
        if context.scoring_hand and context.scoring_name == "Straight" then
          local Xmult = 1 + card.ability.extra.Xmult_mod * card.ability.extra.straights
          return {
            message = localize("agar_outrage_ex"),
            Xmult = Xmult,
            chips = card.ability.extra.chips,
          }
        else
          return {
            chips = card.ability.extra.chips,
          }
        end
      end
    end
  end,
}

return {
  config_key = "bagon",
  list = { bagon, shelgon, salamence, mega_salamence }
}
