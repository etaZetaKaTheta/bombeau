extends RigidBody2D

export var explosion_delay = 3.0
export var knockback = 100.0

var damage = 0.0

func _ready():
	Server.fetch_bomb_damage("normal_bomb", get_instance_id())
	var timer = Timer.new()
	timer.set_wait_time(explosion_delay)
	timer.connect("timeout", self, "_timeout")
	add_child(timer)
	timer.start()
	

func set_bomb_damage(s_damage_value):
	damage = s_damage_value
	

func _timeout():
	$Explosion.restart()
	var bodies = $ExplosionArea.get_overlapping_bodies()
	for i in bodies:
		if i is RigidBody2D:
			i.apply_central_impulse((i.position - position).normalized() * knockback)
		if i.is_in_group("Enemy"):
			i.reduce_health(damage)
	var timer = Timer.new()
	timer.set_wait_time(0.2)
	timer.connect("timeout", self, "_timeout_destroy")
	add_child(timer)
	timer.start()

func _timeout_destroy():
	queue_free()
