extends CharacterBody2D

@export var speed = 2

var player_position
#get player position?

func _process(delta):
	#intialize player position
	player_position = Vector2(600, 600)
	
	if position.distance_to(player_position) > 1:
		var direction = (player_position - position).normalized()
		velocity = direction * speed
		move_and_slide()
	
	$AnimatedSprite2D.play("flying")
