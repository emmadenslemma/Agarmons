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
  fuses = { with = 'j_agar_tatsugiri', into = 'j_agar_dondozo_commander', direction = 'left', evo_this = true }
}

-- Tatsugiri 978
local tatsugiri = {
  name = "tatsugiri",
  pos = { x = 0, y = 3 },
  config = { extra = { form = nil, chips = 24, chip_mod = 2, mult = 5, mult_mod = 1, money = 1, money_mod = 0.25 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local form = card.ability.extra.form or "curly"
    local key = self.key .. '_' .. form
    return {
      key = key,
      vars = ({
        ["curly"] = { card.ability.extra.chips, card.ability.extra.chip_mod },
        ["droopy"] = { card.ability.extra.mult, card.ability.extra.mult_mod },
        ["stretchy"] = { card.ability.extra.money, card.ability.extra.money_mod },
      })[form]
    }
  end,
  rarity = 1,
  cost = 5,
  stage = "Basic",
  ptype = "Dragon",
  gen = 9,
  atlas = "AtlasJokersBasicGen09",
  blueprint_compat = true,
  calculate = function(self, card, context)
    local form = card.ability.extra.form or "curly"
    local values = ({
      ["curly"] = { "chips", "chip_mod", G.C.CHIPS },
      ["droopy"] = { "mult", "mult_mod", G.C.MULT },
      ["stretchy"] = { "money", "money_mod", G.C.MONEY },
    })[form]

    local value, value_mod, ret_colour = values[1], values[2], values[3]

    if context.individual and context.cardarea == G.play then
      return form == "stretchy" and {
        dollars = ease_poke_dollars(card, "tatsugiri_stretchy", card.ability.extra.money, true)
      } or {
        [value] = card.ability.extra[value]
      }
    end

    if context.after and not context.blueprint then
      card.ability.extra[value] = card.ability.extra[value] - card.ability.extra[value_mod]
      if card.ability.extra[value] <= 0 then
        SMODS.destroy_cards(card, nil, nil, true)
        return {
          message = localize('k_eaten_ex'),
          colour = ret_colour,
        }
      else
        local message = form == "stretchy"
            and ('-' .. localize('$') .. card.ability.extra.money_mod)
            or localize { type = 'variable', key = 'a_' .. value .. '_minus', vars = { card.ability.extra[value_mod] } }
        return {
          message = message,
          colour = ret_colour,
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
    if not self.discovered and not self.bypass_discovery_center then return end
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
  aux_poke = true,
  no_collection = true,
  blueprint_compat = true,
  custom_pool_func = true,
  calculate = function(self, card, context)
  end,
  set_ability = function(self, card, initial, delay_sprites)
    self:set_sprites(card)
  end,
  set_sprites = function(self, card, front)
    if not self.discovered and not self.bypass_discovery_center then return end
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
  config_key = "dondozo",
  list = { --[[dondozo, dondozo_commander,]] tatsugiri },
  family = {
    -- 'dondozo',
    { key = 'tatsugiri', form = 'curly' },
    { key = 'tatsugiri', form = 'droopy' },
    { key = 'tatsugiri', form = 'stretchy' },
    -- 'dondozo_commander'
  }
}
