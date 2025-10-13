-- Palkia 484
local palkia = {
  name = "palkia",
  pos = { x = 4, y = 3 },
  soul_pos = { x = 5, y = 3 },
  config = { extra = { joker_slot_mod = 1, bosses_defeated = 0, upgrade_rqmt = 1 } },
  loc_txt = {
    name = "Palkia",
    text = {
      "Gives {C:dark_edition}+#1#{} Joker Slots after",
      "defeating {C:attention}#2#{} {C:inactive}[#3#]{} {C:attention}#4#{}",
      "{C:inactive}(Requirement increases each time)"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return {
      vars = {
        center.ability.extra.joker_slot_mod,
        center.ability.extra.upgrade_rqmt,
        center.ability.extra.upgrade_rqmt - center.ability.extra.bosses_defeated,
        center.ability.extra.upgrade_rqmt == 1 and localize("boss_blind_singular") or localize("boss_blind_plural"),
      }
    }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Water",
  gen = 4,
  atlas = "poke_AtlasJokersBasicGen04",
  calculate = function(self, card, context)
    if context.end_of_round
        and context.game_over == false and context.main_eval and context.beat_boss
        and not context.blueprint and not card.debuff then
      card.ability.extra.bosses_defeated = card.ability.extra.bosses_defeated + 1
      if card.ability.extra.bosses_defeated == card.ability.extra.upgrade_rqmt then
        card.ability.extra.bosses_defeated = 0
        card.ability.extra.upgrade_rqmt = card.ability.extra.upgrade_rqmt + 1
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        return {
          message = localize { type = 'variable', key = 'a_joker_slot', vars = { card.ability.extra.joker_slot_mod } },
          colour = G.C.DARK_EDITION
        }
      end
    end
  end,
}

local DisplayCard = assert(SMODS.load_file("src/ui/display_card.lua"))()

-- TODO: Either make a new adjacent to Card or make a constructor for Card that doesn't have all the functions we don't need


local create_cardarea = function(card_names)
  local scale = 1
  local cardarea = CardArea(0, 0, G.CARD_W * (2 - 1 / #card_names) * scale, G.CARD_H * scale, { card_limit = #card_names, type = 'title' })
  for _, card_name in ipairs(card_names) do
    local prefix = "j_agar_"
    local key = prefix .. card_name
    local card = DisplayCard(0, 0, G.CARD_W * scale, G.CARD_H * scale, nil, --[[G.P_CENTERS[key]] palkia, { bypass_discovery_center = true, bypass_discovery_ui = true })
    cardarea:emplace(card)
  end
  return cardarea
end

local create_preview_toggle = function(card_names, label, config_key)
  return
  {
    n = G.UIT.R,
    config = { align = "cm", w = 8 },
    nodes = {
      {
        n = G.UIT.C,
        config = { align = "cm" },
        nodes = {
          {
            n = G.UIT.R,
            config = { align = "cm" },
            nodes = {
              { n = G.UIT.O, config = { object = create_cardarea(card_names) } },
            }
          },
          {
            n = G.UIT.R,
            config = { align = "cm" },
            nodes = {
              create_toggle { label = label, ref_table = agarmons_config, ref_value = config_key },
            }
          },
        }
      },
    }
  }
end

local function create_header(text)
  return {
    n = G.UIT.R,
    config = { align = "cm", padding = 0.2 },
    nodes = {
      { n = G.UIT.T, config = { text = text, colour = G.C.UI.TEXT, scale = 0.6 } },
    }
  }
end

function G.FUNCS.agar_update_config_page(args)
end

local function create_footer()
  return {
    n = G.UIT.R,
    config = { align = "cm", padding = 0.2 },
    nodes = {
      create_option_cycle({
        options = { localize('k_page') .. " 1/1" },
        current_option = 1,
        opt_callback = "agar_update_config_page",
        -- opt_args = {ui = runs, rpp = runs_per_page, rps = run_paths},
        scale = 0.8, colour = G.C.RED, cycle_shoulders = false, no_pips = true })
      }
    }
end

-- NOTE: Cards are roughly 2.05 by 2.76

local function create_tile()
  return {
    n = G.UIT.C,
    config = { r = 0.1, padding = 0.025, emboss = 0.05, colour = G.C.BLACK, outline = 1, outline_colour = G.C.RARITY[4] },
    nodes = {
      { n = G.UIT.R, config = { align = "cm", r = 0.1, padding = 0.1, emboss = 0.05, colour = G.C.GREY }, nodes = {
        { n = G.UIT.C, config = { align = "cm", w = G.CARD_W * 2 }, nodes = {
          { n = G.UIT.O, config = { object = create_cardarea({ 1, 2, 3 }) } },
        }},
        { n = G.UIT.C, config = { align = "cm" }, nodes = {
          create_toggle { ref_table = agarmons_config, ref_value = "palkia", col = true, hide_label = true, w = 0, h = 0 },
        }},
      }},
      { n = G.UIT.R, config = { align = "cm", padding = 0.1 }, nodes = {
        { n = G.UIT.T, config = { text = "Palkia", colour = G.C.UI.TEXT, scale = 0.4 } },
      }},
    }
  }
end

local function create_tile_spacer()
  return  { n = G.UIT.B, config = { w = 0.1, h = 3.5 } }
end

local function create_tile_grid()
  return {
    n = G.UIT.C,
    nodes = {
      create_header("Legendaries"),
      {
        n = G.UIT.R,
        nodes = {
          create_tile(),
          create_tile_spacer(),
          create_tile(),
          create_tile_spacer(),
          create_tile(),
        }
      },
      {
        n = G.UIT.R,
        nodes = {
          create_tile(),
          create_tile_spacer(),
          create_tile(),
          create_tile_spacer(),
          create_tile(),
        }
      },
      create_footer(),
    }
  }
end

function SMODS.current_mod.config_tab()
  return {
    n = G.UIT.ROOT,
    config = {
      r = 0.1,
      minw = 15,
      minh = 8,
      align = "cm",
      colour = G.C.BLACK,
      emboss = 0.05,
    },
    nodes = { create_tile_grid() }
  }
end
