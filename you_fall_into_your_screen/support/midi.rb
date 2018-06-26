module ReplElectric
  module Midi
    include SonicPi::Lang::Support::DocSystem
    include SonicPi::Util
    MODE_NOTE = 13
    #helpers
    def linear_map(x0, x1, y0, y1, x)
      dydx = (y1 - y0) / (x1- x0)
      dx = (x- x0)
      (y0 + (dydx * dx))
    end

    def flow_oct(oct)
      {
        -24 => 0,
        -12 => 0.3,
        -5 => 0.4,
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

    def find_chord(note)
      chord(note,ct(note))
    end

    def strpat(s)
      p=nil
      s.gsub(/\s+/,'').split('').reduce([]){|ac,x|
        if x != '[' && x!= "]" && x!= "\n"
          ac << x
        elsif x == "]"
          ac[-1] = "[#{ac[-1]}#{x}"
        end
        ac
      }.map{|x| eval(x)}.ring
    end

    def mt_pat
      s1 = ring(_, 5,   _, _,   [5], _,   _, _,   _, _,  _, _,  5, _,  _, _,
                _, 5,   _, _,   [5], _,   5, _,   _, _,  _, _,  5, _,  _, _,
                _, 5,   _, _,   [5], _,   _, _,   _, _,  _, _,  5, _,  _, _,
                _, 5,   _, _,   [5], _,   _, _,   5, _,  _, _,  5, _,  _, _)
      s2 = ring(_, _,   _, _,   [5], _,   _, _,   _, _,  _, _,  5, _,  _, _,
                _, _,   _, _,   [5], _,   5, _,   _, _,  _, _,  5, _,  _, _,
                _, _,   _, _,   [5], _,   _, _,   _, _,  _, _,  5, _,  _, _,
                _, _,   _, _,   [5], _,   _, _,   _, _,  _, _,  5, _,  _, _)
      s3 = ring(_, _,   _, _,   [5], _,   _, _,  5,  _,  _, _,  5, _,  _, _,
                _, _,   _, _,   [5], _,   _, _,  5,  _,  _, _,  5, _,  _, _,
                _, _,   _, _,   [5], _,   _, _,  5,  _,  _, _,  5, _,  _, _,
                _, _,   _, _,   [5], _,   _, _,  5,  _,  _, _,  5, _,  _, _)
      knit(s2,16*4,s3,16*4, s1,16*4)
    end

    def bass(n, *args)
      begin
        if n
          if n.is_a?(Array)
            args = args << {sus: n[1]}
            n = n[0]
          end
          if args && args[0].is_a?(Numeric)
            velocity = args[0]
            args = args[1..-1]
          else
            velocity = 127
          end
          args_h = resolve_synth_opts_hash_or_array(args)
          if(args_h[:cutoff])
            bass_cc(cutoff: args_h[:cutoff])
          end
          if n && ((n != "_") && n != :_)
            midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 5})
            dshader :decay, :iBass, (note(n)/69.0)
          end
        end
      rescue
        puts $!
      end
    end

    def bad_bass(n, *args)
      begin
        if n
          if n.is_a?(Array)
            args = args << {sus: n[1]}
            n = n[0]
          end
          if args && args[0].is_a?(Numeric)
            velocity = args[0]
            args = args[1..-1]
          else
            velocity = 127
          end
          args_h = resolve_synth_opts_hash_or_array(args)
          if(args_h[:cutoff])
            bass_cc(cutoff: args_h[:cutoff])
          end
          if n && ((n != "_") && n != :_)
            midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 6})
            dshader :decay, :iBass, (note(n)/69.0)
          end
        end
      rescue
        puts $!
      end
    end

    def bass_cc(cc)
      cc.keys.each do |k|
        n = case k
            when :cutoff; 6
            else
              nil
            end
        if n
          midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 5
        end
      end
    end

    def bass_x
      midi_all_notes_off port: :iac_bus_1, channel: 5
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
          bitsea_mode(args_h[:mode])
        end
        if n && ((n != "_") && n != :_)
          midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 10})
          nname = SonicPi::Note.new(n).midi_string
          puts "%s%s" %[nname.ljust(4, " "), "[BitSea]"]  unless note(n) < MODE_NOTE
          console("[BitSea] #{nname}") unless note(n) < MODE_NOTE
          bitsea_cc args_h

        end
      end
    end

    def bitsea_on(n, *args)
      if n
        if n.is_a?(Array)
          args =  args  << {sustain: n[1]}
          n = n[0]
        end
        if args && args[0].is_a?(Numeric)
          velocity = args[0]
          args = args[1..-1]
        else
          velocity = 30
        end
        args_h = resolve_synth_opts_hash_or_array(args)
        if(args_h[:mode])
          bitsea_mode(args_h[:mode])
        end
        if n && ((n != "_") && n != :_)
          midi_note_on n, velocity, *(args << {port: :iac_bus_1} << {channel: 10})
          at{
            sleep 0.5
            if $mode == -1
              viz shard: 1.0
            end
            #unity "/sea/on", 1.0
            unity "/sea/spacex",0.1
            unity "/postfx/color",0.0
            unity "/alive/rotate",20.0
            }
        end
      end
    end

    def bitsea_x(*args)
      midi_all_notes_off port: :iac_bus_1, channel: 10
    end

    def bitsea_off(n, *args)
      midi_note_off n, *(args << {port: :iac_bus_1} << {channel: 10})
    end

    def bitsea_cc(cc)
      cc.keys.each do |k|
        n = case k
            when :motion; 1
            when :formant; 98
            when :form_amp; 99
            when :cutoff; 97
            when :phase; 102
            when :comp; 101
            when :octave; 106
            when :lo; 103
            when :mi; 104
            when :hi; 105
            else
              nil
            end
        if n
          midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 10
        end
      end
    end
    def bitsea_mode(mode)
      bitsea ['C-1','Cs-1','D-1','Ds-1','E-1', 'F-1', 'Fs-1', 'G-1', 'Gs-1', 'A-1', 'As-1', 'B-1'][mode]
    end

    def qbitsea_mode(mode)
      qbitsea ['C-1','Cs-1','D-1','Ds-1','E-1', 'F-1', 'Fs-1', 'G-1', 'Gs-1', 'A-1', 'As-1', 'B-1'][mode]
    end

    def qbitsea_x(*args)
      midi_all_notes_off port: :iac_bus_1, channel: 4
    end

    def qbitsea_cc(cc)
      cc.keys.each do |k|
        n = case k
            when :motion; 1
            when :formant; 98
            when :form_amp; 99
            when :cutoff; 97
            when :drive; 101
            when :bass; 102
            when :fm; 103
            when :mod; 104
            when :mul; 105
            when :atk; 106
            when :wav; 107
            when :oct
              f = flow_oct(cc[k])
              if f
                cc[k] = f
              end
              if cc[k] > 1
                cc[k] = flow_oct(0)
              end
              108
            when :charge; 109
            when :width; 110
            when :center; 111
            when :head; 112
            when :lo; 113
            when :hi; 114
            when :mi; 115
            else
              nil
            end
        if n
          midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 4
        end
      end
    end

    def qbitsea_on(n, *args)
      if n
        if n.is_a?(Array)
          args =  args  << {sus: n[1]}
          n = n[0]
        end
        if args && args[0].is_a?(Numeric)
          velocity = args[0]
          args = args[1..-1]
        else
          velocity = 30
        end
        args_h = resolve_synth_opts_hash_or_array(args)
        if(args_h[:mode])
          qbitsea_mode(args_h[:mode])
        end
        if n && ((n != "_") && n != :_)
          midi_note_on n, velocity, *(args << {port: :iac_bus_1} << {channel: 4})
        end
      end
    end
    def qbitsea_off(n, *args)
      midi_note_off n, *(args << {port: :iac_bus_1} << {channel: 4})
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
          midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 4})
          nname = SonicPi::Note.new(n).midi_string
          #puts "%s%s" %[nname.ljust(4, " "), "[QBitSea]"]  unless note(n) < MODE_NOTE
          #console("QbitSea #{nname}") unless note(n) < MODE_NOTE
          qbitsea_cc args_h
        end
      end
    end

    def exception(n,*args)
      if n
        if n.is_a?(Array)
          args =  args  << {sus: n[1]}
          n = n[0]
        end
        if args && args[0].is_a?(Numeric)
          velocity = args[0]
          args = args[1..-1]
        else
          velocity = 15
        end
        args_h = resolve_synth_opts_hash_or_array(args)
        if n && ((n != "_") && n != :_)
          #dshader :decay, :iSharp, (note(n)/69.0)
          puts "%s%s" %[SonicPi::Note.new(n).midi_string.ljust(9, " "), "[Exception!]"]  unless note(n) < MODE_NOTE
          midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 8})
          @ripple = @ripple == 1.0 ? 0.0 : 1.0
          at{
            sleep 0.5
            viz :alive, deformrate: 0.05
            #unity "/ripple/on",1.0
            #unity "/alive/bloat", 800.0
            viz :alive, deform: 6.0
            viz :alive, rotate: 20.0
            unity "/alive/light", 1.2
            #viz :alive, deform: 0.0-rand
            sleep 0.25
            viz :alive, deformrate: 0.0
            viz :alive, rotate: 0.0
            unity "/alive/light", 0.6
        }

        end
        exception_cc(args_h)
      end
    end

    def exception_cc(cc)
      cc.keys.each do |k|
        n = case k
            when :atk; 100
            when :more; 101
            when :shape; 102
            when :wet; 103
            when :hi; 104
            when :mi; 105
            when :lo; 106
            else
              nil
            end
        if n
          midi_cc n, (cc[k] * 127.0).round, port: :iac_bus_1, channel: 8
        end
      end
    end

    def operator_mode(mode)
      operator ['C-1','Cs-1','D-1','Ds-1','E-1', 'F-1'][mode]
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
            #dshader(:decay, :iHarp, (note(n)/69.0), 0.0041) if n && note(n)
            #dshader(:iBright, velocity/127.0) if velocity
            if args_h[:thick]
              @thick=0.01
            end
            if !args_h[:off] && $mode != 4
              @rot||=0.0
              @rot += 0.001
              dunity "/alive/rotspeed", [@rot, 0.5].max
              dunity "/alive/length", rand(0.7)+velocity*0.01
              @thick ||= 0.01
              dviz :alive, thick: @thick
              @thick += 0.001
              if @thick > 0.03
                @thick = 0.01
              end
              if n == :d4 || n == :gs4
                at{
                  sleep 0.5
                  unity "/shard", velocity*0.001
                  sleep 0.125
                  unity "/shard", 0.0
                }
              end
              operator_cc(args_h)
            end

            puts "#{SonicPi::Note.new(n).midi_string.ljust(4, " ")} [Operator]" unless note(n) < MODE_NOTE
          end
        end
      rescue
        puts $!.message
        puts $!.backtrace
      end
    end

    def operator_on(n,*args)
      begin
        if n
          velocity = 30
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
            operator_cc(args_h)
            if(args_h[:mode])
              operator_mode(args_h[:mode])
            end

            midi_note_on n, velocity, *(args << {port: :iac_bus_1} << {channel: 3})
            dshader(:decay, :iHarp, (note(n)/69.0), 0.0041) if n && note(n)
            dshader(:iBright, velocity/127.0) if velocity
          end
        end
      rescue
        puts $!.backtrace
      end
    end

    def operator_cc(cc)
      cc.keys.each do |k|
        n = case k
            when :solo; 100
            else nil
            end
        if n
          if n == :at
            midi_channel_pressure cc[k]*127.0, channel: 3, port: :iac_bus_1
          else
            midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 3
          end
        end
      end
    end

    def operator_off(n)
      midi_note_off n, {port: :iac_bus_1,  channel: 3}
    end

    def whitespace(n,*args)
      begin
        if n
          velocity = 30
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
            whitespace_cc(args_h)

            midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 13})
          end
        end
      rescue
        puts $!.backtrace
      end
    end

    def whitespace_cc(cc)
      cc.keys.each do |k|
        if k == :mode
          #whitespace_mode(cc[k])
        else
          n = case k
              when :cutoff; 4
              when :gain;   5
              when :drive;  8
              when :charge; 9
              when :fx;     12
              when :sound;  42
              when :bass;   36
              when :phase;  13
              when :mod;    1
              else
                nil
              end
          if n
            midi_cc n, (cc[k] * 127.0).round, port: :iac_bus_1, channel: 3
          end
        end
      end
    end

    def harp_x
      midi_all_notes_off port: :iac_bus_1, channel: 3
    end

    def jup(*args)
      midi *(args << {port: :iac_bus_1} << {channel: 4})
    end
    def jup_x
      midi_all_notes_off port: :iac_bus_1, channel: 4
    end

    def zero_cc(*args)
      cc = if args[0].is_a?(SonicPi::Core::SPMap)
             args[0]
           else
             resolve_synth_opts_hash_or_array(args)
           end
      cc.keys.each do |k|
        n = case k
            when :port_time; 5
            #when :more; 100
            #when :filter; 101
            #when :shape; 102
              #when :spread; 103
            when :pulse; 100
            when :wet; 101
            when :more; 102
            when :noise; 103
            when :amp;104
            else
              nil
            end
        if n
          midi_cc n, cc[k]*127.0, *(args << {port: :iac_bus_1} << {channel: 9})
        end
      end
    end

    def zero(*args)
      params, opts = split_params_and_merge_opts_array(args)
      opts         = current_midi_defaults.merge(opts)
      n, vel = *params
      if n.is_a?(Array)
        params =  params  << {sus: n[1]}
        n = n[0]
      end
      midi n, vel, *(args << {port: :iac_bus_1} << {channel: 9})
      zero_cc(opts)
    end

    def zero_on(n, *args)
      if n
        if n.is_a?(Array)
          args =  args  << {sus: n[1]}
          n = n[0]
        end
        if args && args[0].is_a?(Numeric)
          velocity = args[0]
          args = args[1..-1]
        else
          velocity = 30
        end
        if n && ((n != "_") && n != :_)
          midi_note_on n, velocity, *(args << {port: :iac_bus_1} << {channel: 9})
        end
      end
    end
    def zero_off(n,*args)
      midi_note_off n, port: :iac_bus_1, channel: 9
    end
    def zero_x
      midi_all_notes_off port: :iac_bus_1, channel: 9
    end

    def callstack(n,*args)
      if $mode == 3
          at{
            sleep 0.5
            viz :alive, height: 0.036
            sleep 0.125
            viz :alive, height: 0.0
        }
      end
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
          if $mode == 3
            @sea_idx ||= line(0,31,32)+line(31,0,32)
            w = @sea_idx.tick(:sea_idx)
            at{
              sleep 0.5
              #puts  w*0.025
              viz :sea, noise: 10.0-rand*0.004
              viz :sea, height: w*0.025
              viz :sea, size: linear_map(54,69, 0.3,0.7, note(n))
            }
          end

        end
      end
    end

    def cpu2(n,*args)
      if n
        if n.is_a?(Array) && n[1].is_a?(Symbol)
          bonus = n[1]
          n = n[0]
          at {
            sleep 1/8.0
            midi bonus, 60, *(args << {port: :iac_bus_1} << {channel: 1} << {sustain: 1/4.0})
          }
        end
        if n.is_a?(Array)
          args =  args  << {sus: n[1]}
          n = n[0]
        end
        if n
          midi n, *(args << {port: :iac_bus_1} << {channel: 1})
        end
      end
    end

    def null_mode(mode)
      null ['C-1','Cs-1','D-1','B-1'][mode]
    end

    def corrupt_mode(mode)
      corrupt ['C-1','Cs-1','D-1','Ds-1','E-1', 'F-1', 'Fs-1', 'G-1', 'Gs-1', 'A-1', 'As-1', 'B-1'][mode]
    end

    def corrupt_cc(*args)
      cc = if args[0].is_a?(SonicPi::Core::SPMap)
             args[0]
           else
             resolve_synth_opts_hash_or_array(args)
           end
      cc.keys.each do |k|
        n = case k
            when :at; :at
            when :motion; 1
            when :formant; 100
            when :octave; 101
            when :flatpitch; 102
            else nil
            end
        if n
          if n == :at
            midi_channel_pressure cc[k]*127.0, channel: 7, port: :iac_bus_1
          else
            midi_cc n, cc[k]*127.0, *(args << {port: :iac_bus_1} << {channel: 7})
          end
        end
      end
    end

    def corrupt(*args)
      params, opts = split_params_and_merge_opts_array(args)
      opts         = current_midi_defaults.merge(opts)
      n, vel = *params
      if n.is_a?(Array)
        args =  args  << {sus: n[1]}
        n = n[0]
      end
      if(opts[:mode])
        corrupt_mode(opts[:mode])
      end
      if n
        midi n, vel, *(args << {port: :iac_bus_1} << {channel: 7})
        @popsize = ((line 0.3,1.1,8)+(line 1.1,0.3,8)).look
        @spacex = (line 0.1,0.5,8).look
        @noisex = (line 20.0,0.1,8).look
        if $mode == 3
          @light ||= 0.7
          @light += 0.03
        elsif note(n) > MODE_NOTE
          @light = 0.7
        end
        at{
          sleep 0.5
          if $mode == 3
            viz :alive, thick: 0.15
            viz :alive, length: 0.5
            viz :alive, reset: 1.0
            viz :alive, gravity: 0, amp: 0, freq: 0, speed: 0
            viz breath: 1.0
          end
          viz :sea, size: @popsize*1.01
          viz :sea, spacex: @spacex
          viz :sea, noise: @noisex
          if $mode == 3
            viz :alive, light: [@light,1.5].min
            sleep 0.25
            viz :alive, light: [@light-0.05,1.5-0.05].min
          end
        }
        puts "#{SonicPi::Note.new(n).midi_string.ljust(8, " ")}[Corrupt]" unless note(n) < MODE_NOTE
      end
      corrupt_cc(opts)
    end

    def corrupt_on(*args)
      params, opts = split_params_and_merge_opts_array(args)
      opts         = current_midi_defaults.merge(opts)
      n, vel = *params
      if n.is_a?(Array)
        args =  args  << {sus: n[1]}
        n = n[0]
      end
      if(opts[:mode])
        corrupt_mode(opts[:mode])
      end
      if n
        midi_note_on n, vel, *(args << {port: :iac_bus_1} << {channel: 7})
        puts "#{SonicPi::Note.new(n).midi_string.ljust(8, " ")}[Corrupt]" unless note(n) < MODE_NOTE
      end
      corrupt_cc(opts)
    end

    def corrupt_x(*args)
      midi_all_notes_off port: :iac_bus_1, channel: 7
    end

    def null(*args)
      params, opts = split_params_and_merge_opts_array(args)
      opts         = current_midi_defaults.merge(opts)
      n, vel = *params
      if n.is_a?(Array)
        args =  args  << {sus: n[1]}
        n = n[0]
      end
      if(opts[:mode])
        null_mode(opts[:mode])
      end
      if n
        midi n, vel, *(args << {port: :iac_bus_1} << {channel: 15})
        puts "#{SonicPi::Note.new(n).midi_string.ljust(7, " ")}[Null]" unless note(n) < MODE_NOTE
      end
      null_cc(opts)
    end

    def null_on(*args)
      params, opts = split_params_and_merge_opts_array(args)
      opts         = current_midi_defaults.merge(opts)
      n, vel = *params
      if n.is_a?(Array)
        args =  args  << {sus: n[1]}
        n = n[0]
      end
      if(opts[:mode])
        null_mode(opts[:mode])
      end
      if n
        midi_note_on n, vel, *(args << {port: :iac_bus_1} << {channel: 15})
        puts "#{SonicPi::Note.new(n).midi_string.ljust(6, " ")} [Null]" unless note(n) < MODE_NOTE
      end
      null_cc(opts)
    end
    def null_off(n,*args)
      midi_note_off n, *(args << {port: :iac_bus_1} << {channel: 15})
    end
    def null_x
      midi_all_notes_off port: :iac_bus_1, channel: 15
    end

    def null_cc(*args)
      cc = if args[0].is_a?(SonicPi::Core::SPMap)
             args[0]
           else
             resolve_synth_opts_hash_or_array(args)
           end
      cc.keys.each do |k|
        n = case k
            when :deform; 10
            when :defon; 13
            when :mul; 12
            when :shape; 11
            when :at; :at
            when :hi; 104
            when :mi; 105
            when :lo; 106
            else nil
            end
        if n
          if n == :at
            midi_channel_pressure cc[k]*127.0, channel: 15, port: :iac_bus_1
          else
            midi_cc n, cc[k]*127.0, *(args << {port: :iac_bus_1} << {channel: 15})
          end
        end
      end
    end

    def eek_mode(mode)
      eek ['C-1','Cs-1','D-1'][mode]
    end

    def eek_cc(*args)
      cc = if args[0].is_a?(SonicPi::Core::SPMap)
             args[0]
           else
             resolve_synth_opts_hash_or_array(args)
           end
      cc.keys.each do |k|
        if k == :mode
          eek_mode(cc[k])
        else
        n = case k
            when :mod; 1
            when :at; :at
            else nil
            end
        if n
          if n == :at
            midi_channel_pressure cc[k]*127.0, channel: 16, port: :iac_bus_1
          else
            midi_cc n, cc[k]*127.0, *(args << {port: :iac_bus_1} << {channel: 16})
          end
        end
        end
      end
    end

    def eek(*args)
      params, opts = split_params_and_merge_opts_array(args)
      opts         = current_midi_defaults.merge(opts)
      n, vel = *params
      if n.is_a?(Array)
        if !n[1].is_a?(Symbol)
          args =  args  << {sus: n[1]}
          n = n[0]
        end
      end
      if n
        if n.is_a?(Array)
          n.each{|n_note| midi n_note, vel, *(args << {port: :iac_bus_1} << {channel: 16})}
        else
          midi n, vel, *(args << {port: :iac_bus_1} << {channel: 16})
        end
      end
      eek_cc(opts)
    end

    def strings(*args)
      params, opts = split_params_and_merge_opts_array(args)
      opts         = current_midi_defaults.merge(opts)
      n, vel = *params
      if !vel
        vel = 35
      end
      midi n, vel, *(args << {port: :iac_bus_1, channel: 11})
    end
    def strings_cc(*args)
      midi_cc *args << {port: :iac_bus_1, channel: 11}
    end
    def strings_on(*args)
      midi_note_on *(args << {port: :iac_bus_1, channel: 11})
    end
    def strings_off(*args)
      midi_note_off *(args << {port: :iac_bus_1, channel: 11})
    end
    def strings_x(*args)
      midi_all_notes_off port: :iac_bus_1, channel: 11
    end

    def cpu3(*args)
      params, opts = split_params_and_merge_opts_array(args)
      opts         = current_midi_defaults.merge(opts)
      n, vel = *params
      if n.is_a?(Array)
        args =  args  << {sus: n[1]}
        n = n[0]
      end
      if n
        midi n, vel, *(args << {port: :iac_bus_1} << {channel: 5})
      end
    end

    def root(note_seq)
      note_seq.map{|n|
        if n
          note(n)
        else
          nil
        end
      }.compact.sort{|n1,n2| n1 <=> n2 }[0]
    end

    def rootl(note_seq)
      note_seq.map{|n|
        if n && n[0]
          [note(n[0]), n[-1]]
        else
          nil
        end
      }.compact.sort{|n1,n2| n1[0] <=> n2[0] }[0]
    end

    def sidechain
      midi :A2, port: :iac_bus_1, channel: 12
    end

    def rev(*args)
      params, opts = split_params_and_merge_opts_array(args)
      opts         = current_midi_defaults.merge(opts)
      n, vel = *params
      if n.is_a?(Array)
        args =  args  << {sus: n[1]}
        n = n[0]
      end
      if n
        midi n, vel, *(args << {port: :iac_bus_1} << {channel: 6})
      end
    end

    def dripkit(n,v,*args)
      n = (n%(1*12))+(12*4)
      midi n,v,*(args << {port: :iac_bus_1, channel: 2})
    end

    def mt(n, vel, vel2)
      if n
        if n.is_a?(Array)
          n = n[0]
          vel=vel2+rand_i(5)
        end
        note = [
          :C2, :cs2, :d2, :ds2, :e2, :f2, :fs2, :g2, :gs2, :a2, :as2, :b2,
          :C6, :cs6, :d6, :ds6, :e6, :f6, :fs6, :g6, :gs6, :a6][n]

        # note = [
        #   :C2, :cs2, :d2, :ds2, :e2, :f2, :fs2, :g2,
        #   :C6, :cs6, :d6, :ds6, :e6, :f6, :fs6, :g6][n]

        midi note, vel, channel: 2, port: :iac_bus_1
        if note
