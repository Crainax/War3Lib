from __future__ import annotations

import subprocess
from pathlib import Path


def launch_war3(we_path: Path, map_path: Path | None = None) -> subprocess.Popen:
    ydwe_config = we_path / "bin" / "YDWEConfig.exe"
    if not ydwe_config.is_file():
        raise FileNotFoundError(f"YDWEConfig.exe not found: {ydwe_config}")

    args = [str(ydwe_config), "-launchwar3"]
    if map_path is not None:
        args.extend(["-loadfile", str(map_path)])

    return subprocess.Popen(args, cwd=str(ydwe_config.parent))
