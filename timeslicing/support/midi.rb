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
    when :apeg
      midi_cc 20, v, port: :iac_bus_1, channel: 2
    when :perc
      midi_cc 20, v, port: :iac_bus_1, channel: 3
    when :bass
      midi_cc 20, v, port: :iac_bus_1, channel: 4
    when :piano
      midi_cc 20, v, port: :iac_bus_1, channel: 5
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
