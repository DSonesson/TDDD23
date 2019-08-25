extends RigidBody2D

var speed = 300
var direction = Vector2(0, -1)

func _ready():
	set_physics_process(true)
	
	
func _physics_process(delta):
	var pos = get_position()
	set_position(pos + (direction * speed * delta))
	print("test")


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_bullet_body_entered(body):
	print("Bullet hit")
	if body.is_in_group("mobs"):
		queue_free()
