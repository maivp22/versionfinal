extends CharacterBody2D

var pos: Vector2
var rota: float
var dir
var speed = 2000
var life = 10
var damage = 60
@onready var anim = $AnimatedSprite2D
@onready var damage_area = $DamageArea
var current_time = 0.0
var max_time = 5.0

func _ready() -> void:	
	add_to_group("Enemies")
	global_position = pos
	global_rotation = rota
	anim.play("attack")
	
func _physics_process(delta):
	if current_time == max_time:
		die()
	else: 
		current_time += delta
	velocity = dir * speed
	move_and_slide()


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.name == "player":
		attack_player(body)		

func take_damage(amount):
	life -= amount
	if life <= 0:
		die()

func die():
	anim.play("dead")
	queue_free()
	
func attack_player(target):
	if target.has_method("take_damage"):
		target.take_damage(damage)
		die()
			
