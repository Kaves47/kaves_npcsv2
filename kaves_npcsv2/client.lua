Citizen.CreateThread(function()
	for k,v in pairs(Config.Kaves) do
		RequestModel(v.model)
		while not HasModelLoaded(v.model) do Citizen.Wait(1) end
		v.handle = CreatePed(4, v.model, v.coords.x, v.coords.y, v.coords.z-1.0, v.heading, false, false)
		GiveWeaponToPed(v.handle, v.weapon, 10, 1, 1)
		SetPedFleeAttributes(v.handle, 0, 0)
		SetPedDropsWeaponsWhenDead(v.handle, false)
		SetPedDiesWhenInjured(v.handle, false)
		SetEntityInvincible(v.handle , true)
		FreezeEntityPosition(v.handle, true)
		SetBlockingOfNonTemporaryEvents(v.handle, true)
		if v.anim.type == 1 then
			TaskStartScenarioInPlace(v.handle, v.anim.name, 0, true)
		elseif v.anim.type == 2 then
			RequestAnimDict(v.anim.dict)
			while not HasAnimDictLoaded(v.anim.dict) do Citizen.Wait(1) end
			TaskPlayAnim(v.handle, v.anim.dict, v.anim.name, 8.0, 1, -1, 49, 0, false, false, false)
		end
	end
end)


Citizen.CreateThread(function()
	Citizen.Wait(5)
	for a, j in pairs(Config.Vehicles) do
		RequestModel(j.vehmodel)
		while not HasModelLoaded(j.vehmodel) do
			Citizen.Wait(1)
		end
		local veh = CreateVehicle(GetHashKey(j.vehmodel), j.coords.x, j.coords.y, j.coords.z-1.0, j.heading,  false, true)
		SetVehicleDoorsLocked(veh, 2) -- kapıları kilitler
		FreezeEntityPosition(veh, true)
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 1500
		local player = PlayerPedId()
		local playercoord = GetEntityCoords(player)
		for k,v in pairs(Config.Kaves) do
		local dst = #(playercoord - v.coords)
			if dst < 50 then
				sleep = 1
				if dst < 4 then
					DrawText3D(v.coords.x, v.coords.y, v.coords.z+1.0, 0.40, v.text)
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)


function DrawText3D(x, y, z, scale, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    -- local scale = 0.35
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 490
        --DrawRect(_x, _y + 0.0120, 0.0 + factor, 0.025, 41, 11, 41, 100)
    end
end







