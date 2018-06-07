Zz = [nil]
S = 18
T = 21
$pmode=0
def start
  looper_cc motion: 0.6, drive: 0.20, fm: 0.00, mode: 0
  mbox2_cc motion: 0.5, sat: 0.00, drive: 0.00
  mbox_cc  motion: 0.6
  pads_cc amp: 0.85
  looper_cc amp: 0.85
end
def deepbase_init
  looper_cc motion: 1.00, drive: 0.30, fm: 0.00, mode: 0
end
def kickviz
  at{
    sleep 0.5
    unity "/star", -0.1
    light size: 0.04

    star throttle: 0.1
    star life: 2.0
    sleep 0.25
    star throttle: 0.02
    sleep 0.25
    light size: 0.0
  }
end
def star(*args)
  opts = resolve_synth_opts_hash_or_array(args)
  if (o=opts[:throttle])
    unity "/star/throttle",o
  end
  if (o=opts[:life])
    unity "/star/life",o
  end
  if (o = opts[:size])
    unity "/cubeinside", o
  end
end
def scene(n)
  unity "/scene/#{n}"
end
def burst(n=0.0)
  unity "/burst", n
end
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
  slice_cube y: 10, z: 10.0, cubes: 10.0
  slice_cube y: 0.0, z: 0.0, cubes: 0.0
end
def explode_cube()
  unity "/cube/explode"
  world time: 0.002
end
def explode_world()
  world time: 0.1
  unity "/explode2"
end
def explode_aura()
  world time: 0.1
  unity "/explode3"
end
def slice_cube(*args)
  opts = resolve_synth_opts_hash_or_array(args)
  if v=opts[:x]
    unity "/cube/split/x", v
  end
  if v=opts[:y]
    unity "/cube/split/y", v
  end
  if v=opts[:z]
    unity "/cube/split/z", v
  end
  if v=opts[:cubes]
    unity "/cube/split/cubes", v
  end
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
    puts o
  end
  }
end
def roots(*args)
  opts = resolve_synth_opts_hash_or_array(args)
  at{
  if opts[:delay] == true
    sleep 0.5
  end
  if opts[:throttle]
    unity "/roots", opts[:throttle]
  end
  if o=opts[:drag]
    unity "/roots/drag", o
  end
  if o=opts[:freq]
    unity "/roots/freq", o
  end
  if o=opts[:target]
    if o == :bird
      unity "/roots/target/bird", 1.0
    end
    if o == :cube
      unity "/roots/target/cube", 1.0
    end
    if o == :frag
      unity "/roots/target/frag", 1.0
    end
  end
  }
end
def tree(*args)
  opts = resolve_synth_opts_hash_or_array(args)
  if o=opts[:height]
    unity "/tree/height",o
  end
  if o=opts[:grow]
    unity "/tree/grow",o
  end
end
def rocksinit()
  world time: 1.0
  unity "/rocks/vortex", 1.0
  unity "/rocks/vortex/force",-1000.0
  unity "/rocks/turb",0.0
  unity "/rocks/vortex/radius",100.0
  unity "/rocks/pos",6.0
  rocks throttle: 1.0
  rocks throttle: 1.0, orbit: -40.0, rot: -100, noise: 10.8
end
def rocks(*args)
  opts = resolve_synth_opts_hash_or_array(args)
  if o=opts[:throttle]
    unity "/rockcircle/throttle",o
  end
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
def vortex(*args)
  opts = resolve_synth_opts_hash_or_array(args)
  if o=opts[:throttle]
    unity "/rocks/throttle", o
  end
  if opts[:turb]
    unity "/rocks/turb", opts[:turbulence]
  end
  if o=opts[:force]
    if o == 0.0
      unity "/rocks/vortex",0.0
      unity "/rocks/vortex/force",0.0
    else
      unity "/rocks/vortex",1.0
      unity "/rocks/vortex/force",o
      unity "/rocks/vortex/radius",5.0
    end
  end
  if opts[:y]
    unity "/rocks/pos", opts[:y]
  end
  if opts[:radius]
    unity "/rocks/vortex/radius", opts[:radius]
  end
end
#def light(*args)
#end

def cam(type=:main)
  if type == :exit
    $pmode=1
    unity "/cubeinside", 0.25*3
    unity "/sea/waveheight", 0.0
    unity "/star/life", 2.0
    unity "/cubecam/zoomout", 1.0
  elsif type == :main
    $pmode=1
    unity "/cam0"
    unity "/cubeinside", 0.25*3
    unity "/sea/waveheight", 0.0
    unity "/star/life", 2.0
    unity "/cubecam/zoomout", 1.0
  elsif type == :top
    $pmode=2
    unity "/cam1"
  elsif type == :bird
    $pmode=3
    rocks orbit: 20.0
    world time: 0.1
    unity "/cam2"
  elsif type == :cube
    $pmode=0
    unity "/cubeinside", 0.0
    unity "/cam4"
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
def cube_linecolor(s,b,h)
  at{
    sleep 0.5
    unity "/linecolor/cube/s",s
    unity "/linecolor/cube/b",b
    unity "/linecolor/cube/h",h
  }
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
  scene 1
  $zslices=0.0
  defaultcolor
  world :time, 1.0
  create_tree -1
  create_sea -1
  create_island -1
  create_light 1
  create_light 0
  create_bird -1
  create_cube -2
  create_aura -5
  unity "/cubeinside", -0.25
  roots throttle: 0.0
end
