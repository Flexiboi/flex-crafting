Config = {}

Config.inventorylink = 'qb-inventory/html/images/' --Path of your inventory images
Config.waitcardeletetime = 2 --Time before it gets deleted when a car is nearby
Config.undergroundZcheck = -30 -- Z value check for when player cant place anymore (like under the map)

Config.drawtext = {
    show = function() 
        exports['qb-core']:DrawText('©', Lang:t("info.crafting.placecontrols"), 'left')
    end,
    hide = function()
        exports['qb-core']:HideText()
    end,
}

Config.blueprintitem = 'blueprint'
Config.benches = {
    ['workbench'] = {
        benchitem = 'workbench',
        model = 'xs_prop_x18_tool_draw_01x',
        text3dYoffset = 0.8,
        benchrepairtime = 10,
        benchbreakchance = 15,
        benchbreakpercent = math.random(1, 2),
        repaircost = {
            [1] = {
                item = "iron",--Itemname
                amount = 68,--Amount needed
            },
        },
        crafting = {
            ['repairkit'] = {
                uses = 10,
                label = 'Reparatiekit',
                itemname = 'repairkit',
                amount = 1,
                itemtype = 'item',
                materials = {
                    [1] = {
                        item = "steel",
                        amount = 185,
                    },
                    [2] = {
                        item = "metalscrap",
                        amount = 150,
                    },
                    [3] = {
                        item = "copper",
                        amount = 150,
                    },
                },
                crafttime = 10,
            },
        }
    },
    ['printer3d'] = {
        benchitem = 'printer3d',
        model = 'bzzz_electro_prop_3dprinter',
        text3dYoffset = 0.0,
        benchrepairtime = 10,
        benchbreakchance = 15,
        benchbreakpercent = math.random(0, 2),
        repaircost = {
            [1] = {
                item = "iron",--Itemname
                amount = 68,--Amount needed
            },
        },
        crafting = {
            ['repairkit'] = {
                uses = 10,
                label = 'Reparatiekit',
                itemname = 'repairkit',
                itemtype = 'item',
                materials = {
                    [1] = {
                        item = "steel",
                        amount = 185,
                    },
                    [2] = {
                        item = "metalscrap",
                        amount = 150,
                    },
                    [3] = {
                        item = "copper",
                        amount = 100,
                    },
                    [4] = {
                        item = "copper",
                        amount = 150,
                    },
                },
                crafttime = 10,
            },
        },
    },
}