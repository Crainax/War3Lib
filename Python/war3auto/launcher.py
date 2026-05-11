from __future__ import annotations

import subprocess
from pathlib import Path

from .config import AutomationConfig
from .session import War3Session
from .window import list_war3_windows, wait_new_war3_window


def launch_war3(we_path: Path, map_path: Path | None = None) -> subprocess.Popen:
    ydwe_config = we_path / "bin" / "YDWEConfig.exe"
    if not ydwe_config.is_file():
        raise FileNotFoundError(f"YDWEConfig.exe not found: {ydwe_config}")

    args = [str(ydwe_config), "-launchwar3"]
    if map_path is not None:
        args.extend(["-loadfile", str(map_path)])

    return subprocess.Popen(args, cwd=str(ydwe_config.parent))


def launch_war3_and_bind_window(config: AutomationConfig, role: str) -> War3Session:
    if config.we_path is None:
        raise RuntimeError("launching Warcraft III requires --we")

    before = {window.hwnd for window in list_war3_windows(config.window_title_keywords)}
    print(f"[war3auto] launching {role}")
    launch_war3(config.we_path, config.map_path)
    window = wait_new_war3_window(before, config.window_title_keywords, config.timeout_seconds)
    session = War3Session.from_window(role, window)
    print(
        f"[war3auto] bound {role}: hwnd={session.hwnd} "
        f"pid={session.pid} title={session.title}"
    )
    return session
