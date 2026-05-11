from __future__ import annotations

import argparse
import sys
from pathlib import Path

if __package__ in (None, ""):
    sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from war3auto.config import AutomationConfig, DEFAULT_WINDOW_TITLE_KEYWORDS, default_lib_root


def _path(value: str | None) -> Path | None:
    if value is None or value == "":
        return None
    return Path(value)


def _layout(value: str) -> tuple[int, int, int, int]:
    parts = [part.strip() for part in value.split(",") if part.strip()]
    if len(parts) != 4:
        raise argparse.ArgumentTypeError("layout must be x,y,width,height")
    try:
        x, y, width, height = (int(part) for part in parts)
    except ValueError as exc:
        raise argparse.ArgumentTypeError("layout values must be integers") from exc
    if width <= 0 or height <= 0:
        raise argparse.ArgumentTypeError("layout width and height must be greater than 0")
    return x, y, width, height


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Warcraft III foreground automation")
    parser.add_argument("--lib-root", default=str(default_lib_root()))
    parser.add_argument("--project")
    parser.add_argument("--we")
    parser.add_argument("--game-path")
    parser.add_argument("--map-path")
    parser.add_argument("--asset-dir")
    parser.add_argument("--phase", choices=("phase1", "phase2"), default="phase1")
    parser.add_argument("--clients", type=int, default=1)
    parser.add_argument("--host-layout", type=_layout, default=(0, 0, 960, 540))
    parser.add_argument("--client-layout", type=_layout, action="append", default=[])
    parser.add_argument("--post-join-delay", type=float, default=3.0)
    parser.add_argument("--threshold", type=float, default=0.82)
    parser.add_argument("--timeout", type=float, default=60.0)
    parser.add_argument("--click-delay", type=float, default=0.45)
    parser.add_argument("--window-title", action="append", default=[])
    parser.add_argument("--check-assets", action="store_true")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--launch-war3", action="store_true")
    return parser


def build_config(args: argparse.Namespace) -> AutomationConfig:
    keywords = tuple(args.window_title) if args.window_title else DEFAULT_WINDOW_TITLE_KEYWORDS
    client_layouts = tuple(args.client_layout) if args.client_layout else ((960, 0, 960, 540),)
    return AutomationConfig(
        lib_root=Path(args.lib_root),
        project_path=_path(args.project),
        we_path=_path(args.we),
        game_path=_path(args.game_path),
        map_path=_path(args.map_path),
        asset_dir=_path(args.asset_dir),
        phase=args.phase,
        launch_war3=args.launch_war3,
        clients=args.clients,
        host_layout=args.host_layout,
        client_layouts=client_layouts,
        post_join_delay_seconds=args.post_join_delay,
        threshold=args.threshold,
        timeout_seconds=args.timeout,
        click_delay_seconds=args.click_delay,
        dry_run=args.dry_run,
        window_title_keywords=keywords,
    )


def check_assets(config: AutomationConfig) -> int:
    print(f"[war3auto] phase: {config.phase}")
    print(f"[war3auto] asset dir: {config.asset_dir}")
    missing = config.missing_assets()
    for asset in config.required_asset_paths:
        status = "ok" if asset.is_file() else "missing"
        print(f"[war3auto] asset {status}: {asset}")
    return 0 if not missing else 2


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)

    try:
        config = build_config(args)
    except Exception as exc:
        print(f"[war3auto] invalid config: {exc}", file=sys.stderr)
        return 2

    if args.check_assets:
        return check_assets(config)

    if args.launch_war3 and args.phase == "phase1":
        if config.we_path is None:
            print("[war3auto] --launch-war3 requires --we", file=sys.stderr)
            return 2
        from war3auto.launcher import launch_war3

        launch_war3(config.we_path, config.map_path)
    elif args.launch_war3 and args.phase == "phase2" and config.we_path is None:
        print("[war3auto] --phase phase2 --launch-war3 requires --we", file=sys.stderr)
        return 2

    try:
        from war3auto.workflow import run_phase1, run_phase2

        if config.phase == "phase1":
            run_phase1(config)
        elif config.phase == "phase2":
            run_phase2(config)
        else:
            raise RuntimeError(f"unsupported phase: {config.phase}")
    except Exception as exc:
        print(f"[war3auto] failed: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
