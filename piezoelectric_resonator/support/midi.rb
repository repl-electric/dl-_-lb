 MODE_NOTE = 13

def linear_map(x0, x1, y0, y1, x)
  dydx = (y1 - y0) / (x1- x0)
  dx = (x- x0)
  (y0 + (dydx * dx))
end


 def kal(n,*args)
     if n
    if args && args[0].is_a?(Numeric)
      velocity = args[0]
      args = args[1..-1]
    else
      velocity = 40
    end
    if n.is_a?(Array)
      args[0] = {sus: n[1]+0.5}.merge(args[0]||{})
      n = n[0]
    end
    args_h = resolve_synth_opts_hash_or_array(args)
    if(args_h[:mode])
    end
    if n && ((n != "_") && n != :_)
      midi n, velocity, *(args << {port: :iac_bus_2} << {channel: 15})
      nname = SonicPi::Note.new(n).midi_string
    end
  end
 end

 def kalshot(n,*args)
     if n
    if args && args[0].is_a?(Numeric)
      velocity = args[0]
      args = args[1..-1]
    else
      velocity = 40
    end
    if n.is_a?(Array)
      args[0] = {sus: n[1]+0.5}.merge(args[0]||{})
      n = n[0]
    end
    args_h = resolve_synth_opts_hash_or_array(args)
    if(args_h[:mode])
    end
    if n && ((n != "_") && n != :_)
      midi n, velocity, *(args << {port: :iac_bus_2} << {channel: 16})
      nname = SonicPi::Note.new(n).midi_string
    end
  end
 end

 def lfo(args)
   args_h = resolve_synth_opts_hash_or_array(args)
   if args_h[:on] != nil
     if args_h[:on] == true
       midi_cc 20, 127, channel: 1, port: :iac_bus_1
     else
       midi_cc 20, 0, channel: 1, port: :iac_bus_1
     end
   end
 end

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
      midi n, velocity, *(args << {port: :iac_bus_2} << {channel: 8})
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
      if t = args_h[:pad]
        if t == 0
          midi n, velocity, *(args << {port: :iac_bus_2} << {channel: 10})
        end
        if t == 1
          midi n, velocity, *(args << {port: :iac_bus_2} << {channel: 11})
        end
        if t == 2
          midi n, velocity, *(args << {port: :iac_bus_2} << {channel: 12})
        end
      else
        if t = args_h[:thick]
          if t >= 0
            midi n, velocity, *(args << {port: :iac_bus_2} << {channel: 10})
          end
          if t >= 1
            midi n, velocity, *(args << {port: :iac_bus_2} << {channel: 11})
          end
          if t >= 2
            midi n, velocity, *(args << {port: :iac_bus_2} << {channel: 12})
          end
        end
      end
      nname = SonicPi::Note.new(n).midi_string
      puts "Pads -> [#{nname}]"
      pads_cc args_h
    end
  end
end

def sopsea(n,*args)
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
      qbitsea_mode(args_h[:mode])
    end
    if n && ((n != "_") && n != :_)
      midi n, velocity, *(args << {port: :iac_bus_2} << {channel: 4})
      nname = SonicPi::Note.new(n).midi_string
      #puts "%s%s" %[nname.ljust(4, " "), "[QBitSea]"]  unless note(n) < MODE_NOTE
      #          console("QbitSea #{nname}") unless note(n) < MODE_NOTE
      qbitsea_cc args_h
        end
  end
end


def play_with(synths, *args)
  synths.each do |s|
    begin
      method(s).(*args)
    rescue Exception => e
      puts e.inspect
    end
  end
end

def pads_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :drive; 51
        when :amp; 52
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_2, channel: 10
    end
  end
end

def deep(n,*args)
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
      midi n, velocity, *(args << {port: :iac_bus_2} << {channel: 7})
      nname = SonicPi::Note.new(n).midi_string
      puts "#{nname} [Deep]"
      sea wave: linear_map(45,72, 0.3,6.0, note(n)), delay: true
      deep_cc(args_h)
    end
  else
    sea wave: 0.0, ripple: 0.0
  end
end

def deep_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :drive
          sea ripple: cc[k]*1.5, delay: true
          51
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_2, channel: 7
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
      midi n, velocity, *(args << {port: :iac_bus_2} << {channel: 1})
      nname = SonicPi::Note.new(n).midi_string
      mbox_cc args_h
    end
  end
end

def mbox_on(n,*args)
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
      midi_note_on n, velocity, *(args << {port: :iac_bus_2} << {channel: 1})
      nname = SonicPi::Note.new(n).midi_string
      mbox_cc args_h
    end
  end
end

def mbox_of(n)
  if n
    midi_note_off n, port: :iac_bus_2, channel: 1
  end
end

def mbox_x(*args)
  midi_all_notes_off port: :iac_bus_2, channel: 1
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
      midi_cc n, cc[k]*127.0, port: :iac_bus_2, channel: 1
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
      midi n, velocity, *(args << {port: :iac_bus_2} << {channel: 9})
      nname = SonicPi::Note.new(n).midi_string
      mbox_cc args_h
    end
  end
end

def mbox2_on(n,*args)
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
      midi_note_on n, velocity, *(args << {port: :iac_bus_2} << {channel: 9})
    end
  end
end

def mbox2_x(*args)
  midi_all_notes_off port: :iac_bus_2, channel: 9
end

def mbox2_of(n)
  if n
    midi_note_off n, port: :iac_bus_2, channel: 9
  end
end

def mbox2_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :motion; 1
        when :drive; 51
        when :sat; 52
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_2, channel: 9
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
    if(m=args_h[:mode])
      looper_mode(m)
    end
    if n && ((n != "_") && n != :_)
      midi n, velocity, *(args << {port: :iac_bus_2} << {channel: 5})
      nname = SonicPi::Note.new(n).midi_string
      looper_cc args_h
    end
  end
end

def looper_mode(mode)
  if mode
    looper ['C-1','Cs-1','D-1','Ds-1','E-1', 'F-1', 'Fs-1', 'G-1', 'Gs-1', 'A-1', 'As-1', 'B-1'][mode]
  end
end

def flow_oct(oct)
  {
  -24 => 0,
  -12 => 0.3,
  -5  => 0.4,
  0 =>  0.5,
  7 => 0.65,
  12 => 0.66,
  19 => 0.7,
  24 => 0.73,
  31 => 0.75,
  36 => 0.78,
  43 => 0.8,
  48=> 0.83}[oct]
end

def looper_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :motion; 1
        when :fm; 50
        when :drive; 51
        when :amp; 52
        when :oct
          f = flow_oct(cc[k])
          if f
            cc[k] = f
          end
          53
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_2, channel: 5
    end
  end
end
