fx_version 'cerulean'
game 'gta5'
version "1.4.1"
lua54 'yes'
author 'Offsey & Jeakels discord.gg/fiveguard'
description 'Addon pack for fiveguard'

data_file "DLC_ITYP_REQUEST" "stream/mads_no_exp_pumps.ytyp"

shared_script 'shared.lua'

server_scripts {
    'server/sv_main.lua',
    'server/sv_antiCarry.lua',
    'server/sv_antiExplosion.lua',
    'server/sv_antiPedManipulation.lua',
    'server/sv_antiStopper.lua',
    'server/sv_backlistModels.lua',
    'server/sv_bypass.lua',
    'server/sv_checkNicknames.lua',
    'server/sv_easyPermissions.lua',
    'server/sv_heartBeat.lua',
    'server/sv_nativePermissions.lua',
    'server/sv_vehicleProtection.lua',
    'server/sv_weaponProtection.lua',
}

client_scripts {
    'client/cl_main.lua',
    'client/cl_antiCarry.lua',
    'client/cl_antiPedManipulation.lua',
    'client/cl_antiSafeSpawn.lua',
    'client/cl_antiStopper.lua',
    'client/cl_bypass.lua',
    'client/cl_heartBeat.lua',
    'client/cl_vehicleProtection.lua',
    'client/cl_weaponProtection.lua',
}

file 'config.lua'
file 'xss.lua'
file 'bypassNative.lua'
