def warm
  [:c3, :cs3, :d3, :ds3, :e3, :f3, :fs3, :g3, :gs3, :a3, :as3, :b3,
   :c4, :cs4, :d4, :ds4, :e4, :f4, :fs4, :g4, :gs4, :a4, :as4, :b4,
  ].each{|n|
    midi n,1, sus: 0.125, port: '*', channel: '*'
    sleep 0.125
    }
end

def glitch(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, channel: 3
    glitch_cc opts
  end
end

def glitch_cc(cc)
  cc.keys.each do |k|
    case k
    when :mode
      kits = ['c-1','cs-1','d-1','ds-1','e-1','f-1','fs-1','g-1','gs-1']
      midi kits[cc[k] % kits.count], port: :iac_bus_1, channel: 3
    when :corode
      midi_cc 50, 127*cc[k], port: :iac_bus_1, channel: 3
    when :tubes
      midi_cc 51, 127*cc[k], port: :iac_bus_1, channel: 3
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
  if n
    midi n,vel, *(args << {port: :iac_bus_1} << {channel: 1})
  end
end
def vox(*args)

  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {port: :iac_bus_1} << {channel: 2})
  end
end
def bass(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {channel: 4})
  end
end
def looper(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    if opts[:elec] != nil && opts[:elec]
      midi n,vel, *(args << {channel: 8})
      looper_cc(opts)
    elsif opts[:pat] == 1/8.0
      midi n,vel, *(args << {channel: 9})

    else
      midi n,vel, *(args << {channel: 7})
      looper_cc(opts)
    end
  end
end
def looper_cc(cc)
  cc.keys.each do |k|
    n = case k
    when :tune; 50
    else
      nil
    end
    if n == 50
      midi_pitch_bend cc[k], channel: 7
      midi_pitch_bend cc[k], channel: 8
    elsif n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 7
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 8
    end
  end
end
