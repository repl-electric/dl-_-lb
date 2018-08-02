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

def hpad(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {channel: 3})
  end
end

def bass(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {channel: 5})
  end
end

def bass_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :detune; 49
        when :ryth; 50
        else
          nil
        end
    if n == 49
      midi_pitch_bend cc[k], channel: 2
    elsif n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 5
    end
  end
end

def piano(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {channel: 4})
  end
end

def wpiano(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {channel: 1})
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
