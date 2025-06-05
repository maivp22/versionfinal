extends CharacterBody2D

@export var attack_range: float = 120.0
@export var max_life: float = 2000.0
@export var enemy1 : PackedScene
@export var enemy2 : PackedScene
@export var enemy3 : PackedScene
@export var attackProy: PackedScene
@export var spawn_points : Array[Marker2D] = []
@onready var anim = $AnimatedSprite2D
@onready var attack_area = $AttackArea
@onready var attack_timer = $AttackTimer
@onready var generate_timer = $GenerateTimer
@onready var health_bar = $ProgressBar
@onready var player : Node2D = null
@onready var detention_area = $DetentionArea
var current_life: float = max_life

func _ready():	
	add_to_group("Enemies")
	health_bar.max_value = max_life
	health_bar.value = current_life
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	attack_area.body_exited.connect(_on_attack_area_body_exited)
	detention_area.body_entered.connect(_on_detention_area_body_entered)
	detention_area.body_exited.connect(_on_detention_area_body_exited)
	if spawn_points.size() == 0:
		print("No hay puntos de spawn")
	anim.play("default")

func _physics_process(delta):	
	health_bar.position = Vector2(0, -30)	
	# Patrullaje si el jugador no estÃÂÃÂ¡ cerca
	

func _on_attack_area_body_entered(body):
	if body.name == "Player" and attack_timer.is_stopped():
		attack_timer.start()
		attack(body)

func _on_attack_area_body_exited(body):
	pass

func _on_AttackTimer_timeout():
	if attack_area.get_overlapping_bodies().has(player):
		attack(player)

func take_damage(amount):
	current_life -= amount
	generateEnemy()
	current_life = max(current_life, 0)
	health_bar.value = current_life
	if current_life <= 0:
		die()

func die():
	queue_free()


func _on_detention_area_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player = body
		generateEnemy()
		generate_timer.start()


func _on_detention_area_body_exited(body: Node2D) -> void:
	if body == player :
		player = null
		generate_timer.stop()
		

func _on_GenerateTimer_timeout():
	if detention_area.get_overlapping_bodies().has(player):
		generateEnemy()
		

func generateEnemy () -> void:
	if player: 
		var distance = global_position.distance_to(player.global_position)
		for i in range (4):			
			var path = "../Spawner" + str(i)
			var node = get_node_or_null(path)
			if node != null:
				var spawnDistance = player.global_position.distance_to(node.position)
				if spawnDistance < 15:
					var enemyGenerate : PackedScene = null					
					match randi_range(1,4):
						1: enemyGenerate = enemy1
						2: enemyGenerate = enemy2
						3: enemyGenerate = enemy3
						_: enemyGenerate = null
					if  enemyGenerate != null:
						var enemy = enemyGenerate.instantiate()
						enemy.global_position = node.position
						get_parent().add_child(enemy)
					return
			else:
				print("No hay spawn")

func attack (target) -> void:
	var proyectil = attackProy.instantiate()
	proyectil.dir = (target.global_position - global_position).normalized()
	proyectil.pos = $Node2D.global_position
	proyectil.rota = (target.global_rotation - global_rotation).normalized()
	get_parent().add_child(proyectil)
