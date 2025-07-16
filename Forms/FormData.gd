extends Resource
class_name FormData

@export var scale: Vector2
@export var max_speed: float
@export var jump_velocity: float
@export var collision_size: Vector2
@export var animation_name: String
@export var sprite_forms: ImageTexture
@export var sprite_frames: SpriteFrames  # <-- THIS is the missing line
@export var animation_prefix: String  # e.g. "large_", "normal_", etc.
@export var air_control: float
@export var form_type: int  # 0 = SMALLER, 1 = SMALL, etc.

# Ability toggles
@export var can_dash: bool = false

@export var texture = ImageTexture.new()
