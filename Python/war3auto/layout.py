from __future__ import annotations

import ctypes

from .session import War3Session
from .window import get_window_rect, move_window


def screen_size() -> tuple[int, int]:
    user32 = ctypes.windll.user32
    return int(user32.GetSystemMetrics(0)), int(user32.GetSystemMetrics(1))


def row_sizes_for_players(players: int) -> tuple[int, ...]:
    if players <= 3:
        return (players,)
    if players == 4:
        return (2, 2)
    if players == 5:
        return (3, 2)
    return (3, 3)


def player_layouts(players: int) -> tuple[tuple[int, int, int, int], ...]:
    width, height = screen_size()
    rows = row_sizes_for_players(players)
    layouts: list[tuple[int, int, int, int]] = []
    for row_index, row_count in enumerate(rows):
        y = int(row_index * height / len(rows))
        for col_index in range(row_count):
            x = int(col_index * width / row_count)
            layouts.append((x, y, 0, 0))
    return tuple(layouts[:players])


def apply_layout(
    session: War3Session,
    layout: tuple[int, int, int, int],
    dry_run: bool = False,
) -> None:
    x, y, _, _ = layout
    left, top, right, bottom = get_window_rect(session.hwnd)
    width = max(1, right - left)
    height = max(1, bottom - top)
    print(
        f"[war3auto] layout {session.role}: x={x} y={y} "
        f"keep-size={width}x{height}"
    )
    if dry_run:
        return
    move_window(session.hwnd, x, y, width, height)
