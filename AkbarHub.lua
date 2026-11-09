--==================================================
-- AKBARHUB | MALAM BERSAMA OPAH
-- KEY ESP + CODE FINDER + OPAH DETECTOR
-- RETURN TO FIRST LOCATION + FULLBRIGHT
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- RAYFIELD
local Rayfield = loadstring(game:HttpGet(
    "https://sirius.menu/rayfield"
))()

local Window = Rayfield:CreateWindow({
    Name = "AkbarHub | Malam Bersama Opah",
    LoadingTitle = "AkbarHub",
    LoadingSubtitle = "Malam Bersama Opah",
    ConfigurationSaving = {
        Enabled = false
    }
})

local KeyTab = Window:CreateTab("Key ESP", 4483362458)
local CodeTab = Window:CreateTab("Code Finder", 4483362458)
local OpahTab = Window:CreateTab("Opah Detector", 4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)

-- SETTINGS
local Settings = {
    Key = false,
    Code = false,
    Opah = false
}

local Objects = {
    Key = {},
    Code = {},
    Opah = {}
}

local Colors = {
    Key = Color3.fromRGB(255, 220, 0),
    Code = Color3.fromRGB(0, 255, 80),
    Opah = Color3.fromRGB(255, 0, 0)
}

local Names = {
    Key = "Key",
    Opah = "Opah"
}

--==================================================
-- GET PART
--==================================================

local function GetPart(obj)
    if obj:IsA("BasePart") then
        return obj
    elseif obj:IsA("Model") then
        return obj.PrimaryPart
            or obj:FindFirstChildWhichIsA("BasePart", true)
    end
end

--==================================================
-- CLEAR ESP
--==================================================

local function Clear(category)
    for obj, data in pairs(Objects[category]) do
        if data.Highlight then
            data.Highlight:Destroy()
        end

        if data.Billboard then
            data.Billboard:Destroy()
        end
    end

    table.clear(Objects[category])
end

--==================================================
-- CREATE ESP
--==================================================

local function CreateESP(obj, category)
    if Objects[category][obj] then return end

    local part = GetPart(obj)
    if not part then return end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = obj
    highlight.FillColor = Colors[category]
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.1
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = obj

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "AkbarHubESP"
    billboard.Adornee = part
    billboard.Size = UDim2.fromOffset(160, 45)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = PlayerGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.TextColor3 = Colors[category]
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.Parent = billboard

    Objects[category][obj] = {
        Highlight = highlight,
        Billboard = billboard,
        Label = label,
        Part = part
    }
end

--==================================================
-- FEATURE TOGGLE
--==================================================

local function CreateFeature(tab, category, title)
    tab:CreateToggle({
        Name = title .. " + Distance",
        CurrentValue = false,

        Callback = function(value)
            Settings[category] = value

            if not value then
                Clear(category)
            end
        end
    })

    tab:CreateButton({
        Name = "Refresh " .. title,
        Callback = function()
            Clear(category)
        end
    })
end

-- KEY ESP
CreateFeature(KeyTab, "Key", "Key Highlight")

-- OPAH ESP
CreateFeature(OpahTab, "Opah", "Opah Detector")

--==================================================
-- CODE FINDER
--==================================================

CodeTab:CreateToggle({
    Name = "Auto Code Finder",
    CurrentValue = false,

    Callback = function(value)
        Settings.Code = value

        if not value then
            Clear("Code")
        end
    end
})

CodeTab:CreateButton({
    Name = "Refresh Code",
    Callback = function()
        Clear("Code")
    end
})

local function IsCodePrompt(prompt)
    if not prompt:IsA("ProximityPrompt") then
        return false
    end

    local action = string.lower(prompt.ActionText or "")
    local object = string.lower(prompt.ObjectText or "")

    local combined = action .. " " .. object

    return string.find(combined, "passcode", 1, true)
        or string.find(combined, "note", 1, true)
end

local function GetCodeTarget(prompt)
    local current = prompt.Parent
    local nearestPart = nil
    local nearestModel = nil

    while current and current ~= Workspace do
        if current:IsA("BasePart") and not nearestPart then
            nearestPart = current
        end

        if current:IsA("Model") and not nearestModel then
            nearestModel = current
        end

        current = current.Parent
    end

    if nearestModel and GetPart(nearestModel) then
        return nearestModel
    end

    return nearestPart
