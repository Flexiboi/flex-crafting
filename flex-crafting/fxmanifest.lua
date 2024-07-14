fx_version "bodacious"
game "gta5"
lua54 "yes"

author "flexiboi"
description "Flex-craftring"
version "1.0.0"

shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
    'locales/nl.lua',
}

server_scripts {
    'server/main.lua',
}

client_scripts {
    'client/place.lua',
	'client/main.lua',
}

escrow_ignore {
	'locales/*.lua',
	'config.lua',
}

files {
    'stream/bzzz_electro_prop_3dprinter.ytyp'
}

data_file "DLC_ITYP_REQUEST" "stream/bzzz_electro_prop_3dprinter.ytyp"


dependencies {
	'qb-core'
}