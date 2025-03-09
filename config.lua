Config = {}

-- Hive locations and settings
Config.Hives = {
    [1] = { coords = vector3(1902.06, 4927.8, 54.79) },
    [2] = { coords = vector3(1902.37, 4928.51, 54.79) },
    -- Add more hives as needed
}
Config.HarvestAmount = {min = 1, max = 5}    -- Random honey amount range per harvest
Config.HiveCooldown = 300                   -- Cooldown time in seconds for a hive after harvest

-- Honey selling settings
Config.SellerLocation = vector4(2456.28, 4966.1, 46.57, 172.89)  -- NPC vendor coordinates (x,y,z,heading)
Config.SellerPedModel = "a_m_m_farmer_01"    -- Ped model for the honey vendor NPC
Config.HoneyPrice = 10                      -- Price per honey item in cash
Config.DailySellLimit = 0                   -- Max honey a player can sell per day (0 = no limit)
