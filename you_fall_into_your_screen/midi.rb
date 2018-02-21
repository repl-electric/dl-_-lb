module ReplElectric
  module Midi
    include SonicPi::Lang::Support::DocSystem
    include SonicPi::Util
    MODE_NOTE = 13

    def bass(n, *args)
      begin
        if n
          if n.is_a?(Array)
            args = args << {sustain: n[1]}
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
            args = args << {sustain: n[1]}
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

    def sop(n,*args)
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
          sop_mode(args_h[:mode])
        end
        if n && ((n != "_") && n != :_)
          midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 10})
        end
        sop_cc args_h
      end
    end
    def sop_on(n, *args)
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
          sop_mode(args_h[:mode])
        end
        if n && ((n != "_") && n != :_)
          midi_note_on n, velocity, *(args << {port: :iac_bus_1} << {channel: 10})
        end
      end
    end

    def sop_off(n, *args)
      midi_note_off n, *(args << {port: :iac_bus_1} << {channel: 10})
    end

    def sop_cc(cc)
      cc.keys.each do |k|
        n = case k
            when :motion; 1
            when :formant; 98
            when :form_amp; 99
            when :cutoff; 97
            when :phase; 102
            when :comp; 101
            else
              nil
            end
        if n
          midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 10
        end
      end
    end
    def sop_mode(mode)
      sop ['C-1','Cs-1','D-1','Ds-1','E-1', 'F-1', 'Fs-1', 'G-1', 'Gs-1', 'A-1', 'As-1', 'B-1'][mode]
    end

    #DUP which is not sidechained against piano
    def sop2_mode(mode)
      sop ['C-1','Cs-1','D-1','Ds-1','E-1', 'F-1', 'Fs-1', 'G-1', 'Gs-1', 'A-1', 'As-1', 'B-1'][mode]
    end

    def sop2_cc(cc)
      cc.keys.each do |k|
        n = case k
            when :motion; 1
            when :formant; 98
            when :form_amp; 99
            when :cutoff; 97
            else
              nil
            end
        if n
          midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: 4
        end
      end
    end

    def sop2_on(n, *args)
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
          sop2_mode(args_h[:mode])
        end
        if n && ((n != "_") && n != :_)
          midi_note_on n, velocity, *(args << {port: :iac_bus_1} << {channel: 4})
        end
      end
    end
    def sop2_off(n, *args)
      midi_note_off n, *(args << {port: :iac_bus_1} << {channel: 4})
    end

    def sop2(n,*args)
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
          sop2_mode(args_h[:mode])
        end
        if n && ((n != "_") && n != :_)
          midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 4})
        end
        sop2_cc args_h
      end
    end

    def sharp(n,*args)
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
        if n && ((n != "_") && n != :_)
          dshader :decay, :iSharp, (note(n)/69.0)
          midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 8})
        end
      end
    end

    def harp_mode(mode)
      harp ['C-1','Cs-1','D-1','Ds-1','E-1', 'F-1'][mode]
    end

    def harp(n,*args)
      begin
        if n
          velocity = 30
          if n.is_a?(Array)
            args =  args  << {sustain: n[1]}
            n = n[0]
          end
          if args && args[0].is_a?(Numeric)
            velocity = args[0]
            args = args[1..-1]
          end
          if n && ((n != "_") && n != :_)
            args_h = resolve_synth_opts_hash_or_array(args)
            harp_cc(args_h)
            if(args_h[:mode])
              harp_mode(args_h[:mode])
            end

            midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 3})
            dshader(:decay, :iHarp, (note(n)/69.0), 0.0041) if n && note(n)
            dshader(:iBright, velocity/127.0) if velocity
            puts "#{SonicPi::Note.new(n).midi_string} <- [Harp]" unless note(n) < MODE_NOTE
          end
        end
      rescue
        puts $!.backtrace
      end
    end

    def harp_on(n,*args)
      begin
        if n
          velocity = 30
          if n.is_a?(Array)
            args =  args  << {sustain: n[1]}
            n = n[0]
          end
          if args && args[0].is_a?(Numeric)
            velocity = args[0]
            args = args[1..-1]
          end
          if n && ((n != "_") && n != :_)
            args_h = resolve_synth_opts_hash_or_array(args)
            harp_cc(args_h)
            if(args_h[:mode])
              harp_mode(args_h[:mode])
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

    def harp_off(n)
      midi_note_off n, {port: :iac_bus_1,  channel: 3}
    end

    def musicbox(n,*args)
      begin
        if n
          velocity = 30
          if n.is_a?(Array)
            args =  args  << {sustain: n[1]}
            n = n[0]
          end
          if args && args[0].is_a?(Numeric)
            velocity = args[0]
            args = args[1..-1]
          end
          if n && ((n != "_") && n != :_)
            args_h = resolve_synth_opts_hash_or_array(args)
            harp_cc(args_h)

            midi n, velocity, *(args << {port: :iac_bus_1} << {channel: 13})
          end
        end
      rescue
        puts $!.backtrace
      end
    end
    def magicbox(n,*args)
      musicbox(n,*args)
    end

    def harp_cc(cc)
      cc.keys.each do |k|
        if k == :mode
          harp_mode(cc[k])
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
        params =  params  << {sustain: n[1]}
        n = n[0]
      end
      midi n, vel, *(args << {port: :iac_bus_1} << {channel: 9})
      zero_cc(opts)
    end

    def zero_on(n, *args)
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
        if n && ((n != "_") && n != :_)
          midi_note_on n, velocity, *(args << {port: :iac_bus_1} << {channel: 9})
        end
      end
    end
    def zero_x
      midi_all_notes_off port: :iac_bus_1, channel: 9
    end

    def piano(n,*args)
      if n
        if n.is_a?(Array) && n[1].is_a?(Symbol)
          bonus = n[1]
          n = n[0]
          at {
            sleep 1/8.0
            midi bonus, 60, *(args << {port: :iac_bus_1} << {channel: 14} << {sustain: 1/4.0})
          }
        end
        if n.is_a?(Array)
          args =  args  << {sustain: n[1]}
          n = n[0]
        end
        if n
          midi n, *(args << {port: :iac_bus_1} << {channel: 14})
        end
      end
    end

    def piano2(n,*args)
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
          args =  args  << {sustain: n[1]}
          n = n[0]
        end
        if n
          midi n, *(args << {port: :iac_bus_1} << {channel: 1})
        end
      end
    end

    def violin_mode(mode)
      violin ['C-1','Cs-1','B-1'][mode]
    end

    def broken_mode(mode)
      broken ['C-1','Cs-1','D-1','Ds-1','E-1', 'F-1', 'Fs-1', 'G-1', 'Gs-1', 'A-1', 'As-1', 'B-1'][mode]
    end


    def broken_cc(*args)
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
            when :motion; 1
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

    def broken(*args)
      params, opts = split_params_and_merge_opts_array(args)
      opts         = current_midi_defaults.merge(opts)
      n, vel = *params
      if n.is_a?(Array)
        args =  args  << {sustain: n[1]}
        n = n[0]
      end
      if(opts[:mode])
        broken_mode(opts[:mode])
      end
      if n
        midi n, vel, *(args << {port: :iac_bus_1} << {channel: 7})
        puts "#{SonicPi::Note.new(n).midi_string} <- [Broken]" unless note(n) < MODE_NOTE
      end
      broken_cc(opts)
    end

    def violin(*args)
      params, opts = split_params_and_merge_opts_array(args)
      opts         = current_midi_defaults.merge(opts)
      n, vel = *params
      if n.is_a?(Array)
        args =  args  << {sustain: n[1]}
        n = n[0]
      end
      if(opts[:mode])
        violin_mode(opts[:mode])
      end
      if n
        midi n, vel, *(args << {port: :iac_bus_1} << {channel: 15})
        puts "#{SonicPi::Note.new(n).midi_string} <- [Violin]" unless note(n) < MODE_NOTE
      end
      violin_cc(opts)
    end

    def violin_on(*args)
      params, opts = split_params_and_merge_opts_array(args)
      opts         = current_midi_defaults.merge(opts)
      n, vel = *params
      if n.is_a?(Array)
        args =  args  << {sustain: n[1]}
        n = n[0]
      end
      if(opts[:mode])
        violin_mode(opts[:mode])
      end
      if n
        midi_note_on n, vel, *(args << {port: :iac_bus_1} << {channel: 15})
        puts "#{SonicPi::Note.new(n).midi_string} <- [Violin]" unless note(n) < MODE_NOTE
      end
      violin_cc(opts)
    end
    def violin_off(n,*args)
      midi_note_off n, *(args << {port: :iac_bus_1} << {channel: 15})
    end
    def violin_x
      midi_all_notes_off port: :iac_bus_1, channel: 15
    end

    def violin_cc(*args)
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
        args =  args  << {sustain: n[1]}
        n = n[0]
      end
      if n
        midi n, vel, *(args << {port: :iac_bus_1} << {channel: 16})
      end
      eek_cc(opts)
    end

    def strings(*args)
      midi *(args << {port: :iac_bus_1, channel: 11})
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

    def piano3(*args)
      params, opts = split_params_and_merge_opts_array(args)
      opts         = current_midi_defaults.merge(opts)
      n, vel = *params
      if n.is_a?(Array)
        args =  args  << {sustain: n[1]}
        n = n[0]
      end
      if n
        midi n, vel, *(args << {port: :iac_bus_1} << {channel: 5})
      end
    end

    def root(note_seq)
      note_seq.map{|n| note(n[0])}.compact.sort[0]
    end

    def sidechain
      midi :A2, port: :iac_bus_1, channel: 12
    end

    def rev(*args)
      params, opts = split_params_and_merge_opts_array(args)
      opts         = current_midi_defaults.merge(opts)
      n, vel = *params
      if n.is_a?(Array)
        args =  args  << {sustain: n[1]}
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
          :C2, :cs2, :d2, :ds2, :e2, :f2, :fs2, :g2,
          :C6, :cs6, :d6, :ds6, :e6, :f6, :fs6, :g6][n]
        midi note, vel, channel: 2, port: :iac_bus_1
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
      violin_x
    end
    def vioshot(n,fn)
      method("strings_#{fn.to_s}").call("#{n.to_s}", 4)
      with_transpose 12{
        method("violin_#{fn.to_s}").call("#{n.to_s}", 4)
      }
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
        end
      end
    end

    def ct(t)
      am={ :gs=>:minor,:cs=>:minor,:a=>:major,:b=>:minor,:e=>:major,:fs=>:minor,:d=>:major}
      am[(t[0..-2].downcase.to_sym)] if t
    end

    def kick_machine(k, *args)
      #TODO: Pushing midi notes back into `k` pattern
      _=nil
      k1,k3,k4,k5 = Frag[/kick/,9], Mountain[/subkick/,0], Mountain[/kick/,4], Lo[/kick/,15]
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
        n = :a4
        v = 65
        k=_
      elsif k == k4
        n= :a4
        v = 50
        k=_
      elsif k == kt[1]
        n=:as4
        v=100
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
        midi n, v - (rand_i(3)), channel: 2
      end

      if rand(1.0) <= condi
        with_fx :krush, mix: dice(6) > 5 ? 0.1 : 0.0 do
          if k == f1
            r = 1.0
          end
          with_fx fx, phase: 4/8.0 do
            smp k, *(args << {finish: fin} << {rate: r})
          end
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
          midi n,accent*1.0, channel: 2, sustain: 4 # (line 50, 120,32).look,
        end
      end
    end
  end
end
