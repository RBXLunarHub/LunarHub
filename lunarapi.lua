-- Load Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "Lunar Hub | 1.0",
    HidePremium = false,
    SaveConfig = true,
    IntroText = "Lunar",
    ConfigFolder = "OrionTest"
})

-- Notification
OrionLib:MakeNotification({
    Name = "Lunar Hub has been executed!",
    Content = "Thank you for using LunarHub",
    Image = "rbxassetid://4483345998",
    Time = 5
})

-- Misc Tab
local Misc = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
--FE Scripts Tab

local ScriptTab = Window:MakeTab({
	Name = "FE Scripts",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
-- Fly vars 
local FLYING = false
local QEfly = true
local iyflyspeed = 1
local vehicleflyspeed = 1
local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
local SPEED = 0
local flyKeyDown, flyKeyUp

--Noclip Var
local noClipEnabled = false
-- Function to get the root part of the character
local function getRoot(character)
    return character:WaitForChild("HumanoidRootPart", 10)
end

-- Start Flying Function 
local function startFlying(vfly)
    repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character and getRoot(game.Players.LocalPlayer.Character) and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local T = getRoot(game.Players.LocalPlayer.Character)

    local function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro')
        local BV = Instance.new('BodyVelocity')
        BG.P = 9e4
        BG.Parent = T
        BV.Parent = T
        BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.cframe = T.CFrame
        BV.velocity = Vector3.new(0, 0, 0)
        BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            repeat wait()
                if not vfly and game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                    game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
                end
                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                    SPEED = 50
                elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
                    SPEED = 0
                end
                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                    BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                    BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                else
                    BV.velocity = Vector3.new(0, 0, 0)
                end
                BG.cframe = workspace.CurrentCamera.CoordinateFrame
            until not FLYING
            CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            SPEED = 0
            BG:Destroy()
            BV:Destroy()
            if game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
            end
        end)
    end
    flyKeyDown = game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then
            CONTROL.F = iyflyspeed
        elseif input.KeyCode == Enum.KeyCode.S then
            CONTROL.B = -iyflyspeed
        elseif input.KeyCode == Enum.KeyCode.A then
            CONTROL.L = -iyflyspeed
        elseif input.KeyCode == Enum.KeyCode.D then
            CONTROL.R = iyflyspeed
        elseif QEfly and input.KeyCode == Enum.KeyCode.E then
            CONTROL.Q = iyflyspeed * 2
        elseif QEfly and input.KeyCode == Enum.KeyCode.Q then
            CONTROL.E = -iyflyspeed * 2
        end
    end)
    
    flyKeyUp = game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then
            CONTROL.F = 0
        elseif input.KeyCode == Enum.KeyCode.S then
            CONTROL.B = 0
        elseif input.KeyCode == Enum.KeyCode.A then
            CONTROL.L = 0
        elseif input.KeyCode == Enum.KeyCode.D then
            CONTROL.R = 0
        elseif input.KeyCode == Enum.KeyCode.E then
            CONTROL.Q = 0
        elseif input.KeyCode == Enum.KeyCode.Q then
            CONTROL.E = 0
        end
    end)
    FLY()
end
---------------------------------------------------------


-- WalkSpeed Slider
Misc:AddSlider({
    Name = "Walkspeed",
    Min = 0,
    Max = 500,
    Default = 20,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Walkspeed",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end    
})

-- Jump Power Slider
Misc:AddSlider({
    Name = "Jump Power",
    Min = 0,
    Max = 200,
    Default = 30,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Jump Power",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end    
})

local players = {}
for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then  -- Exclude self from the list
        table.insert(players, player.Name)
    end
end

-- Dropdown for player selection
local playerDropdown = ScriptTab:AddDropdown({
    Name = "Select Player to Teleport To",
    Default = "Select a player",
    Options = players,
    Callback = function(selectedPlayerName)
        print("Selected player: " .. selectedPlayerName)
        -- Save the selected player for teleportation
        selectedPlayer = selectedPlayerName
    end
})

