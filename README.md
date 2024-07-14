# flex-crafting
This is a QB based portable crafting bench
<br>
[3D PRINTER CREDIT BzZzi](https://forum.cfx.re/t/addon-prop-3d-printer/4997762)
<br>
<br>
The V1 was without the ability that everyone can use a placed bench and no blueprints.
<br>
<br>
The reason this one is uploaded free is because i couldnt test it with more then 1 player at a time.
<br>
**I might upload a preview soon**
# What is this?
- This is a script where you can place a bench anywhere you want (and pick it back up).
- You can make as many types of benches you want in the config
- When the bench is placed, everyone can use it.
- When first placed nothing can be craft.
- You will need to add blueprints to it
- Blueprints can be given with:
  - A command **/giveprint <id> <item>**
  - exports['flex-crafting']:GiveBluePrint(src, itemname, chance)
  - Or add it to whatever shop you want and add metadata **item = itemname from shared** or **itemname = name shown in bench**
- All items you want to be able to be craft need to be in the config
- After crafting the bench can lose health (defined for each bench how much and chance)
- You can repair a bench with materials defined in config
- When a bench died it should delete itself

  </br>
# What do you need?
- **qb-menu**

</br>

# Extra exports

**BenchPlaceState**
<br>
State if you can place a bench (true or false)
<br>
 **exports['flex-crafting']:BenchPlaceState(bool)**
 <br>
 <br>
 <br>
 # Items template for shared
 ```
blueprint                    = { name = 'blueprint', label = 'Blueprint', weight = 200, type = 'item', image = 'blueprint.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = '' },
workbench                    = { name = 'workbench', label = 'Workbench', weight = 20000, type = 'item', image = 'bench2.png', unique = true, useable = true, shouldClose = true, combinable = nil, description = '' },
```
