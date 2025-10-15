-- This is just the Load Pokemon file but tweaked a bit
local poke_templates = {}

local function load_template(item)
  if item.rarity == "agar_gmax" then
    AGAR.GMAX.preload(item)
  end

  local custom_atlas = item.atlas and string.find(item.atlas, "Agarmons")

  if not item.atlas then
    poke_load_atlas(item)
    poke_load_sprites(item)
  end

  item.atlas = (custom_atlas and "agar_" or "poke_") .. item.atlas
  item.set = 'Joker'
  item.key = 'j_agar_' .. item.name
  item.ability = item.config

  poke_templates[item.key] = item
end

local function load_pokemon_folder(folder)
  local files = NFS.getDirectoryItems(SMODS.current_mod.path .. folder)

  for _, filename in ipairs(files) do
    local file_path = SMODS.current_mod.path .. folder .. filename
    local file_type = NFS.getInfo(file_path).type

    if file_type ~= "directory" and file_type ~= "symlink" then
      local poke = assert(SMODS.load_file(folder .. filename))()

      if poke.list and #poke.list > 0 then
        for _, item in ipairs(poke.list) do
            load_template(item)
        end
      end
    end
  end
end

load_pokemon_folder("src/pokemon/")
load_pokemon_folder("src/pokemon/gmax/")

return poke_templates
