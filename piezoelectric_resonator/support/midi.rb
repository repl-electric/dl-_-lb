 MODE_NOTE = 13

def linear_map(x0, x1, y0, y1, x)
  dydx = (y1 - y0) / (x1- x0)
  dx = (x- x0)
  (y0 + (dydx * dx))
end

def eject_cpu_core(k=:pad)
  case k
    when :pad
      midi_cc 11,127, port: :iac_bus_1, channel: 1
  end
end

def fx(cc)
  cc.keys.each do |k|
    n = case k
        when :reverb; 12
        when :tube; 13
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 1
    end
  end
end

def harp(n,*args)
end

def harp_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :on; 90
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 2
    end
  end
end


def kal(n,*args)
  if n
    if args && args[0].is_a?(Numeric)
      velocity = args[0]
      args = args[1..-1]
    else
      velocity = 10
    end
    if n.is_a?(Array)
      args[0] = {sus: n[1]+0.5}.merge(args[0]||{})
      n = n[0]
    end
    args_h = resolve_synth_opts_hash_or_array(args)
    if(args_h[:mode])
    end
    if n && ((n != "_") && n != :_)
      midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 15})
      if $pmode == 0
      at{
           sleep 0.5
           burst 0.8+velocity*0.01
           sleep 0.5
           burst 0.01
         }
      end
      if $pmode == 1
        at{
           sleep 0.5
           note_weight=linear_map(60,70, 0.0,0.1, note(n))
           x=(line(1.0, 18.0,256)+line(18.0,1.0,256))
           @polyidx ||= 0
           @polyidx +=1
           @polyidx = @polyidx % (x.length-1)
           tree height:  (x[@polyidx]+note_weight)   * (args_h[:f]||1.0)
        }
      end

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
      velocity = 10
    end
    if n.is_a?(Array)
      args[0] = {sus: n[1]+0.5}.merge(args[0]||{})
      n = n[0]
    end
    args_h = resolve_synth_opts_hash_or_array(args)
    if(args_h[:mode])
    end
       if n && ((n != "_") && n != :_)
         at{
         sleep 0.5
         roots_chase radius: 2.01
         sleep 1
         roots_chase radius: 0.01
         }
      midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 16})
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
      velocity = 10
    end
    if n.is_a?(Array)
      args[0] = {sus: n[1]+0.5}.merge(args[0]||{})
      n = n[0]
    end
    args_h = resolve_synth_opts_hash_or_array(args)
    if(args_h[:mode])
    end
    if n && ((n != "_") && n != :_)
      if $pmode == 1 || $pmode == 0
        unity "/linecolor/cube/b", linear_map(64,72, 0.0,4.0, note(n))
        linecolor cube: 1.0, s:  rand, h: rand, b: rand, delay: true
      end

      if $pmode == 0

        if $zslices == nil
          $zslices = 0.0
        end
        if $yslices == nil
          $yslices = 0.0
        end
        if $cslices == nil
          $cslices = 0.0
        end
        if(args_h[:z])
          $zslices += 0.03
        end
        if(args_h[:y])
          $yslices += 0.03
        end
        if(args_h[:c])
          $cslices += 0.03
        end

        at{
          world lightning: true
          sleep 0.5
          if args_h[:z]
            unity "/cube/split/z", [$zslices, 10.0].min
          end
          if args_h[:y]
            unity "/cube/split/y", [$yslices, 10.0].min
          end
          if args_h[:c]
            unity "/cube/split/cubes", [$cslices, 10.0].min
          end

          if args_h[:flash]
            unity "/linecolor/cube/b", linear_map(64,72, 0.0,4.0, note(n))
            linecolor cube: 1.0, s:  rand, h: rand, b: rand, delay: true
          end
          #light(size: linear_map(64,72, -0.02,0.0, note(n)))
          sleep 0.5
          #light(size: 0.0)
        }
      end
      midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 8})
      nname = SonicPi::Note.new(n).midi_string
      ze_cc args_h
    end
  end
end

def ze_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :solo; 100
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 8
    end
  end
end

def heat(n,*args)
  if n
    if args && args[0].is_a?(Numeric)
      velocity = args[0]
      args = args[1..-1]
    else
      velocity = 1
    end
    if n.is_a?(Array)
      args[0] = {sus: n[1]+0.5}.merge(args[0]||{})
      n = n[0]
    end
    args_h = resolve_synth_opts_hash_or_array(args)
    if(args_h[:mode])
    end

    if n && ((n != "_") && n != :_)
      args_h[:pads] ||= 0
      pads = args_h[:pads]
      if pads && !pads.is_a?(Array)
        pads = [pads]
      end
      pads.map{|pad|
        if pad == 0
          midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 10})
        end
        if pad == 1
          midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 11})
        end
        if pad == 2
          midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 12})
        end
      }
      nname = SonicPi::Note.new(n).midi_string
      puts "Heat -> [#{nname}]"
      heat_cc args_h
    end
  end
