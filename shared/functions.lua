local Framework = nil

if Config.Framework == 'qbcore' then
    Framework = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'qbox' then
    Framework = exports.qbx_core
end

function createPed(model, coords, freeze, collision, scenario, anim)
    lib.requestModel(model)
    local ped = CreatePed(0, model, coords.x, coords.y, coords.z - 1.03, coords.w, false, false)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, freeze or true)
    if collision then SetEntityNoCollisionEntity(ped, PlayerPedId(), false) end
    if scenario and not anim then TaskStartScenarioInPlace(ped, scenario, 0, true) end
    if anim and not scenario then
        lib.requestAnimDict(anim[1])
        TaskPlayAnim(ped, anim[1], anim[2], 1.0, 1.0, -1, 1, 0.2, 0, 0, 0)
    end
    if anim and scenario then
        print("BC_Paycheck: Error: Ped can't have both anim and scenario")
    end
    return ped
end

function triggerNotify(title, message, type, src)
    if Config.Notify == "okok" then
        if not src then
            exports.okokNotify:Alert(title, message, 6000, type)
        else
            TriggerClientEvent('okokNotify:Alert', src, title, message, 6000, type)
        end
    elseif Config.Notify == "qb" then
        if not src then
            TriggerEvent("QBCore:Notify", message, type)
        else
            TriggerClientEvent("QBCore:Notify", src, message, type)
        end
    elseif Config.Notify == "t" then
        if not src then
            exports['t-notify']:Custom({ title = title, style = type, message = message, sound = true })
        else
            TriggerClientEvent('t-notify:client:Custom', src,
                { style = type, duration = 6000, title = title, message = message, sound = true, custom = true })
        end
    elseif Config.Notify == "infinity" then
        if not src then
            TriggerEvent('infinity-notify:sendNotify', message, type)
        else
            TriggerClientEvent('infinity-notify:sendNotify', src, message, type)
        end
    elseif Config.Notify == "rr" then
        if not src then
            exports.rr_uilib:Notify({ msg = message, type = type, style = "dark", duration = 6000, position = "top-right", })
        else
            TriggerClientEvent("rr_uilib:Notify", src,
                { msg = message, type = type, style = "dark", duration = 6000, position = "top-right", })
        end
    elseif Config.Notify == "ox" then
        if not src then
            exports.ox_lib:notify({ title = title, description = message, type = type or "success" })
        else
            TriggerClientEvent('ox_lib:notify', src, { type = type or "success", title = title, description = message })
        end
    end
end

function progressBar(data)
    local result = nil
    if Config.ProgressBar == "ox" then
        if exports.ox_lib:progressBar({ duration = Config.Debug and 1000 or data.time, label = data.label, useWhileDead = data.dead or false, canCancel = data.cancel or true,
                anim = { dict = data.dict, clip = data.anim, flag = (data.flag == 8 and 32 or data.flag) or nil, scenario = data.task }, disable = { combat = true }, }) then
            result = true
        else
            result = false
        end
    elseif Config.ProgressBar == "BC_ProgressStage" then
        exports.BC_ProgressStage:Progress({
            duration = Config.Debug and 1000 or data.time,
            useWhileDead = data.dead,
            canCancel = data.cancel or true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = data.dict,
                anim = data.anim,
                flags = (data.flag == 8 and 32 or data.flag) or nil,
                task = data.task
            },
            prop = {},
            propTwo = {},
            icon = {
                name = data.icon
            },
            dialogues = data.dialogues
        }, function()
            result = true
        end, function()
            result = false
        end)
    else
        if Config.Framework == 'qbcore' then
            Framework.Functions.Progressbar("paycheckMenu",
                data.label,
                Config.Debug and 1000 or
                data.time,
                data.dead,
                data.cancel or true, 
                {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = data.dict,
                    anim = data.anim,
                    flags = (data.flag == 8 and 32 or data.flag) or nil,
                    task = data.task
                }, {}, {}, function()
                    result = true
                end, function()
                    result = false
                end, data.icon)
        else
            print("BC_Paycheck: Error: Progressbar Error")
            result = false
        end
    end
    while result == nil do Wait(10) end
    return result
end

function createBlip(data, coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipAsShortRange(blip, true)
    SetBlipSprite(blip, data.sprite or 1)
    SetBlipColour(blip, data.color or 0)
    SetBlipScale(blip, data.scale or 0.7)
    SetBlipDisplay(blip, (data.display or 6))
    if data.category then SetBlipCategory(blip, data.category) end
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(tostring(data.name))
    EndTextCommandSetBlipName(blip)
    if Config.Debug then print("^5Debug^7: ^6Blip ^2created for location^7: '^6" .. data.name .. "^7'") end
    return blip
end