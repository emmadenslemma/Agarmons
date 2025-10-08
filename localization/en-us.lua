return {
    descriptions = {
        Joker = {
            j_agar_nebby = {
                name = '"Nebby"',
                text = {
                    "Applies {C:attention}Splash",
                    "{C:inactive,s:0.8}(Evolves after {C:attention,s:0.8}#1#{C:inactive,s:0.8} rounds)",
                }
            },
            j_agar_nebby_cosmoem = {
                name = "..Nebby?",
                text = {
                    "{C:inactive}Evolves when deck is",
                    "{C:attention}>50% {C:hearts}#1#{C:inactive} or {C:clubs}#2#",
                }
            },
            j_agar_nebby_solgaleo = {
                name = "Nebby",
                text = {
                    "If first played hand is all {C:hearts}#1#{},",
                    "turn 3 cards held in hand to {C:hearts}#1#{}",
                    "{C:inactive,s:0.8}if deck is {C:attention,s:0.8}50% {C:hearts,s:0.8}#1#",
                    "{V:1}Played {V:2}#2#{V:1} cards give {C:white,B:3}X#3#{V:1} Mult when scored",
                    "{C:inactive,s:0.8}if deck is {C:attention,s:0.8}100% {C:hearts,s:0.8}#1#",
                    "{V:4}Disables effect of every {V:5}Boss Blind",
                }
            },
            j_agar_nebby_lunala = {
                name = "Nebby",
                text = {
                    "If first played hand is all {C:clubs}#1#{},",
                    "turn 3 cards held in hand to {C:clubs}#1#{}",
                    "{C:inactive,s:0.8}if deck is {C:attention,s:0.8}50% {C:clubs,s:0.8}#1#",
                    "{V:1}Each {V:2}#2#{V:1} Card held in hand gives {C:white,B:3}X#3#{V:1} Mult",
                    "{C:inactive,s:0.8}if deck is {C:attention,s:0.8}100% {C:clubs,s:0.8}#1#",
                    "{V:4}+#4# Foresight",
                    "{V:5}Foreseen{V:6} cards trigger held",
                    "{V:6}in hand effects",
                }
            },
        },
        Spectral = {
            c_agar_dynamaxband_targeting = {
                name = "Dynamax Band",
                text = {
                    "{C:attention}Reusable{}",
                    "{br:2}ERROR - CONTACT STEAK",
                    "{C:attention}Dynamaxes{} a Pokemon",
                    "for the next {C:attention}3{} hands",
                    "{br:2}ERROR - CONTACT STEAK",
                    "Currently targeting {C:enhanced}#1#{}",
                    "Use again to stop targeting",
                    "{C:inactive}(Usable once per round)",
                },
            },
            c_agar_redorb_active = {
                name = "Red Orb",
                text = {
                    "Returns {C:attention}Primal Groudon{}",
                    "to its base form",
                    "{br:2}ERROR - CONTACT STEAK",
                    "Also happens if sold",
                    "{C:inactive}(Useable once per round)",
                },
            },
            c_agar_blueorb_active = {
                name = "Blue Orb",
                text = {
                    "Returns {C:attention}Primal Kyogre{} to",
                    "to its base form",
                    "{br:2}ERROR - CONTACT STEAK",
                    "Also happens if sold",
                    "{C:inactive}(Useable once per round)",
                },
            },
        },
        Other = {
            gmax_poke = {
                name = "Gigantamax Factor",
                text = {
                    "Can {C:attention}Gigantamax{} with", "a {C:attention}Dynamax Band{}"
                }
            },
        },
    },
    misc = {
        challenge_names = {
            c_agar_lunadon = "LunaDon",
            c_agar_nebby = "Nebby's Journey"
        },
        dictionary = {
            -- Rarities
            k_agar_primal = "Primal",
            k_agar_gmax = "G-Max",

            -- Joker/Item popups
            agar_ice_ball_ex = "Ice Ball!",
            agar_avalanche_ex = "Avalanche!",
            agar_outrage_ex = "Outrage!",
            agar_desolate_land_ex = "Desolate Land!",
            agar_primordial_sea_ex = "Primordial Sea!",
            agar_water_bubble_ex = "Water Bubble!",
            agar_shore_up_ex = "Shore Up!",
            agar_innards_out_ex = "Innards Out!",
            agar_dynamax_ex = "Dynamax!",
            agar_geomancy_charging = "Absorbing...",
            agar_geomancy_ex = "Geomancy!",

            cards_singular = "card",
            cards_plural = "cards",

            agar_turns_left_plural = "hands left",
            agar_turns_left_singular = "hand left",

            -- G-Max Messages
            agar_gmax_wildfire_ex = "G-Max Wildfire!",
            agar_gmax_befuddle_ex = "G-Max Befuddle!",
            agar_gmax_volt_crash_ex = "G-Max Volt Crash!",
            agar_gmax_gold_rush_ex = "G-Max Gold Rush!",
            agar_gmax_chi_strike_ex = "G-Max Chi Strike!",
            agar_gmax_cuddle_ex = "G-Max Cuddle!",
            agar_gmax_meltdown_ex = "G-Max Meltdown!",

            -- LunaDon Challenge Messages
            agar_lunadon_start = "Let's look at the classic: LunaDon",
            agar_lunadon_1 = "Let's instead try a LunaDon core",
            agar_lunadon_2 = "What if, instead of LunaDon, we run LunaDon",
            agar_lunadon_3 = "Introducing LunaDon",
            agar_lunadon_4 = "I think we should run the LunaDon core",
            agar_lunadon_5 = "You know what core could work really well? LunaDon!",
            agar_lunadon_6 = "What if we ran something else instead? Introducing the LunaDon core",
            agar_lunadon_end_1 = "Guys I've figured it out!",
            agar_lunadon_end_2 = "This is my LunaLunaDonDon team",

            -- Settings
            agar_enable_torkoal = "Enable Torkoal",
            agar_enable_spheal = "Enable Spheal Line",
            agar_enable_bagon = "Enable Bagon Line",
            agar_enable_sandygast = "Enable Sandygast Line",
            agar_enable_dewpider = "Enable Dewpider Line",
            agar_enable_pyukumuku = "Enable Pyukumuku",
            agar_enable_hatenna = "Enable Hatenna Line",
            agar_enable_frigibax = "Enable Frigibax Line",
            agar_enable_kyogre = "Enable Kyogre",
            agar_enable_groudon = "Enable Groudon",
            agar_enable_rayquaza = "Enable Rayquaza",
            agar_enable_cosmog = "Enable Cosmog",
            agar_enable_gmax = "Enable Gigantamax [BETA]",
        },
        v_text = {
            ch_c_lunadon = { "Introducing LunaDon, Lunala and Groudon" },
            ch_c_nebby = { "Nebby must survive" },
        },
        v_dictionary = {
            a_discards = "+#1# Discards", -- Why isn't this in the base game ;_;

            agar_x_turns_left_plural_ex = "#1# hands left!",
            agar_x_turns_left_singular_ex = "#1# turn left!",
        },
    },
}
