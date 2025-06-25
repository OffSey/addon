fx_version 'cerulean'
game 'gta5'
version "1.4.0"
lua54 'yes'
author 'Offsey & Jeakels discord.gg/fiveguard'
description 'Addon pack for fiveguard'

data_file "DLC_ITYP_REQUEST" "stream/mads_no_exp_pumps.ytyp"

server_scripts {
    'callbacks/sv_callback.lua',
    'server/*.lua'
}

client_scripts {
    'callbacks/cl_callback.lua'
}

files {
    'config.lua',
    'client/*.lua'
}
