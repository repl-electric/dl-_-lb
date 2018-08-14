def solo(thing)
  case thing
  when :piano
    midi_cc 20, 127.0, port: :iac_bus_1, channel: 1
  end
end

def alive(args)
  _, opts = split_params_and_merge_opts_array(args)
  opts.each{|s|
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
    puts "%s%s" %[nname.ljust(4+2, " "), "[Pluck]"]
    pluck_cc(opts)
  end
end

def pluck_cc(cc)
  channel = 5
  cc.keys.each do |k|
    n = case k
        when :detune; 49
        when :ryth; 50
        when :pulse; 51
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
    puts "%s%s" %[nname.ljust(4+4, " "), "[Bass]"]
    bass_cc opts
  end
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
