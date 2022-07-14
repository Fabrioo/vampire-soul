extends KinematicBody2D



var velocity = Vector2(0,0)
var damage = 100
var health = 1


func _ready():
	pass



func _process(delta):
	move_and_collide(velocity * delta)



func _on_Area2D_body_entered(body):
	if body.test() != "player" and body.test() != "exp" and body.test() != "wall":
		body.hit(damage)
		print(body.test())
		queue_free()

func hit(damag):
	pass
