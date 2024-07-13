extends "res://start_vr.gd"

@onready var scene_manager: OpenXRFbSceneManager = $XROrigin3D/OpenXRFbSceneManager

func _on_scene_data_missing():
	print ("On scene data missing")
	if scene_manager:
		scene_manager.request_scene_capture()


func _on_scene_capture_completed(success):
	print ("On scene capture completed")
	if success == false:
		return

	# Recreate scene anchors since the user may have changed them.
	if scene_manager and scene_manager.are_scene_anchors_created():
		scene_manager.remove_scene_anchors()
		scene_manager.create_scene_anchors()


func _on_scene_anchor_created(scene_node, spatial_entity):
	print ("On scene anchor created")
	if scene_node is GlobalMesh:
		# We can unpause stuff
		get_tree().call_group("unfreeze_on_start", "unfreeze")

		$PlayerRig.enabled = true
