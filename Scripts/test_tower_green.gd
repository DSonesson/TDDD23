extends Node2D

export var fire_range = 120

var bulletScene 

signal towerPressed(tower)

func _ready():
	bulletScene = load("res://Scenes/bullet_test_2.tscn")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func choose_target():
	var target = null
	var target_dist = null
	var new_target_dist = null
	for enemy in get_tree().get_nodes_in_group("mobs"):
		new_target_dist = global_position.distance_to(enemy.get_global_position())
		if  new_target_dist <= fire_range:
			if target_dist == null or new_target_dist < target_dist:
				target_dist = new_target_dist
				target = enemy
	return target

func _on_fire_timer_timeout():
	var target_enemy = choose_target()
	if target_enemy == null:
		pass
	else:
		var bullet = bulletScene.instance()
		calc_fire_dir(target_enemy, bullet)
		bullet.damage = 2
		bullet.speed = 1000
		add_child(bullet)

func calc_fire_dir(target, bullet):
	var target_dir = target.get_direction()
	var target_xvel = target_dir.x * target.speed
	var target_yvel = target_dir.y * target.speed
	var bullet_speed = bullet.speed	
	
	var a = pow(target_xvel, 2) + pow(target_yvel, 2) - pow(bullet_speed, 2)
	var b = 2 * (target_xvel * (target.position.x - position.x) + target_yvel * (target.position.y - position.y))
	var c = pow((target.position.x - position.x), 2) + pow((target.position.y - position.y),2)
	
	var disc = pow(b,2) - 4 * a * c
	
	var t1 = (-b + sqrt(disc)) / (2 * a)
	var t2 = (-b - sqrt(disc)) / (2 * a)
	
	var minimum
	if t1 > 0:
		if t2 > 0:
			minimum = min(t1, t2)
		else:
			minimum = t1
	elif t2 > 0:
		minimum = t2
	else:
		bullet.direction.x = 0
		bullet.direction.y = 0
	
	var fire_position = Vector2(0,0)
	fire_position.x = (minimum * target_xvel + target.position.x)
	fire_position.y = (minimum * target_yvel + target.position.y)
	
	bullet.direction = (fire_position - position).normalized()	
	print("Tower bullet direction: ", bullet.direction)

func _on_TextureButton_toggled(button_pressed):
	emit_signal("towerPressed", self)
