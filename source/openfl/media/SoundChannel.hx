package openfl.media;

#if !flash
import openfl.events.Event;
import openfl.events.EventDispatcher;
#if lime
import lime.media.AudioSource;
#if lime_cffi import lime._internal.backend.native.NativeAudioSource; #end
#end

/**
	The SoundChannel class controls a sound in an application. Every sound is
	assigned to a sound channel, and the application can have multiple sound
	channels that are mixed together. The SoundChannel class contains a
	`stop()` method, properties for monitoring the amplitude
	(volume) of the channel, and a property for assigning a SoundTransform
	object to the channel.

	@event soundComplete Dispatched when a sound has finished playing.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
#if (lime && lime_cffi)
@:access(lime._internal.backend.native.NativeAudioSource)
@:access(lime.media.AudioSource)
@:access(lime.media.AudioBuffer)
#end
@:access(openfl.media.SoundMixer)
@:final @:keep class SoundChannel extends EventDispatcher
{
	/**
		The current amplitude(volume) of the left channel, from 0(silent) to 1
		(full amplitude).
	**/
	public var leftPeak(get, null):Float;
	
	/**
		The current amplitude(volume) of the right channel, from 0(silent) to 1
		(full amplitude).
	**/
	public var rightPeak(get, null):Float;

	/**
		When the sound is playing, the `position` property indicates in
		milliseconds the current point that is being played in the sound file.
		When the sound is stopped or paused, the `position` property
		indicates the last point that was played in the sound file.

		A common use case is to save the value of the `position`
		property when the sound is stopped. You can resume the sound later by
		restarting it from that saved position.

		If the sound is looped, `position` is reset to 0 at the
		beginning of each loop.
	**/
	public var position(get, set):Float;

	/**
		The SoundTransform object assigned to the sound channel. A SoundTransform
		object includes properties for setting volume, panning, left speaker
		assignment, and right speaker assignment.
	**/
	public var soundTransform(get, set):SoundTransform;
	
	/**
		self explanatory
	*/
	public var pitch(get, set):Float;

	@:noCompletion private var __isValid:Bool;
	@:noCompletion private var __soundTransform:SoundTransform;
	#if lime
	@:noCompletion private var __source:AudioSource;
	#end
	@:noCompletion private var __lastPeakTime:Float;
	@:noCompletion private var __leftPeak:Float;
	@:noCompletion private var __rightPeak:Float;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(SoundChannel.prototype, {
			"position": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_position (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_position (v); }")
			},
			"soundTransform": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_soundTransform (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_soundTransform (v); }")
			},
		});
	}
	#end

	@:noCompletion private function new(source:#if lime AudioSource #else Dynamic #end = null, soundTransform:SoundTransform = null):Void
	{
		super(this);

		if (soundTransform != null)
		{
			__soundTransform = soundTransform;
		}
		else
		{
			__soundTransform = new SoundTransform();
		}

		#if lime
		if (source != null)
		{
			__source = source;
			__source.onComplete.add(source_onComplete);
			__isValid = true;

			__source.play();
		}
		#end

		SoundMixer.__registerSoundChannel(this);
	}

	/**
		Stops the sound playing in the channel.
	**/
	public function stop():Void
	{
		SoundMixer.__unregisterSoundChannel(this);

		if (!__isValid) return;

		#if lime
		__source.stop();
		#end
		__dispose();
	}

	@:noCompletion private function __dispose():Void
	{
		if (!__isValid) return;

		#if lime
		__source.onComplete.remove(source_onComplete);
		__source.dispose();
		__source = null;
		#end
		__isValid = false;
	}

	@:noCompletion private function __updateTransform():Void
	{
		this.soundTransform = soundTransform;
	}

	// hi i made these - raltyro
	// took me 8 months to figure this out
	#if (lime_cffi && !macro)
	@:noCompletion private function __checkUpdatePeaks(time:Float):Bool
	{
		if (Math.abs(__lastPeakTime - time) < Math.max(1, pitch * 8)) return false;
		__lastPeakTime = time;
		return true;
	}

	#if lime_vorbis
	@:noCompletion private function __updateVorbisPeaks():Void
	{
		var currentTime:Float = position;
		if (!__checkUpdatePeaks(currentTime)) return;

		var buffer = __source.buffer;
		if (buffer == null || __source.__backend == null) return;

		// MS, NOT SECOND
		var bufferTimeBlocks = __source.__backend.bufferTimeBlocks;
		var khz:Float = (buffer.sampleRate / 1000), index:Int = Std.int((currentTime - Std.int(bufferTimeBlocks[0] * 1000)) * khz), samples:Int = 480;
		if (index < 0) {
			if ((samples -= index) < 1) return;
			index = 0;
		}

		var bufferSize = NativeAudioSource.STREAM_BUFFER_SIZE;
		var bufferDatas = __source.__backend.bufferDatas, bufferi:Int = Math.floor(index / bufferSize);

		var channels:Int = buffer.channels, stereo:Bool = channels > 1;
		var lfilled:Bool = false, rfilled:Bool = !stereo;
		var lpeak:Float = 0, rpeak:Float = 0;
		var sample:Float, rows:Int = 0;

		var bytes = bufferDatas[bufferi].buffer;
		while (rows < samples) {
			if (index >= bufferSize) {
				if ((bytes = bufferDatas[++bufferi].buffer) == null) break;
				index = 0;
			}

			if (!lfilled) {
				sample = bytes.getUInt16(index * channels * 2) / 65535;
				if (sample > .5) sample = Math.abs(sample - 1);
				if (sample > lpeak) lfilled = (lpeak = sample) >= 1;
			}

			if (!rfilled) {
				sample = bytes.getUInt16(index * channels * 2 + 2) / 65535;
				if (sample > .5) sample = Math.abs(sample - 1);
				if (sample > rpeak) rfilled = (rpeak = sample) >= 1;
			}

			if (lfilled && rfilled) break;
			index++;
			rows++;
		}

		__leftPeak = lpeak;
		__rightPeak = rpeak;
	}
	#end
	#end

	@:noCompletion private function __updatePeaks():Void
	{
		__leftPeak = __rightPeak = 0;
		if (!__isValid) return;

		#if (lime_cffi && !macro)
		#if lime_vorbis
		if (__source.__backend.stream) return __updateVorbisPeaks();
		#end

		var currentTime:Float = position;
		if (!__checkUpdatePeaks(currentTime)) return;

		var buffer = __source.buffer;
		if (buffer == null || buffer.data == null) return;

		// MS, NOT SECOND
		var khz:Float = (buffer.sampleRate / 1000), index:Int = Std.int(currentTime * khz), samples:Int = 480;
		if (index < 0) {
			if ((samples -= index) < 1) return;
			index = 0;
		}

		var bytes = buffer.data.buffer, length:Int = bytes.length - 1;
		if (index > length) return;

		var channels:Int = buffer.channels, stereo:Bool = channels > 1;
		var lfilled:Bool = false, rfilled:Bool = !stereo;
		var lpeak:Float = 0, rpeak:Float = 0;
		var sample:Float, rows:Int = 0;

		while (index < length && rows < samples) {
			if (!lfilled) {
				sample = bytes.getUInt16(index * channels * 2) / 65535;
				if (sample > .5) sample = Math.abs(sample - 1);
				if (sample > lpeak) lfilled = (lpeak = sample) >= 1;
			}

			if (!rfilled) {
				sample = bytes.getUInt16(index * channels * 2 + 2) / 65535;
				if (sample > .5) sample = Math.abs(sample - 1);
				if (sample > rpeak) rfilled = (rpeak = sample) >= 1;
			}

			if (lfilled && rfilled) break;
			index++;
			rows++;
		}

		__leftPeak = lpeak;
		__rightPeak = rpeak;
		#else
		__leftPeak = __rightPeak = 0;
		#end
	}

	// Get & Set Methods
	@:noCompletion private function get_position():Float
	{
		if (!__isValid) return 0;

		#if lime
		return __source.currentTime + __source.offset;
		#else
		return 0;
		#end
	}

	@:noCompletion private function set_position(value:Float):Float
	{
		if (!__isValid) return 0;

		#if lime
		__source.currentTime = Std.int(value) - __source.offset;
		#end
		return value;
	}

	@:noCompletion private function get_soundTransform():SoundTransform
	{
		return __soundTransform.clone();
	}

	@:noCompletion private function set_soundTransform(value:SoundTransform):SoundTransform
	{
		if (value != null)
		{
			__soundTransform.pan = value.pan;
			__soundTransform.volume = value.volume;

			var pan = SoundMixer.__soundTransform.pan + __soundTransform.pan;

			if (pan < -1) pan = -1;
			if (pan > 1) pan = 1;

			var volume = SoundMixer.__soundTransform.volume * __soundTransform.volume;

			if (__isValid)
			{
				#if lime
				__source.gain = volume;

				var position = __source.position;
				position.x = pan;
				position.z = -1 * Math.sqrt(1 - Math.pow(pan, 2));
				__source.position = position;

				return value;
				#end
			}
		}

		return value;
	}

	@:noCompletion private function get_pitch():Float
	{
		if (!__isValid) return 1;

		#if lime
		return __source.pitch;
		#else
		return 0;
		#end
	}

	@:noCompletion private function set_pitch(value:Float):Float
	{
		if (!__isValid) return 1;

		#if lime
		return __source.pitch = value;
		#else
		return 0;
		#end
	}

	@:noCompletion private function get_leftPeak():Float
	{
		__updatePeaks();
		return __leftPeak * (soundTransform == null ? 1 : soundTransform.volume);
	}

	@:noCompletion private function get_rightPeak():Float
	{
		__updatePeaks();
		return __rightPeak * (soundTransform == null ? 1 : soundTransform.volume);
	}

	// Event Handlers
	@:noCompletion private function source_onComplete():Void
	{
		SoundMixer.__unregisterSoundChannel(this);

		__dispose();
		dispatchEvent(new Event(Event.SOUND_COMPLETE));
	}
}
#else
typedef SoundChannel = flash.media.SoundChannel;
#end