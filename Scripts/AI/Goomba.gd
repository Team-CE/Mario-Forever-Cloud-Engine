extends Brain

func _ai_process(delta:float) -> void:
  ._ai_process(delta)
  if !owner.is_on_floor():
    owner.velocity.y += Global.gravity * owner.gravity_scale * Global.get_delta(delta)
  
  if !owner.alive:
    return
  
  if !owner.frozen:
    owner.velocity.x = owner.vars["speed"] * owner.dir
  else:
    owner.velocity.x = 0
    
  if owner.is_on_wall():
    owner.turn()
    
  if is_mario_collide('BottomDetector') and !owner.frozen and Global.Mario.velocity.y > 0:
    owner.kill()
    if Input.is_action_pressed('mario_jump'):
      Global.Mario.velocity.y = -(owner.vars["bounce"] + 5) * 50
    else:
      Global.Mario.velocity.y = -owner.vars["bounce"] * 50
  elif on_mario_collide('InsideDetector') and !owner.frozen:
    Global._ppd()
    
  var g_overlaps = owner.get_node('KillDetector').get_overlapping_bodies()
  for i in range(len(g_overlaps)):
    if 'triggered' in g_overlaps[i] and g_overlaps[i].triggered:
      owner.kill(AliveObject.DEATH_TYPE.FALL, 0)
