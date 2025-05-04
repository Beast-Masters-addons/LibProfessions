local major, minor = _G['BMUtils-Version'].parse_version('@project-version@')
---@class LibProfessionsCommon
local lib = _G.LibStub:NewLibrary("LibProfessions-" .. major, minor)
if not lib then
    -- luacov: disable
    return    -- already loaded and no upgrade necessary
    -- luacov: enable
end
_G['LibProfessions-@project-version@'] = lib

lib.name = ...
lib.version = '@project-version@'

---@type boolean Is WoW Classic
lib.is_classic = _G.WOW_PROJECT_ID ~= _G.WOW_PROJECT_MAINLINE

---@type LibProfessionsCurrentProfession
lib.currentProfession = {}
---@type LibProfessionAPI
lib.api = {}