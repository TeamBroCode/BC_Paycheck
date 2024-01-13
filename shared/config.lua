Config = {}

Config.Debug = false

Config.Framework = "qbcore" -- qbcore, qbox
Config.Notify = "qb"        -- qb, okok, t, infinity, rr, ox
Config.Target = "qb"        -- qb, ox
Config.ProgressBar = 'qb'   -- qb, ox, BC_ProgressStage
Config.Logs = true          -- QB Logs

-- Collection Point Guide --
-- Define scenarios as Scenario Names or set to false
-- Anim is a table { AnimDict, AnimName } or false
-- Blip is a table { toggleBlips = true, name = 'Paycheck Collection', sprite = 500, color = 1, display = 6 } or false
-- Set Collision to true or false
-- Set Freeze to true or false

-- Ped configuration:
--   - model: ped model name
--   - coords: vector4 with coordinates and heading (x, y, z, heading)
--   - freeze: set to true for a frozen ped, false otherwise
--   - collision: set to true to enable collision, false to disable
--   - scenario: set to a scenario name or false
--   - anim: set to a table { AnimDict, AnimName } or false
--   - blip: set to a table { toggleBlips, name, sprite, color, display } or false

Config.Ped = {
    { model = 'a_f_y_business_02', coords = vec4(-1083.14, -245.85, 37.76, 210.28), freeze = true, collision = false, scenario = false, anim = false, blip = { toggleBlips = true, name = 'Paycheck Collection', sprite = 500, color = 4, display = 6 } },
    { model = 'a_f_y_business_02', coords = vec4(248.31, 224.54, 106.29, 167.47),   freeze = true, collision = false, scenario = false, anim = false, blip = { toggleBlips = true, name = 'Paycheck Collection', sprite = 500, color = 4, display = 6 } },
    -- { model = 'a_f_y_business_02', coords = vec4(-544.68, -204.79, 38.22, 208.28),  freeze = true, collision = false, scenario = false, anim = false, blip = { toggleBlips = true, name = 'Paycheck Collection', sprite = 500, color = 1, display = 6 } },
}