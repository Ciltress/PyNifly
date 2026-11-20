#!/bin/sh
# Builds PyNifly's NiflyDLL for Linux (libNiflyDLL.so) and installs the add-on with it into Blender's user add-ons,
# enabled. Run again after a `git pull` of PyNifly (and of external/nifly, the author's fork BadDogSkyrim/nifly).
# Local Linux build, 2026-11-20: upstream PyNifly is Windows-only.
set -e
here=$(cd "$(dirname "$0")" && pwd)
repo=$(cd "$here/../.." && pwd)
[ -d "$here/../external/nifly" ] || git clone --depth 1 https://github.com/BadDogSkyrim/nifly.git "$here/../external/nifly"
cmake -S "$here" -B "$here/build" -DCMAKE_BUILD_TYPE=Release
cmake --build "$here/build" -j"$(nproc)"
cp "$here/build/libNiflyDLL.so" "$repo/io_scene_nifly/"
version=$(blender --version | sed -n 's/^Blender \([0-9]*\.[0-9]*\).*/\1/p' | head -1)
addons="$HOME/.config/blender/$version/scripts/addons"
mkdir -p "$addons"
rm -rf "$addons/io_scene_nifly"
cp -r "$repo/io_scene_nifly" "$addons/"
blender -b -noaudio --python-expr "import addon_utils, bpy; addon_utils.enable('io_scene_nifly', default_set=True, persistent=True); bpy.ops.wm.save_userpref()"
echo "PyNifly installed into Blender $version: $addons/io_scene_nifly"
