ESX = nil
TriggerEvent(Config.GetSharedObject, function(obj) ESX = obj end)

ESX.RegisterServerCallback('gdx_tab:get_user', function(source, cb)
    local data = ESX.GetPlayerFromId(source)
    local identifier = data.identifier
    cb(identifier)
end)

 ESX.RegisterServerCallback('gdx_tab:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
        local items = xPlayer.getInventoryItem(item)

        if items == nil then
            cb(0)
        else
            cb(items.count)
        end
end)