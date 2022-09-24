extends KinematicBody2D

const UP_DIR := Vector2.UP

export var movement_speed := 200.0
export var jump_strength := 200.0
export var max_jumps := 2
export var double_jump_strength := 150.0
export var gravity := 200.0

export var throw_force = 100.0

var jumps_executed := 0
var velocity := Vector2.ZERO

var bomb = preload("res://scenes/Bomb.tscn")

func _physics_process(delta: float) -> void:
	var hor_dir = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	velocity.x = hor_dir * movement_speed
	velocity.y += gravity * delta
	
	var is_falling := velocity.y > 0.0 and not is_on_floor()
	var is_jumping := Input.is_action_just_pressed("jump") and is_on_floor()
	var is_double_jumping := Input.get_action_strength("jump") and is_falling
	var is_jump_cancelled := Input.is_action_just_released("jump") and velocity.y < 0.0
	var is_idling := is_on_floor() and is_zero_approx(velocity.x)
	var is_running := is_on_floor() and not is_zero_approx(velocity.x)
	
	if is_jumping:
		jumps_executed += 1
		velocity.y = -jump_strength
	elif is_double_jumping:
		jumps_executed += 1
		if jumps_executed <= max_jumps:
			velocity.y = -double_jump_strength
	elif is_jump_cancelled:
		velocity.y = 0.0
	elif is_idling or is_running:
		jumps_executed = 0
	
	velocity = move_and_slide(velocity, UP_DIR, false, 4, 0.785398, false)
	
	if hor_dir == -1:
		$Sprite.set_flip_h(true)
	elif hor_dir == 1:
		$Sprite.set_flip_h(false)
	
	$ArrowPivot.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("fire_bomb"):
		var current_bomb = bomb.instance()
		current_bomb.position = position
		get_parent().add_child(current_bomb)
		current_bomb.apply_central_impulse((get_local_mouse_position() - $ArrowPivot.position).normalized() * throw_force)
