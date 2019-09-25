extends KinematicBody

export var WalkSpeed = 60.0
export var RunSpeed = 120.0
export var Gravity = 20.0
export var MaxFallSpeed = -2000.0
export var WalkDecceleration = 0.8
export var JumpVelocity = 500
export var FloorSnapDistance = -0.5
var MoveVelocity = Vector3(0,0,0)
var MouseRelative = Vector2(0,0)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	
	var MoveDirection = Vector3(0,0,0)
	var FloorSnap = FloorSnapDistance
	
	if (is_on_floor()):
		if Input.is_action_pressed("Forward"):
			MoveDirection+=-transform.basis.z
		if Input.is_action_pressed("Backward"):
			MoveDirection+=transform.basis.z
		if Input.is_action_pressed("Right"):
			MoveDirection+=transform.basis.x
		if Input.is_action_pressed("Left"):
			MoveDirection+=-transform.basis.x
		if Input.is_action_just_pressed("Jump"):
			MoveVelocity.y = JumpVelocity
			FloorSnap = 0.0
		else:
			MoveVelocity.y = -0.5
		MoveVelocity.x *= WalkDecceleration
		MoveVelocity.z *= WalkDecceleration
	
	if (is_on_ceiling()):
		MoveVelocity.y = 0

	if (!is_on_floor() && MoveVelocity.y > MaxFallSpeed):
		MoveVelocity.y -= Gravity
	
	MoveDirection = MoveDirection.normalized()

	if Input.is_action_pressed("Run"):
		MoveVelocity += MoveDirection * RunSpeed
	else:
		MoveVelocity += MoveDirection * WalkSpeed

	move_and_slide_with_snap(MoveVelocity * delta, Vector3(0,FloorSnap,0), Vector3(0,1,0), true)
	
	rotate_y(-MouseRelative.x * delta * 0.1)
	$Camera.rotate_x(-MouseRelative.y * delta * 0.1)
	if $Camera.rotation.x > 1.5:
		$Camera.rotation.x = 1.5
	if $Camera.rotation.x < -1.5:
		$Camera.rotation.x = -1.5
	
	MouseRelative = Vector2(0,0)

func _input(event):
	if event is InputEventMouseMotion:
		MouseRelative.x = event.relative.x
		MouseRelative.y = event.relative.y