local create_cardarea = function(card_names)
  local cardarea = CardArea(0, 0, G.CARD_W * (2 - 1 / #card_names), G.CARD_H, { card_limit = #card_names, type = 'title' })
  for _, card_name in ipairs(card_names) do
    local prefix = AGAR.enabled[card_name] and "j_agar_" or "j_agar_shell_"
    local key = prefix .. card_name
    local card = Card(0, 0, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[key])
    cardarea:emplace(card)
  end
  return cardarea
end

local create_preview_toggle = function(card_names, label, config_key)
  return
      { n = G.UIT.R, config = { align = "cm", w = 8 }, nodes = {
        { n = G.UIT.C, config = { align = "cm" }, nodes = {
          { n = G.UIT.R, config = { align = "cm" }, nodes = {
            { n = G.UIT.O, config = { object = create_cardarea(card_names) }},
          }},
          { n = G.UIT.R, config = { align = "cm" }, nodes = {
            create_toggle { label = label, ref_table = agarmons_config, ref_value = config_key },
          }},
        }},
      }}
end

SMODS.current_mod.config_tab = function()
  return
  { n = G.UIT.ROOT, config = { colour = G.C.CLEAR, align = "cm", minw = 20 }, nodes = {
    { n = G.UIT.C, config = { align = "cm" }, nodes = {
      { n = G.UIT.R, config = { align = "tl" }, nodes = {
        -- Header
        { n = G.UIT.T, config = { text = "Regular Pokémon", colour = G.C.WHITE, scale = .6, hover = true }},
        { n = G.UIT.B, config = { w = 1, h = 1 }}
      }},
      { n = G.UIT.R, config = { align = "cm", colour = G.C.GREY, padding = .1, r = .1, hover = true }, nodes = {
        { n = G.UIT.C, config = { align = "tm" }, nodes = {
          create_preview_toggle({ "torkoal" }, localize("agar_enable_torkoal"), "torkoal"),
          create_preview_toggle({ "sandygast", "palossand" }, localize("agar_enable_sandygast"), "sandygast"),
        }},
        { n = G.UIT.C, config = { align = "tm" }, nodes = {
          create_preview_toggle({ "spheal", "sealeo", "walrein" }, localize("agar_enable_spheal"), "spheal"),
          create_preview_toggle({ "pyukumuku" }, localize("agar_enable_pyukumuku"), "pyukumuku"),
        }},
        { n = G.UIT.C, config = { align = "tm" }, nodes = {
          create_preview_toggle({ "bagon", "shelgon", "mega_salamence", "salamence" }, localize("agar_enable_bagon"), "bagon"),
          create_preview_toggle({ "frigibax", "arctibax", "baxcalibur" }, localize("agar_enable_frigibax"), "frigibax"),
        }},
        { n = G.UIT.C, config = { align = "tm" }, nodes = {
          create_preview_toggle({ "dewpider", "araquanid" }, localize("agar_enable_dewpider"), "dewpider"),
          -- create_preview_toggle({ "hatenna", "hattrem", "hatterene" }, localize("agar_enable_hatenna"), "hatenna"),
        }},
      }},
      -- Pagination goes here
    }},
  }}
end
