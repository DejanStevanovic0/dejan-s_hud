ESX = nil

local JobMoneyStorage = {}

TriggerEvent('mrpx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('mlsx:addCommand', 'toggleui', function()
end, { help = _U('toggleui') })

RegisterServerEvent('trew_hud_ui:getServerInfo')
AddEventHandler('trew_hud_ui:getServerInfo', function()

	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local job = ''
	local job2 = ''

	if xPlayer ~= nil then
		if xPlayer.job ~= nil and xPlayer.job.label == xPlayer.job.grade_label then
			job = xPlayer.job.grade_label
		elseif xPlayer.job ~= nil then
			job = xPlayer.job.label .. ' <b style="color: red;">\\\\</b> ' .. xPlayer.job.grade_label
		end

		if xPlayer.job2 ~= nil and xPlayer.job2.label == xPlayer.job2.grade_label then
			job2 = xPlayer.job2.grade_label
		elseif xPlayer.job2 ~= nil then
			job2 = xPlayer.job2.label .. ' <b style="color: red;">\\\\</b> ' .. xPlayer.job2.grade_label
		end

		local info = {
			job = job,
			job2 = job2,
			money = xPlayer.getMoney(),
			bankMoney = xPlayer.getBank(),
			blackMoney = xPlayer.getAccount('black_money').money
		}

		TriggerClientEvent('trew_hud_ui:setInfo', source, info)
	end
end)

ESX.RegisterServerCallback('trew_hud_ui:getJob1Money', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if (xPlayer.job ~= nil and xPlayer.job.name ~= nil and xPlayer.job.grade_name ~= nil and string.lower(xPlayer.job.grade_name) == 'boss') then
		local society = xPlayer.job.name

		if (string.sub(xPlayer.job.name, 1, 3) == 'off' or
			string.sub(xPlayer.job.name, 1, 3) == 'Off' or
			string.sub(xPlayer.job.name, 1, 3) == 'OFF') then
			society = string.sub(xPlayer.job.name, 4)
		end

		if (JobMoneyStorage == nil) then
			JobMoneyStorage = {}
		end

		if (JobMoneyStorage[society] == nil) then
			JobMoneyStorage[society] = {
				lastCheck = os.time(os.date("!*t")) - 60,
				money = 0
			}
		end

		if ((JobMoneyStorage[society].lastCheck + 60) < os.time(os.date("!*t"))) then
			JobMoneyStorage[society].lastCheck = os.time(os.date("!*t"))

			TriggerEvent('mrpx_addonaccount:getSharedAccount', 'society_' .. society, function(account)
				if (account == nil) then
					JobMoneyStorage[society].money = 0
				else
					JobMoneyStorage[society].money = account.money
				end

				cb(JobMoneyStorage[society].money)
				return
			end)
		end

		cb(JobMoneyStorage[society].money)
		return
	end

	cb(0)
end)

ESX.RegisterServerCallback('trew_hud_ui:getJob2Money', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if (xPlayer.job2 ~= nil and xPlayer.job2.name ~= nil and xPlayer.job2.grade_name ~= nil and string.lower(xPlayer.job2.grade_name) == 'boss') then
		local society = xPlayer.job2.name

		if (string.sub(xPlayer.job2.name, 1, 3) == 'off' or
			string.sub(xPlayer.job2.name, 1, 3) == 'Off' or
			string.sub(xPlayer.job2.name, 1, 3) == 'OFF') then
			society = string.sub(xPlayer.job2.name, 4)
		end

		if (JobMoneyStorage == nil) then
			JobMoneyStorage = {}
		end

		if (JobMoneyStorage[society] == nil) then
			JobMoneyStorage[society] = {
				lastCheck = os.time(os.date("!*t")) - 60,
				money = 0
			}
		end

		if ((JobMoneyStorage[society].lastCheck + 60) < os.time(os.date("!*t"))) then
			JobMoneyStorage[society].lastCheck = os.time(os.date("!*t"))

			TriggerEvent('mrpx_addonaccount:getSharedAccount', 'society_' .. society, function(account)
				if (account == nil) then
					JobMoneyStorage[society].money = 0
				else
					JobMoneyStorage[society].money = account.money
				end

				cb(JobMoneyStorage[society].money)
				return
			end)
		end

		cb(JobMoneyStorage[society].money)
		return
	end

	cb(0)
end)

RegisterServerEvent('trew_hud_ui:syncCarLights')
AddEventHandler('trew_hud_ui:syncCarLights', function(status)
	TriggerClientEvent('trew_hud_ui:syncCarLights', -1, source, status)
end)