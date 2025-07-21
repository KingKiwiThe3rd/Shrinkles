extends Node

var player: AudioStreamPlayer
var fade_time := 1.0

func _ready():
	player = AudioStreamPlayer.new()
	player.bus = "Music"  # optional: route to "Music" bus
	player.volume_db = -80
	add_child(player)

func play_song(song: AudioStream):
	if player.stream == song and player.playing:
		return  # already playing

	# Fade out current song if playing
	if player.playing:
		await fade_volume_to(-80.0, fade_time)
		player.stop()

	# Set new song and fade in
	player.stream = song
	player.volume_db = -80
	player.play()
	await fade_volume_to(0.0, fade_time)

func fade_volume_to(target_db: float, duration: float) -> void:
	var start_db: float = player.volume_db
	var timer: float = 0.0
	while timer < duration:
		var t: float = timer / duration
		player.volume_db = lerp(start_db, target_db, t)
		await get_tree().process_frame
		timer += get_process_delta_time()
	player.volume_db = target_db
