local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local parent = player:WaitForChild("PlayerGui")

local SettingsUI = Instance.new("ScreenGui")
SettingsUI.Name = "PeppermintEmotes-Settings"
SettingsUI.ResetOnSpawn = false
SettingsUI.IgnoreGuiInset = true
SettingsUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SettingsUI.DisplayOrder = 999

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.Size = UDim2.fromOffset(360, 460)
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 25, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = SettingsUI

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Header = Instance.new("Frame")
Header.BackgroundTransparency = 1
Header.Size = UDim2.new(1, 0, 0, 50)
Header.Parent = MainFrame

local Nav = Instance.new("ScrollingFrame")
Nav.Name = "NavContainer"
Nav.BackgroundTransparency = 1
Nav.Position = UDim2.new(0, 10, 0, 8)
Nav.Size = UDim2.new(1, -55, 0, 34)
Nav.CanvasSize = UDim2.new()
Nav.AutomaticCanvasSize = Enum.AutomaticSize.X
Nav.ScrollBarThickness = 0
Nav.Parent = Header
Instance.new("UIListLayout", Nav).Padding = UDim.new(0, 8)

local Close = Instance.new("TextButton")
Close.BackgroundTransparency = 1
Close.Position = UDim2.new(1, -42, 0, 10)
Close.Size = UDim2.fromOffset(32, 30)
Close.Text = "×"
Close.TextSize = 24
Close.TextColor3 = Color3.new(1,1,1)
Close.Font = Enum.Font.GothamBold
Close.Parent = Header
Close.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

local Body = Instance.new("ScrollingFrame")
Body.Name = "Body"
Body.BackgroundTransparency = 1
Body.Position = UDim2.new(0, 10, 0, 52)
Body.Size = UDim2.new(1, -20, 1, -62)
Body.CanvasSize = UDim2.new()
Body.AutomaticCanvasSize = Enum.AutomaticSize.Y
Body.ScrollBarThickness = 4
Body.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
Body.Parent = MainFrame
Instance.new("UIListLayout", Body).Padding = UDim.new(0, 8)

SettingsUI.Parent = parent

local Lib = {}

function Lib:Create(className, properties, children)
    local obj = Instance.new(className)
    for k,v in pairs(properties or {}) do obj[k] = v end
    for _, child in ipairs(children or {}) do child.Parent = obj end
    return obj
end

function Lib:Tween(obj, info, goal)
    local t = TweenService:Create(obj, info, goal)
    t:Play()
    return t
end

function Lib:AddItem(container, title, description)
    local item = Instance.new("Frame")
    item.Name = tostring(title)
    item.Size = UDim2.new(1, -4, 0, description and 66 or 48)
    item.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
    item.BorderSizePixel = 0
    item.Parent = container
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(12, description and 9 or 0)
    label.Size = UDim2.new(0.62, 0, description and 22 or 48, 0)
    label.Text = tostring(title)
    label.TextColor3 = Color3.new(1,1,1)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = item

    if description then
        local desc = Instance.new("TextLabel")
        desc.BackgroundTransparency = 1
        desc.Position = UDim2.fromOffset(12, 31)
        desc.Size = UDim2.new(0.65, 0, 0, 28)
        desc.Text = tostring(description)
        desc.TextWrapped = true
        desc.TextColor3 = Color3.fromRGB(150,150,150)
        desc.TextSize = 10
        desc.Font = Enum.Font.Gotham
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = item
    end
    return item
end

function Lib:AddToggle(container, title, description, default, callback)
    local item = Lib:AddItem(container, title, description)
    local state = default == true
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(46, 22)
    b.Position = UDim2.new(1, -58, 0.5, -11)
    b.Text = ""
    b.BackgroundColor3 = state and Color3.fromRGB(0,220,130) or Color3.fromRGB(55,58,62)
    b.Parent = item
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    local function refresh()
        b.BackgroundColor3 = state and Color3.fromRGB(0,220,130) or Color3.fromRGB(55,58,62)
    end
    b.MouseButton1Click:Connect(function()
        state = not state
        refresh()
        if callback then callback(state) end
    end)
    return {SetValue=function(v) state = v == true; refresh() end, Button=b, Item=item}
