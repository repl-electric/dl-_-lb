 MODE_NOTE = 13

 class Score
  def initialize(a)
    @a ||= a
  end
  def voice(opts)
    @a.map{|section|
      chd = section[0]
      open_chd = chd.to_a
      open_chd[1] = chd[1] + opts[:open] * 12
      [open_chd, section[-1]]
    }
  end
end
def compose(pat)
  Score.new(pat.map{|root| [chord(root[0]), root[-1]]})
end

def silence!
  @silence=true
end
def silence?
  @silence=false
end

def solo(a)
  case a
  when :cpu
    midi_cc 14, 127.0, channel: 1, port: :iac_bus_1
  end
end

def octave(n, oct)
  if n
    note = SonicPi::Note.new(n)
    "#{note.pitch_class}#{oct}"
  else
    n
  end
end

def state()
  $daw_state ||= {}
end

def alive(args)
  _, opts = split_params_and_merge_opts_array(args)
  opts.each{|s|
    state[s[0]] = ((s[1] == 0) || (s[1] == 0.0)) ? false : true
    v = (s[1] == 0.0) ? 127 : 0
    case s[0]
    when :perc
      midi_cc 20, v, port: :iac_bus_1, channel: 16
    when :kick
      midi_cc 21, v, port: :iac_bus_1, channel: 16
    when :pitch
      midi_cc 22, v, port: :iac_bus_1, channel: 16
    end
  }
end

def warm
  alive pad: 1 , apeg: 1, bass: 1, piano: 1, pitch: 1, kick: 1
  [:c3, :cs3, :d3, :ds3, :e3, :f3, :fs3, :g3, :gs3, :a3, :as3, :b3,
    :c4, :cs4, :d4, :ds4, :e4, :f4, :fs4, :g4, :gs4, :a4, :as4, :b4,
    :c5, :cs5, :d5, :ds5, :e5, :f5, :fs5, :g5, :gs5, :a5, :as5, :b5,
  ].each{|n|
    midi n,1, sus: 0.125, port: '*', channel: '*'
    sleep 0.25
    }
end

def linear_map(x0, x1, y0, y1, x)
  dydx = (y1 - y0) / (x1- x0)
  dx = (x- x0)
  (y0 + (dydx * dx))
end

def eject_cpu_core(k=:pad)
  case k
  when :pad
    $end = true
    $pmode = 4
    unity "/fadeout",1
    colorb 1.0
    midi_cc 11,127, port: :iac_bus_1, channel: 1
    end2
    create_aura -2
    unity "/lights/up",1.0
    unity "/star/throttle", 1.0
    unity "/camtop/jitter",0.0
    unity "/camtop/phase",0.0
    unity "/camtop/glitch_a", 0.0
    unity "/camtop/glitch_v", 0.0
#    unity "/endshard/throttle",1.0
    unity "/world/time", 0.3
    star size: 0
    unity "/lights/end", 7.5
    sleep 0.125
    unity "/lights/up",0.0
    sleep 10/2.0
#    unity "/endshard/throttle",0.1
    sleep 10/2.0
#    unity "/endshard/throttle",0.02
    unity "/world/time", 0.2
    sleep 1
    unity "/world/time", 0.1
    sleep 2
    unity "/world/time", 0.1

  end
end

def vol(c)
  chunks = 256*2
  unity "/camtop/zoomin",-70.0
  chunks.times{
    volume=flow(0.85,c,chunks).look
    midi_cc 0, volume*127.0, port: :iac_bus_1, channel: 1
    tick
    sleep 0.125#/2.0
  }
  fadeout_roots
end

def fx(cc)
  cc.keys.each do |k|
    n = case k
        when :reverb; 12
        when :tube; 13
          if cc[k] > 0.6
            star size: (linear_map 0.6, 1.0, 10,12,cc[k] )
          end
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

      #nname = SonicPi::Note.new(n).midi_string
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

def alu(n,*args)
  if n && !@silence
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
          if args_h[:star]==true
            #star(size: linear_map(43,50, -0.02,0.1, note(n)))
          end
          sleep 0.5
          #light(size: 0.0)
        }
      end
      midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 8})
      nname = SonicPi::Note.new(n).midi_string
      alu_cc args_h
    end
  end
