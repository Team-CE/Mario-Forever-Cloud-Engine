extends KinematicBody2D
class_name AliveObject

const multiplier_scores = [100, 200, 500, 1000, 2000, 5000, 1]

enum DIRECTION{
  UP,
  DOWN,
  LEFT,
  RIGHT
 }

enum DEATH_TYPE {
  BASIC,
  FALL,
  SHELL,            # Requires "Shell Stopped" and "Shell Moving" animations.
  DISAPPEAR
}

export var speed: float
export var jump_height:float
export var gravity_scale: float = 1
export var AI:Script
export(DIRECTION) var piranha_dir: int #Use for pirahna AI **ONLY**
#export var is_static: bool
export var score: int
export var smart_turn: bool
export var invincible: bool
export var ignore_all: bool #temporary
export(float,-1,1) var dir: float = 1

#RayCasts leave empty if smart_turn = false
export var ray_L_pth: NodePath
export var ray_R_pth: NodePath

#Animated sprite
export var animated_sprite_pth: NodePath

var ray_L: RayCast2D
var ray_R: RayCast2D
var animated_sprite: AnimatedSprite

var velocity: Vector2
var alive: bool = true
var freezed: bool
var death_type:int

onready var first_pos: Vector2 = position

func _ready() -> void:
  if ray_L_pth == null || ray_R_pth == null:
    smart_turn = false
  else:
    ray_L = get_node(ray_L_pth)
    ray_R = get_node(ray_R_pth)
  
  if animated_sprite_pth == null:
    push_warning("Can't load Animated sprite at:"+str(self))
  else:
    animated_sprite = get_node(animated_sprite_pth)

func _physics_process(delta:float) -> void:
  if alive:
    AI._ai_process(delta,self)
    if !is_on_floor():
      velocity.y += Global.gravity * gravity_scale
  
  #Fixing ceiling collision and is_on_floor() flickering
  if is_on_floor() || is_on_ceiling():
    velocity.y = 1
  
  velocity = move_and_slide(velocity,Vector2.UP)

#helpful functions
func turn()->void:
  dir = -dir
  velocity.x = speed * dir

func on_edge() -> bool:
  return ray_L.is_colliding() || ray_R.is_colliding()

func kill(death_type: int= 0) -> void:
  match death_type:
    DEATH_TYPE.BASIC:
      pass
    DEATH_TYPE.DISAPPEAR:
      pass
    DEATH_TYPE.FALL:
      pass
    DEATH_TYPE.SHELL:
      pass
  Global.add_score(score)
  queue_free() #Temp

func appear(appear_dir:int) -> void:
  match appear_dir:
    DIRECTION.UP:
      pass  #UP DIRECTION
    DIRECTION.DOWN:
      pass  #DOWN DIRECTION
    DIRECTION.LEFT:
      pass  #LEFT DIRECTION
    DIRECTION.RIGHT:
      pass  #RIGHT DIRECTION

func _on_HitBox_entered(area:Area2D):
  var over: Array = $HitBox.get_overlapping_areas()
  for i in over:
    if i.name == "BottomDetector":
      $Kick.play()
      kill()
      Global.Mario.y_speed = -9