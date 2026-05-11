from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path


PHASE_ASSETS = {
    "phase1": (
        "lan_button.png",
        "create_game.png",
        "create_game2.png",
        "start_game.png",
    ),
    "phase2": (
        "lan_button.png",
        "create_game.png",
        "create_game2.png",
        "start_game.png",
        "room_list.png",
        "join_game.png",
    ),
}

DEFAULT_WINDOW_TITLE_KEYWORDS = (
    "Warcraft",
    "Frozen Throne",
    "魔兽",
)


@dataclass(frozen=True)
class AutomationConfig:
    lib_root: Path
    project_path: Path | None = None
    we_path: Path | None = None
    game_path: Path | None = None
    map_path: Path | None = None
    asset_dir: Path | None = None
    phase: str = "phase1"
    launch_war3: bool = False
    clients: int = 1
    host_layout: tuple[int, int, int, int] = (0, 0, 960, 540)
    client_layouts: tuple[tuple[int, int, int, int], ...] = ((960, 0, 960, 540),)
    post_join_delay_seconds: float = 3.0
    threshold: float = 0.82
    timeout_seconds: float = 60.0
    click_delay_seconds: float = 0.45
    dry_run: bool = False
    window_title_keywords: tuple[str, ...] = field(default_factory=lambda: DEFAULT_WINDOW_TITLE_KEYWORDS)

    def __post_init__(self) -> None:
        object.__setattr__(self, "lib_root", self.lib_root.resolve())
        if self.asset_dir is None:
            object.__setattr__(self, "asset_dir", self.lib_root / "Python" / "assets")
        else:
            object.__setattr__(self, "asset_dir", self.asset_dir.resolve())
        if self.phase not in PHASE_ASSETS:
            raise ValueError(f"unsupported phase: {self.phase}")
        if self.clients < 1:
            raise ValueError("clients must be greater than 0")
        if self.phase == "phase2" and self.clients != 1:
            raise ValueError("phase2 only supports 1 client")
        if len(self.client_layouts) < self.clients:
            raise ValueError("client_layouts must include one layout per client")
        if self.post_join_delay_seconds < 0:
            raise ValueError("post-join delay must be greater than or equal to 0")
        if not 0.0 < self.threshold <= 1.0:
            raise ValueError("threshold must be in the range (0, 1]")
        if self.timeout_seconds <= 0:
            raise ValueError("timeout must be greater than 0")

    @property
    def required_asset_names(self) -> tuple[str, ...]:
        return PHASE_ASSETS[self.phase]

    @property
    def required_asset_paths(self) -> tuple[Path, ...]:
        assert self.asset_dir is not None
        return tuple(self.asset_dir / name for name in self.required_asset_names)

    def missing_assets(self) -> list[Path]:
        return [asset for asset in self.required_asset_paths if not asset.is_file()]


def default_lib_root() -> Path:
    return Path(__file__).resolve().parents[2]
