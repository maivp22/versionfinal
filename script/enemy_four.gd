extends CharacterBody2D

@export var speed: float = 85.0
@export var attack_damage: float = 50.0
@export var attack_range: float = 80.0
@export var attack_delay: float = 5.0
@export var max_life: float = 1000.0

@export var patrol_points : Array[Marker2D] = []
@onready var anim = $AnimatedSprite2D
@onready var attack_area = $AttackArea
@onready var attack_timer = $AttackTimer
@onready var health_bar = $ProgressBar
@onready var player : Node2D = null
@onready var detention_area = $DetentionArea
var current_point_index = 0
var current_life: float = max_life

func _ready():	
	add_to_group("Enemies")
	health_bar.max_value = max_life
	health_bar.value = current_life
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	attack_area.body_exited.connect(_on_attack_area_body_exited)
	detention_area.body_entered.connect(_on_detention_area_body_entered)
	detention_area.body_exited.connect(_on_detention_area_body_exited)
	if patrol_points.size() == 0:
		print("No hay puntos de destino")
		
func _process(delta: float) -> void:
	if player:
		chase_player()
	else:
		patrol()
	move_and_slide()

func _physics_process(delta):		
	# Patrullaje si el jugador no estÃÂÃÂ¡ cerca
	if player: 
		var distance = global_position.distance_to(player.global_position)
		if distance <= attack_range:
			velocity = Vector2.ZERO
			move_and_slide()
			

	health_bar.position = Vector2(0, -30)
	# Animaciones segÃÂÃÂºn direcciÃÂÃÂ³n
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x > 0:
			anim.play("walk_right")
		else:
			anim.play("walk_left")
	else:
		if velocity.y > 0:
			anim.play("walk_down")
		else:
			anim.play("walk_up")

func _on_attack_area_body_entered(body):
	if body.name == "Player" and attack_timer.is_stopped():
		attack_player(body)
		attack_timer.start()

func _on_attack_area_body_exited(body):
	pass

func _on_AttackTimer_timeout():
	if attack_area.get_overlapping_bodies().has(player):
		attack_player(player)

func attack_player(target):
	if target.has_method("take_damage"):
		target.take_damage(attack_damage)
		if anim:
			var dir = (target.global_position - global_position).normalized()
			if abs(dir.x) > abs(dir.y):
				anim.play("attack_right" if dir.x > 0 else "attack_left")
			else:
				anim.play("attack_down" if dir.y > 0 else "attack_up")

func take_damage(amount):
	current_life -= amount
	current_life = max(current_life, 0)
	health_bar.value = current_life
	if current_life <= 0:
		die()

func die():
	queue_free()


func _on_detention_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body


func _on_detention_area_body_exited(body: Node2D) -> void:
	if body == player :
		player = null


func patrol () -> void:
	if patrol_points.size() > 0:
		var target = patrol_points[current_point_index].position
		velocity = (target - position).normalized() * speed
		
		if position.distance_to(target) < 10.0:
			current_point_index += 1
			if current_point_index >= patrol_points.size():
				current_point_index = 0
				
func chase_player() -> void:
	velocity = (player.global_position - global_position).normalized() * speed
