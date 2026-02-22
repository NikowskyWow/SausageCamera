-- ============================================================================
-- Sausage Camera Fix
-- Autor: Sausage Party / Kokotiar
-- ============================================================================

-- Lokálne premenné pre verziu (nahradí sa skriptom na githube)
local SAUSAGE_VERSION = "@SAUSAGE_VERSION@"

-- ============================================================================
-- HLAVNÝ RÁM (Main Frame)
-- ============================================================================
local mainFrame = CreateFrame("Frame", "SausageCameraFixMainFrame", UIParent)
mainFrame:SetSize(400, 250)
mainFrame:SetPoint("CENTER")
mainFrame:SetMovable(true)
mainFrame:EnableMouse(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)
mainFrame:Hide() -- Predvolene skryté

-- Pridanie do UISpecialFrames pre zatváranie pomocou ESC
tinsert(UISpecialFrames, "SausageCameraFixMainFrame")

-- Nastavenie Blizzard Native Backdrop
mainFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})

-- Zatváracie tlačidlo (pravý horný roh)
local closeButton = CreateFrame("Button", nil, mainFrame, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", -5, -5)

-- Hlavička (Header)
local headerTexture = mainFrame:CreateTexture(nil, "ARTWORK")
headerTexture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
headerTexture:SetWidth(256)
headerTexture:SetHeight(64)
headerTexture:SetPoint("TOP", mainFrame, "TOP", 0, 12)

local headerText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
headerText:SetPoint("TOP", headerTexture, "TOP", 0, -14)
headerText:SetText("Sausage Camera Fix")

-- ============================================================================
-- VNÚTORNÁ SEKCIA (Content Box - Vycentrovaná)
-- ============================================================================
local contentBox = CreateFrame("Frame", nil, mainFrame)
contentBox:SetSize(360, 120)
-- Vycentrovanie voči hlavnému oknu s miernym posunom hore, aby bolo miesto pre pätku
contentBox:SetPoint("CENTER", mainFrame, "CENTER", 0, 15) 
contentBox:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
-- Nastavenie farieb pre všeobecný box (Modrá: 0, 0.7, 1, 1)
contentBox:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
contentBox:SetBackdropBorderColor(0, 0.7, 1, 1)

-- Názov sekcie vycentrovaný na vrch boxu
local contentTitle = contentBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
contentTitle:SetPoint("TOP", 0, -15)
contentTitle:SetText("Camera Distance Configuration")
contentTitle:SetJustifyH("CENTER")

-- Popis vycentrovaný priamo pod názvom
local contentDesc = contentBox:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
contentDesc:SetPoint("TOP", contentTitle, "BOTTOM", 0, -10)
contentDesc:SetTextColor(1, 1, 1)
contentDesc:SetText("Unlock the maximum camera distance factor\nbeyond standard Blizzard interface limits.")
contentDesc:SetJustifyH("CENTER")

-- Tlačidlo vycentrované na spodok boxu
local applyButton = CreateFrame("Button", nil, contentBox, "UIPanelButtonTemplate")
applyButton:SetSize(160, 30)
applyButton:SetPoint("BOTTOM", 0, 15)
applyButton:SetText("Unlock Camera")
applyButton:SetScript("OnClick", function()
    -- Samotná logika pre odomknutie kamery (CVar manipulácia pre max zoom)
    SetCVar("cameraDistanceMax", 50)
    SetCVar("cameraDistanceMaxFactor", 4)
    print("|cffFFD700[Sausage Camera Fix]|r Camera distance unlocked! You can now zoom out further.")
end)

-- ============================================================================
-- GIT FRAME (Update / Discord Link)
-- ============================================================================
-- Vytvorenie hlavného vyskakovacieho okna
local GitFrame = CreateFrame("Frame", "SausageCameraFixGitFrame", UIParent)
GitFrame:SetSize(320, 130)
GitFrame:SetPoint("CENTER")
GitFrame:SetFrameStrata("DIALOG") -- Zaistí, že okno bude vždy úplne navrchu
GitFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
tinsert(UISpecialFrames, "SausageCameraFixGitFrame") -- Umožní zatváranie okna pomocou ESC
GitFrame:Hide()

-- Hlavička a texty pre GitFrame
local gitHeader = GitFrame:CreateTexture(nil, "OVERLAY")
gitHeader:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
gitHeader:SetSize(250, 64)
gitHeader:SetPoint("TOP", 0, 12)

local gitTitle = GitFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
gitTitle:SetPoint("TOP", gitHeader, "TOP", 0, -14)
gitTitle:SetText("UPDATE LINK")

local gitClose = CreateFrame("Button", nil, GitFrame, "UIPanelCloseButton")
gitClose:SetPoint("TOPRIGHT", -8, -8)

local gitDesc = GitFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
gitDesc:SetPoint("TOP", 0, -35)
gitDesc:SetText("Press Ctrl+C to copy the Discord link:")

-- EditBox s odkazom
local gitEditBox = CreateFrame("EditBox", nil, GitFrame, "InputBoxTemplate")
gitEditBox:SetSize(260, 20)
gitEditBox:SetPoint("TOP", gitDesc, "BOTTOM", 0, -15)
gitEditBox:SetAutoFocus(true)

local DISCORD_LINK = "https://discord.com/invite/UMbcfhurew"

-- Kúzlo: Nezničiteľný text skript
gitEditBox:SetScript("OnTextChanged", function(self)
    -- Ak sa text nezhoduje s naším odkazom (niekto niečo zmazal/napísal)
    if self:GetText() ~= DISCORD_LINK then
        self:SetText(DISCORD_LINK) -- Okamžite ho vráť späť
        self:HighlightText()       -- A znovu ho celý vysvieť pre Ctrl+C
    end
end)

gitEditBox:SetScript("OnEscapePressed", function(self)
    self:ClearFocus()
    GitFrame:Hide()
end)

GitFrame:SetScript("OnShow", function()
    gitEditBox:SetText(DISCORD_LINK)
    gitEditBox:SetFocus()
    gitEditBox:HighlightText()
end)

-- ============================================================================
-- FOOTER (Branding & Updates)
-- ============================================================================

-- Verzia (vľavo dole)
local versionText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
versionText:SetPoint("BOTTOMLEFT", mainFrame, "BOTTOMLEFT", 20, 15)
versionText:SetText("v " .. SAUSAGE_VERSION)

-- Credits (stred)
local creditsText = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
creditsText:SetPoint("BOTTOM", mainFrame, "BOTTOM", 0, 15)
creditsText:SetText("by Sausage Party")

-- Tlačidlo Check Updates (vpravo dole)
local updateButton = CreateFrame("Button", nil, mainFrame, "UIPanelButtonTemplate")
updateButton:SetSize(110, 25)
updateButton:SetPoint("BOTTOMRIGHT", mainFrame, "BOTTOMRIGHT", -15, 12)
updateButton:SetText("Check Updates")
updateButton:SetScript("OnClick", function()
    GitFrame:Show() -- Zobrazenie nášho Git okna
end)

-- ============================================================================
-- SLASH COMMANDS
-- ============================================================================

-- Iba jeden povolený command podľa zadania
SLASH_SAUSAGECAMERA1 = "/sausagecamera"
SlashCmdList["SAUSAGECAMERA"] = function()
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        mainFrame:Show()
    end
end