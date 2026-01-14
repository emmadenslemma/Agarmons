local in_debt = function()
  return G.GAME.dollars < ((SMODS.Mods["Talisman"] or {}).can_load and to_big(0) or 0)
end

-- Mega Froslass 478-1
local mega_froslass = {
  name = "mega_froslass",
  agar_inject_prefix = "poke",
  pos = { x = 4, y = 4 },
  soul_pos = { x = 5, y = 4 },
  config = { extra = { debt = 25 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_TAGS.tag_poke_pocket_tag
    info_queue[#info_queue+1] = G.P_TAGS.tag_coupon
    info_queue[#info_queue+1] = G.P_TAGS.tag_d_six
    return {
      vars = {
        card.ability.extra.debt,
        localize { type = 'name_text', set = 'Tag', key = 'tag_poke_pocket_tag' },
        localize { type = 'name_text', set = 'Tag', key = 'tag_coupon' },
        localize { type = 'name_text', set = 'Tag', key = 'tag_d_six' },
      }
    }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Water",
  gen = 4,
  atlas = "AgarmonsJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.setting_blind and in_debt() then
      AG.defer(function()
        add_tag(Tag('tag_poke_pocket_tag'))
        add_tag(Tag('tag_coupon'))
        add_tag(Tag('tag_d_six'))
        play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
        play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
      end)
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.bankrupt_at = G.GAME.bankrupt_at - card.ability.extra.debt
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.bankrupt_at = G.GAME.bankrupt_at + card.ability.extra.debt
  end,
}

local function init()
  poke_add_to_family("froslass", "mega_froslass")
  SMODS.Joker:take_ownership("poke_froslass", { megas = { "mega_froslass" } }, true)
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_froslass }
}
