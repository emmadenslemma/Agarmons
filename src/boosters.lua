local subdir = "src/boosters/"
local files = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)

for _, file in ipairs(files) do
  local booster = assert(SMODS.load_file(subdir .. file))()

  if booster.enabled then
    if booster.list and #booster.list > 0 then
      for _, item in ipairs(booster.list) do
        SMODS.Booster(item)
      end
    end
  end
end
