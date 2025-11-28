local function load_file(file, load_item)
  if file.init then
    file.init()
  end
  if file.list then
    for _, item in ipairs(file.list) do
      if file.config_key then
        item.agar_config_key = file.config_key
        -- if not agarmons_config[item.agar_config_key] then
        --   item.no_collection = true
        -- end
      end
      load_item(item)
    end
  end
end

local function load_directory(path, load_item, options)
  options = options or {}
  local files = NFS.getDirectoryItems(SMODS.current_mod.path .. path)

  for _, file_path in ipairs(files) do
    local file_type = NFS.getInfo(SMODS.current_mod.path .. path .. '/' .. file_path).type

    if file_type == "directory" then
      load_directory(path .. '/' .. file_path, load_item, options)
    elseif file_type ~= "symlink" then
      local file = assert(SMODS.load_file(path .. '/' .. file_path))()

      if type(file) == 'table' and file.can_load ~= false then
        if options.pre_load then options.pre_load(file) end
        load_file(file, load_item)
        if options.post_load then options.post_load(file) end
      end
    end
  end
end

local function load_sleeves(file)
  if (SMODS.Mods['CardSleeves'] or {}).can_load and CardSleeves
      and file.sleeves and #file.sleeves > 0 then
    for _, sleeve in ipairs(file.sleeves) do
      CardSleeves.Sleeve(sleeve)
    end
  end
end

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

local function load_pokemon_family(file)
  local names = AG.list_utils.map(file.list, function(a) return a.name end)
  pokermon.dex_order_groups[#pokermon.dex_order_groups+1] = names
  if file.family and #file.family > 1 then
    pokermon.add_family(file.family)
  elseif #names > 1 then
    pokermon.add_family(names)
  end
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

return load_directory, {
  load_sleeves = load_sleeves,
  load_pokemon = load_pokemon,
  load_pokemon_family = load_pokemon_family,
}
