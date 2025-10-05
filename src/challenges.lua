local subdir = "src/challenges/"
local files = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)

for _, file in ipairs(files) do
  local challenge = assert(SMODS.load_file(subdir .. file))()

  if challenge.enabled then
    if challenge.list and #challenge.list > 0 then
      for _, item in ipairs(challenge.list) do
        item.button_colour = HEX("F792BC")
        SMODS.Challenge(item)
      end
    end
  end
end
