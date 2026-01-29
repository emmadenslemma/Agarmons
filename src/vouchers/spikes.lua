local spikes = {
  key = 'spikes',
  pos = { x = 2, y = 0 },
  atlas = "AgarmonsVouchers",
  config = { extra = { hazard_level = 1 } },
  loc_txt = {
    name = "Spikes",
    text = {
      "{C:hazard}+#1#{} hazard layer and limit"
    }
  },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.hazard_level } }
  end,
  redeem = function(self, card)
    poke_change_hazard_max(card.ability.extra.hazard_level)
    poke_change_hazard_level(card.ability.extra.hazard_level)
  end,
  in_pool = function(self)
    return (G.GAME.round_resets.hazard_level or 0) > 0
  end
}

local srocks = {
  key = 'srocks',
  pos = { x = 3, y = 0 },
  atlas = "AgarmonsVouchers",
  requires = { 'v_agar_spikes' },
  loc_txt = {
    name = "Stealth Rocks",
    text = {
      "{C:dark_edition}???"
    }
  },
}

return {
  can_load = false,
  list = { spikes, srocks }
}
