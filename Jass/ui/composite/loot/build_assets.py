"""Reproduce LootReveal's small geometric UI textures (no AI images required).

python Jass/ui/composite/loot/build_assets.py
PNG sources and alpha BLPs are written to the shared import directory. Only
the explicit loot_* names below are replaced. No map resources are modified.
"""
from pathlib import Path
import argparse
import math
import struct
import subprocess
from PIL import Image, ImageDraw, ImageFilter


def make_assets(output: Path, converter: Path):
    output.mkdir(parents=True, exist_ok=True)
    assets = {}
    colors = [(192, 195, 213), (100, 182, 255), (202, 138, 241), (250, 205, 110)]

    panel = Image.new("RGBA", (512, 256))
    for y in range(256):
        for x in range(512):
            d = min(x, 511-x, y, 255-y)
            border = d < 2
            sheen = 5 * math.exp(-((y-40)/70)**2)
            panel.putpixel((x, y), (112, 94, 126, 220) if border else
                           (int(27+sheen), int(22+sheen), int(33+sheen), 230))
    assets["loot_panel"] = panel

    band = Image.new("RGBA", (512, 128))
    line = Image.new("RGBA", (512, 16))
    for x in range(512):
        fade = math.sin(math.pi*x/511)**1.2
        for y in range(128):
            band.putpixel((x, y), (29, 22, 36, round(235*fade)))
        for y in range(16):
            alpha = math.exp(-((y-7.5)/2.1)**2)
            line.putpixel((x, y), (255, 215, 143, round(255*fade*alpha)))
    assets["loot_band"] = band
    assets["loot_line"] = line

    ring = Image.new("RGBA", (128, 128))
    spark = Image.new("RGBA", (64, 64))
    for y in range(128):
        for x in range(128):
            r = math.hypot(x-63.5, y-63.5)
            alpha = math.exp(-((r-47)/2.0)**2)
            ring.putpixel((x, y), (255, 232, 192, round(230*alpha)))
    for y in range(64):
        for x in range(64):
            dx, dy = abs(x-31.5), abs(y-31.5)
            a = max(math.exp(-dx/1.3-dy/10), math.exp(-dy/1.3-dx/10))
            spark.putpixel((x, y), (255, 241, 213, round(255*a)))
    assets["loot_ring"] = ring
    assets["loot_spark"] = spark

    for i, color in enumerate(colors):
        glow = Image.new("RGBA", (128, 128))
        for y in range(128):
            for x in range(128):
                r = math.hypot(x-63.5, y-63.5)/64
                a = max(0, math.exp(-4*r*r)-math.exp(-4))
                glow.putpixel((x, y), (*color, round(240*a)))
        frame = Image.new("RGBA", (128, 128))
        draw = ImageDraw.Draw(frame)
        draw.rectangle((4, 4, 123, 123), outline=(*color, 80), width=5)
        frame = frame.filter(ImageFilter.GaussianBlur(2))
        draw = ImageDraw.Draw(frame)
        draw.rectangle((6, 6, 121, 121), outline=(*color, 245), width=2)
        for x, y, sx, sy in [(6,6,1,1),(121,6,-1,1),(6,121,1,-1),(121,121,-1,-1)]:
            draw.line((x,y,x+sx*12,y), fill=(255,240,220,255), width=2)
            draw.line((x,y,x,y+sy*12), fill=(255,240,220,255), width=2)
        assets[f"loot_glow_{i}"] = glow
        assets[f"loot_border_{i}"] = frame

    total = 0
    for name, picture in assets.items():
        png, blp = output / f"{name}.png", output / f"{name}.blp"
        picture.save(png)
        subprocess.run([str(converter), str(png), str(blp), "--type", "0",
                        "--mipmap", "1", "--quality", "95", "--alpha", "2"], check=True,
                       capture_output=True)
        data = blp.read_bytes()
        assert data[:4] == b"BLP1", blp
        assert struct.unpack_from("<II", data, 12) == picture.size, blp
        assert struct.unpack_from("<I", data, 8)[0] != 0, blp
        total += len(data)
    print(f"Generated and checked {len(assets)} alpha BLPs; total {total:,} bytes in {output}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=Path("D:/War3Asset/Import/resource/ui/image"))
    parser.add_argument("--converter", type=Path, default=Path("D:/War3/tools/BLPLAB/BLP.NET.CL/BLP.NET/blpnetcl.exe"))
    args = parser.parse_args()
    make_assets(args.output, args.converter)