end

def alu_cc(cc)
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

def resonate(n,*args)
  #Subtle visual effects, undertones of chord progression subtly
  #effect the world around them, they don't dominate.
  #Note => Hue?
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
      puts "Resonate -> [#{nname}]"
      # if $chase
      # at{
      #     sleep 0.5
      #     roots_chase freq: 0.1, thick: 0.15, noise: 1,amp: 0.2, drag: [4,2].choose
      #     }
      # end

      if $pmode == 0
        at{
          sleep 0.5
          x = linear_map(note(:A2), note(:a4),10.0,100.0,note(n))
          unity "/color3/b", 49/255.0
          unity "/color2/b",255/255.0
          unity "/color1/b",118/255.0
          rocks speed: x, rot: -1
        }
      end

      resonate_cc args_h
    end
  end
end

def resonate_on(n,*args)
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
          midi_note_on n, velocity, *(args << {port: :iac_bus_1} << {channel: 10})
        end
        if pad == 1
          midi_note_on n, velocity, *(args << {port: :iac_bus_1} << {channel: 11})
        end
        if pad == 2
          midi_note_on n, velocity, *(args << {port: :iac_bus_1} << {channel: 12})
        end
      }
      nname = SonicPi::Note.new(n).midi_string
      puts "Resonate -> [#{nname}]"
      resonate_cc args_h
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

def voltage(n,*args)
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
      midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 13})
      if $pmode == 0
        at{
          sleep 0.5
          unity "/color2/h",1.4+rand*0.1
          rocks noise: 1
          sleep 1.5
          unity "/color2/h",1.7+rand*0.15
          sleep 1
          rocks orbit: -0.9
          defaultcolor
        }
      end
      nname = SonicPi::Note.new(n).midi_string
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

def resonate_cc(cc)
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

def control_unit(n,*args)
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
      puts "#{nname} [CU]"
      at{
        sleep 0.5
        sea ripple: linear_map(45,72, 0.0,0.6, note(n))
        }
      sea wave: linear_map(45,72, 0.3,6.0, note(n)), delay: true
      control_unit_cc(args_h)
    end
  else
    sea wave: 0.0, ripple: 0.0
  end
end

