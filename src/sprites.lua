SMODS.Atlas({
    key = "AgarmonsJokers",
    path = "jokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "shiny_AgarmonsJokers",
    path = "shiny_jokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "AgarmonsConsumables",
    path = "consumables.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "AgarmonsBacks",
    path = "backs.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "AgarmonsSleeves",
    path = "sleeves.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "modicon",
    path = "icon.png",
    px = 32,
    py = 32
})

SMODS.Atlas({
    key = "gmax_clouds",
    path = "gmax_clouds.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "AgarmonsCommandozo",
    path = "commandozo.png",
    px = 142,
    py = 95
})

SMODS.Shader({
    key = 'fuse',
    path = 'fuse.fs'
})

SMODS.Atlas({
    key = "pikachu_hats",
    path = "pikachu_hats.png",
    px = 71,
    py = 95
})

PIKACHU_HAT_VARIANTS = 8

SMODS.DrawStep({
    key = 'pikachu_hats',
    order = 21,
    func = function(self)
        if agarmons_config.pikachus_with_hats and self.config.center.key == 'j_poke_pikachu' and self.ability.extra.wearing_hat ~= -1 then
            if self.ability.extra.wearing_hat or pseudorandom(pseudoseed('pikachu_can_hats')) < agarmons_config.pikachu_hat_rate / 100 then
                local wearing_hat = self.ability.extra.wearing_hat
                    or math.floor(pseudorandom(pseudoseed('pikachu_hats')) * PIKACHU_HAT_VARIANTS)
                self.ability.extra.wearing_hat = wearing_hat
                G.shared_pikachu_hats = G.shared_pikachu_hats or {}
                G.shared_pikachu_hats[wearing_hat] = G.shared_pikachu_hats[wearing_hat]
                    or Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["agar_pikachu_hats"],
                        { x = wearing_hat, y = 0 })

                local using_mydude_pikachu = self.children.center.atlas.key == 'poke_AtlasJokersSeriesANatdex'

                G.shared_pikachu_hats[wearing_hat].role.draw_major = self
                G.shared_pikachu_hats[wearing_hat]:draw_shader('dissolve', nil, nil, nil, self.children.center, nil, nil,
                    nil,
                    using_mydude_pikachu and (G.CARD_H / 95 * 2)) -- move the hat down 2 pixels only for MyDude's custom pikachu
            else
                self.ability.extra.wearing_hat = -1
            end
        end
    end,
})
