def create_tree(n=0.0)
 unity "/tree", n
end
def create_sea(n=1.0)
 unity "/sea", n
end
def create_light(n=1.0)
 unity "/light", n
end
def create_bird(n=0.0)
  unity "/bird",n
end
def create_island(n=0.0)
  unity "/island",n
end
def create_cube(n=0.0)
  unity "/cube",n
end
def explode_cube()
  unity "/cube/explode"
end
def explode_rocks()
  unity "/explode1"
end
def create_aura(n=0.0)
  unity "/aura",n
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
def sea(*args)
  opts = resolve_synth_opts_hash_or_array(args)
  at{
    if opts[:delay]
      sleep 0.5
    end
  if o=opts[:wave]
    unity "/sea/waveheight", o
  end
  if o=opts[:ripple]
    unity "/sea/rippleheight", o
  end
  }
end
def rocks(n=0.0, *args)
  unity "/rockcircle/throttle",n
  opts = resolve_synth_opts_hash_or_array(args)
  if o=opts[:orbit]
    unity "/rockcircle/orbit",o
  end
  if o=opts[:noise]
    unity "/rockcircle/noise",o
  end
  if o=opts[:rot]
    unity "/rockcircle/rot",o
  end
  if o=opts[:freq]
    unity "/rockcircle/freq",o
  end
end
def risingrocks(*args)
  opts = resolve_synth_opts_hash_or_array(args)
  if o=opts[:on] != nil
    if o
      unity "/rocks",1.0
    else
      unity "/rocks",0.0
    end
  end
  if opts[:turbulence]
    unity "/rocks/turb", opts[:turbulence]
  end
  if o=opts[:vortex]
    if o == 0.0
      unity "/rocks/vortex",0.0
      unity "/rocks/vortex/force",0.0
    else
      unity "/rocks/vortex",1.0
      unity "/rocks/vortex/force",o
      unity "/rocks/vortex/radius",5.0
    end
  end
  if opts[:radius]
    unity "/rocks/vortex/radius", opts[:radius]
  end
end
def defaultcolor
  unity "/linecolor/h",0.0
  unity "/linecolor/s",0.0
  unity "/linecolor/b",0.0

  unity "/color2/h", (328.0 / 360)
  unity "/color1/h",0.0
  unity "/color3/h",0.0
  unity "/color2/s", 1.0
  unity "/color1/s",0.0
  unity "/color3/s",0.0
  unity "/color3/b",0.0
end
def linecolor(factor=1)
  at{
    sleep 0.5
    unity "/linecolor/s",1.0
    unity "/linecolor/b",1.0
    unity "/linecolor/h",rand*factor
  }
end
def linear_map(x0, x1, y0, y1, x)
  dydx = (y1 - y0) / (x1- x0)
  dx = (x- x0)
  (y0 + (dydx * dx))
end
def color(factor=1)
  if factor
    factor = note(factor)
    factor = linear_map(30, 60, 0.0,1.0, factor)
    at{
    sleep 0.5
    unity "/color3/b",1.0
    unity "/color2/s", 1.0
    unity "/color1/s",1.0
    unity "/color3/s",1.0
    unity "/color2/h", rand*factor
    unity "/color1/h", rand*factor
    unity "/color3/h", rand*factor
    }
  end
end
def init!
  defaultcolor
  world :time, 0.01
  create_tree -1
  create_sea -1
  create_island -1
  create_light 1
  create_light 0
  create_bird -1
  create_cube -2
  create_aura -5
end