def control_unit_cc(cc)
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
  if !vel
    vel = 50
  end

  if n
    t=linear_map(30,124,0.2,0.8,vel)
    cube_hit(0.2, 0.2, t)
    at{
      sleep 0.5
      if vel > 40
        unity "/cube/aura/scalemul",  linear_map(0,127,0.5,0.7,vel)
        #create_aura 4
      end
      if vel > 121
        slice_cube y: 0.5
      end
      sleep 1/4.0
      unity "/cube/aura/scalemul",  0.0
      8.times{|n|
        sleep 0.125
        slice_cube y: (8.0-n)* (2.0/8.0)
        if vel > 121
          #create_aura 4/8.0 * (8.0-n)
        end
      }


      # 8.times{|n|
      #   sleep 0.125
      #   slice_cube y: (8.0-n)* (2.0/8.0)
      #   if vel > 121
      #     #create_aura 4/8.0 * (8.0-n)
      #     #unity "/cube/aura/scalemul",  1.0/8.0 * (8.0-n)
      #   end
      # }
    }

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
      if state[:perc]
      f = (vec 500, 0, 100, 0).look
      at{
        sleep 0.5
        vortex force: f, throttle: 0.05
        linecolor cube: rand*1.5
        sleep 0.5
        linecolor cube: rand*0.4
        }
      end
    end

    if $pmode != 2
      if n_val == note(:cs4) || n_val == note(:d4)
        if state[:perc]
        at{
          sleep 0.5
          cube rot: 20
          sleep 1
          cube rot: 1
          }
        end
      end
      if n_val == note(:d4)
        if state[:perc]
        at{
          sleep 0.5
          vortex turb: 10.0
          vortex force: 0
          sleep 0.5
          rocks turb: 0.0
          }
        end
      end
      if n_val == note(:c3)
        if state[:perc]
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
      end
      if n_val == note(:fs3)
        if state[:perc]
        at{
            sleep 0.5
            if $pmode == 4
              slice_cube y: (rand*0.3)+0.65
            else
              slice_cube y: (rand*0.2)+0.35
            end
          #          slice_cube z: rand*-1.8
          sleep 1
          slice_cube y: 0
          }
        end
      end
      if n_val == note(:ds3)
        if state[:perc]
        at{
          sleep 0.5
          cube circle: 0.25
          8.times{|n|
            sleep 0.5
            cube circle: 0.25*(1/(n+1))
          }
          }
        end
      end
      if n_val == note(:gs3)
        if state[:perc]
        at{
          sleep 0.5
            #create_cube 1
            if $pmode == 4
              slice_cube cubes: (rand*0.3)+0.25
            else
              slice_cube cubes: rand*0.2
            end
          #roots_chase amp: rand
            sleep 1
            if $pmode == 4
              slice_cube cubes: 0.1
            end

          #create_cube 0
          #roots_chase amp: 0.01
          }
        end
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
  if n && !@silence
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

      at{
        sleep 0.5
        thick_weight=linear_map(40,70, 0.02,0.13, note(n))
        roots_chase radius: linear_map(40,70, 0.0,4.0, note(n))
        roots_chase thick: thick_weight
        sleep 1
        8.times{|n|
          roots_chase radius: 3/8.0 * (8-n)
          sleep 0.125
        }
        roots_chase radius: 0.0

      }

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
  if n && !@silence
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
      if($pmode ==0 && !$triggered && (note(n) == note(:a3)))
          at{
            sleep 0.5
            vortex throttle: 1
          }

      end
        if($pmode ==0 && !$triggered && (note(n) == note(:c4)))
            at{
              sleep 0.5
              vortex throttle: 0.2
            }

        end


      if ($pmode != 2)
      at{
        sleep 0.5
        #vortex throttle: rand*0.5
        rocks throttle: 1.0
        note_weight=linear_map(60,70, 0.0,0.5, note(n))
        rocks noise: 8.0 + note_weight
        sleep 1
        rocks noise: 0.0

        if $pmode != 2
          if (note(n) == note(:c4)) && $triggered
            if $star_size == nil
              $star_size=0.5
            end
            $star_size+=0.013
            star size: [$star_size, 2.8].min, life: 2
          end
        end

        }
      end

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
      if(args_h[:to])
        flop_off n
        n = args_h[:to]
      end
      midi_note_on n, velocity, *(args << {port: :iac_bus_1} << {channel: 9})
      if $pmode == 0
        unity "/lights/end",2.0
        #colorb 1.0
        unity "/color1/b",255/255.0
      end
    end
  end
end

def flop_x(*args)
  midi_all_notes_off port: :iac_bus_1, channel: 9
end

def flop_off(*n)
  if n && n[0]
    midi_note_off n[0], port: :iac_bus_1, channel: 9
  end
end
def flop_of(*n)
  flop_off(n)
end

def flop_cc(cc)
  cc.keys.each do |k|
    n = case k
        when :motion
          if cc[:skip] != true
            if !$triggered && ($pmode != 2)
              @steps ||= 0
              if cc[k] > 0.29
                @steps +=1
                at{
                  sleep 0.5
                  unity "/lights/end", 20.0*cc[k]
                  colorb 3.5*cc[k]
              if cc[k] > 0.3
                vortex force: (1.6*cc[k])+(@steps*@steps)*0.8
              else
                vortex force: (1.4*cc[k])+(@steps*@steps)*0.3
              end
              vortex turb:  (1.4*cc[k])+(@steps)*0.005
                }
              else
                @steps = 0
                at{
                  sleep 0.5
                  unity "/cube/aura/ripple", 0.2
                  vortex force: 1.6*cc[k]
                  vortex turb: 1.6*cc[k]
                 }
              end
            else
              unity "/lights/end", 0
              colorb 1.0
            end

          if $pmode == 0
            at{
            sleep 0.5
            rocks noise: (cc[:motion]-0.27)*55,
            freq: (linear_map 0.27, 0.6, 0,0.08, cc[:motion]), rot: 0.0,  orbit: (cc[:motion]-0.27)*20

            x=cc[:motion]
            min = cc[:min] || 0.0
            sleep 0.5
            #unity "/cube/aura/globalscale", linear_map(0.27,0.5,0.0,1.0,x)
            unity "/cube/aura/fresnel", linear_map(min,0.5,1.5,0,x)
            unity "/cube/aura/ripple",  linear_map(min,0.5,0.0,0.8,x)
            puts "min: #{min}"
            #unity "/cube/aura/scalemul", linear_map(0.27,0.5,-0.6,-0.5,x)
            }
          end
          end
          1
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
    if @bpm > 127
      f=(@bpm/127.0)
      r = if f == 4.0
            (knit 1,4, 2,4, 3,4,4,4,5,4,6,4,7,4,8,4,9,4,10,4,11,4,12,4,13,4,14,4,15,4,16,4,16,4,18,4,19,4,20,8).look
          else
            15
          end
      puts r
      error(speed: 30 + (10*f), radius: r)
    else
      error radius: 9, speed: 30
    end
  end
