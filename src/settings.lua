-- Yes, this file is a mess, I'm not touching it again.
local Tile = assert(SMODS.load_file("src/settings/tile.lua"))()
local map = AGAR.LIST_UTILS.map

local content = assert(SMODS.load_file("src/settings/contents.lua"))()

local function create_tile_spacer()
  return { n = G.UIT.B, config = { w = 0.1, h = 3.5 } }
end

local function create_tile_grid(args)
  local page_options

  for i, _ in ipairs(content.pages) do
    page_options[#page_options + 1] = localize('k_page') .. " " .. i .. "/" .. #page_options
  end

  local current_page = content.pages[args.page_num]

  local first_row = { n = G.UIT.R, config = { align = "cm" }, nodes = { create_tile_spacer() } }
  local second_row = { n = G.UIT.R, config = { align = "cm" }, nodes = { create_tile_spacer() } }

  local tiles = map(current_page.tiles, function(tile)
    return Tile {
      label = tile.label(),
      display_cards = tile.list,
      ref_table = agarmons_config,
      ref_value = tile.config_key,
    }
  end)

  for i, tile in ipairs(tiles) do
    if i < 4 then
      table.insert(first_row.nodes, tile:render())
      table.insert(first_row.nodes, create_tile_spacer())
    else
      table.insert(second_row.nodes, tile:render())
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
          {
            n = G.UIT.R,
            config = { align = "cm", padding = 0.2 },
            nodes = {
              { n = G.UIT.T, config = { text = current_page.title(), colour = G.C.UI.TEXT, scale = 0.5 } },
            }
          },
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
                scale = 0.8,
                colour = G.C.RED,
                cycle_shoulders = false,
                no_pips = true
              })
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
