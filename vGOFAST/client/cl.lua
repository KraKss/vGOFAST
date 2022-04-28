--   _  __          _  __        
--  | |/ /         | |/ /        
--  | ' / _ __ __ _| ' / ___ ___ 
--  |  < | '__/ _` |  < / __/ __|
--  | . \| | | (_| | . \\__ \__ \
--  |_|\_\_|  \__,_|_|\_\___/___/                                                            

local open = false

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local mainMenu = RageUI.CreateMenu(Config.Menu.Title, Config.Menu.Subtitle)
local mainMenu2 = RageUI.CreateMenu(Config.Menu.Title, Config.Menu.Subtitle)
mainMenu.Closed = function() open = false end
mainMenu:DisplayPageCounter(true)
mainMenu.Display.Glare = false
mainMenu.EnableMouse = false

local veh = nil

RegisterNetEvent("KraKss:GoFastCDcount")
AddEventHandler("KraKss:GoFastCDcount", function(_count)
	count = _count
end)

function openMenu()
	open = false
    if open then 
        open = false 
            RageUI.Visible(mainMenu, false)
        return 
    else 
        open = true 
        RageUI.Visible(mainMenu, true)	
        Citizen.CreateThread(function()            
            while open do			
                RageUI.IsVisible(mainMenu, function()											
                    RageUI.Button("Commencer un GoFast", "Livre un véhicule au client dans le meilleur état possible sans te faire prendre par les flics", {}, true, {
                        onSelected = function()
                            if count > 0 then
                                TriggerServerEvent("KraKss:GoFastCDAdd")
                                local random = math.random(#Config.deliveryPoints)
                                for k, v in pairs(Config.deliveryPoints) do
                                    if random == k then 
                                        choosenPos = k                           
                                        blip = AddBlipForCoord(v.x, v.y, v.z)                            
                                        SetBlipAsShortRange(blip, false)
                                        SetBlipSprite (blip, 812)
                                        SetBlipDisplay(blip, 2)
                                        SetBlipScale  (blip, 1.0)
                                        SetBlipAsShortRange(blip, false)
                                        BeginTextCommandSetBlipName("STRING")
                                        AddTextComponentString("Livraison du véhicule")
                                        EndTextCommandSetBlipName(blip)
                                        SetBlipColour(blip, 5)
                                        ClearGpsMultiRoute()
                                        StartGpsMultiRoute(12, true, true)                                 
                                        AddPointToGpsMultiRoute(v.x, v.y, v.z)
                                        SetGpsMultiRouteRender(true)                                  
                                        if DoesBlipExist(blip) then                                                       
                                            local carCoords = vector4(1353.21, -2225.24, 60.59, 10.43)
                                            local vehiclehash = GetHashKey("blista")
                                            RequestModel(vehiclehash)                                
                                            while not HasModelLoaded(vehiclehash) do
                                                Citizen.Wait(100)
                                            end
                                            veh = CreateVehicle(vehiclehash, carCoords.x, carCoords.y, carCoords.z, carCoords.h, true, false)
                                            SetVehicleNumberPlateText(veh, " GOFAST ")
                                            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                                            SetVehicleEngineOn(veh, true, true, false) 	
                                            FreezeEntityPosition(PlayerPedId(), false)
                                            mainMenu.Closed()     
                                            break                                                                          
                                        end                                                                 
                                    end                            
                                end
                            else
                                ESX.ShowNotification("[~r~ERROR~s~]\nLe GoFast n'est pas disponible pour le moment reviens plus tard") 
                            end
                        FreezeEntityPosition(PlayerPedId(), false)
                    end}) 
                end)

                Citizen.Wait(0)
            end
        end)
    end
end

function sellingMenu()
    if vente then 
        vente = false
        RageUI.Visible(mainMenu2, false)
        return
    else
        vente = true 
        RageUI.Visible(mainMenu2, true)
        CreateThread(function()
        	while vente do 
           		RageUI.IsVisible(mainMenu2,function() 
            		RageUI.Button("Vendre le Véhicule", nil, {RightBadge = RageUI.BadgeStyle.Cash}, true , {
               			onSelected = function()	                        
							calculEtatVehicle()
                			RageUI.CloseAll()
							vente = false
               			end
            		})  
           		end)
         	Wait(0)
        	end
    	end)
  	end
end

Citizen.CreateThread(function()
    while true do
    local wait = 1000        
        for k,v in pairs(Config.blipsPosition) do           
            local co = GetEntityCoords(PlayerPedId())
            local dist = Vdist(co.x, co.y, co.z, v.x, v.y, v.z)            
            if dist <= 1.5 then 
                wait = 0                     
                DrawMarker(23, v.x, v.y, v.z - 0.95, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 200, false, false, 2, nil, nil, false) 
                if dist <= 1 then 
                    if IsControlJustPressed(1, 51) then 
                        FreezeEntityPosition(PlayerPedId(), true)                               
                        openMenu()                                                                                             
                    elseif IsControlJustPressed(1, 177) then
                        FreezeEntityPosition(PlayerPedId(), false)                                             
                    end 
                else                       
                    FreezeEntityPosition(PlayerPedId(), false)    
                end        
            end 
        end             
    Citizen.Wait(wait)
    end
end) 

Citizen.CreateThread(function()
    while true do
    local waitEnd = 1000
        for k,v in pairs(Config.deliveryPoints) do
            if choosenPos == k then  
                if veh ~= nil and not IsPedSittingInVehicle(PlayerPedId(), veh) then                    
                    cancelGoFast()
                end                 
                local co = GetEntityCoords(PlayerPedId())
                local dist = Vdist(co.x, co.y, co.z, v.x, v.y, v.z)                       
                if dist <= 3.5 then 
                    waitEnd = 0                   
                    DrawMarker(23, v.x, v.y, v.z - 0.9, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 3.0, 3.0, 3.0, 255, 255, 255, 200, false, false, 2, nil, nil, false)
                    if IsControlJustPressed(1, 51) then                                     
                        sellingMenu()   
                    end                    
                else
                    break
                end  
            end                          
        end        
    Citizen.Wait(waitEnd)
    end
end)

endGoFast = function()   
    RemoveBlip(blip)
    ClearGpsMultiRoute()
    FreezeEntityPosition(PlayerPedId(), false)
    DeleteVehicle(veh)
    veh = nil
    choosenPos = nil
    ESX.ShowAdvancedNotification("VIBE - DEV", "~c~Inconnu", "Merci pour le véhicule ! Voici ton argent.", "CHAR_BLANK_ENTRY", 0)                                           
end

cancelGoFast = function()   
    RageUI.CloseAll()    
    RemoveBlip(blip)
    ClearGpsMultiRoute()
    FreezeEntityPosition(PlayerPedId(), false)
    DeleteVehicle(veh)
    veh = nil
    choosenPos = nil
    count = 1
    ESX.ShowAdvancedNotification("VIBE - DEV", "~r~GOFAST", "J'ai annulé le GOFAST, reviens quand tu sera prêt à amener le véhicule au client !", "CHAR_LJT", 0)                                         
end

calculEtatVehicle = function()
    local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false )
	local vehPlate = GetVehicleNumberPlateText(veh)
    local moteurveh = math.floor(GetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId(), false)) / 10,2)
    local carosserieVeh = math.floor(GetVehicleBodyHealth(GetVehiclePedIsIn(PlayerPedId(), false)) / 10,2)
    local etat = ((moteurveh + carosserieVeh) /2)
    if vehPlate == " GOFAST " then  
        RageUI.CloseAll()      
        endGoFast()
        Citizen.Wait(5000) 
        TriggerServerEvent("KraKss:giveMoneyForDelivery", etat)        
    else        
        ESX.ShowAdvancedNotification("VIBE - DEV", "~r~GOFAST", "T'as cru que tu allais me niquer comme ça ?", "CHAR_LJT", 0)     
    end    
end

AddEventHandler("onResourceStart", function()				
        count = 1	
end)
