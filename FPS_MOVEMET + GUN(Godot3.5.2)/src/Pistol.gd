extends Spatial

onready var AnimPlayer = $AnimationPlayer
onready var sound = $Shot

#Taking care of sound
func shoot():
	if AnimPlayer.is_playing():
		pass
	else: #taking care of sound , making it sound more realastic
		AnimPlayer.play("Kick")
		sound.set_pitch_scale(rand_range(.7 , .9))
