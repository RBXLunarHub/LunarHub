local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function replaceOldWashee()
    local existingWashee = PlayerGui:FindFirstChild("WasheeGui")
    if existingWashee then
        existingWashee:Destroy()  -- Destroy the old version if it exists
    end
end

local ScreenGui = Instance.new("ScreenGui")
local MrWasheeWashee = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
local TextLabel = Instance.new("TextLabel")
local Frame = Instance.new("Frame")
local TextBox = Instance.new("TextBox")
local UICorner = Instance.new("UICorner")

-- Properties:


ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Name = "WasheeGui"

MrWasheeWashee.Name = "Mr Washee Washee"
MrWasheeWashee.Parent = ScreenGui
MrWasheeWashee.BackgroundTransparency = 1.000
MrWasheeWashee.Position = UDim2.new(0.227, 0, 0.695, 0)
MrWasheeWashee.Size = UDim2.new(0, 100, 0, 100)

ImageLabel.Parent = MrWasheeWashee
ImageLabel.BackgroundTransparency = 1.000
ImageLabel.Position = UDim2.new(4.010, 0, -0.969, 0)
ImageLabel.Size = UDim2.new(0, 74, 0, 133)
ImageLabel.Image = "http://www.roblox.com/asset/?id=83532591969932"

TextLabel.Parent = MrWasheeWashee
TextLabel.BackgroundTransparency = 1.000
TextLabel.Position = UDim2.new(2.91, 0, -1.6, 0)
TextLabel.Size = UDim2.new(0, 294, 0, 50)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Welcome To Washee Washee Admin!"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextWrapped = true

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
Frame.BackgroundTransparency = 0.1
Frame.Position = UDim2.new(0.045, 0, 1, 0)
Frame.Size = UDim2.new(0, 572, 0, 22)

TextBox.Parent = Frame
TextBox.BackgroundTransparency = 0
TextBox.Size = UDim2.new(0, 572, 0, 22)
TextBox.Font = Enum.Font.SourceSans
TextBox.PlaceholderText = "-- cmd here"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(199, 199, 199)
TextBox.TextScaled = true
TextBox.TextWrapped = true
TextBox.TextXAlignment = Enum.TextXAlignment.Left

UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = Frame

-- Scripts:

-- Variables for flying and movement control
local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
local SPEED = 50  -- Flying speed
local FLYING = false
local BodyGyro, BodyVelocity

-- Update movement controls based on keypresses
local function updateControls()
    local userInput = game:GetService("UserInputService")

    -- W and S for forward/backward
    if userInput:IsKeyDown(Enum.KeyCode.W) then
        CONTROL.F = 1
    elseif userInput:IsKeyDown(Enum.KeyCode.S) then
        CONTROL.B = 1
    else
        CONTROL.F = 0
        CONTROL.B = 0
    end

    -- A and D for left/right
    if userInput:IsKeyDown(Enum.KeyCode.A) then
        CONTROL.L = 1
    elseif userInput:IsKeyDown(Enum.KeyCode.D) then
        CONTROL.R = 1
    else
        CONTROL.L = 0
        CONTROL.R = 0
    end

    -- Q and E for up/down
    if userInput:IsKeyDown(Enum.KeyCode.Q) then
        CONTROL.Q = 1
    elseif userInput:IsKeyDown(Enum.KeyCode.E) then
        CONTROL.E = 1
    else
        CONTROL.Q = 0
        CONTROL.E = 0
    end
end

-- Apply movement while flying
local function updateFlyingMovement()
    local character = game.Players.LocalPlayer.Character
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Update velocity based on controls
    local velocity = Vector3.new(
        (CONTROL.R - CONTROL.L) * SPEED,  -- Left/Right movement
        (CONTROL.E - CONTROL.Q) * SPEED,  -- Up/Down movement
        (CONTROL.F - CONTROL.B) * SPEED   -- Forward/Backward movement
    )

    -- Apply the new velocity
    BodyVelocity.Velocity = velocity
end

-- Start flying
local function startFlying()
    local character = game.Players.LocalPlayer.Character
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Create BodyGyro and BodyVelocity
    BodyGyro = Instance.new('BodyGyro', humanoidRootPart)
    BodyVelocity = Instance.new('BodyVelocity', humanoidRootPart)

    BodyGyro.P = 9e4
    BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.cframe = humanoidRootPart.CFrame

    BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)

    -- Set platform stand for smoother movement
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true
    end

    -- Start the flying loop
    FLYING = true
    repeat
        updateControls()  -- Update controls each frame
        updateFlyingMovement()  -- Apply updated movement
        wait(0.1)  -- Delay to prevent unnecessary updates
    until not FLYING
end

-- Stop flying
local function stopFlying()
    local character = game.Players.LocalPlayer.Character
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Remove BodyGyro and BodyVelocity
    if BodyGyro then
        BodyGyro:Destroy()
    end
    if BodyVelocity then
        BodyVelocity:Destroy()
    end

    -- Restore humanoid platform stand setting
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
    end

    -- Disable flying
    FLYING = false
end

