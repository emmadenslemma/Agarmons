-- Toxel 848
local toxel = {
  name = "toxel",
  config = { extra = { Xmult_minus = 0.75, rounds = 2 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    if pokermon_config.detailed_tooltips then
      info_queue[#info_queue + 1] = { set = 'Other', key = 'baby' }
      info_queue[#info_queue + 1] = { key = 'e_negative_consumable', set = 'Edition', config = { extra = 1 } }
      info_queue[#info_queue + 1] = G.P_CENTERS.c_stall_blacksludge
    end
    return { vars = { center.ability.extra.Xmult_minus, center.ability.extra.rounds } }
  end,
  designer = "Gem",
  rarity = 2,
  cost = 4,
  stage = "Baby",
  ptype = "Lightning",
  gen = 8,
  toxic = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      faint_baby_poke(self, card, context)
      return {
        Xmult = card.ability.extra.Xmult_minus
      }
    end
    if context.end_of_round and context.cardarea == G.jokers and not card.debuff then
      SMODS.add_card { key = 'c_stall_blacksludge', edition = 'e_negative' }
    end
    return level_evo(self, card, context, "j_agar_toxtricity")
  end,
}

-- Toxtricity 849
local toxtricity = {
  name = "toxtricity",
  pos = { x = 6, y = 0, },
  config = { extra = { form = "amped", money = 2, money_mod = 1, threshold = 0.5 } },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue + 1] = G.P_CENTERS['m_stall_toxic']
    local ret = { vars = { center.ability.extra.money, center.ability.extra.money_mod, center.ability.extra.threshold } }
    if center.ability.extra.form == "lowkey" then
      ret.key = "j_agar_toxtricity_lowkey"
    end
    return ret
  end,
  rarity = 3,
  cost = 7,
  stage = "Basic",
  ptype = "Lightning",
  gen = 8,
  toxic = true,
  atlas = "AtlasJokersBasicGen08",
  blueprint_compat = true,
  enhancement_gate = 'm_stall_toxic',
  calculate = function(self, card, context)
    if context.individual and not context.end_of_round
        and SMODS.has_enhancement(context.other_card, 'm_stall_toxic')
        and ((card.ability.extra.form == "amped" and context.cardarea == G.play)
          or (card.ability.extra.form == "lowkey" and context.cardarea == G.hand)) then
      local money = card.ability.extra.money

      if card.ability.extra.form == "amped" then
        money = money + card.ability.extra.money_mod * math.floor((G.GAME.current_round.toxic.toxicXMult - 1) / card.ability.extra.threshold)
      end

      return {
        dollars = money
      }
    end
  end,
  set_ability = function(self, card, initial, delay_sprites)
    if initial then
      local form = pseudorandom(pseudoseed('toxtricity')) < .5
          and "amped"
          or "lowkey"

      card.ability.extra.form = form
    end
    self:set_sprites(card)
  end,
  set_sprites = function(self, card, front)
    if card.ability and card.ability.extra and card.ability.extra.form then
      local pos = card.ability.extra.form == "amped"
          and { x = 6, y = 0 }
          or { x = 8, y = 0 }

      card.children.center:set_sprite_pos(pos)
    end
  end
}

-- G-Max Toxtricity 849-1
local gmax_toxtricity = {
  name = "gmax_toxtricity",
  pos = { x = 14, y = 12 },
  soul_pos = { x = 15, y = 12 },
  config = { extra = { form = "amped", money1 = 1, retriggers = 1 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Toxtricity",
    text = {
      "All played and held {C:attention}Toxic{} cards",
      "give {C:money}$#3#{} and retrigger",
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    info_queue[#info_queue + 1] = G.P_CENTERS['m_stall_toxic']
    return { vars = { center.ability.extra.money1 } }
  end,
  rarity = "agar_gmax",
  cost = 12,
  stage = "Gigantamax",
  ptype = "Lightning",
  gen = 8,
  toxic = true,
  atlas = "AtlasJokersBasicGen08",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and not context.end_of_round
        and (context.cardarea == G.play or context.cardarea == G.hand)
        and SMODS.has_enhancement(context.other_card, 'm_stall_toxic') then
      return {
        dollars = card.ability.extra.money1
      }
    end
    if context.repetition
        and (context.cardarea == G.play or (context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1)))
        and SMODS.has_enhancement(context.other_card, 'm_stall_toxic') then
      return {
        repetitions = card.ability.extra.retriggers
      }
    end
  end,
}

local init = function()
  AGAR.GMAX.evos["j_agar_toxtricity"] = "j_agar_gmax_toxtricity"
end

local family = {
  "toxel",
  { key = "toxtricity", form = "amped" },
  { key = "toxtricity", form = "lowkey" },
}

if agarmons_config.gmax then
  table.insert(family, "gmax_toxtricity")
else
  gmax_toxtricity.no_collection = true
end

return {
  enabled = (SMODS.Mods["ToxicStall"] or {}).can_load and agarmons_config.toxel,
  init = init,
  list = { toxel, toxtricity, gmax_toxtricity },
  family = family,
}