#          at{
#            sleep 0.5
#            if $mode == 0
              #viz :alive, light: 0.1+rand*(vel*0.001)
#            end
#          }
        end
      end
    end
    def mt_cc(cc)
      cc.keys.each do |k|
        n = case k
            when :morph; 20
            else
              nil
            end
        if n
          midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 2
        end
      end
    end

    def vioshot_x()
      strings_x
      null_x
    end
    def vioshot(n,fn)
      method("strings_#{fn.to_s}").call("#{n.to_s}", 4)
      with_transpose 12{
        method("null_#{fn.to_s}").call("#{n.to_s}", 4)
      }
    end

    def ct(t)
      am={ :gs=>:minor,:cs=>:minor,:a=>:major,:b=>:minor,:e=>:major,:fs=>:minor,:d=>:major,:ds=>:minor, :as=>:major}
      am[(t[0..-2].downcase.to_sym)] if t
    end

    def kick_machine(k, *args)
      #TODO: Pushing midi notes back into `k` pattern
      _=nil
      k1,k4,k3,k5 = Frag[/kick/,9], Mountain[/subkick/,0], Mountain[/kick/,4], Lo[/kick/,15]
      kt = Lo[/kick/,/thin/]
      f1 = "/Users/josephwilk/Workspace/music/samples/Tuned/Drip_effects/E01.wav"
      condi = 1
      r=1
      fx=:none
      fin = 1.0
      accent=1
      if k.is_a?(Array) && k.count == 1
        accent = 1.1
        k=k[0]
      end
      if k && k.is_a?(Hash)
        if k.values[0].is_a?(Hash)
          fin = k.values[0][:fin]
          k=k.keys[0]
        else
          fx=k.values[0]
          k=k.keys[0]
        end
      end
      if k.is_a?(Array)
        condi = k[1]
        k = k[0]
        r= [1.0].choose
      end

      v = 90
      n = _
      if k == k1
        n = :d5
        v = 68
        k=_
      elsif k == k3
        n= :a4
        v = 55
        k=_
      elsif k == kt[1]
        n=:as4
        v=95
        k=_
      elsif k == k5
        n=:c4
        v=90
        k=_
      elsif k == k5
        n=:cs4,
        v=90
        k=_
      end
      args_h = resolve_synth_opts_hash_or_array([*args])
      v= v * (args_h[:accent] || 1)
      if n
        midi n, v - (rand_i(4)), channel: 2
        at{
          sleep 0.5
          if n==:as4 || $mode == 4
            viz :alive, height: $height+(v*0.0025)
          else
            viz :alive, height: $height-(v*0.002)
          end

          viz :alive, z: $z+(v*0.02)

          viz :alive, deformrate: 0.1
          if args_h[:def]
            viz :alive, deform: args_h[:def]
          else
            viz :alive, deform: (rand 0.2)+0.01
          end
          dviz :alive, deform: 0.9
          if n==:as4
            unity "/alive/spike", 1.0
          end
          unity "/shard", v*0.001
          sleep 0.125
          viz :alive, height: $height

          viz :alive, deformrate: 0.0
          #if n==:d5
          #  unity "/breath", 0.0
          #end
          unity "/shard", 0.0
        }
      else
        if rand(1.0) <= condi
          with_fx :krush, mix: dice(6) > 5 ? 0.1 : 0.0 do
            if k == f1
              r = 1.0
            end
            with_fx fx, phase: 4/8.0 do
              if k
              at{sleep 0.5
                unity "/breath", 0.1
                sleep 0.125
                unity "/breath", 0
                }
              end

              smp k, *(args << {finish: fin} << {rate: r})
            end
          end
        end
      end
    end

    def eq(cc)
      cc.keys.each do |k|
        n = case k
            when :lo; 7
            when :hi; 9
            when :mi; 8
            else
              nil
            end
        if n
          midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 1
          if n == 7
            midi_cc 7, 0.0*127,  port: :midi_fighter_twister, channel: 0
          end
          if n == 8
            midi_cc 8, 0.0*127,  port: :midi_fighter_twister, channel: 0
          end
          if n == 9
            midi_cc 9, 0.0*127,  port: :midi_fighter_twister, channel: 0
          end
        end
      end
    end

    def smp_dust(pp,*args)
        if pp
          fx = :none
          cutoff_bump=(pp.is_a?(Array) ? 15 : rand_i(10))
          accent = (pp.is_a?(Array) ? 0.7 : 0.4)*1
          if pp && pp.is_a?(Hash)
            fx = pp.values[0]
            pp = pp.keys[0]
          end
          opts = resolve_synth_opts_hash_or_array(args)
          fuzz = if opts[:rate]
                   opts[:rate]
                 else
                   rand(0.05)
                 end
          fxs=if opts[:fxs]
                opts[:fxs]
              else
                [:slicer,:krush,:bitcrusher,:echo]
              end
          amps = if opts[:amp]
                   opts[:amp] * (accent+10.6)
                 else
                   (accent+10.6)
                 end
          with_fx ring(*fxs).tick(:fx), mix: 0.5, phase: 1/4.0, decay: 2 {
            dterrain 0.1
            smp pp, amp: amps, attack: 0.0, start: 0.1-fuzz, rate: knit(-0.25,32,-0.25,32,
                                                                                   -0.5-fuzz, 1,-0.5,31,
                                                                                   -0.25-fuzz,1,-0.25,31).look
          }
        end
      pp
    end

    #Depreciate
    def dust_pat(pp,&block)
      if pp
        fx = :none
        cutoff_bump=(pp.is_a?(Array) ? 15 : rand_i(10))
        accent = (pp.is_a?(Array) ? 0.7 : 0.4)*1
        if pp && pp.is_a?(Hash)
          fx = pp.values[0]
          pp = pp.keys[0]
        end
        with_fx(fx, phase: 1/3.0, decay: 1.5, room: 250, spread: 0.8, damp: 0.5,pre_damp:0.5,release:6) do
          block.(accent)
        end
        pp
      end
    end

    def verb_slice(s,*args)
      args_h = resolve_synth_opts_hash_or_array(args)
      with_fx :gverb, room: 200.0, mix: 0.8, release: 8, spread: 0.9 do
        with_fx :slicer, phase: (args_h[:phase]||1/8.0) do
          smp s,
          amp: (args_h[:amp] || 0.4),
          cutoff: (args_h[:cutoff] || 100), rate: -0.125,
          attack: (args_h[:atk] || 0.5)
        end
      end
    end

    def drum_machine(zzk)
      if zzk && zzk.is_a?(String)
        accent = zzk.is_a?(Array) ? 0.7 : 0.3
        smp zzk, amp: accent
      elsif zzk
        #midi (knit 'c-1',32,'cs-1',32,'d-1',32,'e-1',32).tick(:in), channel: 2
        accent = zzk.is_a?(Array) ? 120 : 55
        n = zzk.is_a?(Array) ? zzk[0] : zzk
        if n.is_a?(String)
          accent = accent/120
          smp zzk, amp: accent
        else
          n = ring(:C3, :Cs3, :D3, :Ds3, :E3, :F3,  :Fs3,  :G3,  :Gs3,  :A3,  :as3,  :B3,
            :C4,  :Cs4,  :D4,  :Ds4,  :E4,  :F4,  :Fs4,  :G4,  :Gs4,  :A4,  :as4,  :B4,
            :C5,  :Cs5,  :D5,  :Ds5,  :E5,  :F5,  :Fs5,  :G5,  :Gs5, :A5,  :as5, :B5
            )[n]
          #Designed#4 Cube
          midi n,accent*1.0, channel: 2, sus: 4 # (line 50, 120,32).look,
        end
      end
    end
  end
end
