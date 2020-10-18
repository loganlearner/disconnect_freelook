local didTry = false
local isConnected = true
local isFreelooking = false
local timeoutTime = 2 -- 2 : seconds
local retryTime = 2 -- 2 : seconds
local lastTick = CurTime()

local function onDisconnected()
    isFreelooking = true
    print( "DC AHHHHHHHHHHHHHHHHhhhh" )
end

local function onReconnected()
    print( "RE CON AHHHHHHHHHHHHHHHHhhhh" )
    isFreelooking = false
end

dTimer.Create( "DCFL_Timer_Ping", retryTime, 0, function()
    if didTry then return end

    didTry = true

    dTimer.Create( "DCFL_Timer_Timeout", timeoutTime, 1, function()
        isConnected = false

        onDisconnected()
    end )

    net.Start( "DCFL_Ping" )
    net.SendToServer()
end )

net.Receive( "DCFL_Pong", function()
    didTry = false

    if not isConnected then
        isConnected = true

        onReconnected()
    end

    dTimer.Stop( "DCFL_Timer_Timeout" )
end )

-- local function pingServer()
--     lastTick = CurTime()
-- end

-- hook.Add( "Tick", "DCFL_Tick", pingServer )

-- local function clientThink()
--     print( lastTick )

--     if CurTime() - lastTick < timeoutTime then
--         if isWaiting then
--             isWaiting = false
--             onReconnected()
--         end

--         return
--     end

--     if isWaiting then return end

--     isWaiting = true
--     onDisconnected()
-- end

-- hook.Add( "Think", "DCFL_ClientThink", clientThink )

local function freelook( ply, pos, angles, fov )
    if not isFreelooking then return end

    local view = {
        origin = pos - ( angles:Forward() * 100 ),
        angles = angles,
        fov = fov,
        drawviewer = true
    }

    return view
end

hook.Add( "CalcView", "DCFL_Freelook", freelook )
