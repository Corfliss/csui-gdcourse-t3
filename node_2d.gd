extends CharacterBody2D

const GRAVITY = 980
const SPEED = 500.0
const JUMP_VELOCITY = -600.0
const DASH_MULTIPLIER = 3
const ACCELERATION = 10

@export var can_double_jump = false
@onready var dash_end_time: float = 0.0  # Tracks when dash should end
@onready var is_dashing: bool = false  # Flag to track dash state

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jump.
	if is_on_floor():
		can_double_jump = true  # Reset double jump when landing
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_VELOCITY
	
	# Handle Double Jump
	elif can_double_jump and Input.is_action_just_pressed("ui_up"):
		velocity.y = JUMP_VELOCITY
		can_double_jump = false  # Disable double jump after using it
		
		
	var target_speed = 0.0  # Default speed when no input

	# Handle movement input
	if Input.is_action_pressed("ui_left"):
		target_speed = -SPEED
	elif Input.is_action_pressed("ui_right"):
		target_speed = SPEED

	# Assisted with ChatGPT, refer to https://chatgpt.com/share/67b80003-f7fc-8002-8101-713356e7b30f
	# Start dash instantly when Shift is pressed
	if Input.is_action_just_pressed("shift"):
		is_dashing = true
		dash_end_time = Time.get_ticks_msec() + 100  # Dash for 0.5s
	# Apply dash multiplier if dashing
	if is_dashing:
		if Time.get_ticks_msec() < dash_end_time:
			target_speed *= DASH_MULTIPLIER  # Increase speed smoothly
		else:
			is_dashing = false  # Stop dashing after 0.5s
	# Smoothly transition velocity using lerp
	velocity.x = lerp(velocity.x, target_speed, ACCELERATION * delta)

	if is_on_floor() and Input.is_action_pressed("ctrl"):
		$PlayerIdle.visible = false
		$PlayerCrouch.visible = true
	else:
		$PlayerIdle.visible = true
		$PlayerCrouch.visible = false
	move_and_slide()
