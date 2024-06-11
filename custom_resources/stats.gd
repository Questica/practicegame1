class_name Stats
extends Resource

signal stats_changed

@export var max_health := 1

var health: int : set = set_health

func set_health(value : int):
	health = clampi(value, 0, max_health)
	stats_changed.emit()

func take_damage(damage : int):
	if damage <= 0:
		return
	self.health -= damage

func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	return instance
