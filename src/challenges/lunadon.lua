local lunas, dons

local function setup_lunadon()
  lunas = {}
  dons = {}

  for key, center in pairs(G.P_CENTERS) do
    if center.name:find('luna') and not center.name:find('don') then
      lunas[#lunas+1] = key
    end
    if center.name:find('don') and not center.name:find('luna') then
      dons[#dons+1] = key
    end
  end
end

AG.hookafterfunc(SMODS.current_mod, 'reset_game_globals', function(run_start)
  if run_start and G.GAME.modifiers.lunadon then
    setup_lunadon()
  end
end, true)

local function play_lunadon_quip(quip, hold_time)
  hold_time = hold_time or 10
  attention_text({
    scale = 0.8,
    text = localize("agar_lunadon_" .. quip),
    hold = hold_time,
    align = 'cm',
    offset = { x = 0, y = -2.7 },
    major = G.play
  })
end

AG.hookafterfunc(SMODS.current_mod, 'calculate', function(self, context)
  if G.GAME.modifiers.lunadon then
    if context.setting_blind and G.GAME.round == 1 then
      play_sound("tarot1")
      play_lunadon_quip("start")
    end
    if context.end_of_round and not context.repetition and not context.individual
        and G.GAME.blind.boss and not context.game_over then
      local prev_luna
      local prev_don
      -- Scrap em both
      for _, card in pairs(G.jokers.cards) do
        local is_luna = AG.list_utils.elem(lunas, card.config.center.key)
        if is_luna then
          prev_luna = prev_luna or card.config.center.key
        else
          prev_don = prev_don or card.config.center.key
        end

        AG.delay(0.2, function()
          card:remove()
        end)
      end

      if G.GAME.round_resets.ante ~= 7 then
        play_sound("tarot1")
        local quip_number = math.floor(pseudorandom(pseudoseed("lunadon")) * 6) + 1
        play_lunadon_quip(quip_number)
        -- Roll a new set of LunaDons
        local adjusted_lunas = AG.list_utils.filter(lunas, function(luna) return luna ~= prev_luna end)
        local adjusted_dons = AG.list_utils.filter(dons, function(don) return don ~= prev_don end)

        local new_luna = pseudorandom_element(adjusted_lunas, pseudoseed("luna" .. G.GAME.round_resets.ante))
        local new_don = pseudorandom_element(adjusted_dons, pseudoseed("don" .. G.GAME.round_resets.ante))

        AG.delay(1.2, function()
          play_sound("timpani")
          SMODS.add_card { set = "Joker", key = new_luna, stickers = { 'eternal' } }
          SMODS.add_card { set = "Joker", key = new_don, stickers = { 'eternal' } }
        end)
      else
        -- We're at the endgame: Bring out LunaLunaDonDon
        play_sound("tarot1")
        play_lunadon_quip('end_1', 2.4)

        G.jokers.config.card_limit = G.jokers.config.card_limit + 2

        luna1 = pseudorandom_element(lunas, pseudoseed("luna1" .. G.GAME.round_resets.ante))
        don1 = pseudorandom_element(dons, pseudoseed("don1" .. G.GAME.round_resets.ante))

        local second_luna_pool = AG.list_utils.filter(lunas, function(luna) return luna ~= luna1 end)
        local second_don_pool = AG.list_utils.filter(dons, function(don) return don ~= don1 end)

        luna2 = pseudorandom_element(second_luna_pool, pseudoseed("luna2" .. G.GAME.round_resets.ante))
        don2 = pseudorandom_element(second_don_pool, pseudoseed("don2" .. G.GAME.round_resets.ante))

        AG.delay(2.4, function()
          play_sound("timpani")
          play_lunadon_quip('end_2')

          SMODS.add_card { set = "Joker", key = luna1, stickers = { 'eternal' } }
          SMODS.add_card { set = "Joker", key = luna2, stickers = { 'eternal' } }
          SMODS.add_card { set = "Joker", key = don1, stickers = { 'eternal' } }
          SMODS.add_card { set = "Joker", key = don2, stickers = { 'eternal' } }
        end)
      end
    end
  end
end, true)

local lunadon = {
  object_type = "Challenge",
  key = "lunadon",
  rules = {
    custom = {
      { id = "lunadon" },
      { id = "no_shop_jokers" },
      { id = "agar_ignore_settings" }
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
  list = { lunadon }
}
