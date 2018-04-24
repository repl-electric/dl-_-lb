def ze(n,*args)
  if n
    if args && args[0].is_a?(Numeric)
      velocity = args[0]
      args = args[1..-1]
    else
      velocity = 30
    end
    if n.is_a?(Array)
      args[0] = {sus: n[1]+0.5}.merge(args[0]||{})
      n = n[0]
    end
    args_h = resolve_synth_opts_hash_or_array(args)
    if(args_h[:mode])
    end
    if n && ((n != "_") && n != :_)
      midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 8})
      nname = SonicPi::Note.new(n).midi_string
      pads_cc args_h
    end
  end
end


def pads(n,*args)
  if n
    if args && args[0].is_a?(Numeric)
      velocity = args[0]
      args = args[1..-1]
    else
      velocity = 30
    end
    if n.is_a?(Array)
      args[0] = {sus: n[1]+0.5}.merge(args[0]||{})
      n = n[0]
    end
    args_h = resolve_synth_opts_hash_or_array(args)
    if(args_h[:mode])
    end
    if n && ((n != "_") && n != :_)
      midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 3})
      nname = SonicPi::Note.new(n).midi_string
      pads_cc args_h
    end
  end
end

def pads_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :drive; 51
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 3
    end
  end
end

def baz(n,*args)
  if n
    if args && args[0].is_a?(Numeric)
      velocity = args[0]
      args = args[1..-1]
    else
      velocity = 30
    end
    if n.is_a?(Array)
      args[0] = {sus: n[1]+0.5}.merge(args[0]||{})
      n = n[0]
    end
    args_h = resolve_synth_opts_hash_or_array(args)
    if(args_h[:mode])
    end
    if n && ((n != "_") && n != :_)
      midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 7})
      nname = SonicPi::Note.new(n).midi_string
      puts "#{nname} [Baz]"
      baz_cc(args_h)
    end
  end
end

def baz_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :drive; 51
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 7
    end
  end
end

def mbox(n,*args)
  if n
    if args && args[0].is_a?(Numeric)
      velocity = args[0]
      args = args[1..-1]
    else
      velocity = 30
    end
    if n.is_a?(Array)
      args[0] = {sus: n[1]+0.5}.merge(args[0]||{})
      n = n[0]
    end
    args_h = resolve_synth_opts_hash_or_array(args)
    if(args_h[:mode])
    end
    if n && ((n != "_") && n != :_)
      midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 1})
      nname = SonicPi::Note.new(n).midi_string
      mbox_cc args_h
    end
  end
end


def mbox_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :motion; 1
        when :drive; 51
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 1
    end
  end
end


def mbox2(n,*args)
  if n
    if args && args[0].is_a?(Numeric)
      velocity = args[0]
      args = args[1..-1]
    else
      velocity = 30
    end
    if n.is_a?(Array)
      args[0] = {sus: n[1]+0.5}.merge(args[0]||{})
      n = n[0]
    end
    args_h = resolve_synth_opts_hash_or_array(args)
    if(args_h[:mode])
    end
    if n && ((n != "_") && n != :_)
      midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 9})
      nname = SonicPi::Note.new(n).midi_string
      mbox_cc args_h
    end
  end
end


def mbox2_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :motion; 1
        when :drive; 51
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 9
    end
  end
end



def looper(n,*args)
  if n
    if args && args[0].is_a?(Numeric)
      velocity = args[0]
      args = args[1..-1]
    else
      velocity = 30
    end
    if n.is_a?(Array)
      args[0] = {sus: n[1]+0.5}.merge(args[0]||{})
      n = n[0]
    end
    args_h = resolve_synth_opts_hash_or_array(args)
    if(args_h[:mode])
    end
    if n && ((n != "_") && n != :_)
      midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 5})
      nname = SonicPi::Note.new(n).midi_string
      looper_cc args_h
    end
  end
end

def looper_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :motion; 1
        when :fm; 50
        when :drive; 51
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 5
    end
  end
end
