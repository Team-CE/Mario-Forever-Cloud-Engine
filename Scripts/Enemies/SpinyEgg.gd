extends Brain
var spiny_node = preload('res://Objects/Enemies/Spiny.tscn')

func _ready_mixin() -> void:
	owner.death_type = AliveObject.DEATH_TYPE.NONE

func _ai_process(delta:float) -> void:
	._ai_process(delta)
	if !owner.is_on_floor():
		owner.velocity.y += Global.gravity * owner.gravity_scale * Global.get_delta(delta)
	
	if !owner.alive:
		owner.animated_sprite.rotation_degrees = 0
		return
		
	if owner.is_on_floor():
		var spiny = spiny_node.instance()
		spiny.get_node('Sprite').set_animation('appear')
		spiny.position = owner.position
		
		owner.get_parent().add_child(spiny)
		
		#var children = spiny.get_parent().get_children()
		#for node in range(len(children)):
		#	if children[node] is KinematicBody2D:
		#		spiny.add_collision_exception_with(children[node])
		
		if Global.Mario.position.x > owner.position.x:
			spiny.turn()
		owner.queue_free()
	
	if on_mario_collide('InsideDetector'):
		Global._ppd()

	#owner.velocity.y += 0.6 * Global.get_delta(delta)
	
	owner.animated_sprite.rotation_degrees += 22.5 * Global.get_delta(delta)
