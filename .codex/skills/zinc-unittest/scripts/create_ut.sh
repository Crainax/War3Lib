#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  create_ut.sh <module.j> [--root <war3-root>] [--project <war3lib-project>] [--we <we-path>] [--dry-run]

Examples:
  create_ut.sh Jass/utils/unit/UnitUtils.j
  create_ut.sh Jass/utils/ability/SpellUtils.j --we "/Applications/Warcraft III/Warcraft III.app"
USAGE
}

if [[ ${1:-} == "" || ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

module_path="$1"
shift

if [[ "$module_path" != *.j ]]; then
  echo "[create_ut] error: module path must end with .j" >&2
  exit 1
fi

if [[ ! -f "$module_path" ]]; then
  echo "[create_ut] error: file not found: $module_path" >&2
  exit 1
fi

project_default="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
if [[ "$project_default" == *"/Library/War3Lib" ]]; then
  root_default="${project_default%/Library/War3Lib}"
else
  root_default="$(dirname "$project_default")"
fi

root="$root_default"
project="$project_default"
we="${WE_PATH:-$root_default}"
dry_run="0"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)
      root="$2"
      shift 2
      ;;
    --project)
      project="$2"
      shift 2
      ;;
    --we)
      we="$2"
      shift 2
      ;;
    --dry-run)
      dry_run="1"
      shift
      ;;
    *)
      echo "[create_ut] error: unknown arg: $1" >&2
      usage
      exit 1
      ;;
  esac
done

lua_task="$project/Lua/tasks/TaskCreateUT.lua"
if [[ ! -f "$lua_task" ]]; then
  echo "[create_ut] error: TaskCreateUT.lua not found at $lua_task" >&2
  exit 1
fi

cmd=(lua "$lua_task" "$root" "$project" "$we" "$module_path")
echo "[create_ut] root=$root"
echo "[create_ut] project=$project"
echo "[create_ut] we=$we"
echo "[create_ut] module=$module_path"

echo "[create_ut] command: ${cmd[*]}"
if [[ "$dry_run" == "1" ]]; then
  exit 0
fi

"${cmd[@]}"
