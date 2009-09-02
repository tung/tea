# This file contains the Sound class.

require 'sdl'

require 'tea/c_error'

#
module Tea

  # The Sound class allows loading and playing of audio files.
  #
  # Currently supported formats: OGG, WAV, AIFF, RIFF, VOC.
  class Sound

    # Sound states returned by Tea::Sound#state.
    STOPPED = :STOPPED
    PLAYING = :PLAYING
    PAUSED = :PAUSED

    # As per Ruby/SDL's mixer API.
    VOLUME_MAX = 128

    # Tracked because Ruby/SDL's mixer API can't get the channel volumes.
    @@volume = VOLUME_MAX

    # Tracks which Sound objects are playing in which channels, to report
    # accurate playing state info.
    @@channel_sound_ids = []

    # Get the master volume.  Volume ranges from 0..128 inclusive.
    def self.volume
      @@volume
    end

    # Set the master volume.  new_volume should be between 0..128 inclusive.
    def self.volume=(new_volume)
      v = (new_volume >= 0) ? (new_volume <= VOLUME_MAX ? new_volume : VOLUME_MAX) : 0
      SDL::Mixer.set_volume -1, new_volume
      @@volume = v
    end


    # Load a sound file.
    #
    # May raise Tea::Error on failure.
    def initialize(path)
      @wave = SDL::Mixer::Wave.load(path)
      @channel = -1

      # Tracked because Ruby/SDL's mixer API can't get sound volumes.
      @volume = VOLUME_MAX
    rescue SDL::Error => e
      raise Tea::Error, e.message, e.backtrace
    end

    # Get the sound's volume.  Volume ranges from 0..128 inclusive.
    def volume
      @volume
    end

    # Set the sound's volume.  new_volume should be between 0..128 inclusive.
    def volume=(new_volume)
      v = (new_volume >= 0) ? (new_volume <= VOLUME_MAX ? new_volume : VOLUME_MAX) : 0
      @wave.set_volume v
      @volume = v
    end

    # Play the sound.  If this sound is still playing, cut it off and start
    # playing it from the start.
    #
    # loops should be the number of times to repeat playing the sound.  Use -1
    # to loop the sound forever.
    def play(loops=0)
      # Cut off the sound if it's already playing.
      SDL::Mixer.halt(@channel) if channel_valid?

      @channel = SDL::Mixer.play_channel(-1, @wave, loops)
      @@channel_sound_ids[@channel] = object_id
    end

    # Pause the sound if it's playing, otherwise do nothing.
    def pause
      SDL::Mixer.pause(@channel) if channel_valid?
    end

    # Resume the sound if it's paused, otherwise do nothing.
    def resume
      SDL::Mixer.resume(@channel) if channel_valid?
    end

    # Stop the sound if it's playing or paused, otherwise do nothing.
    def stop
      SDL::Mixer.halt(@channel) if channel_valid?
    end

    # Check if the sound is stopped, playing or paused.  Returns one of
    # Tea::Sound::STOPPED, Tea::Sound::PLAYING or Tea::Sound::PAUSED.  A sound
    # that isn't playing or paused is considered stopped.
    def state
      if channel_valid?
        if SDL::Mixer.play?(@channel)
          # For some reason, pause? returns 0 and 1 instead of true and false.
          if SDL::Mixer.pause?(@channel) != 0
            PAUSED
          else
            PLAYING
          end
        else
          STOPPED
        end
      else
        STOPPED
      end
    end

    private

    # Check if @channel really maps to this sound.  Returns the channel number
    # if so, otherwise nil.
    def channel_valid?
      if @channel >= 0 && @@channel_sound_ids[@channel] == object_id
        @channel
      else
        nil
      end
    end

  end

end
