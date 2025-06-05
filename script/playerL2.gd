extends CharacterBody2D
class_name Player

@export var speed = 150
@export var life = 1000000
@export var damage = 10
var current_dir = "down"

func _ready():
	add_to_group("Player")
	var skin_index = GameData.selected_skin_index
	var skin_path = GameData.skin_paths[skin_index]
	var frames = load(skin_path)
	$AnimatedSprite2D.frames = frames
	$LifeBar.value = life
	update_attack_area()
	$AnimatedSprite2D.play("front_idle")  # AnimaciÃ³n inicia
	add_to_group("Player")
func _physics_process(delta):
	player_movement(delta)
	if Input.is_action_just_pressed("attack"):
		attack()

func player_movement(delta):
	if Input.is_action_pressed("right"):
		current_dir = "right"
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("left"):
		current_dir = "left"
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("down"):
		current_dir = "down"
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("up"):
		current_dir = "up"
		velocity.x = 0
		velocity.y = -speed
	else:
		velocity = Vector2.ZERO

	update_attack_area()
	move_and_slide()
	
	# AnimaciÃ³n segÃºn movimiento o idle
	if velocity.length() > 0:
		play_anim(1)
	else:
		play_anim(0)

func update_attack_area():
	match current_dir:
		"up":
			$AttackArea.position = Vector2(0, -20)
		"down":
			$AttackArea.position = Vector2(0, 20)
		"left":
			$AttackArea.position = Vector2(-20, 0)
		"right":
			$AttackArea.position = Vector2(20, 0)
		_:
			$AttackArea.position = Vector2.ZERO
func take_damage(amount: float):
	life -= amount
	if life < 0:
		life = 0
	$LifeBar.value = life
	print("Â¡Jugador recibiÃ³ daÃ±o! Vida restante: ", life)
	if life == 0:
		die()
func die():
	print("Â¡Jugador ha muerto!")
	$AnimatedSprite2D.play("death")  # Solo si tienes una animaciÃ³n de muerte
	await $AnimatedSprite2D.animation_finished
	get_tree().change_scene_to_file("res://Scene/level.tscn")  # Cambia al lobby

func attack():
	print("Ataque ejecutado")
	for body in $AttackArea.get_overlapping_bodies():
		print("Detectado cuerpo: ", body.name)
		if body.is_in_group("Enemies"):
			print("Â¡Enemigo golpeado!")
			body.take_damage(damage)

func play_anim(movement):
	var anim = $AnimatedSprite2D
	
	match current_dir:
		"right":
			anim.flip_h = false
			if movement == 1:
				anim.play("right_walk")
			else:
				anim.play("right_idle")
		"left":
			anim.flip_h = false
			if movement == 1:
				anim.play("left_walk")
			else:
				anim.play("left_idle")
		"up":
			anim.flip_h = true
			if movement == 1:
				anim.play("back_walk")
			else:
				anim.play("back_idle")
		"down":
			anim.flip_h = true
			if movement == 1:
				anim.play("front_walk")
			else:
				anim.play("front_idle")
