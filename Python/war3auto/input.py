from __future__ import annotations

import time


def _import_pyautogui():
    try:
        import pyautogui
    except ImportError as exc:
        raise RuntimeError("Missing dependency: install pyautogui from Python/requirements.txt") from exc
    pyautogui.PAUSE = 0.05
    return pyautogui


def click(
    x: int,
    y: int,
    dry_run: bool = False,
    hold_seconds: float = 0.05,
    clicks: int = 1,
    interval_seconds: float = 0.12,
) -> None:
    if dry_run:
        print(f"[war3auto] dry-run click at ({x}, {y}) clicks={clicks} hold={hold_seconds:.2f}s")
        return
    pyautogui = _import_pyautogui()
    pyautogui.moveTo(x=x, y=y, duration=0.12)
    for index in range(clicks):
        pyautogui.mouseDown(x=x, y=y)
        time.sleep(hold_seconds)
        pyautogui.mouseUp(x=x, y=y)
        if index + 1 < clicks:
            time.sleep(interval_seconds)


def click_center(
    center: tuple[int, int],
    dry_run: bool = False,
    hold_seconds: float = 0.05,
    clicks: int = 1,
    interval_seconds: float = 0.12,
) -> None:
    click(
        center[0],
        center[1],
        dry_run=dry_run,
        hold_seconds=hold_seconds,
        clicks=clicks,
        interval_seconds=interval_seconds,
    )


def move_mouse(x: int, y: int, dry_run: bool = False, duration_seconds: float = 0.12) -> None:
    if dry_run:
        print(f"[war3auto] dry-run move mouse to ({x}, {y})")
        return
    pyautogui = _import_pyautogui()
    pyautogui.moveTo(x=x, y=y, duration=duration_seconds)


def press_key(key: str, dry_run: bool = False) -> None:
    if dry_run:
        print(f"[war3auto] dry-run press key: {key}")
        return
    pyautogui = _import_pyautogui()
    keys = tuple(part.strip().lower() for part in key.split("+") if part.strip())
    if len(keys) > 1:
        pyautogui.hotkey(*keys)
    elif keys:
        pyautogui.press(keys[0])


def pause(seconds: float) -> None:
    time.sleep(seconds)
