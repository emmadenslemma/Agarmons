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
  config = { extra = { form = nil, chips = 25, chip_mod = 5, mult = 5, mult_mod = 1, money = 1, money_mod = 0.2 } },
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
  eternal_compat = false,
  blueprint_compat = true,
  poke_custom_values_to_keep = { "chips", "mult", "money" },
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
      if card.ability.extra[value] < 0.01 then
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
  megas = { 'mega_tatsugiri' },
  fuses = { with = 'j_agar_dondozo', into = 'j_agar_dondozo_commander', direction = 'right' },
}

-- Mega Tatsugiri 978-1
local mega_tatsugiri = {
  name = "mega_tatsugiri",
  pos = { x = 4, y = 3 },
  soul_pos = { x = 5, y = 3 },
  config = { extra = { form = nil, chips1 = 25, mult1 = 5, money1 = 1, num = 1, dem = 3, money2 = 3, retriggers = 1, Xmult_multi = 1.2, chips = 25, mult = 5, money = 1 } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local form = card.ability.extra.form or "curly"
    local key = self.key .. '_' .. form
    local num, dem = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.dem, 'curly_megagiri')

    local vars = ({
      ["curly"] = { card.ability.extra.chips1, card.ability.extra.mult1, card.ability.extra.money1, num, dem },
      ["droopy"] = { card.ability.extra.chips1, card.ability.extra.mult1, card.ability.extra.money1, card.ability.extra.Xmult_multi },
      ["stretchy"] = { card.ability.extra.chips1, card.ability.extra.mult1, card.ability.extra.money2 },
    })[form]

    return { key = key, vars = vars }
  end,
  rarity = "poke_mega",
  cost = 10,
  stage = "Mega",
  ptype = "Dragon",
  gen = 9,
  atlas = "AgarmonsJokers",
  blueprint_compat = true,
  poke_custom_values_to_keep = { "chips", "mult", "money" },
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play
        and card.ability.extra.form == "curly"
        and SMODS.pseudorandom_probability(card, 'curly_megagiri', card.ability.extra.num, card.ability.extra.dem, 'curly_megagiri') then
      return {
        repetitions = card.ability.extra.retriggers
      }
    end
    if context.individual and context.cardarea == G.play then
      local Xmult = card.ability.extra.form == "droopy" and card.ability.extra.Xmult_multi
      local dollars = card.ability.extra.form == "stretchy"
          and card.ability.extra.money2
          or card.ability.extra.money1

      return {
        chips = card.ability.extra.chips1,
        mult = card.ability.extra.mult1,
        dollars = ease_poke_dollars(card, "mega_tatsugiri", dollars, true),
        Xmult = Xmult,
      }
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
      local sprites = ({
        ["curly"] = { { x = 4, y = 3 }, { x = 5, y = 3 } },
        ["droopy"] = { { x = 6, y = 3 }, { x = 7, y = 3 } },
        ["stretchy"] = { { x = 8, y = 3 }, { x = 9, y = 3 } },
      })[card.ability.extra.form]

      local pos, soul_pos = sprites[1], sprites[2]

      card.children.center:set_sprite_pos(pos)
      card.children.floating_sprite:set_sprite_pos(soul_pos)
    end
  end,
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

local init = function()
  -- Evolution does not like `soul_pos` on forms
  AG.hookafterfunc(_G, 'poke_backend_evolve', function(card, to_key, energize_amount)
    if to_key == 'j_agar_mega_tatsugiri' then
      G.P_CENTERS['j_agar_mega_tatsugiri']:set_sprites(card)
    end
  end, true)
end

return {
  config_key = "dondozo",
  init = init,
  list = { --[[dondozo, dondozo_commander,]] tatsugiri, mega_tatsugiri },
  family = {
    -- 'dondozo',
    { key = 'tatsugiri', form = 'curly' },
    { key = 'tatsugiri', form = 'droopy' },
    { key = 'tatsugiri', form = 'stretchy' },
    { key = 'mega_tatsugiri', form = 'curly' },
    { key = 'mega_tatsugiri', form = 'droopy' },
    { key = 'mega_tatsugiri', form = 'stretchy' },
    -- 'dondozo_commander'
  }
}
