def state()
  $daw_state ||= {}
end

def solo(thing)
  case thing
  when :piano
    midi_cc 20, 127.0, port: :iac_bus_1, channel: 1
  end
end

def warm
  [:c3, :cs3, :d3, :ds3, :e3, :f3, :fs3, :g3, :gs3, :a3, :as3, :b3,
   :c4, :cs4, :d4, :ds4, :e4, :f4, :fs4, :g4, :gs4, :a4, :as4, :b4,
  ].each{|n|
    midi n,1, sus: 0.125, port: '*', channel: '*'
    sleep 0.125
    }
end

def alive(args)
  _, opts = split_params_and_merge_opts_array(args)
  opts.each{|s|
    state[s[0]] = ((s[1] == 0) || (s[1] == 0.0)) ? false : true
    v = (s[1] == 0.0) ? 127 : 0
    case s[0]
    when :wpiano
      midi_cc 20, v, port: :iac_bus_1, channel: 1
    when :dragon
      midi_cc 20, v, port: :iac_bus_1, channel: 2
    when :hpad
      midi_cc 20, v, port: :iac_bus_1, channel: 3
    when :piano
      midi_cc 20, v, port: :iac_bus_1, channel: 4
    when :pluck
      midi_cc 20, v, port: :iac_bus_1, channel: 5
    when :glitch
      midi_cc 20, v, port: :iac_bus_1, channel: 6
    when :zero
      midi_cc 20, v, port: :iac_bus_1, channel: 7
    when :bass
      midi_cc 20, v, port: :iac_bus_1, channel: 9
    when :piano_echos
      midi_cc 20, v, port: :iac_bus_1, channel: 16
    when :marimba
      midi_cc 19, v, port: :iac_bus_1, channel: 3
    when :spad
      midi_cc 19, v, port: :iac_bus_1, channel: 2
    when :derbass
      bass(bass: 0)
      midi_cc 19, v, port: :iac_bus_1, channel: 9
    end
  }
end

def octave(n, oct)
  if n
    note = SonicPi::Note.new(n)
    "#{note.pitch_class}#{oct}"
  else
    n
  end
end

def dragon(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {channel: 2})
    dragon_cc opts
  end
end

def dragon_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :detune; 49
        when :more; 50
        when :pulse; 51
        when :filter; 52
        when :wet; 53
        else
          nil
        end
    if n == 49
      midi_pitch_bend cc[k], channel: 2
    elsif n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 2
    end
  end
end

def zero(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {channel: 7})
    zero_cc opts
  end
end

def zero_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :detune; 49
        else
          nil
        end
    if n == 49
      midi_pitch_bend cc[k], channel: 7
    elsif n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 7
    end
  end
end

def hpad(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {channel: 3})
    hpad_cc(opts)
  end
end

def hpad_cc(cc)
  channel = 3
  cc.keys.each do |k|
    n = case k
        when :detune; 49
        when :tone; 80
        when :pitch; 81
        when :motion; 82
        when :fx; 83
        when :glow; 84
        when :piano; 85
        else
          nil
        end
    if n == 49
      midi_pitch_bend cc[k], channel: channel
    elsif n
      puts "#{k} => #{(cc[k]*127.0).round}"
      midi_cc n, (cc[k]*127.0).round, channel: channel
    end
  end
end

def spad(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {channel: 2})
  end
end

def spad_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :detune; 49
        when :filter; 80
        when :atk; 81
        when :wet; 82
        when :reverb; 83
        else
          nil
        end
    if n == 49
      midi_pitch_bend cc[k], channel: 2
    elsif n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 2
    end
  end
end

def pluck(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {channel: 5})
    nname = SonicPi::Note.new(n).midi_string
    puts "%s%s" %[nname.ljust(4+2, " "), "[Pluck]"] if state[:pluck]
    pluck_cc(opts)
  end
end

def pluck_x(*args)
  midi_all_notes_off channel: 5
end

def pluck_cc(cc)
  channel = 5
  cc.keys.each do |k|
    n = case k
        when :detune; 49
        when :ryth; 50
        when :pulse; 51
        when :wash; 52
        else
          nil
        end
    if n == 49
      midi_pitch_bend cc[k], channel: channel
    elsif n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: channel
    end
  end
end

def bass(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {channel: 9})
    nname = SonicPi::Note.new(n).midi_string
    puts "%s%s" %[nname.ljust(4+4, " "), "[Bass]"] if state[:bass]
    bass_cc opts
  end
end

def bass_on(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi_note_on n,vel, *(args << {channel: 9})
    nname = SonicPi::Note.new(n).midi_string
    puts "%s%s" %[nname.ljust(4+4, " "), "[Bass]"] if state[:bass]
    bass_cc opts
  end
end

def bass_x(*args)
  midi_all_notes_off channel: 9
end

def bass_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :detune; 49
        when :dirt; 50
        when :delay; 51
        when :noise; 52
        when :more; 53
        else
          nil
        end
    if n == 49
      midi_pitch_bend cc[k], channel: 9
    elsif n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 9
    end
  end
end


def piano(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    nname = SonicPi::Note.new(n).midi_string
    #puts "%s%s" %[nname.ljust(4, " "), "[Piano]"]
    midi n,vel, *(args << {channel: 4})
  end
end

def piano_echos(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    nname = SonicPi::Note.new(n).midi_string
    #puts "%s%s" %[nname.ljust(4, " "), "[PianoEchos]"]
    midi n,vel, *(args << {channel: 16})
  end
end


def wpiano(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if !vel
    vel = 100
  end
  if n
    midi n,vel, *(args << {channel: 1})
    wpiano_cc opts
  end
end

def wpiano_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :wash; 50
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 1
    end
  end
end


def glitch(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {channel: 6})
  end
end
