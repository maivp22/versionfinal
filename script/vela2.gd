extends Node2D

var noise := FastNoiseLite.new()
var time_passed := 0.0

func _ready():
	noise.seed = randi()
	noise.frequency = 0.8
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	$AnimatedSprite2D.play("1")
	
func _process(delta):
	time_passed += delta
	var base_energy = 3.0
	var flicker = noise.get_noise_1d(time_passed * 2.0)
	$PointLight2D.energy = base_energy + flicker * 0.3
