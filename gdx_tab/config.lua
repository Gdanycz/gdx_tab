Config = {}

Config.ResourceName = GetCurrentResourceName() -- Do not touch
Config.GetSharedObject = "esx:getSharedObject"; -- Set your GetSharedObject
Config.Locale = "cs"; -- Set your locale | en, cs, other
Config.OpenKey = "home"; -- Set key to open the tablet, everyone can set their own key in the settings
Config.ItemName = "tablet"; -- Tablet item name
Config.Debug = false -- Enable or disable debug prints
Config.NotificationType = "esx" -- Set notification type | esx, t-notify, okok, other



-- Locales
Locales['en'] = {
  ['no_tablet'] = 'You don´t have your tablet with you',
}

Locales['cs'] = {
  ['no_tablet'] = 'Nemáš u sebe tablet',
}

Locales['other'] = {
  ['no_tablet'] = 'You don t have your tablet with you',
}