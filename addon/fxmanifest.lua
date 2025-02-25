fx_version 'bodacious'
games {'gta5'}
version '1.0.1'
lua54 'yes'
author 'Addon pack by fiveguard france'
description 'Addon pack by Fg france. Anti-CarryVehicle/Anti-Stopper/Rtx-ThemePark Fix/Custom Ace Permissions/TxAdmin Permissions/Anti Model Detector with fiveguard'

shared_scripts { 
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'sv_config.lua',
    'server/sv_main.lua',
    'server/sv_anticarry.lua',
    'server/sv_antimodeldetector.lua',
    'server/sv_antistopper.lua',
    'server/sv_permissionscustom.lua',
    'server/sv_rcore.lua',
    'server/sv_rtxthemepark.lua',
    'server/sv_txadmin.lua',
}

data_file "DLC_ITYP_REQUEST" "stream/mads_no_exp_pumps.ytyp"