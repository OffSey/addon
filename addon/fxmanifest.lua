fx_version 'bodacious'
games {'gta5'}
version '1.0.0'
lua54 'yes'
author 'Addon pack by fiveguard france'
description 'Addon pack by Fg france. Anti-CarryVehicle/Anti-Stopper/Rtx-ThemePark Fix/Custom Ace Permissions/TxAdmin Permissions with fiveguard'

shared_scripts { 
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

data_file "DLC_ITYP_REQUEST" "stream/mads_no_exp_pumps.ytyp"