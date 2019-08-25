extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var direction = Vector2(0, 0)
var speed = 900
var damage = 2

func _ready():
	set_physics_process(true)
	
func _physics_process(delta):
	position += (direction * speed * delta)


func _on_bullet_test_2_area_entered(area):
	if area.is_in_group("mobs"):
		area.hit_by_bullet(damage)
		queue_free()
