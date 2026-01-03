-- Beta Arceus 493?
local beta_arceus = {
  name = "beta_arceus",
  pos = { x = 8, y = 0 },
  soul_pos = { x = 9, y = 0 },
  config = { extra = { Emult = 1.1 } },
  loc_txt = {
    name = "Arceus?",
    text = {
      "{C:white,X:dark_edition}^#1#{} Mult",
    }
  },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    return { vars = { card.ability.extra.Emult } }
  end,
  rarity = 4,
  cost = 20,
  stage = "Legendary",
  ptype = "Colorless",
  gen = 4,
  atlas = "AgarmonsJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        message = localize { type = 'variable', key = 'agar_a_powmult', vars = { card.ability.extra.Emult } },
        colour = G.C.DARK_EDITION,
        Emult_mod = card.ability.extra.Emult,
      }
    end
  end,
}

local init = function()
  energy_values.Emult = 0.01
  -- Fallback for Emult if either Talisman or Amulet are missing.
  -- stolen from Talisman, naturally
  -- raise your hand if you think this should be a part of SMODS
  -- no? it's just me? okay .-.
  if not (SMODS.Mods["Talisman"] or {}).can_load and not (SMODS.Mods["Amulet"] or {}).can_load then
    SMODS.Scoring_Parameter({
      key = 'emult',
      default_value = 0,
      juice_on_update = true,
      colour = G.C.DARK_EDITION,
      calculation_keys = { 'e_mult', 'emult', 'Emult_mod' },
      calc_effect = function(self, effect, scored_card, key, amount, from_edition)
        if (key == 'e_mult' or key == 'emult' or key == 'Emult_mod') and amount ~= 1 then
          if effect.card then juice_card(effect.card) end
          if SMODS.Scoring_Parameters then
            local mult = SMODS.Scoring_Parameters["mult"]
            mult:modify(mult.current ^ amount - mult.current)
          else
            mult = mod_mult(mult ^ amount)
            update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
          end
          if not effect.remove_default_message then
            if from_edition then
              card_eval_status_text(scored_card, 'jokers', nil, percent, nil,
                { message = "^" .. amount .. " " .. localize("k_mult"), colour = G.C.EDITION, edition = true })
            elseif key ~= 'Emult_mod' then
              if effect.emult_message then
                card_eval_status_text(
                  effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil,
                  percent, nil, effect.emult_message)
              else
                card_eval_status_text(
                  effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'e_mult',
                  amount, percent)
              end
            end
          end
          return true
        end
      end,
      modify = function(self, amount, skip)
        if not skip then mult = mod_mult(self.current + amount) end
        self.current = (mult or 0) + (skip or 0)
        update_hand_text({ delay = 0 }, { mult = self.current })
      end
    })
  end
end

return {
  can_load = pokermon_config.pokemon_aprilfools,
  init = init,
  list = { beta_arceus },
}