end

local function ScanCodes()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and IsCodePrompt(obj) then
            local target = GetCodeTarget(obj)

            if target then
                CreateESP(target, "Code")
            end
        end
    end
end

--==================================================
-- RETURN TO FIRST LOCATION
--==================================================

local FirstLocation = nil

KeyTab:CreateButton({
    Name = "Save First Location",

    Callback = function()
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")

        if root then
            FirstLocation = root.CFrame

            Rayfield:Notify({
                Title = "AkbarHub",
                Content = "First Location Saved!",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "AkbarHub",
                Content = "Character belum siap!",
                Duration = 3
            })
        end
    end
})

KeyTab:CreateButton({
    Name = "Return to First Location",

    Callback = function()
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")

        if root and FirstLocation then
            root.CFrame = FirstLocation

            Rayfield:Notify({
                Title = "AkbarHub",
                Content = "Returned to First Location!",
                Duration = 3
            })
        elseif not FirstLocation then
            Rayfield:Notify({
                Title = "AkbarHub",
                Content = "Save First Location First!",
                Duration = 3
            })
        end
    end
})

--==================================================
-- FULLBRIGHT
--==================================================

local OriginalLighting = nil

local function EnableFullBright()
    if not OriginalLighting then
        OriginalLighting = {
            Brightness = Lighting.Brightness,
            ClockTime = Lighting.ClockTime,
            FogEnd = Lighting.FogEnd,
            GlobalShadows = Lighting.GlobalShadows,
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            ExposureCompensation = Lighting.ExposureCompensation
        }
    end

    Lighting.Brightness = 3
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.ExposureCompensation = 0
end

local function DisableFullBright()
    if not OriginalLighting then return end

    Lighting.Brightness = OriginalLighting.Brightness
    Lighting.ClockTime = OriginalLighting.ClockTime
    Lighting.FogEnd = OriginalLighting.FogEnd
    Lighting.GlobalShadows = OriginalLighting.GlobalShadows
    Lighting.Ambient = OriginalLighting.Ambient
    Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
    Lighting.ExposureCompensation = OriginalLighting.ExposureCompensation

    OriginalLighting = nil
end

VisualTab:CreateToggle({
    Name = "FullBright",
    CurrentValue = false,

    Callback = function(value)
        if value then
            EnableFullBright()

            Rayfield:Notify({
                Title = "AkbarHub",
                Content = "FullBright Enabled!",
                Duration = 3
            })
        else
            DisableFullBright()

            Rayfield:Notify({
                Title = "AkbarHub",
                Content = "FullBright Disabled!",
                Duration = 3
            })
        end
    end
})

--==================================================
-- MAIN LOOP
--==================================================

local ScanTimer = 0

RunService.Heartbeat:Connect(function(dt)
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then return end

    ScanTimer += dt

    if ScanTimer >= 0.5 then
        ScanTimer = 0

        for category, enabled in pairs(Settings) do
            if enabled and Names[category] then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj.Name == Names[category] then
                        CreateESP(obj, category)
                    end
                end
            end
        end

        if Settings.Code then
            ScanCodes()
        end
    end

    -- UPDATE DISTANCE
    for category, objects in pairs(Objects) do
        for obj, data in pairs(objects) do
            if not obj:IsDescendantOf(Workspace)
                or not data.Part.Parent
                or not Settings[category] then

                if data.Highlight then
                    data.Highlight:Destroy()
                end

                if data.Billboard then
                    data.Billboard:Destroy()
                end

                objects[obj] = nil

            else
                local distance =
                    (root.Position - data.Part.Position).Magnitude

                data.Label.Text = string.format(
                    "%s\n%.0f STUDS",
                    category == "Code" and "PASSCODE NOTE"
                        or string.upper(category),
                    distance
                )
            end
        end
    end
end)

--==================================================
-- NOTIFICATION
--==================================================

Rayfield:Notify({
    Title = "AkbarHub",
    Content = "Key + Passcode Note Finder + Opah + Return + FullBright Loaded!",
    Duration = 5
})
