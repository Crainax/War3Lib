"""Check emitted JASS cleanup, including the native-type-name assignment trap.

Run after compiling LootReveal_Test.j:
    python Jass/ui/composite/loot/verify_codegen.py Output/output.j
This checks compiled output, not only the Zinc source. It does not run Warcraft.
"""
import re
import sys
from pathlib import Path


def verify(path: Path):
    text = path.read_text(encoding="utf-8-sig")

    def body(name):
        match = re.search(r"^function " + re.escape(name) + r"\b.*?^endfunction", text, re.M | re.S)
        assert match, f"missing generated function {name}"
        return match.group()

    checked = 0
    for name, expected in [("s__LootReveal___lootEntry_releaseFrames", 9),
                           ("s__lootReveal_releaseFrames", 11)]:
        function_body = body(name)
        destroys = list(re.finditer(
            r"call s__ui(?:Btn|Text|Image)_destroy\((s__\w+\[this\])\)", function_body))
        assert len(destroys) == expected, (name, len(destroys), expected)
        for destroy in destroys:
            field = destroy.group(1)
            # The same branch must clear the reference before its endif. A later
            # reset elsewhere is not evidence that repeated cleanup is safe.
            branch_tail = function_body[destroy.end():].split("endif", 1)[0]
            assert re.search(r"\bset\s+" + re.escape(field) + r"\s*=\s*0\b", branch_tail), (
                f"{name}: missing reset after destroying {field}; repeated cleanup double-frees the UI instance")
            checked += 1
    print(f"PASS: all {checked} generated UI destroy branches clear their member references")
    assert "set s__lootReveal_buildNext[this] = 0" in body("s__lootReveal_releaseFrames")
    assert "set s__lootReveal_buildNext[this] = s__LootReveal___lootEntry_next[entry]" in body("s__lootReveal_buildItem")
    assert re.search(r"if \(s__lootReveal_buildNext\[this\] != 0\) then\s*"
                     r"call s__lootReveal_buildItem\(this\)\s*return\s*endif",
                     body("s__lootReveal_tick")), "must yield before animating partially built frames"
    assert not re.search(r"^\s*loop\s*$", body("s__lootReveal_buildItem"), re.M), "card construction must not loop all rewards"
    assert "call s__lootReveal_tick()" not in body("UTLootReveal___RegressionStep")
    assert "call s__LootReveal___nameBytes_onInit()" in text
    print("PASS: generated construction yields one card per tick and cleanup clears its cursor")


if __name__ == "__main__":
    verify(Path(sys.argv[1] if len(sys.argv) > 1 else "Output/output.j"))
