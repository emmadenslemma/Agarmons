local to_number = to_number or function(a) return a end

-- Mega Glalie 478-1
local mega_glalie = {
  name = "mega_glalie",
  agar_inject_prefix = "poke",
  config = { extra = { debt = 30, Xmult_mod = 0.2, volatile = 'right' } },
  loc_vars = function(self, info_queue, card)
    type_tooltip(self, info_queue, card)
    local current_Xmult = self:get_current_Xmult(card)
    return { vars = { card.ability.extra.debt, card.ability.extra.Xmult_mod, current_Xmult } }
  end,
  rarity = "poke_mega",
  cost = 12,
  stage = "Mega",
  ptype = "Water",
  gen = 3,
  volatile = true,
  blueprint_compat = true,
  get_current_Xmult = function(self, card)
    local money = to_number(G.GAME.dollars or 0)
    return math.max(1, 1 + card.ability.extra.Xmult_mod * (-money))
  end,
  calculate = function(self, card, context)
    if context.joker_main and volatile_active(self, card, card.ability.extra.volatile) then
      if not context.blueprint then
        AG.defer(function()
          card.ability.fainted = G.GAME.round
          card:set_debuff()
        end)
      end

      return {
        message = localize("poke_explosion_ex"),
        colour = G.C.XMULT,
        Xmult_mod = self:get_current_Xmult(card),
        func = function()
          local money = to_number(G.GAME.dollars)
          if not context.blueprint and money ~= 0 then
            ease_poke_dollars(card, nil, -money)
          end
        end
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.bankrupt_at = G.GAME.bankrupt_at - card.ability.extra.debt
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.bankrupt_at = G.GAME.bankrupt_at + card.ability.extra.debt
  end,
}

local function init()
  poke_add_to_family("glalie", "mega_glalie")
  SMODS.Joker:take_ownership("poke_glalie", { megas = { "mega_glalie" } }, true)
end

return {
  can_load = agarmons_config.new_megas,
  init = init,
  list = { mega_glalie }
}
