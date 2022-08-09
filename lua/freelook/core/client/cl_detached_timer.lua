-- Thanks to the CFC Dev Team for this handy class!
-- Check them out! --> cfcservers.org <--

dTimer = {}

dTimer.timers = {}
dTimer.idCounter = 0

function dTimer.Create( id, delay, reps, f )
    dTimer.timers[id] = { id = id, delay = delay, reps = reps, func = f, lastCall = SysTime() }
end

function dTimer.Adjust( id, delay, reps, f )
    if dTimer.timers[id] then
        dTimer.timers[id].delay = delay or dTimer.timers[id].delay
        dTimer.timers[id].reps = reps or dTimer.timers[id].reps
        dTimer.timers[id].func = f or dTimer.timers[id].f
        return true
    end

    return false
end

function dTimer.Exists( id )
    return not not dTimer.timers[id]
end

function dTimer.Remove( id )
    dTimer.timers[id] = nil
end

function dTimer.RepsLeft( id )
    return dTimer.timers[id] and dTimer.timers[id].reps or -1
end

function dTimer.Simple( delay, f )
    dTimer.Create( "SimpleTimer" .. dTimer.idCounter, delay, 1, f )
    dTimer.idCounter = dTimer.idCounter + 1
end

function dTimer.Start( id )
    dTimer.timers[id].isPaused = false
    dTimer.timers[id].lastCall = SysTime()
end

function dTimer.Pause( id )
    dTimer.timers[id].isPaused = true
end

hook.Add( "Think", "cfc_di_detatched_timer", function()
    local time = SysTime()
    for id, curTimer in pairs( dTimer.timers ) do

        local delayPassed = time - curTimer.lastCall > curTimer.delay

        if not curTimer.isPaused then
            if delayPassed then
                curTimer.lastCall = time

                local hasReps = curTimer.reps > 0

                if hasReps then
                    curTimer.reps = curTimer.reps - 1
                    if curTimer.reps == 0 then
                        dTimer.Remove( id )
                    end
                end

                curTimer.func()
            end
        end
    end
end )
