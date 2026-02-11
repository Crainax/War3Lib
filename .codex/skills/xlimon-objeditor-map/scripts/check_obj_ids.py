#!/usr/bin/env python3
"""
检查 War3Lib 物编 ID / Order 冲突。

- 4 位对象 ID 按大小写不敏感比较
- 检查项目对象文件与项目内 db
- 检查 Order 是否已被标记为使用（db/list/List_Order.ini 中行尾含 //）
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path

SECTION_RE = re.compile(r"^\[([A-Za-z0-9]{4})\]\s*$")
ORDER_LINE_RE = re.compile(r"^\s*([A-Za-z0-9_]+)\s*=\s*([0-9]+)(.*)$")

DEFAULT_PROJECT_EXTS = (".ini", ".w3a", ".w3b", ".w3d", ".w3h", ".w3i", ".w3q", ".w3t", ".w3u")
DEFAULT_DB_ROOT = "db"
DEFAULT_DB_FILES = (
    "ability.ini",
    "buff.ini",
    "destructable.ini",
    "doodad.ini",
    "item.ini",
    "unit.ini",
    "upgrade.ini",
    "misc.ini",
    "txt.ini",
)


@dataclass(frozen=True)
class FoundID:
    raw: str
    path: Path
    line_no: int
    source: str


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Check War3Lib object editor ID/Order conflicts.")
    parser.add_argument(
        "--project-root",
        default=".",
        help="Project root path (default: current dir).",
    )
    parser.add_argument(
        "--project-table",
        action="append",
        default=[],
        help="Relative project path under project root (dir or file). Repeatable.",
    )
    parser.add_argument(
        "--db-root",
        default="",
        help="War3 db root path. If omitted, use project-root/db.",
    )
    parser.add_argument(
        "--db-file",
        action="append",
        default=[],
        help="INI filename under db root. Repeatable.",
    )
    parser.add_argument(
        "--id",
        action="append",
        default=[],
        help="Candidate 4-char object ID to check. Repeatable.",
    )
    parser.add_argument(
        "--order",
        action="append",
        default=[],
        help="Order key to check in db/list/List_Order.ini. Repeatable.",
    )
    parser.add_argument(
        "--order-list",
        default="db/list/List_Order.ini",
        help="Relative path of order list under project root.",
    )
    parser.add_argument(
        "--strict-existing",
        action="store_true",
        help="Treat existing index conflicts as errors (default: warn only).",
    )
    return parser.parse_args()


def collect_ids_in_file(path: Path, source: str) -> list[FoundID]:
    found: list[FoundID] = []
    if not path.exists() or not path.is_file():
        return found

    try:
        with path.open("r", encoding="utf-8", errors="ignore") as f:
            for i, line in enumerate(f, start=1):
                m = SECTION_RE.match(line.strip())
                if not m:
                    continue
                found.append(FoundID(raw=m.group(1), path=path, line_no=i, source=source))
    except OSError:
        return found
    return found


def collect_ids_in_dir(path: Path, source: str) -> list[FoundID]:
    found: list[FoundID] = []
    if not path.exists() or not path.is_dir():
        return found
    exts = {x.lower() for x in DEFAULT_PROJECT_EXTS}
    for f in sorted(path.rglob("*")):
        if not f.is_file():
            continue
        if f.suffix.lower() not in exts:
            continue
        found.extend(collect_ids_in_file(f, source=source))
    return found


def pick_db_root(arg_db_root: str, project_root: Path) -> Path | None:
    if arg_db_root:
        p = Path(arg_db_root)
        return p if p.exists() and p.is_dir() else None
    p = (project_root / DEFAULT_DB_ROOT).resolve()
    if p.exists() and p.is_dir():
        return p
    return None


def parse_order_list(path: Path) -> tuple[dict[str, tuple[int, bool]], list[str]]:
    data: dict[str, tuple[int, bool]] = {}
    issues: list[str] = []

    if not path.exists():
        issues.append(f"order list not found: {path}")
        return data, issues

    try:
        with path.open("r", encoding="utf-8", errors="ignore") as f:
            for i, raw in enumerate(f, start=1):
                line = raw.rstrip("\n")
                if not line.strip():
                    continue
                m = ORDER_LINE_RE.match(line)
                if not m:
                    continue
                key = m.group(1)
                value = int(m.group(2))
                tail = m.group(3) or ""
                used = "//" in tail
                data[key.lower()] = (value, used)
    except OSError as e:
        issues.append(f"cannot read order list: {e}")
    return data, issues


def main() -> int:
    args = parse_args()
    project_root = Path(args.project_root).resolve()

    project_tables = tuple(args.project_table) if args.project_table else ("UnitTestMap/table", "Jass")
    db_files = tuple(args.db_file) if args.db_file else DEFAULT_DB_FILES

    all_found: list[FoundID] = []
    missing_paths: list[Path] = []

    for rel in project_tables:
        p = (project_root / rel).resolve()
        if not p.exists():
            missing_paths.append(p)
            continue
        if p.is_dir():
            all_found.extend(collect_ids_in_dir(p, source="project"))
        elif p.is_file():
            all_found.extend(collect_ids_in_file(p, source="project"))
        else:
            missing_paths.append(p)

    db_root = pick_db_root(args.db_root, project_root)
    if db_root is None:
        print("[warn] no db root found; skip db check")
    else:
        for ini in db_files:
            p = (db_root / ini).resolve()
            all_found.extend(collect_ids_in_file(p, source="db"))

    by_lower: dict[str, list[FoundID]] = {}
    for item in all_found:
        by_lower.setdefault(item.raw.lower(), []).append(item)

    hard_conflicts = 0
    existing_conflicts = 0

    print("== ID Index Summary ==")
    print(f"project_root: {project_root}")
    print(f"project_ids: {sum(1 for x in all_found if x.source == 'project')}")
    print(f"db_ids: {sum(1 for x in all_found if x.source == 'db')}")
    if missing_paths:
        for p in missing_paths:
            print(f"[warn] missing table path: {p}")

    # 全量扫描：报告已有大小写冲突（默认仅告警，避免被历史数据阻塞）
    for k, items in sorted(by_lower.items()):
        raws = {x.raw for x in items}
        if len(raws) > 1:
            existing_conflicts += 1
            print(f"[warn] existing case-insensitive duplicate key '{k}' with variants: {sorted(raws)}")
            for hit in items[:6]:
                print(f"  - {hit.path}:{hit.line_no} [{hit.raw}] ({hit.source})")
            if len(items) > 6:
                print(f"  - ... and {len(items) - 6} more")

    # 候选 ID 校验
    if args.id:
        print("== Candidate ID Check ==")
    seen_candidates: set[str] = set()
    for candidate in args.id:
        c = candidate.strip()
        if not re.fullmatch(r"[A-Za-z0-9]{4}", c):
            hard_conflicts += 1
            print(f"[invalid] '{candidate}' is not 4-char alnum ID")
            continue

        lower = c.lower()
        if lower in seen_candidates:
            hard_conflicts += 1
            print(f"[conflict] candidate duplicated in args (case-insensitive): {candidate}")
            continue
        seen_candidates.add(lower)

        hits = by_lower.get(lower, [])
        if hits:
            hard_conflicts += 1
            print(f"[conflict] candidate '{c}' already exists:")
            for hit in hits[:8]:
                print(f"  - {hit.path}:{hit.line_no} [{hit.raw}] ({hit.source})")
            if len(hits) > 8:
                print(f"  - ... and {len(hits) - 8} more")
        else:
            print(f"[ok] candidate '{c}' is free in project + db scope")

    # Order 检查
    order_list_path = (project_root / args.order_list).resolve()
    order_map, order_issues = parse_order_list(order_list_path)
    for issue in order_issues:
        print(f"[warn] {issue}")

    if args.order:
        print("== Candidate Order Check ==")
    for order in args.order:
        key = order.strip().lower()
        if key in order_map:
            value, used = order_map[key]
            state = "used(//)" if used else "unmarked"
            print(f"[hit] order '{order}' => {value}, state={state}")
            if used:
                hard_conflicts += 1
                print("  [conflict] order is marked as used in List_Order.ini")
        else:
            print(f"[ok] order '{order}' not found in List_Order.ini (treat as custom/new)")

    if args.strict_existing and existing_conflicts > 0:
        hard_conflicts += existing_conflicts

    if hard_conflicts > 0:
        print(f"== Result: FAIL ({hard_conflicts} conflict/invalid) ==")
        return 1

    if existing_conflicts > 0:
        print(f"== Result: PASS (with {existing_conflicts} existing warning) ==")
    else:
        print("== Result: PASS ==")
    return 0


if __name__ == "__main__":
    sys.exit(main())
