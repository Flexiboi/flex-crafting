local Translations = {
    error = {
        notowner = 'Ben je de eigenaar wel..?',
        cartoclose = 'Je staat op straat of te dicht bij nen otto..',
        notenoughtmats = 'Je hebt niet genoeg materialen..',
        stoppedcrafting = 'Gestopt met maken..',
        stoppedrepairbench = 'Gestopt met repareren..',
        notenoughtorepair = 'Niet genoeg materialen om je bank te herstellen..',
        benchbroke = 'Je werkbank is kapot gegaan..',
        notvalidplace = 'Hmm, dat is ni veilig hier..',
        alreadyplaced = 'Je hebt al een tafel klaar staan..',
        cantuseblueprint = 'Je staat te ver van je tafel..',
        alreadyonit = 'Deze blauwdruk zit er al op..',
        error404 = 'Oei er klopt iets niet..',
    },
    success = {
        placedbench = 'Werkbank geplaatst!',
        grabbench = 'Werkbank opgepakt.',
        repairedbench = 'Werkbank hersteld.',
        alreadymaxhealth = 'Je werkbank is al volledig hersteld.',
        crafted = 'Je hebt %{value} gemaakt!',
        usedblueprint = 'Blueprint vastgepint op je werkbank'
    },
    info = {
        repairingworkbench = 'Werkbank aan het herstellen..',
        youdonthave = 'Je mist: ',
        crafting = '%{value} aan het maken..',
        useblueprint = 'Blauwdruk aan het leren..',
        needworkbench = 'Je hebt een werkbank nodig om dit te leren..',
        crafting = {
            placecontrols = '[ESC] Annuleer </br>[◄/►] Draai </br>[ENTER] Plaats',
            infinite = 'Oneindig',
            uses = 'Gebruiken: ',
            youget = 'Je krijgt er: ',
        },
    },
    command = {
        testcommamd = 'Test workbench',
        name = 'Itemname of the benchitem',
        level = 'Level of the bench',
        health = 'Health of the bench'
    },
    text = {
        benchhealth = 'Leven',
        craft = 'om te maken',
        takebench = 'om op te pakken',
        repair = 'om te herstellen'
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})