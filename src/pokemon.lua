local subdir = "src/pokemon/"
local files = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)

for _, file in ipairs(files) do
  local poke = assert(SMODS.load_file(subdir .. file))()

  if poke.enabled then
    if poke.init then
      poke:init()
    end

    if poke.list and #poke.list > 0 then
      for _, item in ipairs(poke.list) do
        if item.rarity == "agar_gmax" then
          GMAX.preload(item)
        end

        local custom_atlas = item.atlas and string.find(item.atlas, "agar")

        if not custom_atlas then
          poke_load_atlas(item)
          poke_load_sprites(item)
        end

        pokermon.Pokemon(item, "agar", custom_atlas)
      end
    end
  end
end
