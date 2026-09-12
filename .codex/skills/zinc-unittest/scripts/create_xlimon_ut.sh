#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  create_ut.sh <module.j> [--project-root <path>] [--include-root <win-path>] [--unit-test-h <path>] [--force] [--dry-run]

Examples:
  create_ut.sh edit/unit/Attr.j
  create_ut.sh edit/ability/base/SpellData.j --include-root "D:/War3/Maps/Xlimon"
USAGE
}

if [[ ${1:-} == "" || ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

module_path="$1"
shift

project_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
include_root="D:/War3/Maps/Xlimon"
unit_test_h="$project_root/edit/config/UnitTest.h"
force="0"
dry_run="0"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-root)
      project_root="$2"
      shift 2
      ;;
    --include-root)
      include_root="$2"
      shift 2
      ;;
    --unit-test-h)
      unit_test_h="$2"
      shift 2
      ;;
    --force)
      force="1"
      shift
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

if [[ "$module_path" != *.j ]]; then
  echo "[create_ut] error: module path must end with .j" >&2
  exit 1
fi

if [[ "$module_path" != /* ]]; then
  module_abs="$PWD/$module_path"
else
  module_abs="$module_path"
fi

if [[ ! -f "$module_abs" ]]; then
  echo "[create_ut] error: module not found: $module_abs" >&2
  exit 1
fi

project_root="${project_root%/}"
if [[ "$module_abs" != "$project_root/"* ]]; then
  echo "[create_ut] error: module must be inside project root: $project_root" >&2
  exit 1
fi

module_rel="${module_abs#"$project_root/"}"
test_rel="${module_rel%.j}_Test.j"
test_abs="$project_root/$test_rel"

module_name="$(basename "$module_rel" .j)"
guard="UT${module_name}Included"
ut_lib="UT${module_name}"

module_include="${include_root%/}/$module_rel"
test_include="${include_root%/}/$test_rel"
module_include="${module_include//\\//}"
test_include="${test_include//\\//}"

echo "[create_ut] project_root=$project_root"
echo "[create_ut] module=$module_rel"
echo "[create_ut] test=$test_rel"
echo "[create_ut] unit_test_h=$unit_test_h"

if [[ "$force" == "1" || ! -f "$test_abs" ]]; then
  echo "[create_ut] generate: $test_abs"
  if [[ "$dry_run" != "1" ]]; then
    mkdir -p "$(dirname "$test_abs")"
    cat >"$test_abs" <<EOF
#ifndef $guard
#define $guard

// 用原始地图测试
#undef OriginMapUnitTestMode

#include "$module_include"

//! zinc

//自动生成的文件
library $ut_lib requires $module_name {

    function Init () {
        UnitTestAutoTimer(0.1, 2.0, function() {
            //start,这里是0.1秒后调用的内容
            }, function() {
            //end,这里是2秒后调用的内容
        });
        UnitTestAutoTimer(0.1, 2.0, function() {
            //assert.Boolean(true, "测试1");
        },null);
    }

    function TTest$ut_lib""1 (player p) {}
    function TTest$ut_lib""2 (player p) {}
    function TTest$ut_lib""3 (player p) {}
    function TTest$ut_lib""4 (player p) {}
    function TTest$ut_lib""5 (player p) {}
    function TTest$ut_lib""6 (player p) {}
    function TTest$ut_lib""7 (player p) {}
    function TTest$ut_lib""8 (player p) {}
    function TTest$ut_lib""9 (player p) {}
    function TTest$ut_lib""10 (player p) {}
    function TTestAct$ut_lib""1 (string str) {
        player  p     = GetTriggerPlayer();
        integer index = GetConvertedPlayerId(p);
        integer i,     num = 0, len = StringLength(str); //获取范围式数字
        string  paramS [];                               //所有参数S
        integer paramI [];                               //所有参数I
        real    paramR [];                               //所有参数R
        for (0 <= i <= len - 1) {
            if (SubString(str,i,i+1) == " ") {
                paramS[num]= SubString(str,0,i);
                paramI[num]= S2I(paramS[num]);
                paramR[num]= S2R(paramS[num]);
                num = num + 1;
                str = SubString(str,i + 1,len);
                len = StringLength(str);
                i = -1;
            }
        }
        paramS[num]= str;
        paramI[num]= S2I(paramS[num]);
        paramR[num]= S2R(paramS[num]);
        num = num + 1;

        if (paramS[0] == "a") {

        } else if (paramS[0] == "b") {

        }

        p = null;
    }

    function onInit () {
        //在游戏开始0.0秒后再调用
        trigger tr = CreateTrigger();
        TriggerRegisterTimerEventSingle(tr,0.5);
        TriggerAddCondition(tr,Condition(function (){
            BJDebugMsg("[$module_name] 单元测试已加载");
            Init();
            DestroyTrigger(GetTriggeringTrigger());
        }));
        tr = null;

        UnitTestRegisterChatEvent(function () {
            string str = GetEventPlayerChatString();
            integer i = 1;

            if (SubStringBJ(str,1,1) == "-") {
                TTestAct$ut_lib""1(SubStringBJ(str,2,StringLength(str)));
                return;
            }
            if (str == "s1") TTest$ut_lib""1(GetTriggerPlayer());
            else if(str == "s2") TTest$ut_lib""2(GetTriggerPlayer());
            else if(str == "s3") TTest$ut_lib""3(GetTriggerPlayer());
            else if(str == "s4") TTest$ut_lib""4(GetTriggerPlayer());
            else if(str == "s5") TTest$ut_lib""5(GetTriggerPlayer());
            else if(str == "s6") TTest$ut_lib""6(GetTriggerPlayer());
            else if(str == "s7") TTest$ut_lib""7(GetTriggerPlayer());
            else if(str == "s8") TTest$ut_lib""8(GetTriggerPlayer());
            else if(str == "s9") TTest$ut_lib""9(GetTriggerPlayer());
            else if(str == "s10") TTest$ut_lib""10(GetTriggerPlayer());
        });

    }

}
//! endzinc

#endif
EOF
  fi
else
  echo "[create_ut] keep existing test file (use --force to regenerate)"
fi

if [[ -f "$unit_test_h" ]]; then
  echo "[create_ut] switch UnitTest include => $test_include"
  if [[ "$dry_run" != "1" ]]; then
    tmp="$(mktemp)"
    awk -v newline="#include \"$test_include\"" '
      BEGIN { done = 0 }
      {
        if (done == 0 && $0 ~ /^#include "/) {
          print newline
          done = 1
        } else {
          print $0
        }
      }
      END {
        if (done == 0) {
          print newline
        }
      }
    ' "$unit_test_h" > "$tmp"
    mv "$tmp" "$unit_test_h"
  fi
else
  echo "[create_ut] warning: UnitTest.h not found, skipped include switch"
fi

echo "[create_ut] done"