end

function Lib:AddDropdown(container, title, options, default, callback)
    local item = Lib:AddItem(container, title, nil)
    local box = Instance.new("TextButton")
    box.Size = UDim2.fromOffset(130, 28)
    box.Position = UDim2.new(1, -142, 0.5, -14)
    box.BackgroundColor3 = Color3.fromRGB(24,25,28)
    box.TextColor3 = Color3.new(1,1,1)
    box.TextSize = 11
    box.Font = Enum.Font.Gotham
    box.Text = tostring(default or (options and options[1]) or "")
    box.Parent = item
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)

    local menu = Instance.new("Frame")
    menu.Visible = false
    menu.Size = UDim2.fromOffset(130, math.min(220, math.max(32, (#(options or {}) * 28))))
    menu.BackgroundColor3 = Color3.fromRGB(24,25,28)
    menu.BorderSizePixel = 0
    menu.ZIndex = 20
    menu.Parent = MainFrame
    Instance.new("UICorner", menu).CornerRadius = UDim.new(0,6)
    local layout = Instance.new("UIListLayout", menu)

    for _, opt in ipairs(options or {}) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,28)
        btn.BackgroundTransparency = 1
        btn.Text = tostring(opt)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextSize = 11
        btn.Font = Enum.Font.Gotham
        btn.ZIndex = 21
        btn.Parent = menu
        btn.MouseButton1Click:Connect(function()
            box.Text = tostring(opt)
            menu.Visible = false
            if callback then callback(opt) end
        end)
    end

    box.MouseButton1Click:Connect(function()
        menu.Position = UDim2.new(0, item.AbsolutePosition.X - MainFrame.AbsolutePosition.X + item.AbsoluteSize.X - 142, 0, item.AbsolutePosition.Y - MainFrame.AbsolutePosition.Y + item.AbsoluteSize.Y + 4)
        menu.Visible = not menu.Visible
    end)

    return {SetValue=function(v) box.Text=tostring(v) end, Button=box, Item=item}
end

function Lib:AddFolder(container, title)
    local folder = Instance.new("Frame")
    folder.Name = tostring(title)
    folder.Size = UDim2.new(1,-4,0,44)
    folder.BackgroundTransparency = 1
    folder.Parent = container
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Size = UDim2.new(1,0,1,0)
    l.Text = "— " .. tostring(title):upper() .. " —"
    l.TextColor3 = Color3.fromRGB(0,255,150)
    l.TextSize = 11
    l.Font = Enum.Font.GothamBold
    l.Parent = folder
    return folder
end

function Lib:AddIconButton(container, imageId, callback)
    local b = Instance.new("ImageButton")
    b.Size = UDim2.fromOffset(38,38)
    b.BackgroundTransparency = 1
    b.Image = "rbxassetid://" .. tostring(imageId):gsub("rbxassetid://","")
    b.Parent = container
    b.MouseButton1Click:Connect(callback)
    return b
end

function Lib:AddButton(container, title, callback)
    local item = Lib:AddItem(container, title, nil)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(65,24)
    b.Position = UDim2.new(1,-75,0.5,-12)
    b.Text = "Click"
    b.TextSize = 11
    b.Parent = item
    b.MouseButton1Click:Connect(callback)
    return b
end

function Lib:AddInput(container, title, placeholder, default, callback)
    local item = Lib:AddItem(container,title,nil)
    local input = Instance.new("TextBox")
    input.Size = UDim2.fromOffset(100,24)
    input.Position = UDim2.new(1,-110,0.5,-12)
    input.Text = default or ""
    input.PlaceholderText = placeholder or "..."
    input.Parent = item
    input.FocusLost:Connect(function() callback(input.Text) end)
    return {SetValue=function(v) input.Text=tostring(v) end}
end

function Lib:AddTextArea(container,title,placeholder,default,callback)
    local item = Lib:AddItem(container,title,nil)
    item.Size = UDim2.new(1,-4,0,120)
    local input = Instance.new("TextBox")
    input.Position = UDim2.fromOffset(10,32)
    input.Size = UDim2.new(1,-20,0,80)
    input.Text = default or ""
    input.PlaceholderText = placeholder or "..."
    input.ClearTextOnFocus = false
    input.MultiLine = true
    input.TextWrapped = true
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.TextYAlignment = Enum.TextYAlignment.Top
    input.Parent = item
    input.FocusLost:Connect(function() callback(input.Text) end)
    return input
end

function Lib:AddColorPicker(container,title,default,callback)
    local item = Lib:AddItem(container,title,nil)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(22,22)
    b.Position = UDim2.new(1,-42,0.5,-11)
    b.BackgroundColor3 = default or Color3.new(1,1,1)
    b.Text = ""
    b.Parent = item
    b.MouseButton1Click:Connect(function() callback(b.BackgroundColor3) end)
    return {Button=b, Item=item}
end

function Lib:AddInputWithColor(container,title,placeholder,defaultText,defaultColor,callback)
    local item = Lib:AddItem(container,title,nil)
    local input = Instance.new("TextBox")
    input.Size = UDim2.fromOffset(110,24)
    input.Position = UDim2.new(1,-150,0.5,-12)
    input.Text = defaultText or ""
    input.PlaceholderText = placeholder or "..."
    input.Parent = item
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(22,22)
    b.Position = UDim2.new(1,-35,0.5,-11)
    b.BackgroundColor3 = defaultColor or Color3.new(1,1,1)
    b.Text = ""
    b.Parent = item
    local function fire() callback(input.Text,b.BackgroundColor3) end
    input.FocusLost:Connect(fire)
    b.MouseButton1Click:Connect(fire)
    return {SetValue=function(t,c) input.Text=t or ""; if c then b.BackgroundColor3=c end end, Button=b, Item=item}
end

function Lib:AddAssetColor(container,title,placeholder,defaultText,defaultColor,callback)
    return Lib:AddInputWithColor(container,title,placeholder,defaultText,defaultColor,callback)
end

function Lib:CreateTab(name, order)
    local tab = Instance.new("Frame")
    tab.Name = tostring(name)
    tab.BackgroundTransparency = 1
    tab.Size = UDim2.new(1,0,0,0)
    tab.AutomaticSize = Enum.AutomaticSize.Y
    tab.Visible = false
    tab.LayoutOrder = order or 1
    tab.Parent = Body

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(80,30)
    btn.BackgroundColor3 = Color3.fromRGB(32,34,37)
    btn.Text = tostring(name)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Nav

    btn.MouseButton1Click:Connect(function()
        for _, c in ipairs(Body:GetChildren()) do
            if c:IsA("Frame") then c.Visible = false end
        end
        tab.Visible = true
    end)

    if #Nav:GetChildren() <= 2 then tab.Visible = true end
    return tab
end

function Lib:AddSection(container,title)
    return Lib:AddItem(container,title,nil)
end

Lib.UI = SettingsUI
Lib.UI.MainFrame = MainFrame

-- Match the method/property names consumed by the emote script.
Lib.AddItem = function(container, ...) return Lib:AddItem(container, ...) end
Lib.AddToggle = function(container, ...) return Lib:AddToggle(container, ...) end
Lib.AddDropdown = function(container, ...) return Lib:AddDropdown(container, ...) end
Lib.AddFolder = function(container, ...) return Lib:AddFolder(container, ...) end
Lib.AddIconButton = function(container, ...) return Lib:AddIconButton(container, ...) end
Lib.AddColorPicker = function(container, ...) return Lib:AddColorPicker(container, ...) end
Lib.AddInputWithColor = function(container, ...) return Lib:AddInputWithColor(container, ...) end
Lib.AddAssetColor = function(container, ...) return Lib:AddAssetColor(container, ...) end
Lib.AddButton = function(container, ...) return Lib:AddButton(container, ...) end
Lib.AddInput = function(container, ...) return Lib:AddInput(container, ...) end
Lib.AddTextArea = function(container, ...) return Lib:AddTextArea(container, ...) end

return Lib
