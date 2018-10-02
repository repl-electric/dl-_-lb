def scene(n)
  unity "/scene/#{n}"
end
def world(*args)
  opts = resolve_synth_opts_hash_or_array(args)
  if opts[:lightning]
    at{
      sleep 0.5
      unity "/world/lightning",1.0
    }
  end
  if opts[:time]
    unity "/world/time",opts[:time]
  end
end
def init!
  fx wash: 0
  glitch_cc kick: false
  vox_cc detune: 0.5, semitone: 5
  vox_cc sync: 0, wet: 1.0, spray: 1.0
  voxe_cc semitone: 8
  bass_cc wet: 1, shape: 0, more: 0
  glitch_cc mode: 2
  #glitch_cc rdelay: 8, ldelay: 6, cdelay: 2
  sop_cc mode: 0
end
