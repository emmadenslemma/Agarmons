-- Dondozo 977
local dondozo = {
  name = "dondozo",
  config = { extra = {} },
  loc_txt = {
    name = "Dondozo",
    text = {
      "{C:dark_edition}???",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = {} }
  end,
  rarity = 3,
  cost = 8,
  stage = "Basic",
  ptype = "Water",
  gen = 9,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
  fuses = { with = 'j_agar_tatsugiri', into = 'j_agar_dondozo_commander', direction = 'left' }
}

-- Tatsugiri 978
local tatsugiri = {
  name = "tatsugiri",
  pos = { x = 0, y = 3 },
  config = { extra = { form = nil, num = 1, dem = 3 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local form = card.ability.extra.form
    local key = self.key .. '_' .. form
    local num, dem = SMODS.get_probability_vars(self, card.ability.extra.num, card.ability.extra.dem,
      'tatsugiri_' .. form)
    return { key = key, vars = { num, dem } }
  end,
  rarity = "poke_safari",
  cost = 4,
  stage = "Basic",
  ptype = "Dragon",
  gen = 9,
  atlas = "AtlasJokersBasicGen09",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
      if SMODS.pseudorandom_probability(card, 'tatsugiri_' .. card.ability.extra.form, card.ability.extra.num, card.ability.extra.dem) then
        ---@diagnostic disable-next-line: redundant-parameter
        SMODS.destroy_cards(card, nil, nil, true)
        return {
          message = localize('k_eaten_ex')
        }
      end
    end
  end,
  set_ability = function(self, card, initial, delay_sprites)
    if initial then
      card.ability.extra.form = card.ability.extra.form
          or pseudorandom_element({ "curly", "droopy", "stretchy" }, pseudoseed("tatsugiri"))
    end
    self:set_sprites(card)
  end,
  set_sprites = function(self, card, front)
    if card.ability and card.ability.extra and card.ability.extra.form then
      local pos = ({
        ["curly"] = { x = 0, y = 3 },
        ["droopy"] = { x = 2, y = 3 },
        ["stretchy"] = { x = 4, y = 3 },
      })[card.ability.extra.form]

      card.children.center:set_sprite_pos(pos)
    end
  end,
  fuses = { with = 'j_agar_dondozo', into = 'j_agar_dondozo_commander', direction = 'right' },
}

local dondozo_commander = {
  name = "dondozo_commander",
  pos = { x = 0, y = 0 },
  config = { extra = { form = "curly" }, extra_slots_used = 1 },
  display_size = { w = 142, h = 95 },
  loc_txt = {
    name = "Dondozo",
    text = {
      "{C:dark_edition}???",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = {} }
  end,
  rarity = 3,
  cost = 8,
  stage = "Basic",
  ptype = "Water",
  gen = 9,
  atlas = "AgarmonsCommandozo",
  no_collection = true,
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
  end,
  set_ability = function(self, card, initial, delay_sprites)
    self:set_sprites(card)
  end,
  set_sprites = function(self, card, front)
    if card.ability and card.ability.extra and card.ability.extra.form then
      local pos = ({
        ["curly"] = { x = 0, y = 0 },
        ["droopy"] = { x = 1, y = 0 },
        ["stretchy"] = { x = 2, y = 0 },
      })[card.ability.extra.form]

      card.children.center:set_sprite_pos(pos)
    end
  end,
  in_pool = function(self)
    return false
  end,
}

return {
  init = init,
  list = { dondozo, dondozo_commander, tatsugiri },
  family = {
    'dondozo',
    { key = 'tatsugiri', form = 'curly' },
    { key = 'tatsugiri', form = 'droopy' },
    { key = 'tatsugiri', form = 'stretchy' },
    'dondozo_commander'
  }
}
