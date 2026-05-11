from __future__ import annotations

from dataclasses import dataclass

from .window import WindowInfo


@dataclass(frozen=True)
class War3Session:
    role: str
    hwnd: int
    pid: int
    title: str
    rect: tuple[int, int, int, int]

    @classmethod
    def from_window(cls, role: str, window: WindowInfo) -> War3Session:
        return cls(
            role=role,
            hwnd=window.hwnd,
            pid=window.pid,
            title=window.title,
            rect=window.rect,
        )
