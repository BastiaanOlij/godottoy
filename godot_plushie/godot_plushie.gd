extends PickableCharacterBody3D
class_name GodotPlushie

# Unfreeze is called by our main script once our global mesh is setup.
func unfreeze():
	print("Unfreeze plushie")

	super()

	$StateMachine.state = $StateMachine/FallingState


func pick_up(pick_up_by):
	print("Pickup plushie")

	if is_frozen:
		return

	super(pick_up_by)

	$StateMachine.state = $StateMachine/PickedUpState


func let_go(new_linear_velocity = Vector3()):
	print("Let go plushie")
	if not picked_up_by:
		return

	super(new_linear_velocity)

	$StateMachine.state = $StateMachine/FallingState


func _physics_process(delta):
	# Handle by state machine
	if $StateMachine.do_physics_process(delta):
		move_and_slide()
