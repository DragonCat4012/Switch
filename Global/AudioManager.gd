extends AudioStreamPlayer

const main_backgorund_music = preload("res://Sounds/daylight.mp3")
const zap_sound = preload("res://Sounds/ping.mp3")
var should_play_background_music = true

func _play_music(music: AudioStream, volume = -30.0):
	should_play_background_music = true
	
	stream = music
	volume_db = volume
	play()
	connect("finished", Callable(self,"_on_loop_sound").bind(self))
	
func playZap():
	_play_single_sound_effect(zap_sound)
	
func play_music_background():
	_play_music(zap_sound)

func _play_single_sound_effect(stream: AudioStream, volume = -40.0):
	var player = AudioStreamPlayer.new()
	player.stream = stream
	player.name = "Single Sound Player"
	player.volume_db = volume
	add_child(player)
	player.play()
	
	await player.finished
	player.queue_free()
	
func _on_loop_sound(player):
	_play_music(main_backgorund_music)
