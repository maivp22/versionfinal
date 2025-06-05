extends CharacterBody2D

@export var point1: Vector2 = Vector2(100, 100)
@export var point2: Vector2 = Vector2(300, 100)
@export var point3: Vector2 = Vector2(300, 300)
@export var point4: Vector2 = Vector2(100, 300)

@export var speed: float = 75.0

@onready var anim = $AnimatedSprite2D
@onready var player = get_node_or_null("../Player")

var patrol_points: Array[Vector2] = []
var current_target_index: int = 0

func _ready():
	patrol_points = [point1, point2, point3, point4]
	current_target_index = 0

func _physics_process(delta):
	if patrol_points.size() == 0:
		return

	var target = patrol_points[current_target_index]
	var direction = (target - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	if global_position.distance_to(target) < 5:
		current_target_index = (current_target_index + 1) % patrol_points.size()

	if anim:
		anim.play("walk")