local function inputHandler()
    local input = game:GetService("UserInputService")
    local tweenservice = game:GetService("TweenService")
    local tweeninfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    
    local tween = tweenservice:Create(Frame, tweeninfo, {Position = UDim2.new(0.045, 0, 0.9, 0)})
    local backwardstween = tweenservice:Create(Frame, tweeninfo, {Position = UDim2.new(0.045, 0, 1, 0)})
    
    input.InputBegan:Connect(function(key)
        if key.KeyCode == Enum.KeyCode.Semicolon then
            print("Opening command bar") -- Debugging
            tween:Play()
            TextBox:CaptureFocus()
        end
    end)
    
    TextBox.FocusLost:Connect(function()
        TextBox.Text = ""
        backwardstween:Play()
    end)
end
coroutine.wrap(inputHandler)()

local espHighlights = {}  -- To keep track of active highlights

local espHighlights = {}  -- To keep track of active highlights
local espEnabled = false  -- Track if ESP is enabled

-- Function to apply ESP to a player
local function applyESP(player)
    if player.Character then
        if not espHighlights[player] then
            local highlight = Instance.new("Highlight")
            highlight.Parent = player.Character
            highlight.Name = "ESPHighlight"
            highlight.Adornee = player.Character
            highlight.FillColor = Color3.fromRGB(255, 0, 0)  -- Set highlight color (red)
            highlight.FillTransparency = 0.5  -- Semi-transparent fill
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)  -- Red outline
            highlight.OutlineTransparency = 0  -- Visible outline
            
            espHighlights[player] = highlight  -- Store the highlight
        end
    end
end

-- Function to remove ESP from all players
local function removeESP()
    for _, highlight in pairs(espHighlights) do
        highlight:Destroy()  -- Remove all highlights
    end
    espHighlights = {}  -- Clear the tracking table
end

local espHighlights = {}  -- To keep track of active highlights
local espEnabled = false  -- Track if ESP is enabled

-- Function to apply ESP to a player
local function applyESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if not espHighlights[player] then
            local highlight = Instance.new("Highlight")
            highlight.Parent = player.Character
            highlight.Name = "ESPHighlight"
            highlight.Adornee = player.Character
            highlight.FillColor = Color3.fromRGB(255, 0, 0)  -- Set highlight color (red)
            highlight.FillTransparency = 0.5  -- Semi-transparent fill
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)  -- Red outline
            highlight.OutlineTransparency = 0  -- Visible outline
            
            espHighlights[player] = highlight  -- Store the highlight
        end
    end
end

-- Function to remove ESP from all players
local function removeESP()
    for _, highlight in pairs(espHighlights) do
        highlight:Destroy()  -- Remove all highlights
    end
    espHighlights = {}  -- Clear the tracking table
end

-- Function to ensure character is fully loaded before applying ESP
local function waitForCharacter(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        player.CharacterAdded:Wait()  -- Wait for the character to load
    end
end

local function commandHandler()
    TextBox.FocusLost:Connect(function()
        local inputText = TextBox.Text:lower()
        
        if inputText:sub(1, 5) == ";goto" then
            local targetplrname = inputText:sub(7)
            local targetplr = Players:FindFirstChild(targetplrname)
            if targetplr and targetplr.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetplr.Character.HumanoidRootPart.CFrame
            else
                warn("Player not found!")
            end
        end
        
        if inputText == ";help" then
            print("Available commands: ;goto, ;fly, ;fling, ;spin, ;esp, ;esp off")
        end

		  if inputText == ";fly" then
            startFlying()  -- Start flying when the user types ';fly'
        end
        
        if inputText == ";stopfly" then
            stopFlying()  -- Stop flying when the user types ';stopfly'
        end


        
        if inputText == ";esp" then
            if not espEnabled then
                espEnabled = true
                -- Apply ESP to all existing players
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        waitForCharacter(player)  -- Ensure character is loaded
                        applyESP(player)
                    end
                end
                -- Listen for new players when ESP is enabled
                Players.PlayerAdded:Connect(function(player)
                    player.CharacterAdded:Connect(function()
                        waitForCharacter(player)  -- Wait for character to load
                        if espEnabled then
                            applyESP(player)  -- Apply ESP when their character is loaded
                        end
                    end)
                end)
                print("ESP enabled")
            else
                print("ESP is already enabled")
            end
        end
        
        if inputText == ";esp off" then
            if espEnabled then
                espEnabled = false
                removeESP()  -- Remove all ESP highlights
                print("ESP disabled")
            else
                print("ESP is already off")
            end
        end
    end)
end
coroutine.wrap(commandHandler)()





local function welcomeEffect()
    local blur = Instance.new("BlurEffect", game:GetService("Lighting"))
    blur.Size = 20
    
    local washeewashee = ImageLabel
    local text = TextLabel
    local tweenservice = game:GetService("TweenService")
    local tweeninfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local tween = tweenservice:Create(washeewashee, tweeninfo, {Position = UDim2.new(-3.67, 0, 0.75, 0)})
    
    while text.TextTransparency < 1 do
        task.wait(0.1)
        text.TextTransparency = math.min(1, text.TextTransparency + 0.02)
        blur.Size = math.max(0, blur.Size - 0.5)
    end
    
    tween:Play()
    print("Welcome screen animation completed")
end
coroutine.wrap(welcomeEffect)()

print("Command bar script loaded successfully")
