fx_version "adamant"
game "gta5"

author "KraKss#0667"
description "Go Fast RageUI V2"
version "1.0"

lua54 "on"

shared_scripts { 
    "shared/config.lua",
}

client_scripts {
	"src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/UIHeritage.lua",
    "client/cl.lua"
}

server_scripts {
    "server/sv.lua",
}