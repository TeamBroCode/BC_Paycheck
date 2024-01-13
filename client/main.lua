local PayCheckPed = {}
local PayCheckBlip = {}

local function WithdrawalInput(paycheckAmount)
    local inputResp = lib.inputDialog("Withdrawal", {
        {
            type = "number",
            label = "Withdrawal Amount",
            icon = 'fas fa-hand-pointer',
            description = "Enter the amount. Current Balance: $" .. paycheckAmount,
            required = true,
            min = 0,
            max = paycheckAmount,
            default = 0
        },
        {
            type = 'select',
            label = 'Withdrawal Account',
            description = 'Select the account you want to withdraw from',
            placeholder = 'Select Account',
            icon = 'fas fa-wallet',
            default = 'cash',
            required = true,
            options = {
                { label = 'Cash', value = 'cash' },
                { label = 'Bank', value = 'bank' },
            },
        }
    })

    if not inputResp then return end

    local inputAmt = inputResp[1]
    local accountType = inputResp[2]

    if inputAmt <= 0 then
        triggerNotify('Paycheck Monitor', 'Amount needs to be more than 0', 'error')
        return
    end

    if inputAmt > paycheckAmount then
        triggerNotify('Paycheck Monitor', "You don't have this much in your paycheck", 'error')
        return
    end

    local withdraw = lib.callback.await('BC_Paycheck:server:withdrawPaycheck', false, inputAmt, accountType)
    if withdraw then
        triggerNotify('Paycheck Monitor', 'You have successfully withdrawn $' .. inputAmt .. ' from your paycheck',
            'success')
    else
        triggerNotify('Paycheck Monitor', 'Something went wrong while withdrawing your paycheck', 'error')
    end
end

local function OpenPaycheckMenu()
    local paycheckAmount = lib.callback.await('BC_Paycheck:server:checkPaycheck', false)

    lib.registerContext({
        id = 'openPaycheckContext',
        title = 'Paycheck: $' .. paycheckAmount,
        options = {
            {
                title = 'Withdrawal',
                description = 'Withdraw your hard-earned money from your paycheck',
                icon = "fas fa-money-check-dollar",
                onSelect = function()
                    lib.hideContext()
                    if paycheckAmount == 0 then
                        triggerNotify('Paycheck Monitor', "You don't have any funds to withdraw", 'error')
                        return
                    end
                    WithdrawalInput(tonumber(paycheckAmount))
                end,
            },
        }
    })
    lib.showContext('openPaycheckContext')
end

local function OpenPaycheckTab()
    if progressBar({ label = 'Accessing Paycheck Records', time = 4000, cancel = true, icon = "fas fa-money-check-dollar", dead = false, dialogues = {
            'Validating Credentials',
            'Confirming Ownership Details',
            'Retrieving Payroll Information',
            'Accessing Paycheck Records',
        } }) then
        OpenPaycheckMenu()
    end
end

local function init()
    for _, v in pairs(Config.Ped) do
        PayCheckPed[#PayCheckPed + 1] = createPed(v.model, v.coords, v.freeze, v.collision, v.scenario, v.anim)
        if v.blip.toggleBlips then
            PayCheckBlip[#PayCheckBlip + 1] = createBlip(v.blip, v.coords)
        end
    end
    for _, v in pairs(PayCheckPed) do
        if Config.Target == 'qb' then
            exports['qb-target']:AddTargetEntity(v, {
                options = {
                    {
                        action = function()
                            OpenPaycheckTab()
                        end,
                        icon = "fas fa-money-check-dollar",
                        label = "View Paycheck",
                    },
                },
                distance = 2.0
            })
        elseif Config.Target == 'ox' then
            exports.ox_target:addLocalEntity(v, {
                {
                    name = 'ViewPaycheck',
                    icon = "fas fa-money-check-dollar",
                    label = "View Paycheck",
                    distance = 2.0,
                    onSelect = function()
                        OpenPaycheckTab()
                    end,
                }
            })
        end
    end
    if Config.Debug then
        print('^3 BC_Paycheck: Loaded ^7')
    end
end

local function terminate()
    for k, v in pairs(PayCheckPed) do
        DeleteEntity(v)
    end
    for k, v in pairs(PayCheckBlip) do
        RemoveBlip(v)
    end
    print('^1 BC_Paycheck: Stopped ^7')
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    init()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    terminate()
end)

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        init()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        terminate()
    end
end)
