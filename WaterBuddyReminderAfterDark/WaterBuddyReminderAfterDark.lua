-- Creates the Window for the Reminder to Drink Water
local frame = CreateFrame("Frame")

-- Creates the Timer and values saved and a delay alarm value
local interval = 2 * 60 * 60 -- 2-hour timer for perfect time to drink water
local postponeInterval = 30 * 60 -- 30 minutes for the delay timer
local lastReminder = 0 -- Value saved for checks in loop
local firstTime = true -- Flag to track if it's the first time the reminder appears

-- List of random phrases for the reminder and making them into a stored list
local phrases = 
{
    "It's time to drink you dehydrated raisen!",
    "Your body is drier then the Tanaris desert.",
    "You might disappoint your parents but not your body drinking water right now!",
    "No one is thirsty for you but your body is. So drink the dang water!",
    "Trust me only thing getting wet with you is your mouth after you drink this water!",
    "The Water elemental winks at you in the corner and points to itself.. Its chugging time",
    "That's right drink some Earth sauce.",
    "You may be fake af online but not a fake plant you still need water!",
    "There's more water found on Mars than you drank today.",
    "The only MoP you should be playing is mopping this water in your body!",
    "Your hydration routine is looking worse then a trogs.",
    "Hurry! Drink water now to keep up the water parse!",
    "Behold the power of pure water!", 
    "A turtle made it to the water and so can you!",
    "It's easier to stand in fire if you hydrate first!",
    "No one likes a dry sense of humor and personality but at least you can be hydrated.",
    "Mllgggrrrr?",
    "Water you doing here? Go drink something!",
    "By the Light! Don’t forget to drink your water!",
    "Drinking water is the real Batlle Elixer",
    "Even warriors need water breaks.",
    "You’re so dehydrated, even your shadow needs a drink.",
    "Do you even know what water tastes like anymore?",
    "I’ve seen Barrens desert cacti with more hydration than you.",
    "You’re so dehydrated, even your sweat is on strike.",
    "Your lips are so dry, they could start a fel-fire.",
    "Drink some water; your body called and said it’s in drought mode.",
    "You’re so dehydrated, your body is filing a formal complaint.",
    "Your skin is so dry, sandpaper is jealous.", 
    "You’re so dehydrated, your blood type is Dust to Dust.",
    "You’re so dehydrated, even your breath needs moisturizer.",
    "You're so dehydrated, even a mana potion can't save you.",
    "You're so thirsty, even water elementals is concerned.",
    "You're so dry, even the Burning Crusade would tell you to hydrate.",
    "I've seen forsaken with more hydration than you.",
    "You're so thirsty, the Molten Core are looking like a lush oasis to you.",
    "If you were any more parched, you'd turn into a Sand Fury troll.",
    "Drink some water before you get flagged for being a dry zone.",
    "You're so dehydrated, even a water totem would say 'Not enough water for that action.",
    "You're so dehydrated, even the Wetlands can't help you.",
    "Drink some water before you get classified as a Dust Devil.",
    "You're so dry, even the Sunwell seems like a swimming pool.",
    "You're so dehydrated, even Hydraxian Waterlords want to lower their rep with you.",
    "You're so thirsty, even your quest log says Drink Water.",
    "You're so dry, even the Fire Elementals would give you a pass.",
    "Even Ragnaros thinks you need to cool down.",
    "You're so dry, even the Wailing Caverns are shedding tears for you.",
    "You're so parched, even the Cenarion Circle had to call in an emergency meeting to save you!",
    "You're as dry as a bone in the Badlands.",
    "Stay hydrated; it's cheaper than your therapy.",
    "Are you auditioning for the role of a sand elemental? Drink up!",
}

-- Function to check if the player is in an instance
local function IsPlayerInInstance()
    local _, instanceType = IsInInstance()
    return instanceType == "raid" or instanceType == "party" or instanceType == "pvp"
end

-- checking the elapsed time and determining whether to show a reminder or not
local function ShowWaterReminder()
    local currentTime = time()
    
    -- Check if in combat or in an instance
    if InCombatLockdown() or IsPlayerInInstance() then
        return -- Skip reminder if in combat or in an instance
    end
    
    -- Check if it's the initial login
    if firstTime then
        StaticPopup_Show("SET_INTERVAL_POPUP")
        firstTime = false
    elseif currentTime - lastReminder >= interval then
        -- Select a random phrase
        local randomPhrase = phrases[math.random(#phrases)]
        StaticPopupDialogs["DRINK_WATER_POPUP"].text = randomPhrase
        StaticPopup_Show("DRINK_WATER_POPUP") -- Makes Window show up!
        lastReminder = currentTime
    end
end

-- Function to start the timer on login
local function OnLogin()
    frame:RegisterEvent("PLAYER_LOGOUT")
    frame:SetScript("OnUpdate", ShowWaterReminder)
end

-- Function to stop the timer on logout
local function OnLogout()
    frame:UnregisterEvent("PLAYER_LOGOUT")
    frame:SetScript("OnUpdate", nil)
end

-- The popup window and the buttons for the water reminder
StaticPopupDialogs["DRINK_WATER_POPUP"] = {
    text = "It's time to drink water!", -- Placeholder text, will be replaced dynamically but also left in there just in case error occurs so User experiance is consistent
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

-- Popup window to set the interval for hydrating
StaticPopupDialogs["SET_INTERVAL_POPUP"] = {
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

-- Register events and set up event handling
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        OnLogin()
    elseif event == "PLAYER_LOGOUT" then
        OnLogout()
    end
end)

-- Register the PLAYER_LOGIN event to start the initial loop
frame:RegisterEvent("PLAYER_LOGIN")