-- Teleport button
ScriptTab:AddButton({
    Name = "Teleport",
    Callback = function()
        local targetPlayer = game.Players:FindFirstChild(selectedPlayer)
        if targetPlayer and targetPlayer.Character then
            local targetPosition = targetPlayer.Character:WaitForChild("HumanoidRootPart").Position
            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to selected player
            print("Teleported to: " .. selectedPlayer)
        else
            print("Invalid player selected or player is not in the game!")
        end
    end
})
-- Fly Toggle Button in Orion
ScriptTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(value)
        if value then
            startFlying(true)  -- true for vehicle-style flying or normal
        else
            FLYING = false
        end
    end
})
--Gain Vc
ScriptTab:AddButton({
    Name = "Gain VC Back",
    Default = false,
    Callback = function(value)
        game:GetService("VoiceChatService"):joinVoice()
    end
})
--God Mode
ScriptTab:AddToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        local humanoid = player.Character:WaitForChild("Humanoid")

        if value then
            -- Activate God Mode (invincibility)
            humanoid.Health = math.huge  -- Make health infinite (God Mode)
            humanoid.MaxHealth = math.huge  -- Ensure max health is also set to infinite
        else
            -- Deactivate God Mode (normal health)
            humanoid.Health = humanoid.MaxHealth  -- Set health back to normal max value
        end
    end
})
--Invis
ScriptTab:AddToggle({
    Name = "Invisibility",
    Default = false,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        -- Loop through all BaseParts and accessories to set visibility
        if value then
            -- Make the player and accessories invisible
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1  -- Set transparency to 1 for BodyParts
                end
            end

            -- Make accessories and hats invisible
            for _, accessory in pairs(character:GetChildren()) do
                if accessory:IsA("Accessory") or accessory:IsA("Hat") then
                    for _, part in pairs(accessory:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.Transparency = 1  -- Set transparency to 1 for accessories
                        end
                    end
                end
            end
        else
            -- Make the player and accessories visible again
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0  -- Reset transparency for BodyParts
                end
            end

            -- Make accessories and hats visible again
            for _, accessory in pairs(character:GetChildren()) do
                if accessory:IsA("Accessory") or accessory:IsA("Hat") then
                    for _, part in pairs(accessory:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.Transparency = 0  -- Reset transparency for accessories
                        end
                    end
                end
            end
        end
    end
})
--Noclip
ScriptTab:AddToggle({
    Name = "No Clip",
    Default = false,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        noClipEnabled = value  -- Track whether No Clip is enabled

        -- Apply No Clip (Disable collision for parts)
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not noClipEnabled  -- Toggle CanCollide based on No Clip status
            end
        end
    end
})
-- **Infinite Jump Toggle**
local isJumpingEnabled = false
local jumpConnection
--Infinite Jump
ScriptTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(value)
        local player = game:GetService('Players').LocalPlayer
        local UIS = game:GetService('UserInputService')
        
        _G.JumpHeight = 50  -- You can adjust the jump height here

        -- Handle enabling/disabling Infinite Jump
        if value then
            isJumpingEnabled = true

            -- Enable Infinite Jump: Press Space to keep jumping while in air
            jumpConnection = UIS.InputBegan:Connect(function(UserInput, gameProcessedEvent)
                if gameProcessedEvent then return end
                if UserInput.UserInputType == Enum.UserInputType.Keyboard and UserInput.KeyCode == Enum.KeyCode.Space then
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        local humanoid = player.Character.Humanoid
                        if humanoid:GetState() == Enum.HumanoidStateType.Jumping or humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                            if humanoidRootPart then
                                humanoidRootPart.Velocity = Vector3.new(0, _G.JumpHeight, 0)  -- Apply upward velocity
                            end
                        end
                    end
                end
            end)
        else
            isJumpingEnabled = false
            if jumpConnection then
                jumpConnection:Disconnect()  -- Disconnect the event when the toggle is turned off
            end
        end
    end
})
--------------------------



-- Initialize GUI
OrionLib:Init()
