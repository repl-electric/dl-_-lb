def state()
  $daw_state ||= {}
end

def warm
  alive pad: 1 , apeg: 1, bass: 1, piano: 1, vocal: 1, kick: 1
  [:c3, :cs3, :d3, :ds3, :e3, :f3, :fs3, :g3, :gs3, :a3, :as3, :b3,
    :c4, :cs4, :d4, :ds4, :e4, :f4, :fs4, :g4, :gs4, :a4, :as4, :b4,
    :c5, :cs5, :d5, :ds5, :e5, :f5, :fs5, :g5, :gs5, :a5, :as5, :b5,
  ].each{|n|
    midi n,1, sus: 0.125, port: '*', channel: '*'
    sleep 0.25
    }
end

def alive(args)
  _, opts = split_params_and_merge_opts_array(args)
  opts.each{|s|
    state[s[0]] = ((s[1] == 0) || (s[1] == 0.0)) ? false : true
    v = (s[1] == 0.0) ? 127 : 0
    case s[0]
    when :pad
      midi_cc 20, v, port: :iac_bus_1, channel: 1
    when :harp
      midi_cc 20, v, port: :iac_bus_1, channel: 2
    when :perc
      midi_cc 20, v, port: :iac_bus_1, channel: 3
    when :crystal
      midi_cc 21, v, port: :iac_bus_1, channel: 3
    when :vastness
      midi_cc 20, v, port: :iac_bus_1, channel: 4
    when :pedal
      midi_cc 22, v, port: :iac_bus_1, channel: 4
    when :waves
      midi_cc 21, v, port: :iac_bus_1, channel: 4
    when :piano
      midi_cc 20, v, port: :iac_bus_1, channel: 5
    when :kalim
      midi_cc 21, v, port: :iac_bus_1, channel: 5
    when :kalim2
      midi_cc 22, v, port: :iac_bus_1, channel: 9

    when :vocal
      midi_cc 20, v, port: :iac_bus_1, channel: 6
    when :kick
      midi_cc 20, v, port: :iac_bus_1, channel: 7
    end
  }
end

def pad(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi_note_on n,vel, *(args << {channel: 1})
  end
end

def pad_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :tone; 50
        when :pitch; 51
        when :motion; 52
        when :fx; 53
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, channel: 1
    end
  end
end

def octave(n, oct)
  if n
    note = SonicPi::Note.new(n)
    note("#{note.pitch_class}#{oct}")
  else
    n
  end
end
#scale C, D, E♭, F, G, A♭, and B♭.
def kick(v=100)
  midi :C3 ,v, channel:7
end

def vastness(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n, vel, *(args << {channel: 4, port: :iac_bus_1})
    nname = SonicPi::Note.new(n).midi_string
    if state[:vastness]
      synth = "Vastness"
    elsif state[:waves]
      synth = "waves"
    end
    puts "%s%s" %[nname.ljust(4, " "), "[#{synth}]"] if synth
    vastness_cc opts
  end
end

def vastness_on(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi_note_on n, vel, *(args << {channel: 4, port: :iac_bus_1})
    nname = SonicPi::Note.new(n).midi_string
    if state[:vastness]
      synth = "Vastness"
    elsif state[:waves]
      synth = "waves"
    end
    puts "%s%s" %[nname.ljust(4, " "), "[#{synth}]"] if synth
    vastness_cc opts
  end
end

def vastness_x(*args)
  midi_all_notes_off port: :iac_bus_1, channel: 4
end

def vastness_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :detune; 49
        when :pulse; 50
        when :filter; 51
        when :tone; 52
        when :shape; 53
        else
          nil
        end
    if n == 49
      midi_pitch_bend cc[k], channel: 4
    elsif n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 4
    end
  end
end

def perc(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n, vel, *(args << {channel: 6, port: :iac_bus_1})
    nname = SonicPi::Note.new(n).midi_string
    puts "%s%s" %[nname.ljust(4, " "), "[Perc]"] #if state[:vastness]
  end
end

def crystal(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    if true#note(n) != note(:ds3)
    midi n, vel, *(args << {channel: 11, port: :iac_bus_1})
    nname = SonicPi::Note.new(n).midi_string
      puts "%s%s" %[nname.ljust(4, " "), "  <Crystal>"] if state[:crystal]
    end
  end
end

def bright(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n, vel, *(args << {channel: 5, port: :iac_bus_1})
    if !opts[:piano] || opts[:piano] != 0
      midi n, vel, *(args << {channel: 6, port: :iac_bus_1})
    end
    midi n, vel, *(args << {channel: 8, port: :iac_bus_1})

    nname = SonicPi::Note.new(n).midi_string
    puts "%s%s" %[nname.ljust(4, " "), "[*Bright*]"] if state[:piano]
    bright_cc opts
  end
end

def kalim2(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n, vel, *(args << {channel: 11, port: :iac_bus_1})

    nname = SonicPi::Note.new(n).midi_string
    puts "%s%s" %[nname.ljust(4, " "), "[*Kalim*]"] if state[:piano]
  end
end

def zero_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :wash; 60
        else
          nil
        end
    if n == 49
      #midi_pitch_bend cc[k], channel: 4
    elsif n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 5
    end
  end
end

def bright_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :detune; 49
        when :cutoff; 50
        else
          nil
        end
    if n == 49
      #midi_pitch_bend cc[k], channel: 4
    elsif n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 5
    end
  end
end

def operator(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n, vel, *(args << {channel: 6, port: :iac_bus_1})
    nname = SonicPi::Note.new(n).midi_string
    puts "%s%s" %[nname.ljust(4, " "), "[Operator]"] if state[:piano]
  end
end

def harp(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n, vel, *(args << {channel: 2, port: :iac_bus_1})
    nname = SonicPi::Note.new(n).midi_string
    puts "%s%s" %[nname.ljust(4, " "), "[Harp]"] if state[:harp]
  end
end

def voices(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n, vel, *(args << {channel: 8, port: :iac_bus_1})
    nname = SonicPi::Note.new(n).midi_string
    puts "%s%s" %[nname.ljust(4, " "), "[Harp]"] if state[:voice]
  end
end
