extends Node2D

@export var enemy_scene: PackedScene
@export var player_scene: PackedScene

@onready var player_instance = player_scene.instantiate() as Player
func _ready() -> void:
	if NavigationManage.spawn_door_tag != null:
		_on_level_spawn(NavigationManage.spawn_door_tag)		
	add_child(player_instance)
	for x in range(1,46):
		var enemy_instance = enemy_scene.instantiate()
		var spawn_name = "TilemapLayers/SpawnZones/MiniEnemySpawn"+str(x)
		if has_node(spawn_name):	
			var node = get_node(spawn_name)
			enemy_instance.global_position = node.global_position
			add_child(enemy_instance)	
			
func _on_level_spawn(spawn_door : String):
	var door_path = "TilemapLayers/Doors/Door_"+spawn_door
	var door = get_node(door_path) as Door
	NavigationManage.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
	




	
