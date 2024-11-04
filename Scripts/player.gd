extends CharacterBody3D

var ORIGINAL_SPEED
var SPEED = 3.0
var SPRINT_SPEED = 7.0
var JUMP_VELOCITY = 4.5
var sprint_slider
var sprint_drain_amount = 0.3
var sprint_refresh_amount = 0.4
var movable = false
var rng
@export var walk_footsteps: Array[AudioStream]
@export var sprint_footsteps: Array[AudioStream]

func _ready():
	rng = RandomNumberGenerator.new()
	ORIGINAL_SPEED = SPEED
	sprint_slider = get_node("/root/" + get_tree().current_scene.name + "/UI/sprint_slider")

func _process(delta):
	if SPEED == SPRINT_SPEED:
		sprint_slider.value = sprint_slider.value - sprint_drain_amount * delta
		if sprint_slider.value == sprint_slider.min_value:
			SPEED = ORIGINAL_SPEED
	if SPEED != SPRINT_SPEED:
		if sprint_slider.value < sprint_slider.max_value:
			sprint_slider.value = sprint_slider.value + sprint_refresh_amount * delta
		if sprint_slider.value == sprint_slider.max_value:
			sprint_slider.visible = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if movable == true:
	# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		var input_dir = Input.get_vector("left", "right", "foward", "backward")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			if !$footstep_sound.playing:
				if SPEED != SPRINT_SPEED:
					var num = rng.randi_range(0, walk_footsteps.size() - 1)
					$footstep_sound.stream = walk_footsteps[num]
				if SPEED == SPRINT_SPEED:
					var num = rng.randi_range(0, sprint_footsteps.size() - 1)
					$footstep_sound.stream = sprint_footsteps[num]
				$footstep_sound.play()
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			if Input.is_action_just_pressed("sprint"):
				sprint_slider.visible = true
				SPEED = SPRINT_SPEED
			if Input.is_action_just_released("sprint"):
				SPEED = ORIGINAL_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
