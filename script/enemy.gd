extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

var speed = 70
var player_chase = false
var player = null

var patrol_direction = Vector2(1, 0)
var patrol_speed = 40
var patrol_range = 100
var patrol_origin = Vector2()

var last_direction = "front"
var last_flip_h = false

var is_exploding = false

var skins = [
	preload("res://Enemy/Chomb1.tres"),
	preload("res://Enemy/Chomb2.tres"),
	preload("res://Enemy/Chomb3.tres"),
]

func _ready():
	patrol_origin = position
	animated_sprite.sprite_frames = skins[randi() % skins.size()]

func _physics_process(delta: float):
	if is_exploding:
		return
	if player_chase and player != null:
		var direction = player.position - position
		var move_direction = direction.normalized()
		position += move_direction * speed * delta
		animar(move_direction)
	else:
		patrullar(delta)

func patrullar(delta):
	position += patrol_direction * patrol_speed * delta
	if position.distance_to(patrol_origin) > patrol_range:
		patrol_direction *= -1
	animar(patrol_direction)

func animar(direction: Vector2):
	if abs(direction.x) > abs(direction.y):
		last_direction = "side"
		last_flip_h = direction.x > 0
		animated_sprite.play("side_walk")
		animated_sprite.flip_h = direction.x > 0
	elif direction.y < 0:
		last_direction = "back"
		last_flip_h = false
		animated_sprite.play("back_walk")
	else:
		last_direction = "front"
		last_flip_h = false
		animated_sprite.play("front_walk")

func explode():
	if is_exploding:
		return

	is_exploding = true
	print("💥 Explosión activada")

	player_chase = false
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)
	collision_shape.set_deferred("disabled", true)

	var anim_name = ""
	match last_direction:
		"front": anim_name = "front_atk"
		"back": anim_name = "back_atk"
		"side": anim_name = "side_atk"
		_: anim_name = "front_atk"

	if not animated_sprite.sprite_frames.has_animation(anim_name):
		print("❌ Animación no encontrada:", anim_name)
		queue_free()
		return

	animated_sprite.flip_h = last_flip_h
	animated_sprite.play(anim_name)

	animated_sprite.play(anim_name)
	await get_tree().create_timer(1).timeout
	queue_free()

func _on_detection_area_body_entered(body: Node2D):
	if body.name == "player":
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: Node2D):
	if body == player:
		player = null
		player_chase = false

func _on_hurtbox_body_entered(body: Node2D):
	if body.name == "player":
		explode()
