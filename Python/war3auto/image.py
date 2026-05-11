from __future__ import annotations

import time
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class MatchResult:
    template: Path
    score: float
    center: tuple[int, int]
    box: tuple[int, int, int, int]


def _import_cv():
    try:
        import cv2
        import numpy as np
    except ImportError as exc:
        raise RuntimeError("Missing dependency: install opencv-python and numpy from Python/requirements.txt") from exc
    return cv2, np


def _import_mss():
    try:
        import mss
    except ImportError as exc:
        raise RuntimeError("Missing dependency: install mss from Python/requirements.txt") from exc
    return mss


def capture_rect(rect: tuple[int, int, int, int]):
    cv2, np = _import_cv()
    mss = _import_mss()
    left, top, right, bottom = rect
    width = max(1, right - left)
    height = max(1, bottom - top)
    with mss.mss() as sct:
        raw = sct.grab({"left": left, "top": top, "width": width, "height": height})
    image = np.array(raw)
    return cv2.cvtColor(image, cv2.COLOR_BGRA2BGR), (left, top)


def find_image(rect: tuple[int, int, int, int], template_path: Path, threshold: float) -> MatchResult | None:
    cv2, _ = _import_cv()
    screenshot, offset = capture_rect(rect)
    template = cv2.imread(str(template_path), cv2.IMREAD_COLOR)
    if template is None:
        raise FileNotFoundError(f"Template image cannot be read: {template_path}")

    screen_h, screen_w = screenshot.shape[:2]
    tpl_h, tpl_w = template.shape[:2]
    if tpl_w > screen_w or tpl_h > screen_h:
        raise ValueError(f"Template is larger than the window screenshot: {template_path}")

    result = cv2.matchTemplate(screenshot, template, cv2.TM_CCOEFF_NORMED)
    _, max_score, _, max_loc = cv2.minMaxLoc(result)
    if max_score < threshold:
        return None

    left = offset[0] + max_loc[0]
    top = offset[1] + max_loc[1]
    return MatchResult(
        template=template_path,
        score=float(max_score),
        center=(left + tpl_w // 2, top + tpl_h // 2),
        box=(left, top, tpl_w, tpl_h),
    )


def wait_image(
    rect_provider,
    template_path: Path,
    threshold: float,
    timeout_seconds: float,
    poll_seconds: float = 0.35,
) -> MatchResult:
    deadline = time.monotonic() + timeout_seconds
    best_error: Exception | None = None
    while time.monotonic() < deadline:
        try:
            match = find_image(rect_provider(), template_path, threshold)
            if match is not None:
                return match
        except Exception as exc:
            best_error = exc
        time.sleep(poll_seconds)
    if best_error is not None:
        raise TimeoutError(f"Timed out waiting for {template_path.name}: {best_error}") from best_error
    raise TimeoutError(f"Timed out waiting for {template_path.name}")
