local subdir = "src/pokemon/"

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

        if poke.list and #poke.list > 0 then
          for _, item in ipairs(poke.list) do
            if item.rarity == "agar_gmax" then
              AGAR.GMAX.preload(item)
            end

            local custom_atlas = item.atlas and string.find(item.atlas, "Agarmons")

            if not custom_atlas then
              poke_load_atlas(item)
              poke_load_sprites(item)
            end

            pokermon.Pokemon(item, "agar", custom_atlas)
          end
        end
      end
    end
  end
end

load_pokemon_folder(subdir)
load_pokemon_folder(subdir .. 'gmax/')
