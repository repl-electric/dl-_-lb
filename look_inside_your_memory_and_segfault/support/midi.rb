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

def semitone_to_midi(m)
  map={-12 => 0.0,-11 => 0.05, -10 => 0.1, -9 => 0.11, -8 => 0.15, -7 => 0.2, -6 => 0.25, -5 => 0.3, -4 => 0.35, -3=> 0.36,
    -2  => 0.4, -1 => 0.45 , 0 => 0.5,
    1=> 0.55, 2 => 0.6 ,3 => 0.63 ,4 => 0.65 ,5=> 0.7 ,6 => 0.75 ,7 => 0.8 ,8 => 0.85 ,9 => 0.86 ,10 => 0.9 ,11 => 0.95 ,12 => 1.0
  }
  map[m]*127
end

def octave(n, oct)
  if n
    note = SonicPi::Note.new(n)
    "#{note.pitch_class}#{oct}"
  else
    n
  end
end

def fx(cc)
  cc.keys.each do |k|
    n = case k
        when :wash; 12
        when :smear; 13
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 1
    end
  end
end

def sop(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {port: :iac_bus_1} << {channel: 5})
    if opts[:more]
      midi n+12,vel, *(args << {port: :iac_bus_1} << {channel: 13})
    end
  end
end

def sop_on(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi_note_on n,vel, *(args << {port: :iac_bus_1} << {channel: 5})
  end
end

def sop_off(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi_note_off n, *(args << {port: :iac_bus_1} << {channel: 5})
  end
end


def sop_cc(cc)
  cc.keys.each do |k|
    case k
    when :mode
      kits = ['c-1','cs-1','d-1','ds-1','e-1','f-1','fs-1','g-1','gs-1']
      midi kits[cc[k] % kits.count], port: :iac_bus_1, channel: 5
    end
  end
end

def sop_x(*args)
  midi_all_notes_off port: :iac_bus_1, channel: 5
end

def glitch(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if vel == nil
    vel = 30
  end

  if n
    midi n,vel, channel: 3
    glitch_cc opts
  end
end

def glitch_cc(cc)
  cc.keys.each do |k|
    case k
    when :kick
      if cc[k]
        midi_cc 56, 127, port: :iac_bus_1, channel: 3
      else
        midi_cc 56, 0, port: :iac_bus_1, channel: 3
      end
    when :mode
      kits = ['c-1','cs-1','d-1','ds-1','e-1','f-1','fs-1','g-1','gs-1']
      midi kits[cc[k] % kits.count], port: :iac_bus_1, channel: 3
    when :corode
      midi_cc 50, 127*cc[k], port: :iac_bus_1, channel: 3
    when :tubes
      midi_cc 51, 127*cc[k], port: :iac_bus_1, channel: 3
    when :wash
      midi_cc 52, 127*cc[k], port: :iac_bus_1, channel: 3
    when :cdelay
      m={2 => 0.2, 3=>0.25, 4=> 0.4, 5=> 0.5, 6 => 0.65, 8 => 0.8, 16=> 1.0}
      v = m[cc[k]]
      midi_cc 53, 127*v, port: :iac_bus_1, channel: 3
    when :ldelay
      m={2 => 0.2, 3=>0.25, 4=> 0.4, 5=> 0.5, 6 => 0.65, 8 => 0.8, 16=> 1.0}
      v = m[cc[k]]
      midi_cc 54, 127*v, port: :iac_bus_1, channel: 3
    when :rdelay
      m={2 => 0.2, 3=>0.25, 4=> 0.4, 5=> 0.5, 6 => 0.65, 8 => 0.8, 16=> 1.0}
      v = m[cc[k]]
      midi_cc 55, 127*v, port: :iac_bus_1, channel: 3
    else
      nil
    end
  end
end

def piano(*args)
  #return
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params

  if vel == nil
    vel = 70
  end
  if n
    midi n,vel, *(args << {port: :iac_bus_1} << {channel: 1})
  end
end
def piano_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :detune; 50
        else
          nil
        end
    if n == 50
      midi_pitch_bend cc[k], channel: 1
    elsif n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 1
    end
  end
end
def vox(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if vel == nil
    vel = 60
  end
  if n
    midi n,vel, *(args << {port: :iac_bus_1} << {channel: 2})
  end
end
def vox_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :detune; 50
        when :wet; 51
        when :sync; 52
        when :spray; 54
        when :semitone; 55
        else
          nil
        end
    if n == 50
      midi_pitch_bend cc[k], channel: 2
    elsif n == 52
      midi_cc 53, (1.0-cc[k])*127.0, port: :iac_bus_1, channel: 2
      midi_cc 52, cc[k]*127.0, port: :iac_bus_1, channel: 2
    elsif n == 55
      midi_cc n, semitone_to_midi(cc[k]), port: :iac_bus_1, channel: 2
    else
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 2
    end
  end
end
def vox2(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {port: :iac_bus_1} << {channel: 11})
  end
end
def voxe(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {port: :iac_bus_1} << {channel: 10})
  end
end

def voxe_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :detune; 50
        when :semitone; 55
        when :x; 56
        when :y; 57
        else
          nil
        end
    if n == 50
      midi_pitch_bend cc[k], channel: 10
    elsif n == 55
      m={-12 => 0.0,-11 => 0.05, -10 => 0.1, -9 => 0.11, -8 => 0.15, -7 => 0.2, -6 => 0.25, -5 => 0.3, -4 => 0.35, -3=> 0.36,
        -2  => 0.4, -1 => 0.45 , 0 => 0.5,
        1=> 0.55, 2 => 0.6 ,3 => 0.63 ,4 => 0.65 ,5=> 0.7 ,6 => 0.75 ,7 => 0.8 ,8 => 0.85 ,9 => 0.86 ,10 => 0.9 ,11 => 0.95 ,12 => 1.0
      }
      midi_cc n, m[cc[k]]*127.0, port: :iac_bus_1, channel: 10
    else
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 10
    end
  end
end

def voxe_on(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi_note_on n,vel, *(args << {port: :iac_bus_1} << {channel: 10})
  end
end
def voxe_off(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi_note_off n,vel, *(args << {port: :iac_bus_1} << {channel: 10})
  end
end
def voxe_x(*args)
  midi_all_notes_off  *(args << {port: :iac_bus_1} << {channel: 10})
end

def vox_on(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi_note_on n,vel, *(args << {port: :iac_bus_1} << {channel: 2})
  end
end
def vox_off(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi_note_off n,vel, *(args << {port: :iac_bus_1} << {channel: 2})
  end
end
def vox_x(*args)
  midi_all_notes_off  *(args << {port: :iac_bus_1} << {channel: 2})
end


def bass(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {channel: 4})
    bass_cc(opts)
  end
end
def voltage(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  vel = if !vel
          30
        else
          vel
        end
  if n
    midi n,vel, *(args << {channel: 14})
  end
end

def bass_on(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi_note_on n,vel, *(args << {channel: 4})
    bass_cc(opts)
  end
end

def bass_x(*args)
  midi_all_notes_off channel: 4
end

def bass_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :detune; 50
        when :atk; 14
        when :wet; 17
        when :shape; 15
        when :more; 16
        else
          nil
        end
    if n == 50
      midi_pitch_bend cc[k], channel: 4
    elsif n
      midi_cc n, cc[k]*127.0, channel: 4
    end
  end
end

def looper(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if vel == nil
    vel = 60
  end
  if n
    if opts[:elec] != nil && opts[:elec]
      p = opts[:pat]
      if p == 1/2.0
        midi_cc 51, 127.0, port: :iac_bus_1, channel: 8
        midi_cc 52, 0.0, port: :iac_bus_1, channel: 8
      elsif p == 1/4.0
        midi_cc 51, 0.0, port: :iac_bus_1, channel: 8
        midi_cc 52, 127.0, port: :iac_bus_1, channel: 8
      end
      midi n,vel, *(args << {channel: 8})
      looper_cc(opts)
    elsif p=opts[:pat]
      if p == 1/2.0
        midi n,vel, *(args << {channel: 7})
        looper_cc(opts)
      elsif p == 1/4.0
        midi_cc 51, 127.0, port: :iac_bus_1, channel: 9
        midi_cc 52, 0.0, port: :iac_bus_1, channel: 9
        midi n,vel, *(args << {channel: 9})
      elsif p == '1/2d'
        midi_cc 51, 0.0, port: :iac_bus_1, channel: 9
        midi_cc 52, 127.0, port: :iac_bus_1, channel: 9

        midi n,vel, *(args << {channel: 9})
      end

    else
      midi n,vel, *(args << {channel: 7})
      looper_cc(opts)
    end
  end
end
def looper_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :detune; 50
        when :acutoff; 51
        when :bcutoff; 52
        when :atk; 53
        when :cutoff; 54
        when :abite; 55
        when :bbite; 56
        when :reverb; 57
        when :creverb; 58
        else
          nil
        end
    if n == 50
      midi_pitch_bend cc[k], channel: 7
      midi_pitch_bend cc[k], channel: 8
      midi_pitch_bend cc[k], channel: 9
    elsif n
      v = if n == 53
            (1.0- cc[k]) * 127.0
          else
            cc[k] * 127.0
          end

      midi_cc n, v, port: :iac_bus_1, channel: 7
      midi_cc n, v, port: :iac_bus_1, channel: 8
      midi_cc n, v, port: :iac_bus_1, channel: 9
    end
  end
end
