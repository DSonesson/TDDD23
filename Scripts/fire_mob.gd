extends Area2D

signal mob_died()
signal reached_goal()

var speed = 100
var nav = null setget set_nav
var path = []
var goal= null
var hp = 6.0

onready var hp_bar = get_node("healthBar")

func _ready():
	pass
	
func _physics_process(delta):
	pass
	
func _process(delta):
	if path.size() > 1:
		var d = position.distance_to(path[0])
		if d > 2:
			position = position.linear_interpolate(path[0], (speed * delta)/d)
		else:
			path.remove(0)
	else:
		print("reached goal")
		remove_from_group("mobs")
		emit_signal("reached_goal")
		queue_free()
		
func set_nav(new_nav):
	nav = new_nav
	update_path()
	
func update_path():
	path = nav.get_simple_path(get_position(), goal, false)
	if path.size() == 0:
		print("reached goal")
		emit_signal("reached_goal")
		remove_from_group("mobs")
		queue_free()
		
func get_direction():
	var direction = (position - path[0]).normalized()
	return direction
	
func hit_by_bullet(damage):
	hp_bar.show()
	hp = hp - damage
	if hp > 0:
		hp_bar.value = hp
	elif hp <= 0: #dead
		remove_from_group("mobs")
		emit_signal("mob_died")
		queue_free()
		

