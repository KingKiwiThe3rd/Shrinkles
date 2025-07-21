extends Area2D

@export var song_stream: AudioStream

func _on_body_entered(body):
	if body.name == "Shrinky":
		MusicManager.play_song(song_stream)
