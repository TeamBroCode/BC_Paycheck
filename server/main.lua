local Framework = nil

if Config.Framework == 'qbcore' then
    Framework = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'qbox' then
    Framework = exports.qbx_core
end

local function getPlayer(source)
    local src = tonumber(source)
    if Config.Framework == 'qbcore' then
        return Framework.Functions.GetPlayer(src)
    elseif Config.Framework == 'qbox' then
        return Framework:GetPlayer(src)
    end
end

local function addPaycheck(source, amount, reason)
    local src = source
    local reason = reason or 'Unknown'
    local Player = getPlayer(src)
    local paycheck = Player.PlayerData.metadata.paycheck or 0
    local newPaycheck = paycheck + amount
    Player.Functions.SetMetaData("paycheck", newPaycheck)
    if Config.Logs then
        TriggerEvent('qb-log:server:CreateLog', 'paycheck', 'Paycheck', 'blue',
            '**' ..
            Player.PlayerData.charinfo.firstname ..
            ' ' ..
            Player.PlayerData.charinfo.lastname ..
            '** ( ' ..
            Player.PlayerData.citizenid ..
            ' ) has received a paycheck of $' .. amount .. ' **(Total Paycheck = $'.. newPaycheck .. ')** from their employer for Reason: ' .. reason,
            false)
    end
end
exports("addPaycheck", addPaycheck)

local function withdrawPaycheck(source, amount, withdrawalType)
    local src = source
    local Player = getPlayer(src)
    local paycheck = Player.PlayerData.metadata.paycheck or 0
    if amount > paycheck then
        triggerNotify('Withdrawal', "You don't have this much in your paycheck", 'error', src)
        return false
    end
    local newPaycheck = paycheck - amount
    Player.Functions.SetMetaData("paycheck", newPaycheck)
    if withdrawalType == 'cash' then
        if Player.Functions.AddMoney('cash', amount, 'Paycheck Withdrawal') then
            if Config.Logs then
                TriggerEvent('qb-log:server:CreateLog', 'paycheck', 'Paycheck', 'green',
                    '**' ..
                    Player.PlayerData.charinfo.firstname ..
                    ' ' ..
                    Player.PlayerData.charinfo.lastname ..
                    '** ( ' ..
                    Player.PlayerData.citizenid ..
                    ' ) has withdrawn $' .. amount .. ' **(Total Paycheck = $'.. newPaycheck .. ')** from their paycheck through ' .. withdrawalType,
                    false)
            end
            return true
        end
    elseif withdrawalType == 'bank' then
        if Player.Functions.AddMoney('bank', amount, 'Paycheck Withdrawal') then
            if Config.Logs then
                TriggerEvent('qb-log:server:CreateLog', 'paycheck', 'Paycheck', 'green',
                    '**' ..
                    Player.PlayerData.charinfo.firstname ..
                    ' ' ..
                    Player.PlayerData.charinfo.lastname ..
                    '** ( ' ..
                    Player.PlayerData.citizenid ..
                    ' ) has withdrawn $' .. amount .. ' **(Total Paycheck = $'.. newPaycheck .. ')** from their paycheck through ' .. withdrawalType,
                    false)
            end
            return true
        end
    end
end

lib.callback.register('BC_Paycheck:server:checkPaycheck', function(source)
    local src = source
    local Player = getPlayer(src)
    local paycheck = Player.PlayerData.metadata.paycheck
    return paycheck
end)

lib.callback.register('BC_Paycheck:server:withdrawPaycheck', function(source, amount, withdrawalType)
    return withdrawPaycheck(source, amount, withdrawalType)
end)
