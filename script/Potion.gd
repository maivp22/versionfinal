extends Area2D


# Tipos de pociones y sus efectos
enum PotionType { HEALTH, SPEED, STRENGTH }

var potion_type = PotionType.HEALTH  # Por defecto
var effect_value = 0
var effect_duration = 0.0

@onready var label = $Label
@onready var sprite = $AnimatedSprite2D

var player_in_range = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	randomize()
	randomize_potion()
	label.visible = false
	label.position = Vector2(0, -40)
	sprite.play("default")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		show_label("Presiona E para recoger")

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		label.visible = false  # Oculta el label al alejarse

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):  # "interact" es tecla E
		await apply_effect()
		queue_free()

func randomize_potion():
	# Asigna un tipo random
	potion_type = int(randi() % 3)
	match potion_type:
		PotionType.HEALTH:
			effect_value = 50  # +50 vida
		PotionType.SPEED:
			effect_value = 100  # +100 velocidad
			effect_duration = 5.0
		PotionType.STRENGTH:
			effect_value = 5  # +5 fuerza
			effect_duration = 5.0

func apply_effect() -> void:
	var player = get_tree().get_nodes_in_group("Player")[0]
	match potion_type:
		PotionType.HEALTH:
			player.recibir_vida(effect_value)
			await show_label("Poción de Vida consumida +" + str(effect_value))
		PotionType.SPEED:
			player.aumentar_velocidad(effect_value, effect_duration)
			await show_label("Poción de Velocidad consumida +" + str(effect_value))
		PotionType.STRENGTH:
			player.aumentar_fuerza(effect_value, effect_duration)
			await show_label("Poción de Fuerza consumida +" + str(effect_value))

func show_label(texto: String) -> void:
	label.text = texto
	label.visible = true
	await get_tree().create_timer(0.8).timeout
	label.visible = false
