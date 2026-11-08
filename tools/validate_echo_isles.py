#!/usr/bin/env python3
"""Validate the Echo Isles Jak 3 custom-level source package.

This checks repository structure and descriptor consistency only. It does not
replace OpenGOAL compilation or an in-game collision/spawn test.
"""
from __future__ import annotations

import json
import re
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEVEL_DIR = ROOT / "custom_assets/jak3/levels/echo-isles"
JSONC = LEVEL_DIR / "echo-isles.jsonc"
DGO = LEVEL_DIR / "echo-isles.gd"
EXPECTED_GLB = LEVEL_DIR / "echo-isles.glb"


def strip_jsonc_comments(source: str) -> str:
    """Remove // and /* */ comments without touching quoted strings."""
    out: list[str] = []
    i = 0
    in_string = False
    escaped = False
    while i < len(source):
        ch = source[i]
        nxt = source[i + 1] if i + 1 < len(source) else ""
        if in_string:
            out.append(ch)
            if escaped:
                escaped = False
            elif ch == "\\\\":
                escaped = True
            elif ch == '"':
                in_string = False
            i += 1
            continue
        if ch == '"':
            in_string = True
            out.append(ch)
            i += 1
            continue
        if ch == "/" and nxt == "/":
            i += 2
            while i < len(source) and source[i] not in "\\r\\n":
                i += 1
            continue
        if ch == "/" and nxt == "*":
            i += 2
            while i + 1 < len(source) and source[i:i + 2] != "*/":
                i += 1
            i += 2
            continue
        out.append(ch)
        i += 1
    return "".join(out)


def fail(message: str) -> None:
    raise ValueError(message)


def main() -> int:
    for required in (JSONC, DGO, EXPECTED_GLB):
        if not required.is_file():
            fail(f"Missing required level file: {required.relative_to(ROOT)}")

    config = json.loads(strip_jsonc_comments(JSONC.read_text(encoding="utf-8")))
    checks = {
        "long_name": config.get("long_name") == "echo-isles",
        "iso_name": config.get("iso_name") == "ECHOISLE",
        "nickname": config.get("nickname") == "eis",
        "base_id": isinstance(config.get("base_id"), int) and config["base_id"] >= 1,
        "base_region_id": isinstance(config.get("base_region_id"), int),
        "wall_detection": config.get("automatic_wall_detection") is True,
    }
    bad = [name for name, passed in checks.items() if not passed]
    if bad:
        fail("Invalid Echo Isles JSONC fields: " + ", ".join(bad))

    glb_path = ROOT / config["gltf_file"]
    if glb_path.resolve() != EXPECTED_GLB.resolve():
        fail(f"gltf_file must point to {EXPECTED_GLB.relative_to(ROOT)}")
    data = EXPECTED_GLB.read_bytes()
    if len(data) < 12 or data[:4] != b"glTF":
        fail("GLB header is missing or invalid")
    version, declared_length = struct.unpack_from("<II", data, 4)
    if version != 2:
        fail(f"Expected glTF binary version 2, got {version}")
    if declared_length != len(data):
        fail(f"GLB declared length {declared_length} does not match file size {len(data)}")

    dgo = DGO.read_text(encoding="utf-8")
    for token in ('"EIS.DGO"', '"echo-isles-obs.o"', '"echo-isles.go"'):
        if token not in dgo:
            fail(f"DGO descriptor is missing {token}")

    print("Echo Isles source-package checks passed.")
    print("Note: OpenGOAL compilation and in-game tests are not covered.")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
