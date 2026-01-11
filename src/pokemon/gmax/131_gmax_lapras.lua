-- G-Max Lapras 131
local gmax_lapras = {
  name = "gmax_lapras",
  agar_inject_prefix = "poke",
  config = { extra = { chips = 0 } },
  loc_txt = {
    name = "{C:agar_gmax}G-MAX{} Lapras",
    text = {
      "{C:chips}+#3#{} Chips",
      "Every hand played",
      "creates a random {C:attention}Tag{}"
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.chips } }
  end,
  rarity = "agar_gmax",
  cost = 10,
  stage = "Gigantamax",
  ptype = "Water",
  gen = 1,
  blueprint_compat = true,
  poke_custom_values_to_keep = { "chips" },
  calculate = function(self, card, context)
    if context.before then
      SMODS.calculate_effect({
        message = localize("agar_gmax_resonance_ex"),
        colour = G.C.RARITY["agar_gmax"]
      }, card)

      G.E_MANAGER:add_event(Event({
        func = function()
          -- Stolen from Missingno
          local tags = {}
          for k, v in pairs(G.P_TAGS) do
            if v.key ~= "tag_boss" then
              tags[#tags+1] = v
            end
          end
          local temp_tag = pseudorandom_element(tags, pseudoseed("gmaxlapras"))
          local tag = Tag(temp_tag.key)
          if tag.key == "tag_orbital" then
            local _poker_hands = {}
            for k, v in pairs(G.GAME.hands) do
              if v.visible then
                _poker_hands[#_poker_hands+1] = k
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
    return G.P_CENTERS.j_poke_lapras.calculate(self, card, context)
  end,
}

local init = function()
  pokermon.add_family { "lapras", "gmax_lapras" }

  SMODS.Joker:take_ownership("poke_lapras", { gmax = "gmax_lapras", poke_custom_values_to_keep = { "chips" } }, true)
end

return {
  can_load = agarmons_config.gmax,
  init = init,
  list = { gmax_lapras }
}
