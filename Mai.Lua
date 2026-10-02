local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local HopButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "DeltaHopGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 140)
MainFrame.Position = UDim2.new(0.5, -120, 0.3, -70)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

TitleLabel.Size = UDim2.new(1, -30, 0, 40)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "STEAL AN EGG HOP"
TitleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 75, 75)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = MainFrame

HopButton.Name = "HopButton"
HopButton.Size = UDim2.new(0, 200, 0, 40)
HopButton.Position = UDim2.new(0.5, -100, 0.45, -20)
HopButton.BackgroundColor3 = Color3.fromRGB(235, 100, 0)
HopButton.Text = "Hop Server (<= 2 Nguoi)"
HopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HopButton.Font = Enum.Font.GothamBold
HopButton.TextSize = 14
HopButton.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = HopButton

StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0.75, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Trang thai: San sang"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.Parent = MainFrame

local function hopServer()
    StatusLabel.Text = "Dang quet danh sach..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    
    local url = "https://roblox.com" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success or not result then
        url = "https://roproxy.com" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        success, result = pcall(function() return game:HttpGet(url) end)
    end
    
    if not success or not result then
        StatusLabel.Text = "Delta bi loi ket noi API!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        return
    end
    
    local serverList = HttpService:JSONDecode(result)
    local targetServerId = nil
    local playerCountFound = 0
    
    if serverList and serverList.data then
        for _, server in pairs(serverList.data) do
            if server.playing and server.playing >= 1 and server.playing <= 2 and server.playing < server.maxPlayers then
                if server.id ~= game.JobId then
                    targetServerId = server.id
                    playerCountFound = server.playing
                    break
                end
            end
        end
    end
    
    if targetServerId then
        StatusLabel.Text = "Tim thay (" .. tostring(playerCountFound) .. " nguoi). Chuyen..."
        StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        task.wait(0.3)
        TeleportService:TeleportToPlaceInstance(PlaceId, targetServerId, LocalPlayer)
    else
        StatusLabel.Text = "Tim kiem server trong..."
        for _, server in pairs(serverList.data) do
            if server.playing == 0 and server.id ~= game.JobId then
                StatusLabel.Text = "Chuyen vao server trong..."
                StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
                TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer)
                return
            end
        end
        StatusLabel.Text = "Khong tim thay phong!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end

HopButton.MouseButton1Click:Connect(hopServer)
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
