from __future__ import annotations

import time
from pathlib import Path

from .config import AutomationConfig
from .image import find_image, wait_image
from .input import click_center, move_mouse, pause, press_key
from .launcher import launch_war3_and_bind_window
from .layout import apply_layout, player_layouts
from .session import War3Session
from .window import activate_window, get_window_rect


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

    def _wait_step_image(
        self,
        session: War3Session,
        step_name: str,
        template_path: Path,
        timeout_seconds: float | None = None,
    ):
        print(f"[war3auto] waiting {session.role} for {step_name}: {template_path.name}")
        activate_window(session.hwnd)
        return wait_image(
            lambda: self._window_rect(session),
            template_path,
            self.config.threshold,
            timeout_seconds or self.config.timeout_seconds,
        )

    def is_step_image_visible(self, session: War3Session, asset_name: str) -> bool | None:
        template_path = self._asset_path(asset_name)
        if not template_path.is_file():
            return None
        try:
            return find_image(self._window_rect(session), template_path, self.config.threshold) is not None
        except Exception:
            return False

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

    def click_step_image(
        self,
        session: War3Session,
        step_name: str,
        asset_name: str,
        hold_seconds: float = 0.05,
        clicks: int = 1,
    ):
        match = self._wait_step_image(session, step_name, self._asset_path(asset_name))
        print(
            f"[war3auto] matched {session.role}.{step_name}: score={match.score:.3f} "
            f"center=({match.center[0]}, {match.center[1]}) click x{clicks}"
        )
        activate_window(session.hwnd)
        click_center(match.center, dry_run=self.config.dry_run, hold_seconds=hold_seconds, clicks=clicks)
        pause(self.config.click_delay_seconds)
        return match

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
        select_state = self.select_first_room(session)
        if select_state == "joined":
            print(f"[war3auto] {session.role} joined room by double-click")
            pause(self.config.click_delay_seconds)
            return
        print(f"[war3auto] matched {session.role}.select_room: hotkey=J")
        activate_window(session.hwnd)
        press_key("j", dry_run=self.config.dry_run)
        pause(self.config.click_delay_seconds)
        self.wait_joined_room(session, timeout_seconds=5.0)

    def select_first_room(self, session: War3Session) -> str:
        max_attempts = 3
        for attempt in range(1, max_attempts + 1):
            print(f"[war3auto] selecting {session.role} room attempt {attempt}/{max_attempts}")
            self.click_step_image(session, "room_list", "room_list.png", hold_seconds=0.18, clicks=2)
            self.move_mouse_away_from_room(session)
            if self.wait_joined_room(session, timeout_seconds=1.5, raise_on_timeout=False):
                return "joined"
            try:
                match = self._wait_step_image(
                    session,
                    "select_room",
                    self._asset_path("select_room.png"),
                    timeout_seconds=2.0,
                )
                print(
                    f"[war3auto] matched {session.role}.select_room: score={match.score:.3f} "
                    f"center=({match.center[0]}, {match.center[1]})"
                )
                return "selected"
            except TimeoutError:
                if attempt == max_attempts:
                    raise
                print(f"[war3auto] {session.role}.select_room not visible; retry room click")
                pause(0.35)
        raise TimeoutError("Timed out selecting room")

    def wait_joined_room(
        self,
        session: War3Session,
        timeout_seconds: float,
        raise_on_timeout: bool = True,
    ) -> bool:
        join_game_path = self._asset_path("join_game.png")
        if not join_game_path.is_file():
            return False
        deadline = time.monotonic() + timeout_seconds
        while time.monotonic() < deadline:
            visible = self.is_step_image_visible(session, "join_game.png")
            if visible is False:
                print(f"[war3auto] {session.role}.join_game disappeared; room joined")
                return True
            pause(0.25)
        if raise_on_timeout:
            raise TimeoutError("Timed out waiting for room join completion")
        return False

    def move_mouse_away_from_room(self, session: War3Session) -> None:
        left, top, right, bottom = self._window_rect(session)
        x = min(right - 20, left + 40)
        y = min(bottom - 20, top + 40)
        print(f"[war3auto] move mouse away from room list: ({x}, {y})")
        move_mouse(x, y, dry_run=self.config.dry_run)


class MultiPlayerTestWorkflow(BaseWorkflow):
    def run(self) -> None:
        self.check_assets()
        if self.config.dry_run and not self.config.launch_war3:
            self._print_dry_run_plan()
            return
        if not self.config.launch_war3:
            raise RuntimeError("MultiPlayerTest requires --launch-war3 so host/client windows can be bound")

        print(f"[war3auto] MultiPlayerTest players={self.config.players}")
        layouts = self._player_layouts()
        host = launch_war3_and_bind_window(self.config, "host")
        apply_layout(host, layouts[0], dry_run=self.config.dry_run)
        pause(self.config.click_delay_seconds)
        self.goto_lan(host)
        self.host_create_game(host)

        clients: list[War3Session] = []
        for index in range(self.config.clients):
            role = f"client{index + 1}"
            client = launch_war3_and_bind_window(self.config, role)
            apply_layout(client, layouts[index + 1], dry_run=self.config.dry_run)
            pause(self.config.click_delay_seconds)
            self.client_join_first_room(client)
            clients.append(client)

        print(f"[war3auto] clients joined: {len(clients)}")
        pause(self.config.post_join_delay_seconds)
        self.host_start_game(host)

    def _print_dry_run_plan(self) -> None:
        print("[war3auto] dry-run MultiPlayerTest plan")
        print(f"[war3auto] players: {self.config.players}")
        layouts = self._player_layouts()
        print(f"[war3auto] host position: x={layouts[0][0]} y={layouts[0][1]}")
        for index in range(self.config.clients):
            layout = layouts[index + 1]
            print(f"[war3auto] client{index + 1} position: x={layout[0]} y={layout[1]}")
        print("[war3auto] host: launch -> bind -> L -> C -> C")
        print("[war3auto] each client: launch -> bind -> L -> slow double-click room_list.png -> move mouse away -> if join_game disappears then joined, else wait select_room.png -> J")
        print(f"[war3auto] host: wait {self.config.post_join_delay_seconds:.1f}s -> Alt+S")

    def _player_layouts(self) -> tuple[tuple[int, int, int, int], ...]:
        if self.config.host_layout is not None and self.config.client_layouts:
            return (self.config.host_layout,) + self.config.client_layouts[: self.config.clients]
        return player_layouts(self.config.players)


def run_multi_player_test(config: AutomationConfig) -> None:
    MultiPlayerTestWorkflow(config).run()
