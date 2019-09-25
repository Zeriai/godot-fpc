extends RigidBody

export var WalkSpeed = 500.0
export var MaxSpeed  = 15.0
var MoveDirection = Vector3(0,0,0)
var MouseRelative = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var MoveDirection = Vector3(0,0,0)
	if Input.is_action_pressed("Forward"):
		#apply_central_impulse(-$RotationHelper.transform.basis.z * delta * WalkSpeed)
		MoveDirection+=-$RotationHelper.transform.basis.z
	if Input.is_action_pressed("Backward"):
		#apply_central_impulse($RotationHelper.transform.basis.z * delta * WalkSpeed)
		MoveDirection+=$RotationHelper.transform.basis.z
	if Input.is_action_pressed("Right"):
		#apply_central_impulse($RotationHelper.transform.basis.x * delta * WalkSpeed)
		MoveDirection+=$RotationHelper.transform.basis.x
	if Input.is_action_pressed("Left"):
		#apply_central_impulse(-$RotationHelper.transform.basis.x * delta * WalkSpeed)
		MoveDirection+=-$RotationHelper.transform.basis.x
		
#	if linear_velocity.length() < MaxSpeed:
#		add_central_force(MoveDirection.normalized() * delta * WalkSpeed)
	set_axis_velocity(MoveDirection.normalized() * delta * WalkSpeed)
		
	$RotationHelper.rotate_y(-MouseRelative.x * delta * 0.1)
	$RotationHelper/Camera.rotate_x(-MouseRelative.y * delta * 0.1)
	MouseRelative = Vector2(0,0)

func _input(event):
	if event is InputEventMouseMotion:
		MouseRelative.x = event.relative.x
		MouseRelative.y = event.relative.y