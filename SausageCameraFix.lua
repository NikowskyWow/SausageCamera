-- ============================================================================
-- Sausage Camera Fix
-- Autor: Sausage Party / Kokotiar
-- ============================================================================

-- Lokálne premenné pre verziu (nahradí sa skriptom na githube)
local SAUSAGE_VERSION = "@SAUSAGE_VERSION@"

-- Vytvorenie hlavného okna (Main Frame)
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

-- Vnútorná sekcia (Content Box - Všeobecné nastavenia)
local contentBox = CreateFrame("Frame", nil, mainFrame)
contentBox:SetSize(360, 120)
contentBox:SetPoint("TOP", mainFrame, "TOP", 0, -50)
contentBox:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
-- Nastavenie farieb pre všeobecný box (Modrá: 0, 0.7, 1, 1)
contentBox:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
contentBox:SetBackdropBorderColor(0, 0.7, 1, 1)

-- Názov sekcie vnútri content boxu
local contentTitle = contentBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
contentTitle:SetPoint("TOPLEFT", 15, -15)
contentTitle:SetText("Camera Distance Configuration")

local contentDesc = contentBox:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
contentDesc:SetPoint("TOPLEFT", contentTitle, "BOTTOMLEFT", 0, -10)
contentDesc:SetTextColor(1, 1, 1)
contentDesc:SetText("Unlock the maximum camera distance factor\nbeyond standard Blizzard interface limits.")
contentDesc:SetJustifyH("LEFT")

-- Tlačidlo pre aplikovanie fixu
local applyButton = CreateFrame("Button", nil, contentBox, "UIPanelButtonTemplate")
applyButton:SetSize(160, 30)
applyButton:SetPoint("BOTTOMLEFT", 15, 15)
applyButton:SetText("Unlock Camera")
applyButton:SetScript("OnClick", function()
    -- Samotná logika pre odomknutie kamery (CVar manipulácia pre max zoom)
    SetCVar("cameraDistanceMax", 50)
    SetCVar("cameraDistanceMaxFactor", 4)
    print("|cffFFD700[Sausage Camera Fix]|r Camera distance unlocked! You can now zoom out further.")
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
    -- Otvára GitFrame (predpokladáme, že GitFrame logika bude dobudovaná, alebo len oznámi hráčovi)
    print("|cffFFD700[Sausage Camera Fix]|r Check our Discord for updates!")
end)

-- ============================================================================
-- SLASH COMMANDS
-- ============================================================================

SLASH_SAUSAGECAMERA1 = "/sausagecamera"
SLASH_SAUSAGECAMERA2 = "/scf"
SlashCmdList["SAUSAGECAMERA"] = function()
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        mainFrame:Show()
    end
end