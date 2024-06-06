-- Creates the Window for the Reminder to Drink Water
local frame = CreateFrame("Frame")

-- Creates the Timer and values saved and a delay alarm value
local interval = 2 * 60 * 60 -- 2 hour timer for perfect time to drink water
local postponeInterval = 30 * 60 -- 30 minutes for the delay timer
local lastReminder = 0 --Value saved for checks in loop
local firstTime = true -- Flag to track if it's the first time the reminder appears

-- Function to check if the player is in an instance
local function IsPlayerInInstance()
    local _, instanceType = IsInInstance()
    return instanceType == "raid" or instanceType == "party" or instanceType == "pvp"
end

-- Loop to check to check the elapsed time and determining whether to show a reminder or not
local function ShowWaterReminder()
    local currentTime = time()
    
    -- Check if in combat or in an instance
    if InCombatLockdown() or IsPlayerInInstance() then
        return -- Skip reminder if in combat or in an instance
    end
    
    --Checks to see if intial log in 
    if firstTime then
        StaticPopup_Show("SET_INTERVAL_POPUP") --Gives the Timer interval selection
        firstTime = false
    elseif currentTime - lastReminder >= interval then
        StaticPopup_Show("DRINK_WATER_POPUP") --Makes Window show up!
        lastReminder = currentTime
    end
end

-- Basically on log in we want the timer to start and on log out stop working
local function OnLogin()
    frame:RegisterEvent("PLAYER_LOGOUT")
    frame:SetScript("OnUpdate", ShowWaterReminder)
end

local function OnLogout()
    frame:UnregisterEvent("PLAYER_LOGOUT")
    frame:SetScript("OnUpdate", nil)
end

--The Pop up window and the buttons
StaticPopupDialogs["DRINK_WATER_POPUP"] = 
{
    text = "It's time to drink water!",
    button1 = "I got you fam!",
    button2 = "Remind Me Later",
    OnAccept = function()
        print("Thank you for drinking water!")
    end,
    OnCancel = function()
        lastReminder = time() + postponeInterval
    end,
    timeout = 0,
    hideOnEscape = true,
    preferredIndex = 100,
}
-- Set Interval for hydrating
StaticPopupDialogs["SET_INTERVAL_POPUP"] = 
{
    text = "Select your reminder interval:",
    button1 = "30 minutes",
    button2 = "1 hour",
    button3 = "1.5 hours",
    button4 = "2 hours",
    OnButton1 = function()
        interval = 30 * 60
    end,
    OnButton2 = function()
        interval = 60 * 60
    end,
    OnButton3 = function()
        interval = 90 * 60
    end,
    OnButton4 = function()
        interval = 2 * 60 * 60
    end,
    timeout = 0,
    hideOnEscape = true,
    preferredIndex = 100,
}

-- Another loop to make sure player is online
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnLogin()
    elseif event == "PLAYER_LOGOUT" then
        OnLogout()
    end
end)

--Placed at end of code to make sure initial loops are started and no weird bottlenecking to happen 
frame:RegisterEvent("PLAYER_LOGIN")