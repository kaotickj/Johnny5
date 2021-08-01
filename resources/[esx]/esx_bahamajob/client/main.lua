local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData              = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local Blips                   = {}

local isBarman                = false
local isInMarker              = false
local isInPublicMarker        = false
local hintIsShowed            = false
local hintToDisplay           = "no hint to display"

ESX                           = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

function IsJobTrue()
    if PlayerData ~= nil then
        local IsJobTrue = false
        if PlayerData.job ~= nil and PlayerData.job.name == 'bahama' then
            IsJobTrue = true
        end
        return IsJobTrue
    end
end

function IsGradeBoss()
    if PlayerData ~= nil then
        local IsGradeBoss = false
        if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'viceboss' then
            IsGradeBoss = true
        end
        return IsGradeBoss
    end
end

function SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 0,
    modBrakes       = 0,
    modTransmission = 0,
    modSuspension   = 0,
    modTurbo        = false,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


function OpenCloakroomMenu()

  local elements = {
    {label = _U('citizen_wear'), value = 'citizen_wear'},
    }
    
    if PlayerData.job.grade_name =='barman' then   
        table.insert(elements, {label =('Tenue Barman'), value = 'barman_outfit'})
    end
    
    if PlayerData.job.grade_name =='dj' then   
        table.insert(elements, {label =('Tenue DJ'), value = 'dj_outfit_1'})
    end
    
    if PlayerData.job.grade_name =='secu' then  
        table.insert(elements, {label =('Tenue Sécurité'), value = 'secu_outfit_2'})
    end
    
        if PlayerData.job.grade_name =='viceboss' then 
        table.insert(elements, {label =('Tenue de Co-gérant'), value = 'viceboss_outfit_3'})
    end
    
    if PlayerData.job.grade_name =='boss' then    
        table.insert(elements, {label =('Tenue Boss'), value = 'boss_outfit_4'})
    end

  ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'cloakroom',
      {
        title    = _U('cloakroom'),
        align    = 'top-left',
        elements = elements,
        },

        function(data, menu)

      --menu.close()
	  
        if data.current.value == 'citizen_wear' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerServerEvent("player:serviceOff", "bahama")

                local playerPed = GetPlayerPed(-1)
                TriggerEvent('skinchanger:loadSkin', skin)
                ClearPedBloodDamage(playerPed)
                ResetPedVisibleDamage(playerPed)
                ClearPedLastWeaponDamage(playerPed)

                ResetPedMovementClipset(playerPed, 0)

                isBarman = false
            end)
        
        elseif data.current.value == 'barman_outfit' then
            TriggerEvent('skinchanger:getSkin', function(skin)
             TriggerServerEvent("player:serviceOn", "bahama")

        
                if skin.sex == 0 then

                    local clothesSkin = {
                        ['tshirt_1'] = 6, ['tshirt_2'] = 0,
                        ['torso_1'] = 11, ['torso_2'] = 0,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 11,
                        ['pants_1'] = 24, ['pants_2'] = 1,
                        ['shoes_1'] = 10, ['shoes_2'] = 0,
                        ['chain_1'] = 22, ['chain_2'] = 1
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

                else

                    local clothesSkin = {
                        ['tshirt_1'] = 24, ['tshirt_2'] = 0,
                        ['torso_1'] = 28, ['torso_2'] = 0,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 0,
                        ['pants_1'] = 6, ['pants_2'] = 1,
                        ['shoes_1'] = 29, ['shoes_2'] = 0,
                        ['chain_1'] = 0, ['chain_2'] = 0
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

                end

                local playerPed = GetPlayerPed(-1)
                ClearPedBloodDamage(playerPed)
                ResetPedVisibleDamage(playerPed)
                ClearPedLastWeaponDamage(playerPed)

                ResetPedMovementClipset(playerPed, 0)

                isBarman = true

            end) 
        elseif data.current.value == 'dj_outfit_1' then

            TriggerEvent('skinchanger:getSkin', function(skin)
              TriggerServerEvent("player:serviceOn", "bahama")


                local playerPed = GetPlayerPed(-1)

                if skin.sex == 0 then

                    local clothesSkin = {
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                        ['torso_1'] = 143, ['torso_2'] = 5,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 2,
                        ['pants_1'] = 71, ['pants_2'] = 0,
                        ['shoes_1'] = 4, ['shoes_2'] = 0,
                        ['chain_1'] = 124, ['chain_2'] = 1
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

                    RequestAnimSet("MOVE_M@POSH@")
                    while not HasAnimSetLoaded("MOVE_M@POSH@") do
                      Citizen.Wait(0)
                    end
                    SetPedMovementClipset(playerPed, "MOVE_M@POSH@", true)

                else

                    local clothesSkin = {
                        ['tshirt_1'] = 2, ['tshirt_2'] = 0,
                        ['torso_1'] = 140, ['torso_2'] = 5,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 0,
                        ['pants_1'] = 76, ['pants_2'] = 0,
                        ['shoes_1'] = 3, ['shoes_2'] = 3,
                        ['chain_1'] = 94, ['chain_2'] = 0
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

                    RequestAnimSet("MOVE_F@POSH@")
                    while not HasAnimSetLoaded("MOVE_F@POSH@") do
                      Citizen.Wait(0)
                    end
                    SetPedMovementClipset(playerPed, "MOVE_F@POSH@", true)

                end

                ClearPedBloodDamage(playerPed)
                ResetPedVisibleDamage(playerPed)
                ClearPedLastWeaponDamage(playerPed)

                isBarman = false

            end)
        elseif data.current.value == 'secu_outfit_2' then
            
            TriggerEvent('skinchanger:getSkin', function(skin)
            	  TriggerServerEvent("player:serviceOn", "bahama")


                local playerPed = GetPlayerPed(-1)

                if skin.sex == 0 then

                    local clothesSkin = {
                        ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                        ['torso_1'] = 129, ['torso_2'] = 0,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 1,
                        ['pants_1'] = 4, ['pants_2'] = 0,
                        ['shoes_1'] = 12, ['shoes_2'] = 6,
                        ['chain_1'] = 0, ['chain_2'] = 0
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

                    RequestAnimSet("MOVE_M@POSH@")
                    while not HasAnimSetLoaded("MOVE_M@POSH@") do
                      Citizen.Wait(0)
                    end
                    SetPedMovementClipset(playerPed, "MOVE_M@POSH@", true)

                else

                    local clothesSkin = {
                        ['tshirt_1'] = 2, ['tshirt_2'] = 0,
                        ['torso_1'] = 127, ['torso_2'] = 0,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 3,
                        ['pants_1'] = 77, ['pants_2'] = 0,
                        ['shoes_1'] = 56, ['shoes_2'] = 0,
                        ['chain_1'] = 10, ['chain_2'] = 0
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

                    RequestAnimSet("MOVE_F@POSH@")
                    while not HasAnimSetLoaded("MOVE_F@POSH@") do
                      Citizen.Wait(0)
                    end
                    SetPedMovementClipset(playerPed, "MOVE_F@POSH@", true)

                end

                ClearPedBloodDamage(playerPed)
                ResetPedVisibleDamage(playerPed)
                ClearPedLastWeaponDamage(playerPed)

                isBarman = false

            end)

        elseif data.current.value == 'viceboss_outfit_3' then

            TriggerEvent('skinchanger:getSkin', function(skin)
            	  TriggerServerEvent("player:serviceOn", "bahama")


                local playerPed = GetPlayerPed(-1)

                if skin.sex == 0 then

                    local clothesSkin = {
                        ['tshirt_1'] = 4, ['tshirt_2'] = 1,
                        ['torso_1'] = 23, ['torso_2'] = 2,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 1,
                        ['pants_1'] = 25, ['pants_2'] = 5,
                        ['shoes_1'] = 20, ['shoes_2'] = 3,
                        ['chain_1'] = 0, ['chain_2'] = 0
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

                    RequestAnimSet("MOVE_M@POSH@")
                    while not HasAnimSetLoaded("MOVE_M@POSH@") do
                      Citizen.Wait(0)
                    end
                    SetPedMovementClipset(playerPed, "MOVE_M@POSH@", true)

                else

                    local clothesSkin = {
                        ['tshirt_1'] = 38, ['tshirt_2'] = 3,
                        ['torso_1'] = 92, ['torso_2'] = 1,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 3,
                        ['pants_1'] = 7, ['pants_2'] = 0,
                        ['shoes_1'] = 20, ['shoes_2'] = 6,
                        ['chain_1'] = 0, ['chain_2'] = 0
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

                    RequestAnimSet("MOVE_F@POSH@")
                    while not HasAnimSetLoaded("MOVE_F@POSH@") do
                      Citizen.Wait(0)
                    end
                    SetPedMovementClipset(playerPed, "MOVE_F@POSH@", true)

                end

                ClearPedBloodDamage(playerPed)
                ResetPedVisibleDamage(playerPed)
                ClearPedLastWeaponDamage(playerPed)

                isBarman = false

            end)

        
        elseif data.current.value == 'boss_outfit_4' then
			
            TriggerEvent('skinchanger:getSkin', function(skin)
            	  TriggerServerEvent("player:serviceOn", "bahama")


                local playerPed = GetPlayerPed(-1)

                if skin.sex == 0 then

                    local clothesSkin = {
                        ['tshirt_1'] = 10, ['tshirt_2'] = 7,
                        ['torso_1'] = 23, ['torso_2'] = 3,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 4,
                        ['pants_1'] = 25, ['pants_2'] = 5,
                        ['shoes_1'] = 20, ['shoes_2'] = 3,
                        ['chain_1'] = 10, ['chain_2'] = 0
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

                    RequestAnimSet("MOVE_M@POSH@")
                    while not HasAnimSetLoaded("MOVE_M@POSH@") do
                      Citizen.Wait(0)
                    end
                    SetPedMovementClipset(playerPed, "MOVE_M@POSH@", true)

                else

                    local clothesSkin = {
                        ['tshirt_1'] = 38, ['tshirt_2'] = 7,
                        ['torso_1'] = 7, ['torso_2'] = 1,
                        ['decals_1'] = 0, ['decals_2'] = 0,
                        ['arms'] = 3,
                        ['pants_1'] = 37, ['pants_2'] = 5,
                        ['shoes_1'] = 13, ['shoes_2'] = 7,
                        ['chain_1'] = 21, ['chain_2'] = 0
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

                    RequestAnimSet("MOVE_F@POSH@")
                    while not HasAnimSetLoaded("MOVE_F@POSH@") do
                      Citizen.Wait(0)
                    end
                    SetPedMovementClipset(playerPed, "MOVE_F@POSH@", true)

                end

                ClearPedBloodDamage(playerPed)
                ResetPedVisibleDamage(playerPed)
                ClearPedLastWeaponDamage(playerPed)

                isBarman = false
			end)

            

		end
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
    )

end

function OpenVaultMenu()

  if Config.EnableVaultManagement then

    local elements = {
      {label = _U('get_weapon'), value = 'get_weapon'},
      {label = _U('put_weapon'), value = 'put_weapon'},
      {label = _U('get_object'), value = 'get_stock'},
      {label = _U('put_object'), value = 'put_stock'}
    }
    

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vault',
      {
        title    = _U('vault'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'get_weapon' then
          OpenGetWeaponMenu()
        end

        if data.current.value == 'put_weapon' then
          OpenPutWeaponMenu()
        end

        if data.current.value == 'put_stock' then
           OpenPutStocksMenu()
        end

        if data.current.value == 'get_stock' then
           OpenGetStocksMenu()
        end

      end,
      
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = _U('open_vault')
        CurrentActionData = {}
      end
    )

  end

end

function OpenFridgeMenu()

    local elements = {
      {label = _U('get_object'), value = 'get_stock'},
      {label = _U('put_object'), value = 'put_stock'}
    }
    

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fridge',
      {
        title    = _U('fridge'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'put_stock' then
           OpenPutFridgeStocksMenu()
        end

        if data.current.value == 'get_stock' then
           OpenGetFridgeStocksMenu()
        end

      end,
      
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_fridge'
        CurrentActionMsg  = _U('open_fridge')
        CurrentActionData = {}
      end
    )

end


function OpenVehicleSpawnerMenu()

  local vehicles = Config.Zones.Vehicles

  ESX.UI.Menu.CloseAll()

  if Config.EnableSocietyOwnedVehicles then

    local elements = {}

    ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

      for i=1, #garageVehicles, 1 do
        table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_spawner',
        {
          title    = _U('vehicle_menu'),
          align    = 'top-left',
          elements = elements,
        },
        function(data, menu)

          menu.close()

          local vehicleProps = data.current.value
          ESX.Game.SpawnVehicle(vehicleProps.model, vehicles.SpawnPoint, vehicles.Heading, function(vehicle)
              ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
              local playerPed = GetPlayerPed(-1)
              --TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)  -- teleport into vehicle
          end)            

          TriggerServerEvent('esx_society:removeVehicleFromGarage', 'bahama', vehicleProps)

        end,
        function(data, menu)

          menu.close()

          CurrentAction     = 'menu_vehicle_spawner'
          CurrentActionMsg  = _U('vehicle_spawner')
          CurrentActionData = {}

        end
      )

    end, 'bahama')

  else

    local elements = {}

    for i=1, #Config.AuthorizedVehicles, 1 do
      local vehicle = Config.AuthorizedVehicles[i]
      table.insert(elements, {label = vehicle.label, value = vehicle.name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = _U('vehicle_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        local model = data.current.value

        local vehicle = GetClosestVehicle(vehicles.SpawnPoint.x,  vehicles.SpawnPoint.y,  vehicles.SpawnPoint.z,  3.0,  0,  71)

        if not DoesEntityExist(vehicle) then

          local playerPed = GetPlayerPed(-1)

          if Config.MaxInService == -1 then

            ESX.Game.SpawnVehicle(model, {
              x = vehicles.SpawnPoint.x,
              y = vehicles.SpawnPoint.y,
              z = vehicles.SpawnPoint.z
            }, vehicles.Heading, function(vehicle)
              --TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1) -- teleport into vehicle
              SetVehicleMaxMods(vehicle)
              SetVehicleDirtLevel(vehicle, 0)
            end)

          else

            ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

              if canTakeService then

                ESX.Game.SpawnVehicle(model, {
                  x = vehicles[partNum].SpawnPoint.x,
                  y = vehicles[partNum].SpawnPoint.y,
                  z = vehicles[partNum].SpawnPoint.z
                }, vehicles[partNum].Heading, function(vehicle)
                  --TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)  -- teleport into vehicle
                  SetVehicleMaxMods(vehicle)
                  SetVehicleDirtLevel(vehicle, 0)
                end)

              else
                ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
              end

            end, 'etat')

          end

        else
          ESX.ShowNotification(_U('vehicle_out'))
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('vehicle_spawner')
        CurrentActionData = {}

      end
    )

  end

end

function OpenSocietyActionsMenu()

  local elements = {}

  table.insert(elements, {label = _U('billing'),    value = 'billing'})
  if (isBarman or IsGradeBoss()) then
    table.insert(elements, {label = _U('crafting'),    value = 'menu_crafting'})
  end

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'bahama_actions',
    {
      title    = _U('bahama'),
      align    = 'top-left',
      elements = elements
    },
    function(data, menu)

      if data.current.value == 'billing' then
        OpenBillingMenu()
      end

      if data.current.value == 'menu_crafting' then
        
          ESX.UI.Menu.Open(
              'default', GetCurrentResourceName(), 'menu_crafting',
              {
                  title = _U('crafting'),
                  align = 'top-left',
                  elements = {
                      {label = _U('jagerbomb'),     value = 'jagerbomb'},
                      {label = _U('golem'),         value = 'golem'},
                      {label = _U('whiskycoca'),    value = 'whiskycoca'},
                      {label = _U('vodkaenergy'),   value = 'vodkaenergy'},
                      {label = _U('vodkafruit'),    value = 'vodkafruit'},
                      {label = _U('rhumfruit'),     value = 'rhumfruit'},
                      {label = _U('teqpaf'),        value = 'teqpaf'},
                      {label = _U('rhumcoca'),      value = 'rhumcoca'},
                      {label = _U('mojito'),        value = 'mojito'},
                      {label = _U('coffee'),        value = 'coffee'},
                      {label = _U('mixapero'),      value = 'mixapero'},
                      {label = _U('metreshooter'),  value = 'metreshooter'},
                      {label = _U('jagercerbere'),  value = 'jagercerbere'},
                  }
              },
              function(data2, menu2)
            
                TriggerServerEvent('esx_bahamajob:craftingCoktails', data2.current.value)
                animsAction({ lib = "mini@drinking", anim = "shots_barman_b" })
      
              end,
              function(data2, menu2)
                  menu2.close()
              end
          )
      end
     
    end,
    function(data, menu)

      menu.close()

    end
  )

end

function OpenBillingMenu()

  ESX.UI.Menu.Open(
    'dialog', GetCurrentResourceName(), 'billing',
    {
      title = _U('billing_amount')
    },
    function(data, menu)
    
      local amount = tonumber(data.value)
      local player, distance = ESX.Game.GetClosestPlayer()

      if player ~= -1 and distance <= 3.0 then

        menu.close()
        if amount == nil then
            ESX.ShowNotification(_U('amount_invalid'))
        else
            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_bahama', _U('billing'), amount)
        end

      else
        ESX.ShowNotification(_U('no_players_nearby'))
      end

    end,
    function(data, menu)
        menu.close()
    end
  )
end

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_bahamajob:getStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('bahama_stock'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              OpenGetStocksMenu()

              TriggerServerEvent('esx_bahamajob:getStockItem', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutStocksMenu()

ESX.TriggerServerCallback('esx_bahamajob:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('inventory'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              OpenPutStocksMenu()

              TriggerServerEvent('esx_bahamajob:putStockItems', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenGetFridgeStocksMenu()

  ESX.TriggerServerCallback('esx_bahamajob:getFridgeStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fridge_menu',
      {
        title    = _U('bahama_fridge_stock'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'fridge_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              OpenGetStocksMenu()

              TriggerServerEvent('esx_bahamajob:getFridgeStockItem', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutFridgeStocksMenu()

ESX.TriggerServerCallback('esx_bahamajob:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fridge_menu',
      {
        title    = _U('fridge_inventory'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'fridge_menu_put_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              OpenPutFridgeStocksMenu()

              TriggerServerEvent('esx_bahamajob:putFridgeStockItems', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_bahamajob:getVaultWeapons', function(weapons)

    local elements = {}

    for i=1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vault_get_weapon',
      {
        title    = _U('get_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('esx_bahamajob:removeVaultWeapon', function()
          OpenGetWeaponMenu()
        end, data.current.value)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutWeaponMenu()

  local elements   = {}
  local playerPed  = GetPlayerPed(-1)
  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'vault_put_weapon',
    {
      title    = _U('put_weapon_menu'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_bahamajob:addVaultWeapon', function()
        OpenPutWeaponMenu()
      end, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end



function OpenShopMenu(zone)

    local elements = {}
    for i=1, #Config.Zones[zone].Items, 1 do

        local item = Config.Zones[zone].Items[i]

        table.insert(elements, {
            label     = item.label  ..  ' € '  .. item.price .. '',
            realLabel = item.label,
            value     = item.name,
            price     = item.price
        })

    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'bahama_shop',
        {
            title    = _U('shop'),
            elements = elements
        },
        function(data, menu)
            TriggerServerEvent('esx_bahamajob:buyItem', data.current.value, data.current.price, data.current.realLabel)
        end,
        function(data, menu)
            menu.close()
        end
    )

end


function animsAction(animObj)
    Citizen.CreateThread(function()
        if not playAnim then
            local playerPed = GetPlayerPed(-1);
            if DoesEntityExist(playerPed) then -- Check if ped exist
                dataAnim = animObj

                -- Play Animation
                RequestAnimDict(dataAnim.lib)
                while not HasAnimDictLoaded(dataAnim.lib) do
                    Citizen.Wait(0)
                end
                if HasAnimDictLoaded(dataAnim.lib) then
                    local flag = 0
                    if dataAnim.loop ~= nil and dataAnim.loop then
                        flag = 1
                    elseif dataAnim.move ~= nil and dataAnim.move then
                        flag = 49
                    end

                    TaskPlayAnim(playerPed, dataAnim.lib, dataAnim.anim, 8.0, -8.0, -1, flag, 0, 0, 0, 0)
                    playAnimation = true
                end

                -- Wait end animation
                while true do
                    Citizen.Wait(0)
                    if not IsEntityPlayingAnim(playerPed, dataAnim.lib, dataAnim.anim, 3) then
                        playAnim = false
                        TriggerEvent('ft_animation:ClFinish')
                        break
                    end
                end
            end -- end ped exist
        end
    end)
end


AddEventHandler('esx_bahamajob:hasEnteredMarker', function(zone)
 
    if zone == 'BossActions' and IsGradeBoss() then
      CurrentAction     = 'menu_boss_actions'
      CurrentActionMsg  = _U('open_bossmenu')
      CurrentActionData = {}
    end

    if zone == 'Cloakrooms' then
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end

    if Config.EnableVaultManagement then
      if zone == 'Vaults' then
        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = _U('open_vault')
        CurrentActionData = {}
      end
    end

    if zone == 'Fridge' then
      CurrentAction     = 'menu_fridge'
      CurrentActionMsg  = _U('open_fridge')
      CurrentActionData = {}
    end

    if zone == 'Flacons' then
      CurrentAction     = 'menu_shop'
      CurrentActionMsg  = _U('shop_menu')
      CurrentActionData = {zone = zone}
    end

    if zone == 'NoAlcool' then
      CurrentAction     = 'menu_shop'
      CurrentActionMsg  = _U('shop_menu2')
      CurrentActionData = {zone = zone}   
    end

    if zone == 'Apero' then
      CurrentAction     = 'menu_shop'
      CurrentActionMsg  = _U('shop_menu3')
      CurrentActionData = {zone = zone}
    end

    if zone == 'Ice' then
      CurrentAction     = 'menu_shop'
      CurrentActionMsg  = _U('shop_menu4')
      CurrentActionData = {zone = zone}
    end    

    if zone == 'Vehicles' then
        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('vehicle_spawner')
        CurrentActionData = {}
    end

    if zone == 'VehicleDeleters' then

      local playerPed = GetPlayerPed(-1)

      if IsPedInAnyVehicle(playerPed,  false) then

        local vehicle = GetVehiclePedIsIn(playerPed,  false)

        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = _U('store_vehicle')
        CurrentActionData = {vehicle = vehicle}
      end

    end

    if Config.EnableHelicopters then
        if zone == 'Helicopters' then

          local helicopters = Config.Zones.Helicopters

          if not IsAnyVehicleNearPoint(helicopters.SpawnPoint.x, helicopters.SpawnPoint.y, helicopters.SpawnPoint.z,  3.0) then

            ESX.Game.SpawnVehicle('swift2', {
              x = helicopters.SpawnPoint.x,
              y = helicopters.SpawnPoint.y,
              z = helicopters.SpawnPoint.z
            }, helicopters.Heading, function(vehicle)
              SetVehicleModKit(vehicle, 0)
              SetVehicleLivery(vehicle, 0)
            end)

          end

        end

        if zone == 'HelicopterDeleters' then

          local playerPed = GetPlayerPed(-1)

          if IsPedInAnyVehicle(playerPed,  false) then

            local vehicle = GetVehiclePedIsIn(playerPed,  false)

            CurrentAction     = 'delete_vehicle'
            CurrentActionMsg  = _U('store_vehicle')
            CurrentActionData = {vehicle = vehicle}
          end

        end
    end


end)

AddEventHandler('esx_bahamajob:hasExitedMarker', function(zone)

    CurrentAction = nil
    ESX.UI.Menu.CloseAll()

end)

-- Create blips
Citizen.CreateThread(function()

    local blipMarker = Config.Blips.Blip
    local blipCoord = AddBlipForCoord(blipMarker.Pos.x, blipMarker.Pos.y, blipMarker.Pos.z)

    SetBlipSprite (blipCoord, blipMarker.Sprite)
    SetBlipDisplay(blipCoord, blipMarker.Display)
    SetBlipScale  (blipCoord, blipMarker.Scale)
    SetBlipColour (blipCoord, blipMarker.Colour)
    SetBlipAsShortRange(blipCoord, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('map_blip'))
    EndTextCommandSetBlipName(blipCoord)


end)

-- Display markers
Citizen.CreateThread(function()
    while true do

        Wait(0)
        if IsJobTrue() then

            local coords = GetEntityCoords(GetPlayerPed(-1))

            for k,v in pairs(Config.Zones) do
                if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
                    DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, false, false, false, false)
                end
            end

        end

    end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do

        Wait(0)
        if IsJobTrue() then

            local coords      = GetEntityCoords(GetPlayerPed(-1))
            local isInMarker  = false
            local currentZone = nil

            for k,v in pairs(Config.Zones) do
                if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                    isInMarker  = true
                    currentZone = k
                end
            end

            if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                HasAlreadyEnteredMarker = true
                LastZone                = currentZone
                TriggerEvent('esx_bahamajob:hasEnteredMarker', currentZone)
            end

            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('esx_bahamajob:hasExitedMarker', LastZone)
            end

        end

    end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlJustReleased(0,  Keys['E']) and IsJobTrue() then

        if CurrentAction == 'menu_cloakroom' then
            OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_vault' then
            OpenVaultMenu()
        end

        if CurrentAction == 'menu_fridge' then
            OpenFridgeMenu()
        end

        if CurrentAction == 'menu_shop' then
            OpenShopMenu(CurrentActionData.zone)
        end
        
        if CurrentAction == 'menu_vehicle_spawner' then
            OpenVehicleSpawnerMenu()
        end

        if CurrentAction == 'delete_vehicle' then

          if Config.EnableSocietyOwnedVehicles then

            local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
            TriggerServerEvent('esx_society:putVehicleInGarage', 'bahama', vehicleProps)

          else

            if
              GetEntityModel(vehicle) == GetHashKey('rentalbus')
            then
              TriggerServerEvent('esx_service:disableService', 'bahama')
            end

          end

          ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
        end


        if CurrentAction == 'menu_boss_actions' and IsGradeBoss() then

          local options = {
            wash      = Config.EnableMoneyWash,
          }

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:BossMenuOpen1', 'bahama', function(data, menu)

            menu.close()
            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = _U('open_bossmenu')
            CurrentActionData = {}

          end,options)

        end

        
        CurrentAction = nil

      end

    end

    if IsControlJustReleased(0,  Keys['F6']) and IsJobTrue() and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'bahama_actions') then
        OpenSocietyActionsMenu()
    end

  end
end)


-----------------------
----- TELEPORTERS -----

AddEventHandler('esx_bahamajob:teleportMarkers', function(position)
  SetEntityCoords(GetPlayerPed(-1), position.x, position.y, position.z)
end)

-- Show top left hint
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if hintIsShowed == true then
      SetTextComponentFormat("STRING")
      AddTextComponentString(hintToDisplay)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end
  end
end)

-- Display teleport markers
Citizen.CreateThread(function()
  while true do
    Wait(0)

    if IsJobTrue() then

        local coords = GetEntityCoords(GetPlayerPed(-1))
        for k,v in pairs(Config.TeleportZones) do
          if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
            DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
          end
        end

    end

  end
end)

local TeleportFromTo = {

    ["Bahama Mamas"] = {
        positionFrom = { ['x'] = -1389.1306152344, ['y'] = -585.53326416016, ['z'] = 29.99818115234, nom = "Entrer au Bahama Mamas"},
        positionTo = { ['x'] = -1387.0266113281, ['y'] = -588.84320068359, ['z'] = 29.99898062134, nom = "Sortir du Bahama Mamas"},
    },
    
}

Drawing = setmetatable({}, Drawing)
Drawing.__index = Drawing


function Drawing.draw3DText(x,y,z,textInput,fontId,scaleX,scaleY,r, g, b, a)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function Drawing.drawMissionText(m_text, showtime)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(m_text)
    DrawSubtitleTimed(showtime, 1)
end

------------------------------------------
------------------------------------------
------Modifier text-----------------------
------------------------------------------
------------------------------------------
function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    --DisplayHelpTextFromStringLabel(0, 0, 0, -1)           ---A 0 Enleve le son de la notif
end
------------------------------------------
------------------------------------------
------Modifier text-----------------------
------------------------------------------
------------------------------------------

function msginf(msg, duree)
    duree = duree or 500
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(msg)
    DrawSubtitleTimed(duree, 1)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2)
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        
        for k, j in pairs(TeleportFromTo) do
        
            --msginf(k .. " " .. tostring(j.positionFrom.x), 15000)
            if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 150.0) then
                DrawMarker(1, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1, 0, 0, 0, 0, 0, 0, 1.5001, 1.5001, 0.501, 117,202,93,255, 0, 0, 0,0)
                if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 5.0)then
                    -- Drawing.draw3DText(j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1.100, j.positionFrom.nom, 1, 0.2, 0.1, 255, 255, 255, 215)
                    if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 1.0)then
                        ClearPrints()
                        DisplayHelpText("Appuyez sur ~INPUT_PICKUP~ pour ~b~".. j.positionFrom.nom,1, 1, 0.5, 0.8, 0.9, 255, 255, 255, 255)
                        DrawSubtitleTimed(2000, 1)
                        if IsControlJustPressed(1, 38) then
                            DoScreenFadeOut(1000)
                            Citizen.Wait(2000)
                            SetEntityCoords(GetPlayerPed(-1), j.positionTo.x, j.positionTo.y, j.positionTo.z - 1)
                            DoScreenFadeIn(1000)
                        end
                    end
                end
            end
            
            if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 150.0) then
                DrawMarker(1, j.positionTo.x, j.positionTo.y, j.positionTo.z - 1, 0, 0, 0, 0, 0, 0, 1.5001, 1.5001, 0.501, 117,202,93,255, 0, 0, 0,0)
                if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 5.0)then
                    -- Drawing.draw3DText(j.positionTo.x, j.positionTo.y, j.positionTo.z - 1.100, j.positionTo.nom, 1, 0.2, 0.1, 255, 255, 255, 215)
                    if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 1.0)then
                        ClearPrints()
                        DisplayHelpText("Appuyez sur ~INPUT_PICKUP~ pour ~r~".. j.positionTo.nom,1, 1, 0.5, 0.8, 0.9, 255, 255, 255, 255)
                        DrawSubtitleTimed(2000, 1)
                        if IsControlJustPressed(1, 38) then
                            DoScreenFadeOut(1000)
                            Citizen.Wait(2000)
                            SetEntityCoords(GetPlayerPed(-1), j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1)
                            DoScreenFadeIn(1000)
                        end
                    end
                end
            end
        end
    end
end)

-- Activate teleport marker
Citizen.CreateThread(function()
  while true do
    Wait(0)
    local coords      = GetEntityCoords(GetPlayerPed(-1))
    local position    = nil
    local zone        = nil

    if IsJobTrue() then

        for k,v in pairs(Config.TeleportZones) do
          if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
            isInPublicMarker = true
            position = v.Teleport
            zone = v
            break
          else
            isInPublicMarker  = false
          end
        end

        if IsControlJustReleased(0, Keys["E"]) and isInPublicMarker then
          TriggerEvent('esx_bahamajob:teleportMarkers', position)
        end

        -- hide or show top left zone hints
        if isInPublicMarker then
          hintToDisplay = zone.Hint
          hintIsShowed = true
        else
          if not isInMarker then
            hintToDisplay = "no hint to display"
            hintIsShowed = false
          end
        end

    end

  end
end)

-----------------------
