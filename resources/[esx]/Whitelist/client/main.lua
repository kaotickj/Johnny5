AddEventHandler('esx:playerLoaded', function(xPlayer)
	TriggerServerEvent('esx_whitelistExtended:removePlayerToInConnect')
end)