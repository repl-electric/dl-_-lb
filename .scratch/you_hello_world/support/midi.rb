def nsynth(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n, vel, *(args << {port: :iac_bus_1} << {channel: 1})
  end
  nsynth_cc(opts)
end
def nsynth_on(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  midi_note_on n, vel, *(args << {port: :iac_bus_1} << {channel: 1})
end

def nsynth_cc(*args)
  cc = if args[0].is_a?(SonicPi::Core::SPMap)
         args[0]
       else
         resolve_synth_opts_hash_or_array(args)
       end
  cc.keys.each do |k|
    n = case k
        when :x; 52
        when :y; 53
        when :mix; 60
            else nil
        end
    if n
      if n == :at
        midi_channel_pressure cc[k]*127.0, channel: 1, port: :iac_bus_1
      else
        midi_cc n, cc[k]*127.0, *(args << {port: :iac_bus_1} << {channel: 1})
      end
    end
  end
end

def baz(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  midi n, vel, *(args << {port: :iac_bus_1} << {channel: 2})
  baz_cc opts
end
def baz_cc(*args)
  cc = if args[0].is_a?(SonicPi::Core::SPMap)
         args[0]
       else
         resolve_synth_opts_hash_or_array(args)
       end
  cc.keys.each do |k|
    n = case k
        when :mix; 60
        else nil
        end
    if n
      if n == :at
        midi_channel_pressure cc[k]*127.0, channel: 2, port: :iac_bus_1
      else
        midi_cc n, cc[k]*127.0, *(args << {port: :iac_bus_1} << {channel: 2})
      end
    end
  end
end
