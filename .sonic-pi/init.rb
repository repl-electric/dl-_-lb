load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/shaderview.rb"
load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/samples.rb"
load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/dsp.rb"
load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/monkey.rb"
load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/log.rb"
_=nil
set_volume! 1.0
def note_slices(n, m)
  NoteSlices.find(note: n, max: m, pat: "sop|alto|bass").select{|s| s[:path] =~ /sop|alto/}.take(64)
end
uncomment do
@slices ||= {"Gs2/4" => note_slices("Gs2",1/4.0),"D2/4" => note_slices("D2",1/4.0), "E2/4" => note_slices("E2",1/4.0), "A2/4" => note_slices("A2",1/4.0), "Fs2/4" => note_slices("F#2",1/4.0),"Fs2/8" => note_slices("F#2",1/8.0), "E3/4" => note_slices("E3",1/4.0), "D3/4" => note_slices("D3",1/4.0),"D3/8" => note_slices("D3",1/8.0),"Cs3/4" => note_slices("C#3",1/4.0), "Fs3/8" => note_slices("F#3",1/8.0),"Fs3/4" => note_slices("F#3",1/4.0), "Gs3/4" => note_slices("G#3",1/4.0), "A3/8" => note_slices("A3",1/8.0),"A3/4" => note_slices("A3",1/4.0), "B3/4" => note_slices("B3",1/4.0), "Cs4/4" => note_slices("C#4",1/4.0), "Cs4/8" => note_slices("C#4",1/8.0), "D4/4" => note_slices("D4",1/4.0),"D4/8" => note_slices("D4",1/8.0), "E4/4" => note_slices("E4",1/4.0),"E4/8" => note_slices("E4",1/8.0), "Fs4/4" => note_slices("F#4",1/4.0),"Fs4/8" => note_slices("F#4",1/8.0), "FS4/8" => note_slices("F#4",1/8.0), "Gs4/4" => note_slices("G#4",1/4.0), "B4/4" => note_slices("B4",1/4.0),"Fs5/4" => note_slices("F#5",1/4.0), "Fs6/4" => note_slices("F#6",1/4.0),"A4/4" => note_slices("A4",1/4.0),"E5/4" => note_slices("E5",1/4.0)}
@slices.values.flatten.each{|f| load_sample f[:path]}
puts @slices.values.flatten.count
#smp Harp.slice(:Fs3).look, amp: 2, cutoff:  ramp(10, 130, 128).tick(:ram)
module Straw
  def self.slice(n, size: 1/4.0)
    @straw_cache ||= {}
    n = n.to_s.downcase.gsub(/s/,"#")
    if !@straw_cache.has_key?(n)
      @straw_cache[n] = NoteSlices.find(note: n, max: size, pat: "Straw").take(64)
    end
    @straw_cache[n]
  end
end
module Berry
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/strawberry/Samples/**/*.wav"]
    Sample.matches(samples, a)
  end
end
module Harp
  def self.slice(n, size: 1/4.0)
    @harp_cache ||= {}
    n = n.to_s.gsub(/s/,"#")
    if !@harp_cache.has_key?(n)
      @harp_cache[n] = NoteSlices.find(note: n, max: size, pat: "Harp").take(64)
    end
    @harp_cache[n]
  end
end

☠ =Straw
❄️ =Straw
☃️=Straw
🐿️=Straw
♥️ =Straw
🌶️ =Straw
⚡︎ =Straw
〄=Straw
㉿=Straw

MODE_NOTE = note('Cs0')
use_midi_defaults port: :iac_bus_1
D4=:d4;E4=:e4;FS4=:Fs4;GS4=:Gs4;Cs4=:Cs4;A4=:A4;B4=:B4;
D3=:d3;E3=:e3;FS3=:Fs3;GS3=:Gs3;Cs3=:Cs3;A3=:A3;B3=:B3;
D2=:d2;E2=:e2;FS2=:Fs2;GS2=:Gs2;Cs2=:Cs2;A2=:A2;B2=:B2;

def live(name, *args, &block)
  fx = resolve_synth_opts_hash_or_array(args)
  x = lambda{||
    with_fx((fx[:fx] || :none), mix: (fx[:mix] || 0)) do
      block.()
    end}
  live_loop(name, *args, &x)
end
def play_midi(*args)
  notes = args.first
  if notes.is_a?(SonicPi::Core::RingVector)||notes.is_a?(Array)
    notes.map{|n|
      midi *([n]+args[1..-1])
    }
  else
    midi *args
  end
end
def form(*args)play_midi *(args << {port: :reaktor_6_virtual_input});end
def mass(*args)play_midi *(args << {port: :massive_virtual_input});end
def blof(*args)play_midi *(args << {port: :blofeld});end
def stop_midi() midi('C-2', channel: 16);end

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
        puts "#{n} <- [Harp]" unless note(n) < MODE_NOTE
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

def zero(n,*args)
  if n.is_a?(Array)
    args =  args  << {sustain: n[1]}
    n = n[0]
  end
  midi n, *(args << {port: :iac_bus_1} << {channel: 9})
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
      midi_note_on n, velocity, *(args << {port: :iac_bus_1} << {channel: 10})
    end
  end
end
def zero_cc(*args)
  cc = resolve_synth_opts_hash_or_array(args)
  cc.keys.each do |k|
    n = case k
        when :port; 65
        when :port_time; 5
        else
          nil
        end
    if n
      midi_cc n, cc[k], *(args << {port: :iac_bus_1} << {channel: 9})
    end
  end
end
def zero_x
  midi_all_notes_off port: :iac_bus_1, channel: 7
end
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

def violin_mode(mode)
  violin ['C-1','Cs-1','B-1'][mode]
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
    puts "#{Note.new(n).midi_string} <- [Violin]" unless note(n) < MODE_NOTE
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
    puts "#{Note.new(n).midi_string} <- [Violin]" unless note(n) < MODE_NOTE
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

def eek_cc(*args)
  cc = if args[0].is_a?(SonicPi::Core::SPMap)
         args[0]
       else
         resolve_synth_opts_hash_or_array(args)
       end
  cc.keys.each do |k|
    n = case k
        when :mod; 1
          when :at; :at
        else nil
        end
    if n
      if n == :at
        midi_channel_pressure cc[k]*127.0, channel: 16, port: :iac_bus_1
      else
        midi_cc n, cc[k]*127.0, *(args << {port: :iac_bus_1} <<
          {channel: 16})
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
def strings_on(*args)
  midi_note_on *(args << {port: :iac_bus_1, channel: 11})
end
def strings_off(*args)
  midi_note_off *(args << {port: :iac_bus_1, channel: 11})
end
def strings_x(*args)
  midi_all_notes_off port: :iac_bus_1, channel: 11
end

def root(note_seq)
  note_seq.map{|n| note(n[0])}.compact.sort[0]
end

def sidechain
  midi :A2, port: :iac_bus_1, channel: 12
end

puts "Init Complete"
