local subdir = "src/backs/"
local files = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)

for _, file in ipairs(files) do
  local cardback = assert(SMODS.load_file(subdir .. file))()

  if cardback.enabled then
    if cardback.init then
      cardback.init()
    end

    if cardback.list and #cardback.list > 0 then
      for _, item in ipairs(cardback.list) do
        SMODS.Back(item)
      end
    end

    if (SMODS.Mods["CardSleeves"] or {}).can_load and CardSleeves
        and cardback.sleeves and #cardback.sleeves > 0 then
      for _, sleeve in ipairs(cardback.sleeves) do
        CardSleeves.Sleeve(sleeve)
      end
    end
  end
end
