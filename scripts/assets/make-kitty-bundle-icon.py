#!/usr/bin/env python3
# Build kitty-bundle.icns: the cat from .config/kitty/kitty.app.png on a
# black rounded tile (same gradient as the Ghostty icon's tile).
#
# This is the icon kitty-setup.sh bakes into kitty.app for the Dock and
# Notification Center. Since macOS 26, bundle icons that don't match the
# system tile shape get put on a grey plate. The tile must be a plain
# rounded rect on Apple's 824px grid: a superellipse "squircle" of the same
# size still got plated on macOS 27.
# Needs Pillow (pip3 install pillow); only re-run when the cat changes.

import shutil
import subprocess
import tempfile
from pathlib import Path

from PIL import Image, ImageDraw

HERE = Path(__file__).resolve().parent
SRC = HERE.parent.parent / ".config/kitty/kitty.app.png"
OUT = HERE / "kitty-bundle.icns"

S, INSET = 1024, 100  # Apple's macOS grid: 824px tile centred on a 1024 canvas
TILE = S - 2 * INSET
TOP, BOTTOM = (0x02, 0x02, 0x02), (0x2D, 0x2D, 0x2D)
CAT_SCALE = 0.80  # cat's longest side, relative to the tile
RADIUS = 0.225  # corner radius relative to the tile (Apple's template: 185/824)


def tile_mask(size, supersample=4):
    """Rounded-rect mask matching the macOS app-icon template."""
    big = size * supersample
    mask = Image.new("L", (big, big), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, big - 1, big - 1), radius=round(big * RADIUS), fill=255)
    return mask.resize((size, size), Image.LANCZOS)


def main():
    mask = tile_mask(TILE)
    grad = Image.new("RGB", (1, TILE))
    for y in range(TILE):
        t = y / (TILE - 1)
        grad.putpixel((0, y), tuple(round(a + (b - a) * t) for a, b in zip(TOP, BOTTOM)))
    canvas = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    canvas.paste(grad.resize((TILE, TILE)), (INSET, INSET), mask)

    cat = Image.open(SRC).convert("RGBA")
    cat = cat.crop(cat.getbbox())
    scale = CAT_SCALE * TILE / max(cat.size)
    cat = cat.resize((round(cat.width * scale), round(cat.height * scale)), Image.LANCZOS)
    layer = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    layer.paste(cat, (INSET + (TILE - cat.width) // 2, INSET + (TILE - cat.height) // 2), cat)
    canvas = Image.alpha_composite(canvas, layer)

    with tempfile.TemporaryDirectory() as tmp:
        iconset = Path(tmp) / "kitty.iconset"
        iconset.mkdir()
        for size in (16, 32, 128, 256, 512):
            for mult, suffix in ((1, ""), (2, "@2x")):
                px = size * mult
                canvas.resize((px, px), Image.LANCZOS).save(iconset / f"icon_{size}x{size}{suffix}.png")
        subprocess.run(["iconutil", "-c", "icns", str(iconset), "-o", str(OUT)], check=True)
    print(f"wrote {OUT}")


if __name__ == "__main__":
    if not shutil.which("iconutil"):
        raise SystemExit("iconutil not found (macOS only)")
    main()
