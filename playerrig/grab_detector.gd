extends Area3D

@export var enabled : bool = true:
	set(value):
		enabled = value
		if is_inside_tree():
			_update_enabled()

var closest_body : PickableObject3D
var picked_up_body : PickableObject3D
var was_grab_pressed : bool = false


func _update_enabled():
	if not enabled and closest_body:
		closest_body.remove_is_closest(self)
		closest_body = null

	set_physics_process(enabled)

	if enabled:
		print("Grab detector enabled")

func _update_closest_body():
	# If we've picked up something, we no longer track who is closest
	if picked_up_body:
		if closest_body:
			closest_body.remove_is_closest(self)
			closest_body = null

		return

	# Find our closest body
	var new_closest_body : PickableObject3D
	var closest_distance : float = 1000000.0
	
	for body in get_overlapping_bodies():
		if body is PickableObject3D and not body.is_picked_up():
			var distance_squared = (body.global_position - global_position).length_squared()
			if distance_squared < closest_distance:
				new_closest_body = body
				closest_distance = distance_squared

	# Unchanged? we are done
	if closest_body == new_closest_body:
		return

	# Out with the old
	if closest_body:
		closest_body.remove_is_closest(self)

	# In with the new
	closest_body = new_closest_body
	if closest_body:
		closest_body.add_is_closest(self)


func _get_parent_controller() -> XRController3D:
	var parent : Node = get_parent()
	while parent:
		if parent is XRController3D:
			return parent

		parent = parent.get_parent()

	return null


func _ready():
	_update_enabled()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not enabled:
		set_physics_process(false)
		return

	_update_closest_body()

	# Check if we're grabbing something or letting something go
	var grab_pressed = false
	var controller : XRController3D = _get_parent_controller()
	if controller:
		var grab_value : float = controller.get_float("grab")
		var threshold : float = 0.4 if was_grab_pressed else 0.6
		grab_pressed = grab_value > threshold
	
	# Do we need to let go
	if picked_up_body and not grab_pressed:
		picked_up_body.let_go()
		picked_up_body = null
		
	# Do we need to pick something up
	if not picked_up_body and not was_grab_pressed and grab_pressed and closest_body:
		picked_up_body = closest_body
		picked_up_body.pick_up(self)
	
	was_grab_pressed = grab_pressed
