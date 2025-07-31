extends Node

enum SoundType {
	SFX,
	VOICE,
	AMBIENT,
}

enum SoundId {
	SYSTEM,
	START,
	COMPLETE,
	GAME_OVER,
	JUMP,
	FALL,
	BGM,
}

var _audio_pools: Dictionary[SoundType, Array] = {}
var _sound_library: Dictionary[SoundId, AudioStream] = {}

var _master_volume := 0.4
var _sfx_volume := 0.8
var _voice_volume := 0.8
var _ambient_volume := 0.8


func _get_pool_size(type: SoundType) -> int:
	match type:
		SoundType.SFX:
			return 8
		SoundType.VOICE:
			return 2
		SoundType.AMBIENT:
			return 3
		_:
			return 5


func _setup_audio_pools() -> void:
	for type: int in SoundType.values():
		_audio_pools[type] = []
		var pool_size := _get_pool_size(type)

		for i in pool_size:
			var player := AudioStreamPlayer.new()
			player.name = "AudioPlayer_%s_%d" % [SoundType.keys()[type], i]
			add_child(player)
			_audio_pools[type].append(player)


func _load_sound_library() -> void:
	_sound_library[SoundId.SYSTEM] = preload("res://assets/audio/sfx/system8.ogg")
	_sound_library[SoundId.START] = preload("res://assets/audio/sfx/bonus1.ogg")
	_sound_library[SoundId.COMPLETE] = preload("res://assets/audio/sfx/its_fine.ogg")
	_sound_library[SoundId.GAME_OVER] = preload("res://assets/audio/sfx/thats_too_bad.ogg")
	_sound_library[SoundId.JUMP] = preload("res://assets/audio/sfx/se_jump_002.ogg")
	_sound_library[SoundId.FALL] = preload("res://assets/audio/sfx/fall2.ogg")
	_sound_library[SoundId.BGM] = preload("res://assets/audio/ambient/outing_time.ogg")


func _ready() -> void:
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	_setup_audio_pools()
	_load_sound_library()


func _get_available_player(type: SoundType) -> AudioStreamPlayer:
	var pool := _audio_pools[type]

	for player: AudioStreamPlayer in pool:
		if not player.playing:
			return player

	return pool[0]


func _get_type_volume(type: SoundType) -> float:
	var type_volume := 1.0

	match type:
		SoundType.SFX:
			type_volume = _sfx_volume
		SoundType.VOICE:
			type_volume = _voice_volume
		SoundType.AMBIENT:
			type_volume = _ambient_volume

	return linear_to_db(_master_volume * type_volume)


func play_sound(
	id: SoundId, type := SoundType.SFX, volume_db := 0.0, pitch := 1.0, delay := 0.0
) -> AudioStreamPlayer:
	if not _sound_library.has(id):
		print("WARN: Sound not found: %s" % id)
		return null

	var player := _get_available_player(type)

	player.stream = _sound_library[id]
	player.volume_db = volume_db + _get_type_volume(type)
	player.pitch_scale = pitch

	if delay > 0.0:
		await get_tree().create_timer(delay).timeout

	player.play()
	return player


func play_sfx(id: SoundId, volume_db := 0.0, pitch := 1.0) -> AudioStreamPlayer:
	return await play_sound(id, SoundType.SFX, volume_db, pitch)


func play_voice(id: SoundId, volume_db := 0.0, pitch := 1.0) -> AudioStreamPlayer:
	return await play_sound(id, SoundType.VOICE, volume_db, pitch)


func play_ambient(id: SoundId, volume_db := 0.0, pitch := 1.0, loop := true) -> AudioStreamPlayer:
	var player := await play_sound(id, SoundType.AMBIENT, volume_db, pitch)

	if player.stream is AudioStreamOggVorbis:
		(player.stream as AudioStreamOggVorbis).loop = loop

	return player


func set_master_volume(volume: float) -> void:
	_master_volume = clamp(volume, 0.0, 1.0)


func set_sfx_volume(volume: float) -> void:
	_sfx_volume = clamp(volume, 0.0, 1.0)


func set_voice_volume(volume: float) -> void:
	_voice_volume = clamp(volume, 0.0, 1.0)


func set_ambient_volume(volume: float) -> void:
	_ambient_volume = clamp(volume, 0.0, 1.0)


func stop_sound_type(type: SoundType) -> void:
	var pool := _audio_pools[type]

	for player: AudioStreamPlayer in pool:
		if player.playing:
			player.stop()


func stop_all_sounds() -> void:
	for type: SoundType in SoundType.values():
		stop_sound_type(type)


func is_sound_playing(id: SoundId, type := SoundType.SFX) -> bool:
	var target_stream := _sound_library[id]
	var pool := _audio_pools[type]

	for player: AudioStreamPlayer in pool:
		if player.playing and player.stream == target_stream:
			return true

	return false
