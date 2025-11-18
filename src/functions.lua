local subdir = "src/functions/"
local files = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)

for _, file in ipairs(files) do
  assert(SMODS.load_file(subdir .. file))()
end
