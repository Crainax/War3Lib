from __future__ import annotations

import time
from dataclasses import dataclass
from typing import Iterable


EXCLUDED_TITLE_KEYWORDS = (
    "antigravity",
    "codex",
    "war3lib",
)


@dataclass(frozen=True)
class WindowInfo:
    hwnd: int
    title: str
    rect: tuple[int, int, int, int]
    pid: int


def _import_win32():
    try:
        import win32con
        import win32gui
        import win32process
    except ImportError as exc:
        raise RuntimeError("Missing dependency: install pywin32 from Python/requirements.txt") from exc
    return win32con, win32gui, win32process


def list_windows(title_keywords: Iterable[str]) -> list[WindowInfo]:
    _, win32gui, win32process = _import_win32()
    keywords = tuple(keyword.lower() for keyword in title_keywords if keyword)
    matches: list[WindowInfo] = []

    def enum_handler(hwnd: int, _: object) -> None:
        if not win32gui.IsWindowVisible(hwnd):
            return
        title = win32gui.GetWindowText(hwnd) or ""
        if not title:
            return
        lowered = title.lower()
        if any(keyword in lowered for keyword in EXCLUDED_TITLE_KEYWORDS):
            return
        if not any(keyword in lowered for keyword in keywords):
            return
        rect = win32gui.GetWindowRect(hwnd)
        _, pid = win32process.GetWindowThreadProcessId(hwnd)
        matches.append(WindowInfo(hwnd=hwnd, title=title, rect=rect, pid=pid))

    win32gui.EnumWindows(enum_handler, None)
    return matches


def list_war3_windows(title_keywords: Iterable[str]) -> list[WindowInfo]:
    return list_windows(title_keywords)


def wait_new_war3_window(
    before_hwnds: Iterable[int],
    title_keywords: Iterable[str],
    timeout_seconds: float,
) -> WindowInfo:
    before = set(before_hwnds)
    deadline = time.monotonic() + timeout_seconds
    last_titles: list[str] = []
    while time.monotonic() < deadline:
        windows = list_war3_windows(title_keywords)
        for window in windows:
            if window.hwnd not in before:
                return window
        last_titles = [window.title for window in windows]
        time.sleep(0.5)
    suffix = f"; candidates={last_titles}" if last_titles else ""
    raise TimeoutError(f"New Warcraft III window not found within {timeout_seconds:.1f}s{suffix}")


def find_war3_window(title_keywords: Iterable[str], timeout_seconds: float) -> WindowInfo:
    deadline = time.monotonic() + timeout_seconds
    last_titles: list[str] = []
    while time.monotonic() < deadline:
        windows = list_windows(title_keywords)
        if windows:
            return windows[0]
        if windows:
            last_titles = [window.title for window in windows]
        time.sleep(0.5)
    suffix = f"; candidates={last_titles}" if last_titles else ""
    raise TimeoutError(f"Warcraft III window not found within {timeout_seconds:.1f}s{suffix}")


def activate_window(hwnd: int) -> None:
    win32con, win32gui, _ = _import_win32()
    if win32gui.IsIconic(hwnd):
        win32gui.ShowWindow(hwnd, win32con.SW_RESTORE)
        time.sleep(0.1)
    try:
        win32gui.SetForegroundWindow(hwnd)
    except Exception as exc:
        raise RuntimeError(f"Failed to activate Warcraft III window: hwnd={hwnd}") from exc
    time.sleep(0.2)


def get_window_rect(hwnd: int) -> tuple[int, int, int, int]:
    _, win32gui, _ = _import_win32()
    return win32gui.GetWindowRect(hwnd)


def move_window(hwnd: int, x: int, y: int, width: int, height: int) -> None:
    _, win32gui, _ = _import_win32()
    win32gui.MoveWindow(hwnd, x, y, width, height, True)
