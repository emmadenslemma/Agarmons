-- Dummy pack to spawn when using the Ubers Deck
local uber_pack = {
  key = "uber_pack",
  config = { extra = 3, choose = 1 },
  weight = 0,
  draw_hand = false,
  no_collection = true,
  create_card = function(self, card)
    return SMODS.create_card {
      key = get_random_poke_key("uber_pack", "Legendary"),
      no_edition = true,
      skip_materialize = true,
      key_append = "uber_pack",
    }
  end,
  create_UIBox = function(self)
    local _size = math.max(1, SMODS.OPENED_BOOSTER.ability.extra)

    G.pack_cards = G.pack_cards or CardArea(
      G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
      math.max(1, math.min(_size, 5)) * G.CARD_W * 1.1,
      1.05 * G.CARD_H,
      {
        card_limit = _size,
        type = 'consumeable',
        highlight_limit = 1,
        negative_info = true
      }
    )

    ---@format disable-next
    local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
      {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
            {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
              {n=G.UIT.O, config={object = G.pack_cards}},
            }}
          }}
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={}},
        {n=G.UIT.R, config={align = "tm"}, nodes={
          {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
            UIBox_dyn_container({
              {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                  {n=G.UIT.O, config={object = DynaText({string = localize { type = "name_text", set = "Back", key = "b_agar_uberdeck" }, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}
                }},
                {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                  {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                  {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}
                }},
              }}
            }),
          }},
        }}
      }}
    }}

    return t
  end,
}

return {
  list = { uber_pack }
}
