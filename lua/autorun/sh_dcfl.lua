if SERVER then
    AddCSLuaFile( "freelook/core/client/cl_detached_timer.lua" )
    AddCSLuaFile( "freelook/core/client/cl_init.lua" )

    include( "freelook/core/server/sv_init.lua" )
end

if CLIENT then
    include( "freelook/core/client/cl_detached_timer.lua" )
    include( "freelook/core/client/cl_init.lua" )
end