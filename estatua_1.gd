extends CanvasLayer
@onready var timer = $AutoTimer

func _ready():
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/Mundo.tscn")  
