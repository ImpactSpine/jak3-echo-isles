# Run inside Blender 4.0 or 4.2:
# Blender > Scripting > Open this file > Run Script.
# It imports the generated GLB, adds useful markers, and saves Echo-Isles-Blockout.blend beside this script.
import bpy, os
from mathutils import Vector

here = os.path.dirname(os.path.abspath(__file__))
glb = os.path.abspath(os.path.join(here, "..", "custom_levels", "echo-isles", "echo-isles.glb"))
out = os.path.join(here, "Echo-Isles-Blockout.blend")

bpy.ops.object.select_all(action="SELECT")
bpy.ops.object.delete(use_global=False)
bpy.ops.import_scene.gltf(filepath=glb)

# Add non-export helper empties for spawn and points of interest.
markers = [
    ("SPAWN_CANDIDATE", (-21, 3.0, -7), (1.0, 0.2, 0.1, 1.0)),
    ("RUINS_GATE", (8, 4.0, -5), (0.2, 0.7, 1.0, 1.0)),
    ("EAST_OVERLOOK", (29, 6.0, 4), (0.2, 1.0, 0.4, 1.0)),
    ("CRYSTAL_LANDMARK", (-8, 5.0, 15), (0.3, 0.8, 1.0, 1.0)),
]
for name, loc, color in markers:
    bpy.ops.object.empty_add(type="ARROWS", location=loc)
    obj = bpy.context.object
    obj.name = name
    obj["authoring_helper_only"] = True

# Set viewport and scene units.
bpy.context.scene.unit_settings.system = "METRIC"
for area in bpy.context.screen.areas:
    if area.type == "VIEW_3D":
        area.spaces.active.region_3d.view_distance = 105
        area.spaces.active.region_3d.view_location = Vector((0, 4, 0))
bpy.ops.wm.save_as_mainfile(filepath=out)
print("Saved editable blockout:", out)
