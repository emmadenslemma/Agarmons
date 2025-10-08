local lunas = {
  "j_agar_lunala",
  "j_poke_ursaluna",
}

if (SMODS.Mods["PokermonMaelmc"] or {}).can_load then
  lunas[#lunas + 1] = "j_maelmc_lunatone"
  lunas[#lunas + 1] = "j_maelmc_bloodmoon_ursaluna"
end

local dons = {
  "j_agar_groudon",
  "j_poke_rhydon",
  "j_poke_donphan",
}

local calculate_ref = SMODS.current_mod.calculate

SMODS.current_mod.calculate = function(self, context)
  if calculate_ref then
    calculate_ref(self, context)
  end
  if context and context.setting_blind
      and G.GAME.modifiers.lunadon and G.GAME.round == 1 then
    play_sound("tarot1")
    attention_text({
      scale = 0.8, text = localize("agar_lunadon_start"), hold = 10, align = 'cm', offset = { x = 0, y = -2.7 }, major = G.play
    })
  end
  if context and context.end_of_round and not context.repetition and not context.individual
      and G.GAME.modifiers.lunadon and G.GAME.blind.boss and not context.game_over then
    local prev_luna
    local prev_don
    -- Scrap em both
    for _, card in pairs(G.jokers.cards) do
      local is_luna = false
      for _, luna in pairs(lunas) do
        if card.config.center.key == luna then
          is_luna = true
          break
        end
      end
      if is_luna then
        prev_luna = prev_luna or card.config.center.key
      else
        prev_don = prev_luna or card.config.center.key
      end
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
          card:remove()
          return true
        end
      }))
    end

    if G.GAME.round_resets.ante ~= 7 then
      play_sound("tarot1")
      local quip_number = math.floor(pseudorandom(pseudoseed("lunadon")) * 6) + 1
      attention_text({
        scale = 0.8, text = localize("agar_lunadon_" .. quip_number), hold = 10, align = "cm", offset = { x = 0, y = -2.7 }, major = G.play
      })
      -- Roll a new set of LunaDons
      local new_luna = pseudorandom_element(lunas, pseudoseed("luna" .. G.GAME.round_resets.ante))
      local new_don
      -- We only want 1 repeat max
      if new_luna == prev_luna then
        local adjusted_dons = {}
        for _, don in pairs(dons) do
          if don ~= prev_don then
            adjusted_dons[#adjusted_dons + 1] = don
          end
        end
        new_don = pseudorandom_element(adjusted_dons, pseudoseed("don" .. G.GAME.round_resets.ante))
      else
        new_don = pseudorandom_element(dons, pseudoseed("don" .. G.GAME.round_resets.ante))
      end

      G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 1.2,
        func = function()
          play_sound("timpani")
          local _luna = SMODS.create_card { set = "Joker", key = new_luna }
          _luna:set_eternal(true)
          _luna:add_to_deck()
          G.jokers:emplace(_luna)
          local _don = SMODS.create_card { set = "Joker", key = new_don }
          _don:set_eternal(true)
          _don:add_to_deck()
          G.jokers:emplace(_don)
          return true
        end
      }))
    else
      -- We're at the endgame: Bring out LunaLunaDonDon
      play_sound("tarot1")
      attention_text({
        scale = 0.8, text = { localize("agar_lunadon_end_1"), localize("agar_lunadon_end_2") }, hold = 2.4, align = 'cm', offset = { x = 0, y = -2.7 }, major = G.play
      })

      G.jokers.config.card_limit = G.jokers.config.card_limit + 2

      luna1 = pseudorandom_element(lunas, pseudoseed("luna1" .. G.GAME.round_resets.ante))
      don1 = pseudorandom_element(dons, pseudoseed("don1" .. G.GAME.round_resets.ante))

      local second_luna_pool = {}
      for _, luna in pairs(lunas) do
        if luna ~= luna1 then
          second_luna_pool[#second_luna_pool + 1] = luna
        end
      end

      local second_don_pool = {}
      for _, don in pairs(dons) do
        if don ~= don1 then
          second_don_pool[#second_don_pool + 1] = don
        end
      end

      luna2 = pseudorandom_element(second_luna_pool, pseudoseed("luna2" .. G.GAME.round_resets.ante))
      don2 = pseudorandom_element(second_don_pool, pseudoseed("don2" .. G.GAME.round_resets.ante))

      G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 2.4,
        func = function()
          play_sound("timpani")
          attention_text({
            scale = 0.8, text = localize("agar_lunadon_end_2"), hold = 10, align = 'cm', offset = { x = 0, y = -2.7 }, major = G.play
          })
          local _luna1 = SMODS.create_card { set = "Joker", key = luna1 }
          _luna1:set_eternal(true)
          _luna1:add_to_deck()
          G.jokers:emplace(_luna1)
          local _luna2 = SMODS.create_card { set = "Joker", key = luna2 }
          _luna2:set_eternal(true)
          _luna2:add_to_deck()
          G.jokers:emplace(_luna2)
          local _don1 = SMODS.create_card { set = "Joker", key = don1 }
          _don1:set_eternal(true)
          _don1:add_to_deck()
          G.jokers:emplace(_don1)
          local _don2 = SMODS.create_card { set = "Joker", key = don2 }
          _don2:set_eternal(true)
          _don2:add_to_deck()
          G.jokers:emplace(_don2)
          return true
        end
      }))
    end
  end
end

local lunadon = {
  object_type = "Challenge",
  key = "lunadon",
  rules = {
    custom = {
      { id = "lunadon" },
      { id = "no_shop_jokers" },
    },
    modifiers = {
      { id = "joker_slots", value = 2 },
    },
  },
  jokers = {
    { id = "j_agar_lunala", eternal = true },
    { id = "j_agar_groudon", eternal = true },
  },
  restrictions = {
    banned_cards = {
      { id = 'c_judgement' },
      { id = 'c_wraith' },
      { id = 'c_soul' },
      { id = 'c_poke_pokeball' },
      { id = 'c_poke_greatball' },
      { id = 'c_poke_ultraball' },
      { id = 'c_poke_masterball' },
      { id = 'v_blank' },
      { id = 'v_antimatter' },
      { id = 'p_buffoon_normal_1', ids = { 'p_buffoon_normal_1', 'p_buffoon_normal_2', 'p_buffoon_jumbo_1', 'p_buffoon_mega_1', } },
    },
    banned_tags = {
      { id = 'tag_rare' },
      { id = 'tag_uncommon' },
      { id = 'tag_holo' },
      { id = 'tag_polychrome' },
      { id = 'tag_negative' },
      { id = 'tag_foil' },
      { id = 'tag_buffoon' },
      { id = 'tag_top_up' },
      { id = 'tag_poke_shiny_tag' },
      { id = 'tag_poke_stage_one_tag' },
      { id = 'tag_poke_safari_tag' },
      { id = 'tag_poke_starter_tag' },
    },
    banned_other = {
      { id = 'bl_final_heart', type = 'blind' },
      { id = 'bl_final_leaf', type = 'blind' },
      { id = 'bl_final_acorn', type = 'blind' },
    }
  },
}

return {
  name = "Agarmons Lunadon Challenge",
  enabled = agarmons_config.cosmog and agarmons_config.groudon or false,
  list = { lunadon }
}
