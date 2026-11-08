#!/usr/bin/env python3
"""Validate Echo Isles source assets; this is not an OpenGOAL build/runtime test."""
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
GLB = LEVEL_DIR / "echo-isles.glb"

def strip_jsonc_comments(source: str) -> str:
    out = []
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
            elif ch == "\\":
                escaped = True
            elif ch == '"':
                in_string = False
            i += 1
        elif ch == '"':
            in_string = True
            out.append(ch)
            i += 1
        elif ch == "/" and nxt == "/":
            i += 2
            while i < len(source) and source[i] not in "\r\n":
                i += 1
        elif ch == "/" and nxt == "*":
            i += 2
            while i + 1 < len(source) and source[i:i + 2] != "*/":
                i += 1
            i += 2
        else:
            out.append(ch)
            i += 1
    return "".join(out)

def fail(message: str) -> None:
    raise ValueError(message)

def read_glb_json(data: bytes) -> dict:
    if len(data) < 20 or data[:4] != b"glTF":
        fail("GLB header is missing or invalid")
    version, declared_length = struct.unpack_from("<II", data, 4)
    if version != 2:
        fail(f"Expected glTF binary version 2, got {version}")
    if declared_length != len(data):
        fail(f"GLB declared length {declared_length} does not match file size {len(data)}")
    json_length, json_type = struct.unpack_from("<II", data, 12)
    if json_type != 0x4E4F534A:
        fail("First GLB chunk is not JSON")
    end = 20 + json_length
    if end > len(data):
        fail("GLB JSON chunk extends beyond file size")
    try:
        return json.loads(data[20:end].decode("utf-8").rstrip(" \t\r\n\0"))
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        fail(f"GLB JSON chunk is invalid: {exc}")

def main() -> int:
    for required in (JSONC, DGO, GLB):
        if not required.is_file():
            fail(f"Missing required file: {required.relative_to(ROOT)}")
    config = json.loads(strip_jsonc_comments(JSONC.read_text(encoding="utf-8")))
    fields = {
        "long_name": config.get("long_name") == "echo-isles" and len(config.get("long_name", "")) <= 10,
        "iso_name": config.get("iso_name") == "ECHOISLE" and len(config.get("iso_name", "")) <= 8,
        "nickname": config.get("nickname") == "eis",
        "base_id": isinstance(config.get("base_id"), int) and config["base_id"] >= 1,
        "base_region_id": isinstance(config.get("base_region_id"), int),
        "wall_detection": config.get("automatic_wall_detection") is True,
    }
    bad = [name for name, ok in fields.items() if not ok]
    if bad:
        fail("Invalid JSONC fields: " + ", ".join(bad))
    if (ROOT / config["gltf_file"]).resolve() != GLB.resolve():
        fail("gltf_file points outside the Echo Isles GLB")
    gltf = read_glb_json(GLB.read_bytes())
    primitives = [p for mesh in gltf.get("meshes", []) for p in mesh.get("primitives", [])]
    if not primitives:
        fail("GLB contains no mesh primitives")
    missing = [i for i, p in enumerate(primitives) if "COLOR_0" not in p.get("attributes", {})]
    if missing:
        fail("GLB primitives missing COLOR_0: " + ", ".join(map(str, missing)))
    extra = [i for i, p in enumerate(primitives)
             if any(re.fullmatch(r"COLOR_[1-9][0-9]*", k) for k in p.get("attributes", {}))]
    if extra:
        fail("GLB contains unsupported additional vertex color sets: " + ", ".join(map(str, extra)))
    dgo = re.sub(r";;[^\n]*", "", DGO.read_text(encoding="utf-8"))
    expected = re.compile(r'\(\s*"EIS\.DGO"\s*\(\s*"echo-isles-obs\.o"\s*"echo-isles\.go"\s*\)\s*\)', re.DOTALL)
    if not expected.search(dgo):
        fail("DGO must be one ordered list: echo-isles-obs.o, echo-isles.go")
    print("Echo Isles source-package checks passed.")
    print(f"GLB mesh primitives: {len(primitives)}; COLOR_0 present on each.")
    print("DGO descriptor matches the Jak 3 test-zone structure.")
    print("OpenGOAL compilation and in-game tests are not covered.")
    return 0

if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
