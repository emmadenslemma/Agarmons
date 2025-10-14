local map = AGAR.LIST_UTILS.map

local pokes = {}
local settings_content = assert(SMODS.load_file("src/ui/settings_contents.lua"))()


local function load_pokemon(item)
  if item.rarity == "agar_gmax" then
    AGAR.GMAX.preload(item)
  end

  local custom_atlas = item.atlas and string.find(item.atlas, "Agarmons")

  if not item.atlas then
    poke_load_atlas(item)
    poke_load_sprites(item)
  end

  item.atlas = (custom_atlas and "agar_" or "poke_") .. item.atlas
  item.set = 'Joker'
  item.key = 'j_agar_' .. item.name
  item.ability = item.config

  pokes[item.key] = item
end

local function load_pokemon_folder(folder)
  local files = NFS.getDirectoryItems(SMODS.current_mod.path .. folder)

  for _, filename in ipairs(files) do
    local file_path = SMODS.current_mod.path .. folder .. filename
    local file_type = NFS.getInfo(file_path).type

    if file_type ~= "directory" and file_type ~= "symlink" then
      local poke = assert(SMODS.load_file(folder .. filename))()

      if poke.list and #poke.list > 0 then
        for _, item in ipairs(poke.list) do
            load_pokemon(item)
        end
      end
    end
  end
end

load_pokemon_folder("src/pokemon/")
load_pokemon_folder("src/pokemon/gmax/")

local DisplayCard = assert(SMODS.load_file("src/ui/display_card.lua"))()

-- TODO: Either make a new adjacent to Card or make a constructor for Card that doesn't have all the functions we don't need


local create_cardarea = function(card_names)
  local scale = 1
  local cardarea = CardArea(0, 0, G.CARD_W * (2 - 1 / #card_names) * scale, G.CARD_H * scale, { card_limit = #card_names, type = 'title' })
  for _, card_name in ipairs(card_names) do
    local prefix = "j_agar_"
    local key = prefix .. card_name
    local card = DisplayCard(0, 0, G.CARD_W * scale, G.CARD_H * scale, nil, pokes[key], { bypass_discovery_center = true, bypass_discovery_ui = true })
    cardarea:emplace(card)
  end
  return cardarea
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

local function create_tile(card_names, label, config_key)
  return {
    n = G.UIT.C,
    config = { r = 0.1, padding = 0.025, emboss = 0.05, colour = G.C.BLACK, outline = 1, outline_colour = mix_colours(G.C.GREY, G.C.BLACK, 0.4) },
    nodes = {
      { n = G.UIT.R, config = { align = "cm", r = 0.1, minw = G.CARD_W * 2, padding = 0.1, emboss = 0.1, colour = G.C.GREY }, nodes = {
          { n = G.UIT.O, config = { object = create_cardarea(card_names) } },
      }},
      { n = G.UIT.R, config = { align = "cm" }, nodes = {
        -- { n = G.UIT.B, config = { w = 0.4 * 0.9 + 0.43, h = 0.1 } },
        { n = G.UIT.C, config = { align = "cl", --[[minw = 2.6 + 0.36 + 0.43]] }, nodes = {
          { n = G.UIT.T, config = { text = label, colour = G.C.UI.TEXT, scale = 0.4,  } }
        }},
        -- { n = G.UIT.C, nodes = {
          -- create_toggle { ref_table = agarmons_config, ref_value = config_key, col = true, hide_label = true, w = 0, h = 0, scale = 0.9 },
        -- }},
      }}
    }
  }
end

local function create_tile_spacer()
  return  { n = G.UIT.B, config = { w = 0.1, h = 3.5 } }
end

local function create_tile_grid(args)
  local content = settings_content.pages[args.page_num]

  local first_row = { n = G.UIT.R, config = { align = "cm" }, nodes = { create_tile_spacer() } }
  local second_row = { n = G.UIT.R, config = { align = "cm" }, nodes = { create_tile_spacer() } }
  
  local tile_elements = map(content.tiles, function(tile)
    return create_tile(tile.list, tile.label(), tile.config_key)
  end)

  for i,v in ipairs(tile_elements) do
    if i < 4 then
      table.insert(first_row.nodes, v)
      table.insert(first_row.nodes, create_tile_spacer())
    else
      table.insert(second_row.nodes, v)
      table.insert(second_row.nodes, create_tile_spacer())
    end
  end

  return {
    n = G.UIT.ROOT,
    config = { colour = G.C.CLEAR },
    nodes = {
      {
        n = G.UIT.C,
        nodes = {
          create_header(content.title),
          first_row,
          second_row,
          {
            n = G.UIT.R,
            config = { align = "cm", padding = 0.2 },
            nodes = {
              create_option_cycle({
                options = { localize('k_page') .. " 1/3", localize('k_page') .. " 2/3", localize('k_page') .. " 3/3" },
                current_option = args.page_num,
                opt_callback = "agar_update_config_page",
                -- opt_args = {ui = runs, rpp = runs_per_page, rps = run_paths},
                scale = 0.8, colour = G.C.RED, cycle_shoulders = false, no_pips = true })
            }
          }
        }
      }
    }
  }
end

function G.FUNCS.agar_update_config_page(e)
  if not e or not e.cycle_config then return end

  local grid_wrap = G.OVERLAY_MENU:get_UIE_by_ID("agar_grid_wrap")

  grid_wrap.config.object:remove()
  grid_wrap.config.object = UIBox {
    definition = create_tile_grid { page_num = e.cycle_config.current_option },
    config = { parent = grid_wrap, type = "cm" },
  }

  grid_wrap.UIBox:recalculate()
end

function SMODS.current_mod.config_tab()
  local grid = UIBox {
    definition = create_tile_grid { page_num = 1 },
    config = { type = "cm" },
  }

  return {
    n = G.UIT.ROOT,
    config = {
      r = 0.1,
      minw = 14,
      minh = 8.5,
      align = "cm",
      colour = G.C.BLACK,
      emboss = 0.05,
    },
    nodes = {
      { n = G.UIT.O, config = { id = "agar_grid_wrap", object = grid } }
    }
  }
end
