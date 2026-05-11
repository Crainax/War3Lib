from __future__ import annotations

from pathlib import Path

from .config import AutomationConfig
from .image import wait_image
from .input import click_center, pause, press_key
from .launcher import launch_war3_and_bind_window
from .layout import apply_layout
from .session import War3Session
from .window import activate_window, find_war3_window, get_window_rect


HOST_CREATE_STEPS = (
    ("lan", "lan_button.png", "l"),
    ("create_game", "create_game.png", "c"),
    ("create_game2", "create_game2.png", "c"),
)

HOST_START_STEPS = (
    ("start_game", "start_game.png", "alt+s"),
)


class BaseWorkflow:
    def __init__(self, config: AutomationConfig) -> None:
        self.config = config

    def check_assets(self) -> None:
        missing = self.config.missing_assets()
        if missing:
            formatted = "\n".join(f"  - {asset}" for asset in missing)
            raise FileNotFoundError(f"Missing required template images:\n{formatted}")

    def _asset_path(self, asset_name: str) -> Path:
        assert self.config.asset_dir is not None
        return self.config.asset_dir / asset_name

    def _window_rect(self, session: War3Session) -> tuple[int, int, int, int]:
        return get_window_rect(session.hwnd)

    def _wait_step_image(self, session: War3Session, step_name: str, template_path: Path):
        print(f"[war3auto] waiting {session.role} for {step_name}: {template_path.name}")
        activate_window(session.hwnd)
        return wait_image(
            lambda: self._window_rect(session),
            template_path,
            self.config.threshold,
            self.config.timeout_seconds,
        )

    def press_step_hotkey(self, session: War3Session, step_name: str, asset_name: str, hotkey: str) -> None:
        match = self._wait_step_image(session, step_name, self._asset_path(asset_name))
        hotkey_label = hotkey.upper()
        print(
            f"[war3auto] matched {session.role}.{step_name}: score={match.score:.3f} "
            f"center=({match.center[0]}, {match.center[1]}) hotkey={hotkey_label}"
        )
        activate_window(session.hwnd)
        press_key(hotkey, dry_run=self.config.dry_run)
        pause(self.config.click_delay_seconds)

    def click_step_image(self, session: War3Session, step_name: str, asset_name: str) -> None:
        match = self._wait_step_image(session, step_name, self._asset_path(asset_name))
        print(
            f"[war3auto] matched {session.role}.{step_name}: score={match.score:.3f} "
            f"center=({match.center[0]}, {match.center[1]}) click"
        )
        activate_window(session.hwnd)
        click_center(match.center, dry_run=self.config.dry_run)
        pause(self.config.click_delay_seconds)

    def goto_lan(self, session: War3Session) -> None:
        self.press_step_hotkey(session, "lan", "lan_button.png", "l")

    def host_create_game(self, session: War3Session) -> None:
        for step_name, asset_name, hotkey in HOST_CREATE_STEPS[1:]:
            self.press_step_hotkey(session, step_name, asset_name, hotkey)

    def host_start_game(self, session: War3Session) -> None:
        for step_name, asset_name, hotkey in HOST_START_STEPS:
            self.press_step_hotkey(session, step_name, asset_name, hotkey)

    def client_join_first_room(self, session: War3Session) -> None:
        self.goto_lan(session)
        self.click_step_image(session, "room_list", "room_list.png")
        self.press_step_hotkey(session, "join_game", "join_game.png", "j")


class Phase1Workflow(BaseWorkflow):
    def run(self) -> None:
        self.check_assets()
        window = find_war3_window(self.config.window_title_keywords, self.config.timeout_seconds)
        session = War3Session.from_window("host", window)
        print(f"[war3auto] window: hwnd={session.hwnd} pid={session.pid} title={session.title}")

        self.goto_lan(session)
        self.host_create_game(session)
        self.host_start_game(session)


class Phase2Workflow(BaseWorkflow):
    def run(self) -> None:
        self.check_assets()
        if self.config.dry_run and not self.config.launch_war3:
            self._print_dry_run_plan()
            return
        if not self.config.launch_war3:
            raise RuntimeError("phase2 requires --launch-war3 so host/client windows can be bound")

        host = launch_war3_and_bind_window(self.config, "host")
        apply_layout(host, self.config.host_layout, dry_run=self.config.dry_run)
        pause(self.config.click_delay_seconds)
        self.goto_lan(host)
        self.host_create_game(host)

        clients: list[War3Session] = []
        for index in range(self.config.clients):
            role = f"client{index + 1}"
            client = launch_war3_and_bind_window(self.config, role)
            apply_layout(client, self.config.client_layouts[index], dry_run=self.config.dry_run)
            pause(self.config.click_delay_seconds)
            self.client_join_first_room(client)
            clients.append(client)

        print(f"[war3auto] clients joined: {len(clients)}")
        pause(self.config.post_join_delay_seconds)
        self.host_start_game(host)

    def _print_dry_run_plan(self) -> None:
        print("[war3auto] dry-run phase2 plan")
        print(f"[war3auto] host position: x={self.config.host_layout[0]} y={self.config.host_layout[1]}")
        for index in range(self.config.clients):
            layout = self.config.client_layouts[index]
            print(f"[war3auto] client{index + 1} position: x={layout[0]} y={layout[1]}")
        print("[war3auto] host: launch -> bind -> L -> C -> C")
        print("[war3auto] client1: launch -> bind -> L -> click room_list.png -> J after join_game.png")
        print(f"[war3auto] host: wait {self.config.post_join_delay_seconds:.1f}s -> Alt+S")


def run_phase1(config: AutomationConfig) -> None:
    Phase1Workflow(config).run()


def run_phase2(config: AutomationConfig) -> None:
    Phase2Workflow(config).run()
