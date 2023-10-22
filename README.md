WoW classic has no profession API, but profession info can be fetched using GetTradeSkill... functions.
This library provides methods that wraps the API calls and works the same way on both classic and retail.
This makes it easy to create cross-platform addons.

## Usage:

### Dependencies

If you are using [BigWigMods packager](https://github.com/BigWigsMods/packager) add it under externals in .pkgmeta like this:
```
  libs/LibStub:
    url: https://repos.wowace.com/wow/libstub/trunk
    tag: latest
  libs/LibProfessions:
    url: https://github.com/datagutten/wow-LibProfessions.git
    tag: latest
  libs/BM-utils:
    url: https://github.com/Beast-Masters-addons/BM-utils.git
    tag: v1.10
```

Otherwise, you need to add the content of this library in your addon folder as libs\LibProfessions

You also need to get the dependencies [BM-Utils](https://github.com/Beast-Masters-addons/BM-utils) and [LibStub](https://www.wowace.com/projects/libstub) and place them in the libs folder. 
### toc
Add these lines to your addons toc file in this order:

```
libs\LibStub\LibStub.lua
libs\BM-utils\lib.xml
libs\LibProfessions\lib.xml
```

### Inclusion

Include the library in your addon like this:

`local professions = LibStub("LibProfessions-0")`

