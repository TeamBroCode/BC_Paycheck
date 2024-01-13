fx_version "cerulean"
game "gta5"

author "Team BroCode"
description "Paycheck Script for QBCore"
version "1.0.0"
lua54 "yes"

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua'
}

dependencies {
    'ox_lib'
}

use_experimental_fxv2_oal "yes"