end

def bitsea(n,*args)
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
      midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 6})
      nname = SonicPi::Note.new(n).midi_string
      #bitsea_cc args_h
    end
  end
end

def qbitsea(n,*args)
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
      midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 13})
      nname = SonicPi::Note.new(n).midi_string
      #bitsea_cc args_h
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

def heat_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :drive; 51
        when :amp; 52
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 10
    end
  end
end

def deep(n,*args)
  if n
    if args && args[0].is_a?(Numeric)
      velocity = args[0]
      args = args[1..-1]
    else
      velocity = 1
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
      puts "#{nname} [Deep]"
      sea wave: linear_map(45,72, 0.3,8.0, note(n)), delay: true
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
        when :sat; 52
        when :dirt; 14
        when :wet; 15
        when :tone; 16
        when :filter; 17
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 7
    end
  end
end

def dark(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params

  if n
    midi n, vel, port: :iac_bus_1, channel: 2
  end
end

def dark_cc(cc)
    cc.keys.each do |k|
    case k
    when :mode
      kits = ['c-1','cs-1','d-1','ds-1','e-1','f-1','fs-1','g-1','gs-1', 'a-1', 'as-1',
        'b-1', 'c0', 'cs0', 'd0', 'ds0', 'e0','f0']
      midi kits[cc[k] % kits.count], port: :iac_bus_1, channel: 2
    when :corode
      midi_cc 50, 127*cc[k], port: :iac_bus_1, channel: 2
    when :tubes
      midi_cc 51, 127*cc[k], port: :iac_bus_1, channel: 2
    else
      nil
    end
  end
end

def glitch(*args)
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params

  if n
    midi n, vel, port: :iac_bus_1, channel: 4
    n_val = note(n)

    if n_val == note(:c3) && $p_glitch != n_val #a double tap
      f = (ing 500, 0, 100, 0).look
      at{
        sleep 0.5
        vortex force: f, throttle: 0.05
        linecolor cube: rand*1.5
        sleep 0.5
        linecolor cube: rand*0.4
      }
    end

    if $pmode != 2
      if n_val == note(:cs4) || n_val == note(:d4)
        at{
          sleep 0.5
          cube rot: 20
          sleep 1
          cube rot: 1
        }
      end
      if n_val == note(:d4)
        at{
          sleep 0.5
          vortex turb: 10.0
          vortex force: 0
          sleep 0.5
          rocks turb: 0.0
        }
      end
      if n_val == note(:c3)
        at{
          sleep 0.5
          rocks speed: 0.1*vel
          rocks rot: 1
          #slice_cube y: (rand*0.2)+3
          #cube circle: 0.03
          sleep 0.25
          rocks speed: 0
          #cube circle: 0
        }
      end
      if n_val == note(:fs3)
        at{
          sleep 0.5
          slice_cube y: (rand*0.2)+0.35
          #          slice_cube z: rand*-1.8
          sleep 1
          slice_cube y: 0
        }
      end
      if n_val == note(:ds3)
        at{
          sleep 0.5
          cube circle: 0.25
          8.times{|n|
            sleep 0.5
            cube circle: 0.25*(1/(n+1))
          }
        }
      end
      if n_val == note(:gs3)
        at{
          sleep 0.5
          #create_cube 1
          slice_cube cubes: rand*0.2
          #roots_chase amp: rand
          sleep 1
          #create_cube 0
          roots_chase amp: 0.01
        }
      end
    end
    $p_glitch = n_val
  end
end

def glitch_cc(cc)
  cc.keys.each do |k|
    case k
    when :mode
      kits = ['c-1','cs-1','d-1','ds-1','e-1','f-1','fs-1','g-1','gs-1', 'a-1', 'as-1',
        'b-1', 'c0', 'cs0', 'd0', 'ds0', 'e0','f0']
      midi kits[cc[k] % kits.count], port: :iac_bus_1, channel: 4
    when :corode
      midi_cc 50, 127*cc[k], port: :iac_bus_1, channel: 4
    when :tubes
      midi_cc 51, 127*cc[k], port: :iac_bus_1, channel: 4
    else
      nil
    end
  end
end

def flip(n,*args)
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

      if $pmode==4
        if($triggered_flip)
          roots throttle: 1, target: :cube, drag: 3
          star size: 1.0
          create_aura
          $triggered_flip=false
        end
      end
      if $pmode==1 || $pmode==4
        at{
          sleep 0.5
          cube aura: 2
          sleep 1.0
          cube aura: rand(1.8)
        }
      end
      nname = SonicPi::Note.new(n).midi_string
      puts "Flip -> [#{nname}]"

      flip_cc args_h
    end
  end
end

def flip_on(n,*args)
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
      midi_note_on n, velocity, *(args << {port: :iac_bus_1} << {channel: 1})
      nname = SonicPi::Note.new(n).midi_string
      flip_cc args_h
    end
  end
end

def flip_of(n)
  if n
    midi_note_off n, port: :iac_bus_1, channel: 1
  end
end

def flip_x(*args)
  midi_all_notes_off port: :iac_bus_1, channel: 1
end

def flip_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :motion; 1
        when :drive; 51
        when :sat; 52
        when :delay; 53
        when :on; 54
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 1
    end
  end
end

def flop(n,*args)
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
      at{
        sleep 0.5
        vortex throttle: rand*0.5
        rocks throttle: 1.0
        note_weight=linear_map(60,70, 0.0,0.5, note(n))
        rocks noise: 8.0 + note_weight
        sleep 1
        rocks noise: 0.0
        }

      flop_cc args_h
    end
  end
end

def flop_on(n,*args)
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
      midi_note_on n, velocity, *(args << {port: :iac_bus_1} << {channel: 9})
    end
  end
end

def flop_x(*args)
  midi_all_notes_off port: :iac_bus_1, channel: 9
end

def flop_of(n)
  if n
    midi_note_off n, port: :iac_bus_1, channel: 9
  end
end

def flop_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :motion; 1
        when :drive; 51
        when :sat; 52
        when :delay; 53
        when :on; 54
        else
          nil
        end
    if n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 9
    end
  end
end

def overclock(n,*args)
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
      overclock_mode(m)
    end
    if n && ((n != "_") && n != :_)
      midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 5})
      if $pmode == 0
        at{
          sleep 0.5
          burst 0.05
        }
      end
      nname = SonicPi::Note.new(n).midi_string
      overclock_cc args_h
    end
  end
