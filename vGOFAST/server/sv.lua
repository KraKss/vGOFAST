ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

count = 1

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.timeBetweenGoFast * 60000)
          count = 1
          TriggerClientEvent("KraKss:GoFastCDcount", -1, count)
	end
end)

RegisterServerEvent("KraKss:GoFastCDAdd")
AddEventHandler("KraKss:GoFastCDAdd", function()
     count = 0
     TriggerClientEvent("KraKss:GoFastCDcount", -1, count)
end)

RegisterServerEvent("Krakss:giveMoneyForDelivery")
AddEventHandler("KraKss:giveMoneyForDelivery", function(etat)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local randomAmount1 = math.random(Config.minMoney100, Config.maxMoney100)   
    local randomAmount2 = math.random(Config.minMoney75, Config.maxMoney75)
    local randomAmount3 = math.random(Config.minMoney50, Config.maxMoney50)
    local randomAmount4 = math.random(Config.minMoney0, Config.maxMoney0)
    if etat == 100 then 
        xPlayer.addAccountMoney("money", randomAmount1)
        TriggerClientEvent('esx:showAdvancedNotification', source, "Banque", "~g~Virement", "Vous avez reçu un virement de ~g~$" ..randomAmount1, "CHAR_BANK_FLEECA", 1)
    elseif etat >= 85 then 
        xPlayer.addAccountMoney("money", randomAmount2)
        TriggerClientEvent('esx:showAdvancedNotification', source, "Banque", "~g~Virement", "Vous avez reçu un virement de ~g~$" ..randomAmount2, "CHAR_BANK_FLEECA", 1)
    elseif etat >= 60 then
        xPlayer.addAccountMoney("money", randomAmount3)
        TriggerClientEvent('esx:showAdvancedNotification', source, "Banque", "~g~Virement", "Vous avez reçu un virement de ~g~$" ..randomAmount3, "CHAR_BANK_FLEECA", 1)
    elseif etat >= 0 then
        xPlayer.addAccountMoney("money", randomAmount4)
        TriggerClientEvent('esx:showAdvancedNotification', source, "Banque", "~g~Virement", "Vous avez reçu un virement de ~g~$" ..randomAmount4, "CHAR_BANK_FLEECA", 1)
    end
end)

print("^0GOFAST by ^4KraKss#0667^0 initialized")