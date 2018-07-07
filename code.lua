-- This file is loaded from "Waylay Arena Unit Frames.toc"


-- Arena 1, 2, 3
local U=UnitIsUnit hooksecurefunc("CompactUnitFrame_UpdateName",function(F)if IsActiveBattlefieldArena()and F.unit:find("nameplate")then for i=1,5 do if U(F.unit,"arena"..i)then F.name:SetText(i)F.name:SetTextColor(1,1,0)break end end end end)

-- Rescale Friendly and Enemy unit frames
-- local f=CreateFrame("Frame") f:RegisterEvent("NAME_PLATE_UNIT_ADDED") f:SetScript("OnEvent", function(self, event, unit) if UnitIsFriend("player", unit) then C_NamePlate.SetNamePlateFriendlySize(80,100) C_NamePlate.GetNamePlateForUnit(unit).UnitFrame:SetScale(0.8) else C_NamePlate.SetNamePlateEnemySize(130,100) C_NamePlate.GetNamePlateForUnit(unit).UnitFrame:SetScale(1.3) end end)


-- Remove Realm from NamePlates
-- unit_name:match("[^-]+") - To hide the Realm Name only
hooksecurefunc("CompactUnitFrame_UpdateName",function(frame)
	if frame and not frame:IsForbidden() then
		local frame_name = frame:GetName()
		if frame_name and frame_name:match("^NamePlate%d") and frame.unit and frame.name then
			local unit_name = GetUnitName(frame.unit,true)
			if unit_name then
				frame.name:SetText()
			end
		end
	end
end)


-- Darken Interface
local frame=CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(self, event, addon)
    if (addon == "Blizzard_TimeManager") then
        for i, v in pairs({PlayerFrameTexture, TargetFrameTextureFrameTexture, PetFrameTexture, PartyMemberFrame1Texture, PartyMemberFrame2Texture, PartyMemberFrame3Texture, PartyMemberFrame4Texture,
            PartyMemberFrame1PetFrameTexture, PartyMemberFrame2PetFrameTexture, PartyMemberFrame3PetFrameTexture, PartyMemberFrame4PetFrameTexture, FocusFrameTextureFrameTexture,
            TargetFrameToTTextureFrameTexture, FocusFrameToTTextureFrameTexture, BonusActionBarFrameTexture0, BonusActionBarFrameTexture1, BonusActionBarFrameTexture2, BonusActionBarFrameTexture3,
            BonusActionBarFrameTexture4, MainMenuBarTexture0, MainMenuBarTexture1, MainMenuBarTexture2, MainMenuBarTexture3, MainMenuMaxLevelBar0, MainMenuMaxLevelBar1, MainMenuMaxLevelBar2,
            MainMenuMaxLevelBar3, MinimapBorder, CastingBarFrameBorder, FocusFrameSpellBarBorder, TargetFrameSpellBarBorder, MiniMapTrackingButtonBorder, MiniMapLFGFrameBorder, MiniMapBattlefieldBorder,
            MiniMapMailBorder, MinimapBorderTop,
            select(1, TimeManagerClockButton:GetRegions())
        }) do
            v:SetVertexColor(.4, .4, .4)
        end

        for i,v in pairs({ select(2, TimeManagerClockButton:GetRegions()) }) do
            v:SetVertexColor(1, 1, 1)
        end

        self:UnregisterEvent("ADDON_LOADED")
        frame:SetScript("OnEvent", nil)
    end
end)

for i, v in pairs({ MainMenuBarLeftEndCap, MainMenuBarRightEndCap }) do
    v:SetVertexColor(.35, .35, .35)
end

-- Hide PvP Icon
PlayerPVPIcon:SetAlpha(0)
TargetFrameTextureFramePVPIcon:SetAlpha(0)
FocusFrameTextureFramePVPIcon:SetAlpha(0)

-- Hide Hot Keys
for i=1, 12 do
    _G["ActionButton"..i.."HotKey"]:SetAlpha(0) -- main bar
    _G["MultiBarBottomRightButton"..i.."HotKey"]:SetAlpha(0) -- bottom right bar
    _G["MultiBarBottomLeftButton"..i.."HotKey"]:SetAlpha(0) -- bottom left bar
    _G["MultiBarRightButton"..i.."HotKey"]:SetAlpha(0) -- right bar
    _G["MultiBarLeftButton"..i.."HotKey"]:SetAlpha(0) -- left bar
end


-- Larger Cast bar
CastingBarFrame:SetScale(1.2)

-- Focus Cast Bar
FocusFrameSpellBar:ClearAllPoints()
FocusFrameSpellBar:SetPoint("CENTER", UIParent, "CENTER", 0, -140)
FocusFrameSpellBar.SetPoint = function() end
FocusFrameSpellBar:SetScale(1.0)



-- Autosell grey trash and repair
local g = CreateFrame("Frame")
g:RegisterEvent("MERCHANT_SHOW")

g:SetScript("OnEvent", function()
    local bag, slot
    for bag = 0, 4 do
        for slot = 0, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot)
            if link and (select(3, GetItemInfo(link)) == 0) then
                UseContainerItem(bag, slot)
            end
        end
    end

    if(CanMerchantRepair()) then
        local cost = GetRepairAllCost()
        if cost > 0 then
            local money = GetMoney()
            if IsInGuild() then
                local guildMoney = GetGuildBankWithdrawMoney()
                if guildMoney > GetGuildBankMoney() then
                    guildMoney = GetGuildBankMoney()
                end
                if guildMoney > cost and CanGuildBankRepair() then
                    RepairAllItems(1)
                    print(format("|cfff07100Repair cost covered by G-Bank: %.1fg|r", cost * 0.0001))
                    return
                end
            end
            if money > cost then
                RepairAllItems()
                print(format("|cffead000Repair cost: %.1fg|r", cost * 0.0001))
            else
                print("Not enough gold to cover the repair cost.")
            end
        end
    end
end)

-- Minimap
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()
Minimap:EnableMouseWheel(true)
Minimap:SetScript('OnMouseWheel', function(self, delta)
    if delta > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end)
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetPoint("TOPRIGHT", -26, 7)

-- Command to show Raid Frame while solo
SlashCmdList["RAIDFRAME"] = function() CompactRaidFrameManager:Show()CompactRaidFrameManager.container:Show() end
SLASH_RAIDFRAME1 = '/rf'
-- Command to enable keybinds
SlashCmdList["SHOWKEYS"] = function()
for i=1, 12 do
    _G["ActionButton"..i.."HotKey"]:SetAlpha(0) -- main bar
    _G["MultiBarBottomRightButton"..i.."HotKey"]:SetAlpha(1) -- bottom right bar
    _G["MultiBarBottomLeftButton"..i.."HotKey"]:SetAlpha(1) -- bottom left bar
    _G["MultiBarRightButton"..i.."HotKey"]:SetAlpha(1) -- right bar
    _G["MultiBarLeftButton"..i.."HotKey"]:SetAlpha(1) -- left bar
end
end
SLASH_SHOWKEYS1 = '/kb'
