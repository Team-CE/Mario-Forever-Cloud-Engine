class_name StarPowerupAction

onready var init = false
var delay_counter: float = 70

func _process_movement(brain, delta):
  if delay_counter > 0:
    delay_counter -= 1 * Global.get_delta(delta)
    return

  if !init:
    brain.owner.get_node('AnimatedSprite').speed_scale = 4
    init = true
  
  if !brain.owner.is_on_floor():
    brain.owner.velocity.y += Global.gravity * brain.owner.gravity_scale * Global.get_delta(delta)
  else:
    brain.owner.velocity.y = brain.owner.vars['bounce']
  brain.owner.velocity.x = brain.owner.vars['speed'] * brain.owner.dir
  if brain.owner.is_on_wall():
    brain.owner.turn()

func do_action(brain):
  if brain.custom_script.delay_counter > 1: return
  
  Global.Mario.shield_counter = 750
  Global.Mario.shield_star = true
  Global.add_score(brain.owner.score)
  MusicPlayer.get_node('Main').stop()
  if Global.musicBar > -100:
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Music'), round(Global.musicBar / 5))
  if Global.musicBar == -100:
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Music'), -1000)
  MusicPlayer.get_node('Star').play()
  brain.owner.get_parent().add_child(ScoreText.new(brain.owner.score, brain.owner.position))
  brain.owner.queue_free()
