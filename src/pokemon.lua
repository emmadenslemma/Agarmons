local subdir = "src/pokemon/"

local function load_pokemon(item)
  if item.rarity == "agar_gmax" then
    AG.gmax.preload(item)
  end

  local custom_prefix = item.agar_inject_prefix or "agar"

  local custom_atlas = item.atlas and string.find(item.atlas, "Agarmons")

  if not item.atlas then
    poke_load_atlas(item)
    poke_load_sprites(item)
  end

  pokermon.Pokemon(item, custom_prefix, custom_atlas)
end

local load_pokemon_ref = pokermon.load_pokemon
function pokermon.load_pokemon(item)
  if item.agar_inject_prefix then
    item.key = item.agar_inject_prefix .. '_' .. item.name
    item.prefix_config = item.prefix_config or {}
    item.prefix_config.key = { mod = false }
  end
  return load_pokemon_ref(item)
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
            family[#family+1] = item.name
            load_pokemon(item)
          end
        end

        pokermon.dex_order_groups[#pokermon.dex_order_groups+1] = family

        if poke.family then
          if #poke.family > 1 then
            pokermon.add_family(poke.family)
          end
        elseif #family > 1 then
          pokermon.add_family(family)
        end
      end
    end
  end
end

load_pokemon_folder(subdir)
load_pokemon_folder(subdir .. 'regional/')
load_pokemon_folder(subdir .. 'gmax/')
load_pokemon_folder(subdir .. 'mega/')
