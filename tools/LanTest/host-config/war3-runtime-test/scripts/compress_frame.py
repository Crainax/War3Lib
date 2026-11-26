"""Publish a compact preview while keeping text legible on high-resolution frames."""
import io
import sys
from pathlib import Path

from PIL import Image


def publish(source: Path, destination: Path) -> None:
    with Image.open(source) as frame:
        frame.thumbnail((1920, 1440), Image.Resampling.LANCZOS)
        while True:
            for quality in (94, 90, 86, 82, 78):
                output = io.BytesIO()
                frame.save(output, "JPEG", quality=quality, subsampling=0, optimize=True)
                if output.tell() <= 500 * 1024:
                    temporary = destination.with_suffix(".tmp")
                    temporary.write_bytes(output.getvalue())
                    temporary.replace(destination)
                    print(f"{destination} ({frame.width} x {frame.height}, {output.tell() // 1024} KiB)")
                    return
            frame.thumbnail((int(frame.width * 0.85), int(frame.height * 0.85)), Image.Resampling.LANCZOS)


if __name__ == "__main__":
    publish(Path(sys.argv[1]), Path(sys.argv[2]))
