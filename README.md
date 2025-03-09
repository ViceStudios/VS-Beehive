# VS-Beehive

**Status:** Work in Progress (WIP)

This script provides a simple beehive system for collecting honey in QBCore. It works, but it's still at an early stage. Future updates will add more features.

### Installation
1. Rename the folder to `VS-Beehive` and place it in your `[qb]` resource folder.
2. Add the honey item in `QB-Core/Shared/Items.lua` as shown below.
3. Ensure the resource is started (or ensured) in your server config.

### Honey Item
```lua
// filepath: c:\Users\User\Server\[QBCore]\[FiveMServer]\QBCore\Shared\Items.lua
// ...existing code...
['honey'] = { 
    name = 'honey', 
    label = 'Honey', 
    weight = 100, 
    type = 'item', 
    image = 'honey.png', 
    unique = false, 
    useable = false, 
    shouldClose = true, 
    description = 'Sweet honey collected from a beehive' 
},
// ...existing code...
