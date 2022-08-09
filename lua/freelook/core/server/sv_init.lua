util.AddNetworkString( "DCFL_Ping" )
util.AddNetworkString( "DCFL_Pong" )

net.Receive( "DCFL_Ping", function( len, ply )
    net.Start( "DCFL_Pong" )
    net.Send( ply )
end )
