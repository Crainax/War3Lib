from __future__ import annotations

from pathlib import Path

from .config import AutomationConfig
from .image import wait_image
from .input import pause, press_key
from .window import activate_window, find_war3_window, get_window_rect


PHASE1_STEPS = (
    ("lan", "lan_button.png", "l"),
    ("create_game", "create_game.png", "c"),
    ("create_game2", "create_game2.png", "c"),
    ("start_game", "start_game.png", "alt+s"),
)


class Phase1Workflow:
    def __init__(self, config: AutomationConfig) -> None:
        self.config = config
        self.window_hwnd: int | None = None

    def run(self) -> None:
        missing = self.config.missing_assets()
        if missing:
            formatted = "\n".join(f"  - {asset}" for asset in missing)
            raise FileNotFoundError(f"Missing required template images:\n{formatted}")

        window = find_war3_window(self.config.window_title_keywords, self.config.timeout_seconds)
        self.window_hwnd = window.hwnd
        print(f"[war3auto] window: hwnd={window.hwnd} pid={window.pid} title={window.title}")
        activate_window(window.hwnd)

        for step_name, asset_name, hotkey in PHASE1_STEPS:
            self._press_step_hotkey(step_name, self.config.asset_dir / asset_name, hotkey)

    def _window_rect(self) -> tuple[int, int, int, int]:
        if self.window_hwnd is None:
            raise RuntimeError("Window has not been selected")
        return get_window_rect(self.window_hwnd)

    def _press_step_hotkey(self, step_name: str, template_path: Path, hotkey: str) -> None:
        print(f"[war3auto] waiting for {step_name}: {template_path.name}")
        match = wait_image(
            self._window_rect,
            template_path,
            self.config.threshold,
            self.config.timeout_seconds,
        )
        hotkey_label = hotkey.upper()
        print(
            f"[war3auto] matched {step_name}: score={match.score:.3f} "
            f"center=({match.center[0]}, {match.center[1]}) hotkey={hotkey_label}"
        )
        if self.window_hwnd is not None:
            activate_window(self.window_hwnd)
        press_key(hotkey, dry_run=self.config.dry_run)
        pause(self.config.click_delay_seconds)


def run_phase1(config: AutomationConfig) -> None:
    Phase1Workflow(config).run()
