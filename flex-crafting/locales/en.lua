local Translations = {
    error = {
        notowner = 'Are you the owner..?',
        cartoclose = 'You are on the street or too close to a car..',
        notenoughtmats = 'You dont have enough materials..',
        stoppedcrafting = 'Stopped making..',
        stoppedrepairbench = 'Stopped repairing..',
        notenoughtorepair = 'Not enough materials to restore your bench..',
        benchbroke = 'Your workbench has broken..',
        notvalidplace = 'Hmm, thats not safe here..',
        alreadyplaced = 'You already have a table ready..',
        cantuseblueprint = 'You are too far from your table..',
        alreadyonit = 'This blueprint is already on this bench..',
        error404 = 'Oops there is something wrong..',
    },
    success = {
        placedbench = 'Workbench placed!',
        grabbench = 'Workbench pikced up.',
        repairedbench = 'Workbench restored.',
        alreadymaxhealth = 'Your workbench has already been fully recovered.',
        crafted = 'You made %{value}!',
        usedblueprint = 'Blueprint pinted on your workbench'
    },
    info = {
        repairingworkbench = 'Repairing Workbench..',
        youdonthave = 'You need: ',
        crafting = 'Making %{value}..',
        useblueprint = 'Blueprint learning..',
        needworkbench = 'You need a workbench to learn this..',
        crafting = {
            placecontrols = '[ESC] Cancel </br>[◄/►] Turn </br>[ENTER] Place',
            infinite = 'Infinite',
            uses = 'Uses: ',
            youget = 'You get: ',
        },
    },
    command = {
        testcommamd = 'Test workbench',
        name = 'Itemname of the benchitem',
        level = 'Level of the bench',
        health = 'Health of the bench'
    },
    text = {
        benchhealth = 'Health',
        craft = 'to make',
        takebench = 'to pick up',
        repair = 'to repair'
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})