extends Area2D
class_name Maletin

@export var nueva_animacion : SpriteFrames = preload("res://Frames/Skin2.2.tres")

func _ready():
	add_to_group("Items")  # O el grupo que uses para detectar objetos interactuables

func recoger():
	print("Maletín recogido!")
	queue_free()  # Elimina el maletín del juego, o haz lo que quieras cuando se recoja
