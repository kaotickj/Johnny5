Config = {}
Config.Locale = 'fr'

Config.PoliceNumberRequired = 3
Config.TimerBeforeNewRob = 172800 -- seconds


-- Change secondsRemaining if you want another timer
Stores = {
    --[["paleto_twentyfourseven"] = {
        position = { ['x'] = 1736.32092285156, ['y'] = 6419.4970703125, ['z'] = 35.037223815918 },
        reward = math.random(100,1000),
        nameofstore = "24/7. (Paleto Bay)",
        secondsRemaining = 200, -- seconds
        lastrobbed = 0
    },]]
    ["sandyshores_twentyfoursever"] = {
        position = { ['x'] = 1961.24682617188, ['y'] = 3749.46069335938, ['z'] = 32.3437461853027 },
        reward = math.random(4000,15000),
        nameofstore = "24/7. (Sandy Shores)",
        secondsRemaining = 360, -- seconds
        lastrobbed = 0
    },
    ["bar_one"] = {
        position = { ['x'] = 1990.579, ['y'] = 3044.957, ['z'] = 47.215171813965 },
        reward = math.random(4000,15000),
        nameofstore = "Yellow Jack. (Sandy Shores)",
        secondsRemaining = 360, -- seconds
        lastrobbed = 0
    },
    ["ocean_liquor"] = {
        position = { ['x'] = -2959.33715820313, ['y'] = 388.214172363281, ['z'] = 14.0432071685791 },
        reward = math.random(4000,15000),
        nameofstore = "Robs Liquor. (Great Ocean Higway)",
        secondsRemaining = 400, -- seconds
        lastrobbed = 0
    },
    ["sanandreas_liquor"] = {
        position = { ['x'] = -1219.85607910156, ['y'] = -916.276550292969, ['z'] = 11.3262157440186 },
        reward = math.random(4000,15000),
        nameofstore = "Robs Liquor. (San andreas Avenue)",
        secondsRemaining = 400, -- seconds
        lastrobbed = 0
    },
    ["grove_ltd"] = {
        position = { ['x'] = -43.4035377502441, ['y'] = -1749.20922851563, ['z'] = 29.421012878418 },
        reward = math.random(4000,15000),
        nameofstore = "LTD Gasoline. (Grove Street)",
        secondsRemaining = 400, -- seconds
        lastrobbed = 0
    },
    ["mirror_ltd"] = {
        position = { ['x'] = 1160.67578125, ['y'] = -314.400451660156, ['z'] = 69.2050552368164 },
        reward = math.random(4000,15000),
        nameofstore = "LTD Gasoline. (Mirror Park Boulevard)",
        secondsRemaining = 400, -- seconds
        lastrobbed = 0
    },
    ["littleseoul_twentyfourseven"] = {
        position = { ['x'] = -709.17022705078, ['y'] = -904.21722412109, ['z'] = 19.215591430664 },
        reward = math.random(4000,15000),
        nameofstore = "24/7. (Little Seoul)",
        secondsRemaining = 400, -- seconds
        lastrobbed = 0
    },
	["blainecounty"] = {
        position = { ['x'] = -107.06505584717, ['y'] = 6474.8012695313, ['z'] = 31.62670135498 },
        reward = math.random(50000,100000),
        nameofstore = "Banque Nord",
        secondsRemaining = 500, -- seconds
        lastrobbed = 0
    },
	["pacificstandard"] = {
        position = { ['x'] = 254.9073638916, ['y'] = 225.21484375, ['z'] = 101.87573242188 },
        reward = math.random(100000,500000),
        nameofstore = "Banque De France",
        secondsRemaining = 800, -- seconds
        lastrobbed = 0
    }
}