end

def overclock(n,*args)
  if n && !@silence
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
          unity "/cam0/glitch_a", 0.5
          unity "/cam0/glitch_v", 0.2
          unity "/cam0/glitch_s", 0.1
          roots throttle: 1, freq: args_h[:freq]||0.0
          star size: 1.0
          $triggered = true
          slow_init
          at{
            sleep 2
            unity "/cam0/glitch_s", 0.0
            unity "/cam0/glitch_v", 0.0
            sleep 2
            unity "/cam0/glitch_a", 0.2
            sleep 1
            unity "/cam0/glitch_a", 0.0
          }
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
        when :attune; 1
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
          velocity = 80
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
            midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 16})
            puts "#{SonicPi::Note.new(n).midi_string.ljust(4, " ")} [Operator]" unless note(n) < MODE_NOTE
          end
        end
      rescue
        puts $!.message
        puts $!.backtrace
      end
end

def zero_delay(phases)
  delays = phases
  zero_cc rdelay: delays[0], ldelay: delays[1], cdelay: delays[2]
end

def zero_cc(cc)
  channel = 5
  cc.keys.each do |k|
    n = case k
        when :wash; 60
        when :cdelay
          m={1=> 0, 2 => 0.2, 3=>0.25, 4=> 0.4, 5=> 0.5, 6 => 0.65, 8 => 0.8, 16=> 1.0}
          v = m[cc[k]]
          if v
            midi_cc 61, 127*v, port: :iac_bus_1, channel: channel
          end
          nil
        when :ldelay
          m={1=> 0, 2 => 0.2, 3=>0.25, 4=> 0.4, 5=> 0.5, 6 => 0.65, 8 => 0.8, 16=> 1.0}
          v = m[cc[k]]
          if v
            midi_cc 62, 127*v, port: :iac_bus_1, channel: channel
          end

          nil
        when :rdelay
          m={1=> 0, 2 => 0.2, 3=>0.25, 4=> 0.4, 5=> 0.5, 6 => 0.65, 8 => 0.8, 16=> 1.0}
          v = m[cc[k]]
          if v
            midi_cc 63, 127*v, port: :iac_bus_1, channel: channel
          end
          nil
        else
          nil
        end
    if n == 49
      #midi_pitch_bend cc[k], channel: 4
    elsif n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: channel
    end
  end
end

