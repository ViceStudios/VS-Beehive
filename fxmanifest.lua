fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'ViceStudios'
description 'QB-Core Beehive Harvesting and Honey Selling Script'
version '1.0.0'

dependencies {
    'qb-core',
    'qb-target'
}

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}
