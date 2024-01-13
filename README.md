<h1 align="center"><a href="https://discord.gg/brocode" target="_blank" rel="noopener noreferrer">Brocode Paycheck</a></h1>

This script, you can immerse the Roleplay Experience for your Players to Force them to collect their PayChecks from the Collection Points, this can be added to any job or Paycheck system of QBCore or QBOX. Comprehensive installation and feature instructions are provided in the README.

## Features

- Force Players to collect their Paychecks from the Collection Points.
- Add this to any Job or Paycheck System.
- Easy to use and simple code.
- Easy to integrate with any job system.
- Utilized the Character MetaData system.
- No SQL Creation to import and Better Server Performance.
- Utilizes ox_lib and ox_target.
- Optimized and Clean Code.
- Creates Logs for the Paychecks.

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- QBCore and QBOX

## Installation

1. Download the script.
2. Add the script to your resources folder.
3. Open the script and configure the `config.lua` file.
4. Follow the Steps provided in `Integration` Section.
5. Add `ensure BC_Paycheck` to your server.cfg file.
6. Restart your server.

## Integration

### Exports
Can be integrated with any Job or Paycheck System, just replace the Export with your Job or Paycheck System Export.
```lua
exports.BC_Paycheck:addPaycheck(source, amount, reason)
```

### QBCore

Find the `PaycheckInterval()` function in `qb-core/server/functions.lua` and replace it with the following code:

```lua
function PaycheckInterval()
    if next(QBCore.Players) then
        for _, Player in pairs(QBCore.Players) do
            if Player then
                local payment = QBShared.Jobs[Player.PlayerData.job.name]['grades'][tostring(Player.PlayerData.job.grade.level)].payment
                if not payment then payment = Player.PlayerData.job.payment end
                if Player.PlayerData.job and payment > 0 and (QBShared.Jobs[Player.PlayerData.job.name].offDutyPay or Player.PlayerData.job.onduty) then
                    if QBCore.Config.Money.PayCheckSociety then
                        local account = exports['qb-banking']:GetAccountBalance(Player.PlayerData.job.name)
                        if account ~= 0 then          -- Checks if player is employed by a society
                            if account < payment then -- Checks if company has enough money to pay society
                                TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('error.company_too_poor'), 'error')
                            else
                                exports.BC_Paycheck:addPaycheck(Player.PlayerData.source, payment, Player.PlayerData.job.name..' Paycheck')     -- BC_Paycheck Replace Export
                                exports['qb-banking']:RemoveMoney(Player.PlayerData.job.name, payment, 'Employee Paycheck')
                                TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', { value = payment }))
                            end
                        else
                            exports.BC_Paycheck:addPaycheck(Player.PlayerData.source, payment, Player.PlayerData.job.name .. ' Paycheck')       -- BC_Paycheck Replace Export
                            TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', { value = payment }))
                        end
                    else
                        exports.BC_Paycheck:addPaycheck(Player.PlayerData.source, payment, Player.PlayerData.job.name .. ' Paycheck')           -- BC_Paycheck Replace Export
                        TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', { value = payment }))
                    end
                end
            end
        end
    end
    SetTimeout(QBCore.Config.Money.PayCheckTimeOut * (60 * 1000), PaycheckInterval)
end
```

### QBCore Logs
Add it in your `qb-smallresources/server/logs.lua` file.
```lua
    ['paycheck'] = '',
```

## Support

If you need any help, feel free to join my [Discord Server](https://discord.gg/brocode) and write your issues in the support channel.