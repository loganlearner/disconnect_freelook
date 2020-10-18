if SERVER then
    AddCSLuaFile( "core/client/cl_detached_timer.lua" )
    AddCSLuaFile( "core/client/cl_freelook.lua" )

    include( "core/server/sv_init.lua" )
end

if CLIENT then
    include( "core/client/cl_detached_timer.lua" )
    include( "core/client/cl_freelook.lua" )
end