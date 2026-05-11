from __future__ import annotations

from .session import War3Session
from .window import get_window_rect, move_window


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
