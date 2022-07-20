if not game:IsLoaded() then
    game.Loaded:Wait()
end
local syn = syn or {}

local BASE_64_DECODE = syn.crypt.base64.decode
local BASE_64_ENCODE = syn.crypt.base64.encode

local jsonEncode = function(data)
    return game:GetService("HttpService"):JSONEncode(data)
end
local jsonDecode = function(data)
    return game:GetService("HttpService"):JSONDecode(data)
end

local config = jsonDecode(readfile("config.json"))

local WEBSOCKET_URL = "ws://localhost:" .. config.port .. "/" --Check config.json
local suc, websocket = pcall(syn.websocket.connect, WEBSOCKET_URL)

if not suc then
    return error("Failed to initialize websocket, server is probably dead and/or invalid url.,")
end

-- 'data' in this context is
-- {status: number, data: string}
-- 1 = success, 0 = error

local function sendData(data)
    --Convert data into a json string, and then encodes it with base64, and then send it
    data = BASE_64_ENCODE(jsonEncode(data))
    websocket:Send(data)
end

local function onReceived(data)
    --'data' is in base64, must be decoded and then convert into 'data'
    data = jsonDecode(BASE_64_DECODE(data))

    --I dont think client needs to know the server's personal issue, kinda invasive dont you think...?
    if data.status == 0 then
        return error("Error from server..\n" .. data.data)
    end

    --Safely call the script
    local func = loadstring(data.data)
    local suc, err = pcall(func)

    --Something went wrong...
    if not suc then
        sendData{
            status = 0,
            data = err
        }
    end
end

local function onClosed()
    print("Oh no its closed 😧")
end

websocket.OnMessage:Connect(onReceived)
websocket.OnClose:Connect(onClosed)



