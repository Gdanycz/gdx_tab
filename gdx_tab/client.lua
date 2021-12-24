ESX          = nil
local PlayerData                = {}
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.GetSharedObject, function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

Citizen.CreateThread(function()
    Wait(500)
    PlayerData.job = ESX.GetPlayerData().job
end)

local tabEnabled = false
local tabLoaded = true

function REQUEST_NUI_FOCUS(bool, steamid, typx)
    if bool == true then
        startAnim()
        Citizen.Wait(300)
        SetNuiFocus(bool, bool)
        print(steamid)
        SendNUIMessage({showtab = true, xsteamid = steamid, xtypx = typx})
    else
        SetNuiFocus(bool, bool)
        SendNUIMessage({hidetab = true})
    end
    return bool
end

RegisterNUICallback("tablet-status",function(data)
    if data.load then
        tabLoaded = true
        Debug("Tablet loaded")
    elseif data.hide then
        Debug("Hiding tablet")
        SetNuiFocus(false, false)
        tabEnabled = false
        Citizen.Wait(300)
        stopAnim()
    end
end)


Citizen.CreateThread(
    function()
        Wait(550)
        local l = 0
        local timeout = false
        while not tabLoaded do
            Citizen.Wait(0)
            l = l + 1
            if l > 500 then
                tabLoaded = true
                timeout = true
            end
        end

        if timeout == true then
            Debug("Failed to load tablet nui...")
        end

        Debug("The client lua for tablet loaded")

        REQUEST_NUI_FOCUS(false)

        while true do
            if (tabEnabled) then
                local ped = PlayerPedId()
                DisableControlAction(0, 1, tabEnabled) -- LookLeftRight
                DisableControlAction(0, 2, tabEnabled) -- LookUpDown
                DisableControlAction(0, 24, tabEnabled) -- Attack
                DisablePlayerFiring(ped, tabEnabled) -- Disable weapon firing
                DisableControlAction(0, 142, tabEnabled) -- MeleeAttackAlternate
                DisableControlAction(0, 106, tabEnabled) -- VehicleMouseControlOverride
            end
            Citizen.Wait(0)
        end
    end
)

RegisterKeyMapping("tablet", "Tablet", "keyboard", Config.OpenKey)

RegisterCommand("tablet", function(source, args, rawCommand)
    hasTablet(function (hasTablet)
      if hasTablet == true then
        ToogleTablet()
      else
        ShowNoTabletWarning()
      end
    end)
end)

function ShowNoTabletWarning ()
  if (ESX == nil) then return end
  Notif("Tablet", _U('no_tablet'), "error")
end

function hasTablet (cb)
  if (ESX == nil) then return cb(0) end
  ESX.TriggerServerCallback('gdx_tab:getItemAmount', function(qtty)
    cb(qtty > 0)
  end, Config.ItemName)
end

function ToogleTablet()
    if true then
        ESX.TriggerServerCallback('gdx_tab:get_user', function(cb)
            tabEnabled = not tabEnabled
            Debug("Tab identifier: "..cb.." JobName: "..PlayerData.job.name)
            REQUEST_NUI_FOCUS(tabEnabled, cb, PlayerData.job.name)
            Debug("The tablet state is: " .. tostring(tabEnabled))
            Citizen.Wait(0)
        end, GetPlayerServerId(PlayerId()))
    end
end

function startAnim()
    Citizen.CreateThread(function()
        RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
        while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
            Citizen.Wait(0)
        end
        attachObject()
        TaskPlayAnim(PlayerPedId(), "amb@world_human_seat_wall_tablet@female@base", "base", 8.0, -8.0, -1, 50, 0, false, false, false)
    end)
end

function attachObject()
    tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(tab, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)
end

function stopAnim()
    StopAnimTask(PlayerPedId(), "amb@world_human_seat_wall_tablet@female@base", "base", 8.0, -8.0, -1, 50, 0, false, false, false)
    DeleteEntity(tab)
end

function Notif(title, text, type)
    if Config.NotificationType == "esx" then
        ESX.ShowNotification(text)
    elseif Config.NotificationType == "t-notify" then
        exports['t-notify']:Custom({
            style = 'info',
            duration = 2500,
            title = title,
            message = text,
            sound = true
        })
    elseif Config.NotificationType == "okok" then
        exports['okokNotify']:Alert(title, text, 2500, type)
    elseif Config.NotificationType == "other" then
        -- insert here your own notification
    end
end

function Debug(text)
    if Config.Debug then
        print("^4["..Config.ResourceName.."]^0 "..text)
    end
end