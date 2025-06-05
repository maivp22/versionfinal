extends CharacterBody2D

@export var move_speed: float 
@export var move_jump: float 
var is_facing_right = true

func _physics_process(delta):
	move_x()
	flip()
	move_and_slide()
func flip():
	if (is_facing_right and velocity.x<0) or (not is_facing_right and velocity.x>0):
		scale.x *=-1
		is_facing_right=not is_facing_right
func move_x():
	var input_axis = Input.get_axis("move_left","move_right")
	velocity.x =input_axis*move_speed
	
	