end

def overclock_on(n,*args)
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
    if(m=args_h[:to])
      midi_note_off m, port: :iac_bus_1, channel: 5
    end
    if n && ((n != "_") && n != :_)
      midi_note_on n, velocity, *(args << {port: :iac_bus_1} << {channel: 5})

      if $pmode==0
        if(!$triggered)
          roots throttle: 1, freq: args_h[:freq]||0.0
          star size: 1.0
          $triggered = true
        end
      end
      nname = SonicPi::Note.new(n).midi_string
      overclock_cc args_h
    end
  end
end

def overclock_off(n,*args)
  if n
    midi_note_off n, port: :iac_bus_1, channel: 5
  end
end

def overclock_x(*args)
  midi_all_notes_off port: :iac_bus_1, channel: 5
end

def overlock_mode(mode)
  if mode
    overclock ['C-1','Cs-1','D-1','Ds-1','E-1', 'F-1', 'Fs-1', 'G-1', 'Gs-1', 'A-1', 'As-1', 'B-1'][mode]
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

def overclock_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :motion; 1
        when :fm; 50
        when :drive; 51
        when :amp; 52
        when :solo; 100
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
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 5
    end
  end
end

def callstack(n,*args)
  if n
    if args && args[0].is_a?(Numeric)
      velocity = args[0]
      args = args[1..-1]
    else
      velocity = 30
    end
    if n.is_a?(Array) && n[1].is_a?(Symbol)
      bonus = n[1]
      n = n[0]
      at {
        sleep 1/8.0
        midi bonus, 60, *(args << {port: :iac_bus_1} << {channel: 14} << {sus: 1/4.0})
      }
    end
    if n.is_a?(Array)
      args[0] =  {sus: n[-1]}.merge(args[0] || {})
      n = n[0]
    end
    if n
      puts "#{SonicPi::Note.new(n).midi_string.ljust(6, " ")}[Callstack]" unless note(n) < MODE_NOTE
      midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 14})
    end
  end
end

def operator(n,*args)
      begin
        if n
          velocity = 40
          if n.is_a?(Array)
            args =  args  << {sus: n[1]}
            n = n[0]
          end
          if args && args[0].is_a?(Numeric)
            velocity = args[0]
            args = args[1..-1]
          end
          if n && ((n != "_") && n != :_)
            args_h = resolve_synth_opts_hash_or_array(args)
            midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 3})
            puts "#{SonicPi::Note.new(n).midi_string.ljust(4, " ")} [Operator]" unless note(n) < MODE_NOTE
          end
        end
      rescue
        puts $!.message
        puts $!.backtrace
      end
end
