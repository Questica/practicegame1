class_name Enemy
extends CharacterBody2D

@export var stats: Stats : set = set_stats

var player_position = PlayerSingleton.player.global_position
#get player position?

func set_stats(value: Stats) -> void:
	stats = value.create_instance()

func _process(delta):
	player_position = PlayerSingleton.player.global_position
	
	if position.distance_to(player_position) > 1:
		var direction = (player_position - position).normalized()
		velocity = direction * stats.speed
		move_and_slide()
	
	$AnimatedSprite2D.play("flying")
