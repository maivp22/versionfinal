extends CharacterBody2D
class_name Player

@export var velocidad_base = 150
var velocidad_actual = 150
var tiempo_velocidad = 0.0
@export var life = 1000000
@export var damage = 10
var current_dir = "down"
var item_cercano = null
var fuerza_base = 10
var fuerza_actual = 10
var fuerza_extra_duracion = 0.0

func _ready():
	add_to_group("Player")
	$LifeBar.value = life
	update_attack_area()
	$AnimatedSprite2D.play("front_idle")  # AnimaciÃ³n inicia
	add_to_group("Player")
func _physics_process(delta):
	player_movement(delta)
	if Input.is_action_just_pressed("attack"):
		attack()
	if Input.is_action_just_pressed("interact") and item_cercano != null:
		if item_cercano.has_method("recoger"):
			item_cercano.recoger()
	if tiempo_velocidad > 0:
		tiempo_velocidad -= delta
		if tiempo_velocidad <= 0:
			velocidad_actual = velocidad_base
			if fuerza_extra_duracion > 0:
				fuerza_extra_duracion -= delta
				if fuerza_extra_duracion <= 0:
					fuerza_actual = fuerza_base

func player_movement(delta):
	if Input.is_action_pressed("right"):
		current_dir = "right"
		velocity.x = velocidad_actual
		velocity.y = 0
	elif Input.is_action_pressed("left"):
		current_dir = "left"
		velocity.x = -velocidad_actual
		velocity.y = 0
	elif Input.is_action_pressed("down"):
		current_dir = "down"
		velocity.x = 0
		velocity.y = velocidad_actual
	elif Input.is_action_pressed("up"):
		current_dir = "up"
		velocity.x = 0
		velocity.y = -velocidad_actual
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
			body.take_damage(fuerza_actual)


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
func recibir_vida(cantidad: int):
	life += cantidad
	$LifeBar.value = life
	print("Recuperaste ", cantidad, " de vida. Vida actual: ", life)
func aumentar_velocidad(extra: float, duracion: float):
	velocidad_actual += extra
	tiempo_velocidad = duracion
	print("¡Velocidad aumentada a ", velocidad_actual, " por ", duracion, " segundos!")
func aumentar_fuerza(extra: float, duracion: float):
	fuerza_actual += extra
	fuerza_extra_duracion = duracion
	print("¡Fuerza aumentada a ", fuerza_actual, " por ", duracion, " segundos!")
func _on_body_entered(body):
	if body.has_method("recoger"):
		item_cercano = body

func _on_body_exited(body):
	if item_cercano == body:
		item_cercano = null 
