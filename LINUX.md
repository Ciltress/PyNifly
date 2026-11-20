# PyNifly on Linux (unofficial build)

This fork adds a Linux build of [PyNifly](https://github.com/BadDogSkyrim/PyNifly), which upstream ships for Windows only.
It is not supported by PyNifly's author: report Linux problems here, not upstream. Everything else is PyNifly as
BadDogSkyrim wrote it; the Linux changes live on the `linux-build` branch and are kept small, so new upstream releases
merge in easily.

## What changed

- **`NiflyDLL/linux/`** builds the native library as `libNiflyDLL.so` with CMake and GCC: the same sources the Visual
  Studio project compiles, against the author's [nifly fork](https://github.com/BadDogSkyrim/nifly) (cloned into
  `NiflyDLL/external/nifly`). A small `compat/windows.h` answers the one Windows call the library makes (finding its own
  path, through `dladdr`), and a few header aliases cover includes that only work on Windows' case-insensitive file system.
- **The add-on** loads `libNiflyDLL.so` on Linux, skips Windows' short (8.3) path names, finds Steam in the home folder
  instead of the registry, opens `Shaders.blend` by its own letter case, and finds a NIF's textures whatever their slashes
  and letter case — on Windows it behaves exactly as before.

## Install

Needs Blender (4.0 or later; tested with 5.3.0), CMake, GCC and git.

```bash
git clone -b linux-build https://github.com/Ciltress/PyNifly.git
PyNifly/NiflyDLL/linux/install-blender.sh
```

The script clones the nifly fork, builds `libNiflyDLL.so`, copies the add-on into Blender's user add-ons
(`~/.config/blender/<version>/scripts/addons/io_scene_nifly`) and enables it. Run it again after pulling updates.

## What is tested

Tested on CachyOS (Arch) with Blender 5.3.0 and GCC 16, through
[Skyrim Modding Tools](https://github.com/Ciltress/skyrim-modding-tools-mcp)' cell export: **importing Skyrim SE meshes**
with their textures — a whole interior (Breezehome: 170 meshes, 212 textures) loads fully textured.

**Not tested yet:** exporting NIFs from Blender, animations (HKX), tri files, and Fallout 4, Fallout 76 and Starfield
meshes. They may well work — the native code is the same — but nobody has checked them on Linux. Reports are welcome.

## License

GPL-3.0, as PyNifly and nifly. All credit for PyNifly goes to BadDogSkyrim, and for nifly to ousnius and the
BodySlide/Outfit Studio team.
