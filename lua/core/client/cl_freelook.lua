local didTry = false
local isConnected = true
local isFreelooking = false
local timeoutTime = 2 -- 2 : seconds
local retryTime = 2 -- 2 : seconds
local lastTick = CurTime()
local flView = {
    pos = Vector()
}

local function onDisconnected()
    isFreelooking = true

    flView.pos = LocalPlayer():EyePos()
    flView.ang = LocalPlayer():EyeAngles()
end

local function onReconnected()
    isFreelooking = false
end

dTimer.Create( "DCFL_Timer_Ping", retryTime, 0, function()
    if didTry then return end
    didTry = true

    net.Start( "DCFL_Ping" )
    net.SendToServer()

    dTimer.Create( "DCFL_Timer_Timeout", timeoutTime, 1, function()
        isConnected = false

        onDisconnected()
    end )
end )

net.Receive( "DCFL_Pong", function()
    didTry = false

    if not isConnected then
        isConnected = true

        onReconnected()
    end

    dTimer.Remove( "DCFL_Timer_Timeout" )
end )

local function freelook( ply, pos, angles, fov )
    if not isFreelooking then return end

    local x = ( input.IsKeyDown( KEY_W ) and 1 or 0 ) - ( input.IsKeyDown( KEY_S ) and 1 or 0 )
    local y = ( input.IsKeyDown( KEY_A ) and 1 or 0 ) - ( input.IsKeyDown( KEY_D ) and 1 or 0 )
    local z = ( input.IsKeyDown( KEY_SPACE ) and 1 or 0 ) - ( input.IsKeyDown( KEY_LCONTROL ) and 1 or 0 )
    local speed = 20 * ( input.IsKeyDown( KEY_LSHIFT ) and 2 or 1 )

    local moveVec = Vector( x, y, 0 )
    moveVec:Rotate( angles )
    moveVec = ( moveVec + Vector( 0, 0, z ) ) * speed

    flView.pos = flView.pos + moveVec

    local view = {
        origin = flView.pos,
        angles = angles,
        fov = fov,
        drawviewer = true
    }

    return view
end

hook.Add( "CalcView", "DCFL_Freelook", freelook )

