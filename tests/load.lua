loadfile('build_utils/wow_api/constants.lua')()
loadfile('build_utils/wow_api/functions.lua')()
if os.getenv('GAME_VERSION') == 'retail' then
    loadfile('build_utils/wow_api/profession_api_retail.lua')()
else
    loadfile('build_utils/wow_api/profession_api_classic.lua')()
    loadfile('build_utils/wow_api/skills.lua')()
end
loadfile('build_utils/utils/load_toc.lua')('../LibProfessions.toc')