-- Use the client's built-in logger; no combat data is read by this addon.
local frame = CreateFrame("Frame")

local function UpdateLogging()
    local inside, instanceType = IsInInstance()
    local inDungeonOrRaid = inside and (instanceType == "party" or instanceType == "raid")

    if inDungeonOrRaid then
        if not LoggingCombat() then
            LoggingCombat(true)
            if LoggingCombat() then
                print("|cff00ff00Auto Instance Combat Log:|r Combat logging enabled.")
            else
                print("|cffff0000Auto Instance Combat Log:|r Could not enable combat logging. Try /combatlog manually.")
            end
        end
    elseif not UnitIsDeadOrGhost("player") then
        -- A ghost outside the entrance is still on a corpse run: leave logging alone.
        -- On resurrection, recheck location before deciding whether to stop.
        if LoggingCombat() then
            LoggingCombat(false)
            if not LoggingCombat() then
                print("|cffffff00Auto Instance Combat Log:|r Combat logging disabled (alive outside a dungeon or raid).")
            else
                print("|cffff0000Auto Instance Combat Log:|r Could not disable combat logging. Try /combatlog manually.")
            end
        end
    end
end

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_ALIVE")
frame:RegisterEvent("PLAYER_UNGHOST")
frame:SetScript("OnEvent", UpdateLogging)
