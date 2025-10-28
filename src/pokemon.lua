local subdir = "src/pokemon/"

local nachos_loaded = (SMODS.Mods["NachosPokermonDip"] or {}).can_load and PkmnDip and PkmnDip.dex_order_groups

local function load_pokemon(item)
  if item.rarity == "agar_gmax" then
    AGAR.GMAX.preload(item)
  end

  local custom_atlas = item.atlas and string.find(item.atlas, "Agarmons")

  if not item.atlas then
    poke_load_atlas(item)
    poke_load_sprites(item)
  end

  pokermon.Pokemon(item, "agar", custom_atlas)
end

local function load_pokemon_folder(folder)
  local files = NFS.getDirectoryItems(SMODS.current_mod.path .. folder)

  for _, filename in ipairs(files) do
    local file_path = SMODS.current_mod.path .. folder .. filename
    local file_type = NFS.getInfo(file_path).type

    if file_type ~= "directory" and file_type ~= "symlink" then
      local poke = assert(SMODS.load_file(folder .. filename))()

      if poke.enabled then
        if poke.init then
          poke:init()
        end

        local family = {}

        if poke.list and #poke.list > 0 then
          for _, item in ipairs(poke.list) do
            family[#family + 1] = item.name
            load_pokemon(item)
          end
        end

        if nachos_loaded then
          -- Remove this when Nacho adds GMAX Butterfree to his list
          if family[1] ~= 'gmax_butterfree' then
            PkmnDip.dex_order_groups[#PkmnDip.dex_order_groups + 1] = family
          end
        end

        if #family > 1 then
          pokermon.add_family(family)
        end
      end
    end
  end
end

load_pokemon_folder(subdir)
load_pokemon_folder(subdir .. 'gmax/')
