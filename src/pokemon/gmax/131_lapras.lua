-- G-Max Lapras 131
local gmax_lapras = {
  name = "gmax_lapras",
  pos = { x = 14, y = 7 },
  soul_pos = { x = 15, y = 7 },
  config = { extra = { chips = 0 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Lapras",
    text = {
      "{C:chips}+#3#{} Chips",
      "Every hand played",
      "creates a random {C:attention}Tag{}"
    }
  },
  loc_vars = function(self, info_queue, center)
    type_tooltip(self, info_queue, center)
    return { vars = { center.ability.extra.chips } }
  end,
  rarity = "agar_gmax",
  cost = 10,
  stage = "Gigantamax",
  ptype = "Water",
  gen = 1,
  atlas = "AtlasJokersBasicGen01",
  blueprint_compat = true,
  poke_custom_values_to_keep = { "chips" },
  calculate = function(self, card, context)
    if context.joker_main then
      card_eval_status_text(card, "extra", nil, nil, nil, {
        message = localize("agar_gmax_resonance_ex"),
        colour = G.C.RARITY["agar_gmax"]
      })
      G.E_MANAGER:add_event(Event({
        func = function()
          -- Stolen from Missingno
          local tags = {}
          for k, v in pairs(G.P_TAGS) do
            if v.key ~= "tag_boss" then
              tags[#tags + 1] = v
            end
          end
          local temp_tag = pseudorandom_element(tags, pseudoseed("gmaxlapras"))
          local tag = Tag(temp_tag.key)
          if tag.key == "tag_orbital" then
            local _poker_hands = {}
            for k, v in pairs(G.GAME.hands) do
              if v.visible then
                _poker_hands[#_poker_hands + 1] = k
              end
            end
            tag.ability.orbital_hand = pseudorandom_element(_poker_hands, pseudoseed("gmaxlapras"))
          end
          add_tag(tag)
          play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
          play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
          return true
        end
      }))
    end
    -- Keep Lapras's regular Chips scoring
    return SMODS.Joker.obj_table.j_poke_lapras.calculate(self, card, context)
  end,
}

local init = function()
  AGAR.GMAX.evos["j_poke_lapras"] = "j_agar_gmax_lapras"
  AGAR.FAMILY_UTILS.init_gmax(gmax_lapras)
  G.E_MANAGER:add_event(Event({
    func = function()
      G.P_CENTERS["j_poke_lapras"].poke_custom_values_to_keep = G.P_CENTERS["j_poke_lapras"].poke_custom_values_to_keep or {}
      table.insert(G.P_CENTERS["j_poke_lapras"].poke_custom_values_to_keep, "chips")
      return true
    end
  }))
end

return {
  name = "Agarmons G-Max Lapras",
  enabled = agarmons_config.gmax or false,
  init = init,
  list = { gmax_lapras }
}
