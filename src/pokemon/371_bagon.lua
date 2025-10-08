-- Bagon 371
local bagon = {
  name = "bagon",
  config = { extra = { chips = 0, chip_mod = 2, straights = 0 }, evo_rqmt = 36 },
  loc_txt = {
    name = "Bagon",
    text = {
      "If played hand is a",
      "{C:attention}Straight{}, gain {C:chips}+#1#{} Chips",
      "for every consecutive",
      "{C:attention}Straight{} {C:inactive}[#2#]{} played",
      "{C:inactive}(Evolves at {C:chips}+#3#{C:inactive} / +#4# Chips)",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.chip_mod, center.ability.extra.straights, center.ability.extra.chips, center.ability.evo_rqmt } }
  end,
  rarity = 2,
  cost = 6,
  stage = "Basic",
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
    return scaling_evo(self, card, context, "j_agar_shelgon", card.ability.extra.chips, self.config.evo_rqmt)
  end,
}

-- Shelgon 372
local shelgon = {
  name = "shelgon",
  config = { extra = { chips = 0, chip_mod = 3, straights = 0 }, evo_rqmt = 186 },
  loc_txt = {
    name = "Shelgon",
    text = {
      "If played hand is a",
      "{C:attention}Straight{}, gain {C:chips}+#1#{} Chips",
      "for every consecutive",
      "{C:attention}Straight{} {C:inactive}[#2#]{} played",
      "{C:inactive}(Evolves at {C:chips}+#3#{C:inactive} / +#4# Chips)",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.chip_mod, center.ability.extra.straights, center.ability.extra.chips, center.ability.evo_rqmt } }
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
  loc_txt = {
    name = "Salamence",
    text = {
      "{C:chips}+#1#{} Chips",
      "{C:white,X:mult}X#2#{} Mult for every",
      "consecutive {C:attention}Straight{} played",
      "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue + 1] = { set = 'Other', key = 'mega_poke' }
    end
    local current_Xmult = 1 + center.ability.extra.Xmult_mod * center.ability.extra.straights
    return { vars = { center.ability.extra.chips, center.ability.extra.Xmult_mod, current_Xmult } }
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
  loc_txt = {
    name = "Mega Salamence",
    text = {
      "{C:chips}+#1#{} Chips",
      "{X:mult,C:white}X#2#{} Mult if played",
      "hand is a {C:attention}Straight{} and",
      "retrigger every card one",
      "more time than the last",
      "{C:inactive,s:0.8}(Retriggers 0, 1, 2, 3, and 4 times)"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    local current_Xmult = 1 + center.ability.extra.Xmult_mod * center.ability.extra.straights
    return { vars = { center.ability.extra.chips, current_Xmult } }
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

local init = function()
  if (SMODS.Mods["NachosPokermonDip"] or {}).can_load then
    SMODS.Joker:take_ownership('nacho_bagon', { aux_poke = true, no_collection = true, custom_pool_func = true, in_pool = function() return false end }, true)
    SMODS.Joker:take_ownership('nacho_shelgon', { aux_poke = true, no_collection = true, custom_pool_func = true, in_pool = function() return false end }, true)
    SMODS.Joker:take_ownership('nacho_salamence', { aux_poke = true, no_collection = true, custom_pool_func = true, in_pool = function() return false end }, true)
    SMODS.Joker:take_ownership('nacho_mega_salamence', { aux_poke = true, no_collection = true, custom_pool_func = true, in_pool = function() return false end }, true)
  end
end

return {
  name = "Agarmons Bagon Evo Line",
  enabled = agarmons_config.bagon or false,
  init = init,
  list = { bagon, shelgon, salamence, mega_salamence }
}
