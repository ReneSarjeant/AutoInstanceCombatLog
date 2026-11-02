local state, callback, events, calls, messages
function CreateFrame(kind)
    assert(kind == "Frame")
    return {
        RegisterEvent = function(_, event) events[event] = true end,
        SetScript = function(_, script, fn) assert(script == "OnEvent"); callback = fn end,
    }
end
function IsInInstance() return state.inside, state.kind end
function UnitIsDeadOrGhost(unit) assert(unit == "player"); return state.dead end
function LoggingCombat(value)
    if value ~= nil then
        calls[#calls + 1] = value
        if not state.fail then state.logging = value end
    end
    return state.logging
end
function print(message) messages[#messages + 1] = message end
local function reset(inside, kind, dead, logging)
    state = {inside=inside, kind=kind, dead=dead, logging=logging}
    calls, messages, events = {}, {}, {}
    dofile("AutoInstanceCombatLog/AutoInstanceCombatLog.lua")
end
local function fire(event)
    assert(events[event], event)
    callback(nil, event)
end

reset(true, "party", false, false)
fire("PLAYER_ENTERING_WORLD"); assert(state.logging and #calls == 1)
fire("PLAYER_ENTERING_WORLD"); assert(#calls == 1)
state.dead = true
state.inside, state.kind = false, "none"
fire("PLAYER_ENTERING_WORLD"); fire("PLAYER_ALIVE")
assert(state.logging and #calls == 1, "corpse run must keep logging")
state.inside, state.kind = true, "party"
fire("PLAYER_ENTERING_WORLD")
state.dead = false; fire("PLAYER_UNGHOST")
assert(state.logging and #calls == 1, "inside resurrection must keep logging")
state.inside, state.kind = false, "none"
fire("PLAYER_ENTERING_WORLD"); assert(not state.logging and #calls == 2)

reset(false, "none", true, true)
fire("PLAYER_ENTERING_WORLD"); assert(state.logging, "reload as ghost")
state.dead = false; fire("PLAYER_UNGHOST")
assert(not state.logging, "outside resurrection stops logging")

for _, kind in ipairs({"party", "raid"}) do
    reset(true, kind, false, false)
    fire("PLAYER_ENTERING_WORLD"); assert(state.logging)
    reset(true, kind, true, true)
    fire("PLAYER_ENTERING_WORLD"); assert(state.logging and #calls == 0)
end
for _, kind in ipairs({"none", "pvp", "arena", "scenario"}) do
    reset(kind ~= "none", kind, false, false)
    fire("PLAYER_ENTERING_WORLD"); assert(not state.logging and #calls == 0)
    reset(kind ~= "none", kind, false, true)
    fire("PLAYER_ENTERING_WORLD"); assert(not state.logging and #calls == 1)
end
reset(false, "none", true, false)
fire("PLAYER_ENTERING_WORLD"); assert(not state.logging and #calls == 0)
reset(true, "party", false, false); state.fail = true
fire("PLAYER_ENTERING_WORLD")
assert(not state.logging and messages[1]:find("Could not enable"))
reset(false, "none", false, true); state.fail = true
fire("PLAYER_ENTERING_WORLD")
assert(state.logging and messages[1]:find("Could not disable"))
io.write("PASS: entry, death/ghost run, resurrection, exit, reload, instance filters, idempotence, logger failures\n")