def perc_machine(pat)
  if spread(4,8).look
    glitch_cc mode: (ring 0, 2, 3, 5).look
  end
    if spread(8,8).look
      if spread(3,8).look
        at{
          sleep 0.25
          dark :e3, ring(122, 100, 110, 90).look-(rand*5) if pat[-1]!=0
      }
        if (dice(16)) > 8
          at{
          sleep 0.47
          dark :b3, 60 if pat[-1]!=0
          sleep 0.43
          dark :c4, 58+rand if pat[-1]!=0
        }
        else
        at{
        sleep 0.47
        dark :b3, 60 if pat[-1]!=0
        sleep 0.53
        dark :b3, 58 if pat[-1]!=0
        }
        end
      else
        dark :e3, ring(122, 100, 110, 90).look-(rand*5) if pat[-1]!=0
      end
    end
    glitch_cc corode: 1.0
    glitch :c3, (ring 65, 60, 60, 60).look if pat[0]!=0
    at{
      sleep 0.25
      glitch :c3, 2.1*(ring 120, 90, 100, 100,    100, 90, 90, 90).look if pat[1]!=0
    }
    glitch_cc corode: 0.8

    if spread(7,11).look
      sleep 1
    else
      #glitch :gs3,3# if spread(1,4).look

      sleep 1/2.0
      glitch :ds3, 127 if state[:perc] && pat[2]!=0 #if spread(1,4).look
      sleep 1/2.0

      glitch :fs3,20 if state[:perc] && pat[3]!=0# if spread(1,4).look

      at{
        sleep 1/2.0
        glitch :g3, 50 if pat[4]!=0# if spread(1,4).look
        }
    end

    glitch_cc corode: (line 0.8, 0.9, 128).look
    #glitch (ring :c3, :a3).look, 30 if spread(7,11).look

    sleep 1/4.0
    if dice(32) > 29
      glitch :fs3, 40 if pat[1]!=0
    end
    sleep 1/4.0

    sleep 1/4.0
    if dice(32) > 28
      glitch :ds3, 127 if pat[0]!=0
    end
    sleep 1/4.0


    with_swing 0.1 {#((knit -0.1/2.0, 4, 0.1,4).look) {
      glitch :gs3, 40 if pat[5]!=0
    }

    sleep 1/2.0
    glitch :gs3, 80 if spread(1,8).look
    sleep 1/2.0
    glitch :gs3, 90 if spread(1,8).look

    #dark :cs3, 20

    sleep 1/2.0
    glitch (ring :cs4, :cs4, :cs4, :d4).look,127 if pat[6] !=0
    sleep 1/2.0
end

def perc_machine_old(pat)
  if spread(4,8).look
    glitch_cc mode: (ring 0, 2, 3, 5).look
  end
    if spread(8,8).look
      if spread(3,8).look
        at{
          sleep 0.25
          dark :e3, ring(122, 100, 110, 90).look-(rand*5) if pat[-1]!=0
        }
        at{
        sleep 0.47
          dark :a3, 127 if pat[-1]!=0
        }
      else
        dark :e3, ring(122, 100, 110, 90).look-(rand*5) if pat[-1]!=0
      end
    end
    glitch_cc corode: 1.0
    glitch :c3, (ring 65, 60, 60, 60).look if pat[0]!=0
    at{
      sleep 0.25
      glitch :c3, 2.1*(ring 120, 90, 100, 100,    100, 90, 90, 90).look if pat[1]!=0
    }
    glitch_cc corode: 0.8

    if spread(7,11).look
      sleep 1
    else
      #glitch :gs3,3# if spread(1,4).look

      sleep 1/2.0
      glitch :ds3, 127 if state[:perc] && pat[2]!=0 #if spread(1,4).look
      sleep 1/2.0

      glitch :fs3,20 if state[:perc] && pat[3]!=0# if spread(1,4).look

      at{
        sleep 1/2.0
        glitch :g3, 50 if pat[4]!=0# if spread(1,4).look
        }
    end

    glitch_cc corode: (line 0.8, 0.9, 128).look
    #glitch (ring :c3, :a3).look, 30 if spread(7,11).look

    sleep 1/4.0
    if dice(32) > 29
      glitch :fs3, 40 if pat[1]!=0
    end
    sleep 1/4.0

    sleep 1/4.0
    if dice(32) > 28
      glitch :ds3, 127 if pat[0]!=0
    end
    sleep 1/4.0


    with_swing 0.1 {#((knit -0.1/2.0, 4, 0.1,4).look) {
      glitch :gs3, 40 if pat[5]!=0
    }

    sleep 1/2.0
    glitch :gs3, 80 if spread(1,8).look
    sleep 1/2.0
    glitch :gs3, 90 if spread(1,8).look

    #dark :cs3, 20

    sleep 1/2.0
    glitch (ring :cs4, :cs4, :cs4, :d4).look,127 if pat[6] !=0
    sleep 1/2.0
end
