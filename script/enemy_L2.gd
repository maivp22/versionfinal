extends CharacterBody2D

@onready var player = $"../Player"
@onready var anim = $AnimatedSprite2D
@onready var health_bar = $ProgressBar


@export var speed = 75
@export var attack = 5
@export var max_life = 30

var current_life = max_life
var player_pos = Vector2.ZERO
var countdown = 0
var direction = Vector2.ZERO

func _ready():
	current_life = max_life
	health_bar.max_value = max_life
	health_bar.value = current_life
	health_bar.visible = true
	add_to_group("Enemies")

func _physics_process(delta):
	if player == null or not player.is_inside_tree():
		return

	player_pos = player.global_position
	direction = (player_pos - global_position).normalized()

	if global_position.distance_to(player_pos) < 200:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	update_anim()
	move_and_slide()
	# Posiciona la barra un poco arriba del enemigo
	health_bar.position = Vector2(0, -30)

func update_anim():
	# Atacar si estÃ¡ cerca
	if global_position.distance_to(player_pos) <= 30:
		if countdown == 0:
			player.take_damage(attack)
			countdown = 100
			anim.play("attack")
			anim.flip_h = direction.x < 0
			return
		else:
			countdown -= 1
			return

	# Movimiento
	if velocity.length() > 0:
		anim.play("walk")
		anim.flip_h = direction.x < 0
	else:
		anim.play("idle")
		anim.flip_h = direction.x < 0

func take_damage(amount):
	current_life -= amount
	if current_life < 0:
		current_life = 0
	health_bar.value = current_life
	print("Enemigo recibiÃ³ daÃ±o, vida restante: " + str(current_life))
	if current_life <= 0:
		die()

func die():
	print("Enemigo muerto")
	queue_free()
