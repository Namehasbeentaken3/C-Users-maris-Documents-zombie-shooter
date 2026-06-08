extends CharacterBody2D

# Movement variables
@export var speed = 200.0
@export var acceleration = 500.0

# Reference to sprites and collision
var sprite: Sprite2D
var collision_shape: CollisionShape2D

func _ready():
	# Create sprite if not already in scene
	if not has_node("Sprite2D"):
		sprite = Sprite2D.new()
		sprite.name = "Sprite2D"
		add_child(sprite)
		# Placeholder: white square for player
		sprite.modulate = Color.WHITE
		sprite.scale = Vector2(0.5, 0.5)
	else:
		sprite = $Sprite2D
	
	# Create collision shape if not already in scene
	if not has_node("CollisionShape2D"):
		collision_shape = CollisionShape2D.new()
		collision_shape.name = "CollisionShape2D"
		var shape = CapsuleShape2D.new()
		shape.radius = 8
		shape.height = 32
		collision_shape.shape = shape
		add_child(collision_shape)
	else:
		collision_shape = $CollisionShape2D

func _physics_process(delta):
	# Get input
	var input_dir = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		input_dir.y -= 1
	if Input.is_action_pressed("ui_down"):
		input_dir.y += 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
	
	# Normalize input direction
	input_dir = input_dir.normalized()
	
	# Apply acceleration/deceleration
	if input_dir.length() > 0:
		velocity = velocity.lerp(input_dir * speed, acceleration * delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, acceleration * delta)
	
	# Move the player
	move_and_slide()
	
	# Rotate player to face mouse
	look_at(get_global_mouse_position())
	
	# Draw debug vision cone (cone of view)
	queue_redraw()

func _draw():
	# Draw vision cone from player looking toward mouse
	var player_pos = Vector2.ZERO  # Relative to self
	var mouse_angle = get_angle_to(get_global_mouse_position())
	var cone_angle = PI / 3  # 60 degree cone (adjust as needed)
	var cone_range = 300.0
	
	# Calculate cone points
	var cone_points = []
	cone_points.append(player_pos)
	
	# Left edge of cone
	var left_angle = mouse_angle - cone_angle / 2
	cone_points.append(player_pos + Vector2(cos(left_angle), sin(left_angle)) * cone_range)
	
	# Right edge arc
	var segments = 20
	for i in range(segments + 1):
		var angle = left_angle + (cone_angle / segments) * i
		cone_points.append(player_pos + Vector2(cos(angle), sin(angle)) * cone_range)
	
	# Draw the cone
	draw_colored_polygon(PackedVector2Array(cone_points), Color(1, 1, 0, 0.2))
