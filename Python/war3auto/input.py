from __future__ import annotations

import time


def _import_pyautogui():
    try:
        import pyautogui
    except ImportError as exc:
        raise RuntimeError("Missing dependency: install pyautogui from Python/requirements.txt") from exc
    pyautogui.PAUSE = 0.05
    return pyautogui


def click(x: int, y: int, dry_run: bool = False) -> None:
    if dry_run:
        print(f"[war3auto] dry-run click at ({x}, {y})")
        return
    pyautogui = _import_pyautogui()
    pyautogui.click(x=x, y=y)


def click_center(center: tuple[int, int], dry_run: bool = False) -> None:
    click(center[0], center[1], dry_run=dry_run)


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
