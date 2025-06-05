class_name Enemy_patrol2 extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var health_bar = $ProgressBar
@onready var player = null

@export var patrol_points := [Vector2(966, 580), Vector2(966, 380)]
@export var speed = 50
@export var chase_speed = 100
@export var attack = 10
@export var max_life = 50
@export var detection_range = 200
@export var attack_range = 40
@export var attack_delay = 2.0

var current_life = max_life
var current_point = 0
var attack_timer := 0.0
var last_direction = Vector2.DOWN  # Para mantener direcciÃ³n de animaciÃ³n en idle

func _ready():
	add_to_group("Enemies")
	current_life = max_life
	health_bar.max_value = max_life
	health_bar.value = current_life
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player == null or not player.is_inside_tree():
		player = get_tree().get_first_node_in_group("player")
		return

	attack_timer -= delta

	var distance = global_position.distance_to(player.global_position)

	if distance < attack_range:
		velocity = Vector2.ZERO
		update_attack_animation(last_direction)
		move_and_slide()

		if attack_timer <= 0:
			attack_player()
			attack_timer = attack_delay

	elif distance <= detection_range:
		var dir = (player.global_position - global_position).normalized()
		velocity = dir * chase_speed
		move_and_slide()
		update_walk_animation(dir)
		last_direction = dir
	else:
		patrol(delta)

	health_bar.position = Vector2(0, -30)

func patrol(delta):
	var target = patrol_points[current_point]
	var dir = (target - global_position).normalized()
	velocity = dir * speed
	move_and_slide()

	if global_position.distance_to(target) < 5:
		current_point = (current_point + 1) % patrol_points.size()

	update_walk_animation(dir)
	last_direction = dir

func update_walk_animation(dir):
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			anim.play("walk_right")
		else:
			anim.play("walk_left")
	else:
		if dir.y > 0:
			anim.play("walk_down")
		else:
			anim.play("walk_up")

func update_attack_animation(dir):
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			anim.play("attack_right")
		else:
			anim.play("attack_left")
	else:
		if dir.y > 0:
			anim.play("attack_down")
		else:
			anim.play("attack_up")

func attack_player():
	if player and player.has_method("take_damage"):
		player.take_damage(attack)
		print("Â¡Jugador recibiÃ³ daÃ±o!")

func take_damage(amount):
	current_life -= amount
	current_life = max(current_life, 0)
	health_bar.value = current_life
	if current_life <= 0:
		die()

func die():
	queue_free()
