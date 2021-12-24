fx_version 'adamant'
game 'gta5'

author 'Gdany#2835'
description 'Tablet script for my PD and EMS Database'
version '1.0.0'

ui_page "nui/ui.html"

client_scripts {
    'client.lua'
}
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'server.lua'
}

files {
    "nui/ui.html",
    "nui/material-icons.ttf",
    "nui/material-icons.css",
    "nui/loadscreen.jpg",
    "nui/close.jpg",
    "nui/fancy-crap.css",
    "nui/fancy-crap.js",
    "nui/jquery.min/js",
    "nui/bootstrap.min.css",
}
