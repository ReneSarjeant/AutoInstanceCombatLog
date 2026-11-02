# Auto Instance Combat Log

A small WoW Forever addon that controls the client's built-in combat logger.

- Enter a dungeon or raid: logging turns on immediately.
- Die inside: logging stays on.
- Release and run back as a ghost: logging stays on, including outside the entrance.
- Resurrect inside: logging stays on.
- Leave alive, or resurrect outside: logging turns off.
- Battlegrounds, arenas, and the open world do not start logging.
- Login and UI reload check your current location and death state.

No timers, saved settings, dependencies, or slash commands. It does not change
AutoChatLog or chat logging. It does not enable Advanced Combat Logging or read
restricted combat events. The client writes combat log files in its Logs folder.

## Installation

On GitHub, select **Code → Download ZIP**, then extract it. Copy the inner
AutoInstanceCombatLog folder into your Forever
client's Interface/AddOns folder. The .toc and .lua files must be directly inside
Interface/AddOns/AutoInstanceCombatLog, without another nested folder.
Restart the client after first installation and enable Auto Instance Combat Log
in the AddOns list. Use /reload for later file updates.

To stop automatic control, disable this addon and reload the UI. If logging is
still on, use /combatlog once to toggle it off. This addon deliberately turns off
any active combat logging when you are alive outside a dungeon or raid, including
logging started manually or by another addon; avoid competing logging addons.

## Compatibility and validation

Targets Forever interface 16001 (1.60.1). LoggingCombat calls were checked against
Blizzard's UI source mirrored in Gethe/wow-ui-source, forever branch. The addon
uses IsInInstance and the player's UnitIsDeadOrGhost state, plus
PLAYER_ENTERING_WORLD, PLAYER_ALIVE, and PLAYER_UNGHOST events.

Source baseline reviewed: 1.60.1.70532, commit
ca8368f2f2380cbe696854f7f2646387c278a61b.
https://github.com/Gethe/wow-ui-source/tree/ca8368f2f2380cbe696854f7f2646387c278a61b

Mocked Lua tests cover dungeon/raid entry, death and ghost runs, resurrection
inside/outside, leaving alive, login/reload, excluded instance types, repeated
events, and logger failures. These are logic tests, not in-game certification.

In-game check: enter a dungeon, die and release, return and resurrect, then leave
alive. Logging should stay enabled through the corpse run and stop only while
alive outside. Repeat with a UI reload as a ghost. Verify that the client creates
combat log output. No addon can preserve logging across a full client restart
without explicitly turning it on again; a new session outside as a ghost leaves
the client's existing state unchanged until you re-enter a dungeon or raid.

Version 1.0. Free to use, modify, and redistribute; provided without warranty.

## Development

Run `lua tests/test_instance_log.lua` from the repository root (or use
`texlua tests/test_instance_log.lua` if Lua is provided by TeX Live).

## License and support

MIT License; see LICENSE. This is a personal addon, provided as-is.
There is no guarantee of updates or support after Blizzard client changes.
You are welcome to fork it and maintain your own version.
