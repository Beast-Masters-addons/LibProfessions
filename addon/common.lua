_G['LibProfessionsCommon-@project-version@'] = {}
local common = _G['LibProfessionsCommon-@project-version@']
common.version = '@project-version@'

common.utils = _G['BMUtils']
common.utils = _G.LibStub("BM-utils-1")

common.is_classic = common.utils:IsWoWClassic()
