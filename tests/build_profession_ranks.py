import os

from build_utils import WoWTables

data_folder = os.path.realpath(os.path.join(os.path.dirname(__file__), '..', 'data'))
textures = None
for version in ['classic', 'wrath', 'cata', 'mists', 'retail']:
    print('Build %s' % version)
    tables = WoWTables(data_folder=data_folder, game=version)
    if not textures:
        textures = tables.art_textures()
        textures = dict(zip(textures.values(), textures.keys()))

    skills = tables.get_db_table('skillline')
    abilities = list(tables.get_db_table('skilllineability'))

    profession_ranks = {}
    profession_info = {'professions': {}}

    for skill in skills:
        rank = 1
        if skill['CategoryID'] != '11':
            continue
        info = {'name': skill['DisplayName_lang'],
                'icon': int(skill['SpellIconFileID'])
                }
        if info['icon'] != 0:
            info['iconFile'] = textures[info['icon']]
        profession_info['professions'][int(skill['ID'])] = info

        profession_ranks[skill['DisplayName_lang']] = {}
        for ability in abilities:
            if ability['SkillLine'] != skill['ID']:
                continue
            if ability['SupercedesSpell'] == '0':
                continue
            if rank == 1:
                profession_ranks[skill['DisplayName_lang']][1] = int(ability['SupercedesSpell'])
                rank += 1
            profession_ranks[skill['DisplayName_lang']][rank] = int(ability['Spell'])
            rank += 1

    tables.save(profession_ranks, 'ProfessionRanks-' + version, save_json=False)
    tables.save(profession_info, 'ProfessionInfo-' + version, save_json=False)
