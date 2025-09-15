fx_version 'cerulean'
game 'gta5'

author 'Offsey & Jeakels discord.gg/fiveguard'
description 'Addon pack for fiveguard'
version "1.5.5"
lua54 'yes'
addon 'yes'

data_file "DLC_ITYP_REQUEST" "stream/mads_no_exp_pumps.ytyp"

shared_script 'shared.lua'

server_scripts {
    'server/sv_resourceManager.js',
    'server/sv_main.lua',
    'server/sv_antiExplosion.lua',
    'server/sv_antiThrow.lua',
    'server/sv_antiPedManipulation.lua',
    'server/sv_antiStopper.lua',
    'server/sv_backlistModels.lua',
    'server/sv_checkNicknames.lua',
    'server/sv_easyBypass.lua',
    'server/sv_easyPermissions.lua',
    'server/sv_heartbeat.lua',
    'server/sv_vehicleProtection.lua',
    'server/sv_weaponProtection.lua'
}

client_scripts {
    'client/cl_main.lua',
    'client/cl_antiThrow.lua',
    'client/cl_antiPedManipulation.lua',
    'client/cl_antiStopper.lua',
    'client/cl_easyBypass.lua',
    'client/cl_heartbeat.lua',
    'client/cl_vehicleProtection.lua',
    'client/cl_weaponProtection.lua'
}

file 'bypassNative.lua'
file 'config.lua'
file 'xss.lua'