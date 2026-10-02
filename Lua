local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

local function teleportToSmallServer()
    print("Đang quét tìm server vắng người...")
    
    -- Gọi API Roblox để lấy danh sách server sắp xếp từ ít người nhất (Asc)
    local url = "https://roblox.com" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success or not result then
        warn("Không thể kết nối tới API Roblox. Thử lại sau.")
        return
    end
    
    local serverList = HttpService:JSONDecode(result)
    local targetServerId = nil
    
    if serverList and serverList.data then
        for _, server do
            -- Kiểm tra server có từ 1 người trở lên và chưa bị đầy
            if server.playing and server.playing >= 1 and server.playing < server.maxPlayers then
                -- Bỏ qua server hiện tại bạn đang chơi
                if server.id ~= game.JobId then
                    targetServerId = server.id
                    print("Đã tìm thấy server lý tưởng với " .. tostring(server.playing) .. " người chơi!")
                    break
                end
            end
        end
    end
    
    if targetServerId then
        -- Thực hiện dịch chuyển sang server tìm được
        TeleportService:TeleportToPlaceInstance(PlaceId, targetServerId, LocalPlayer)
    else
        print("Không tìm thấy server 1 người nào khác. Hệ thống sẽ thử tìm server trống (0 người)...")
        -- Nếu không có server 1 người, quét lại để tìm server trống hoàn toàn
        for _, server in pairs(serverList.data) do
            if server.playing == 0 and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer)
                return
            end
        end
        print("Hiện tại tất cả các server đều đông người.")
    end
end

-- Kích hoạt chạy script
teleportToSmallServer()
