Zz = [nil]
S = 18
T = 21

def mbox_inits
  #mbox_cc motion: 0.30, drive: 1.00, sat: 1.00
  #mbox2_cc sat: 1.00, motion: 0.50, drive: 0.00

  #mbox_cc motion: 0.70, drive: 0.00, sat: 0.00
  #mbox2_cc sat: 1.00, motion: 0.60, drive: 0.00
  #overclock_cc motion: 0.45, drive: 0.60
end
def slow_init
  vortex throttle: 1.0, y: 1.2, force: 100
  star life: 8, size: 0.125
  roots throttle: 1.0, freq: 0.8
  rocks throttle: 1.0
  burst 1.0
end
def start_init
  if $pmode==0
    overclock_cc motion: 0.6, drive: 0.20, fm: 0.00, mode: 0
    flop_cc motion: 0.5, sat: 0.00, drive: 0.00
    flip_cc  motion: 0.6
    heat_cc amp: 0.85
    overclock_cc amp: 0.8
  end
end
def bright
  star life: 4, size: 15.0 #4
end
def end1
  create_sea -2
  create_tree -2
  create_cube 3
  sea ripple: 13.0
  burst 1.0
  linecolor factor: -10
  rocks orbit: 200.0, throttle: 1.0
  star life: 5, size: 10.0 #4
  roots throttle: 1.0, freq: 1.0, target: :bird, drag: 0.0, swirl: 1.0
  #vortex y: 7.0, force: -400, throttle: 1.0, radius: 4.9, throttle: 1.0
  cam :top
  vortex throttle: 0.0
  rocks throttle: 0.0
  burst 1.0
  unity "/endit", 0.0
  unity "/endit", 1.0
end
def end2
  star life: 5, size: 12.0 #4
  unity "/enditall",1.0
end
def deepbase_init
  overclock_cc motion: 1.00, drive: 0.30, fm: 0.00, mode: 0
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
  slice_cube y: 10.0, z: 10.0, cubes: 10.0
  slice_cube y: 0.0, z: 0.0, cubes: 0.0
  star size: 0.0, life: 2.0
end
def explode_cube()
  unity "/cube/explode"
  cube wires: 0.0
  $pmode=-1
  world time: 0.002
end
def explode_world()
  star size: 12, life: 5
  world time: 0.1
  cube wires: 0.0
  $pmode=-1
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
    end
    if o=opts[:dir]
      unity "/sea/direction", o
    end
    if o=opts[:circle]
      unity "/sea/circle", o
    end
    if o=opts[:sphere]
      unity "/sea/sphere", o
    end

  }
end
def roots_chase(*args)
  opts = resolve_synth_opts_hash_or_array(args)
  if (o=opts[:radius])
    unity "/knitroots/radius", o
  end
  if (o=opts[:amp])
    unity "/knitroots/amp", o
  end
  if (o=opts[:freq])
    unity "/knitroots/freq", o
  end


end

def roots(*args)
  opts = resolve_synth_opts_hash_or_array(args)
  at{
    if opts[:delay] == true
      sleep 0.5
    end
    if !opts[:alive] && !opts[:chase] && !opts[:swirl]
      if (o=opts[:throttle])
        unity "/roots", o
      end
      if (o=opts[:drag])
        unity "/roots/drag", o
      end
      if (o=opts[:freq])
        unity "/roots/freq", o
      end
      if (o=opts[:target])
        if o == :bird
          unity "/roots/target/bird", 1.0
        end
        if o == :cube
          unity "/roots/target/cube", 0.0
          unity "/roots/target/cube", 1.0
        end
        if o == :frag
          unity "/roots/target/frag", 1.0
        end
      end
    end
    if (o=opts[:swirl])
      unity "/roots/swirl/throttle", o
      if (o=opts[:amp])
        unity "/roots/swirl/amp", o
      end
      if (o=opts[:drag])
        unity "/roots/swirl/drag", o
      end
    end
    if (o=opts[:alive])
      unity "/roots/alive", o
    end
    if (o=opts[:chase])
      unity "/knitroots/throttle", o

      if (o=opts[:amp])
        unity "/knitroots/amp", o
      end
      if (o=opts[:drag])
        unity "/knitroots/drag", o
      end
      if (o=opts[:force])
        unity "/knitroots/force", o
      end
      if (o=opts[:radius])
        unity "/knitroots/radius", o
      end
      if (o=opts[:target])
        if o == :spiral
        unity "/knitroots/target/spiral", 1.0
        elsif o == :cube
          unity "/knitroots/target/cube", 1.0
        elsif o == :none
          unity "/knitroots/target/none", 1.0
        end
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
  if o=opts[:circle]
    unity "/tree/circle",o
  end
  if o=opts[:sphere]
    unity "/tree/sphere",o
  end
end
def rocksinit()
  world time: 1.0
  unity "/rocks/vortex", 1.0
  unity "/rocks/vortex/force",-1000.0
  unity "/rocks/turb",0.0
  unity "/rocks/vortex/radius",100.0
  unity "/rocks/pos",6.0
  rocks throttle: 0.0, orbit: 0.0, rot: -100, noise: 10.8
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
  if o=opts[:rotate]
    unity "/rockcircle/rot",o
  end
  if o=opts[:speed]
    unity "/rockcircle/rotate/speed", o
  end
  if o=opts[:freq]
    unity "/rockcircle/freq",o
  end
  if o=opts[:y]
    unity "/rockcircle/y",o
  end

end
def vortex(*args)
  opts = resolve_synth_opts_hash_or_array(args)
  if o=opts[:throttle]
    unity "/rocks/throttle", o
  end
  if opts[:turb]
    unity "/rocks/turb", opts[:turb]
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

def zoomout
  unity "/cubecam/zoomout", 0.0
  unity "/cubecam/zoomout", 1.0
  $pmode=4
end
def cam(type=:main, f=false)
  if type == :exit
    if $pmode !=1 || f
      $pmode=1
      unity "/cubecam/zoomout", 0.0
      unity "/cubecam/zoomout", 1.0
      unity "/cubeinside", 0.25*3
      unity "/sea/waveheight", 0.0
      unity "/star/life", 2.0
      at{
        8.times{|n|
          roots throttle: 1.0* (1.0/(n + 1.0))
          sleep 1/2.0
        }
        roots throttle: 0.0
        create_aura
        cube aura: 1.47
      }
    end
  elsif type == :main
    $pmode=1
    tree height: 1.0
    unity "/cam0"
    unity "/cubeinside", 0.25*3
    unity "/sea/waveheight", 0.0
    unity "/star/life", 2.0
    vortex throttle: 0.01
    create_light
    create_aura
    burst 0.0
    shard 0.0
    roots throttle: 0.0, freq: 0.1, target: :bird, drag: 1.0
    roots chase: 0.1, force: 1, target: :spiral, drag: 3
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
    unity "/cubecam/zoomin", 0.0
    unity "/cubecam/zoomin", 1.0
    unity "/cubeinside", -0.25
    create_light 0
    create_aura -5
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
def linecolor(*args)
  opts = resolve_synth_opts_hash_or_array(args)
  if (f=opts[:cube])
    at{
      sleep 0.5 if opts[:delay] == true
      unity "/linecolor/cube/s",opts[:s] || 0.0
      unity "/linecolor/cube/b",opts[:b] || 1.0+rand*f
      unity "/linecolor/cube/h",opts[:h] || 1.0
      }
  else
    factor = opts[:factor] || 1.0
    at{
      sleep 0.5 if opts[:delay] == true
      unity "/linecolor/s",1.0
      unity "/linecolor/b",1.0
      unity "/linecolor/h",rand*factor
    }
  end
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

def cube(*args)
  opts = resolve_synth_opts_hash_or_array(args)
  if (o=opts[:wires])
    unity "/cube/wires/throttle", o
  end
  if (o=opts[:embers])
    unity "/cube/embers/throttle", o
  end
  if (o=opts[:lightning])
    if o > 0
      unity "/cube/lightning/1", o
    else
      unity "/cube/lightning", o
    end
  end
  if (o=opts[:aura])
    unity "/cube/aura/ripple", o
  end
  if (o=opts[:circle])
    unity "/cube/aura/circle", o
  end
  if (o=opts[:rot])
    unity "/cube/rotate/speed", o
  end

end

def roots_init()
  roots chase: 0.0, force: 18.87, radius: 0.01
end

def init!(force=false)
  if force || $pmode !=0 #only init once
    $pmode=0
    start_init
    $xslices=0.0
    $yslices=0.0
    $zslices=0.0
    $cslices=0.0
    scene 1
    sleep 2
    world :time, 1.0
    $zslices=0.0
    defaultcolor
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
    rocksinit
    rocks throttle: 1
    vortex y: 1.25, throttle: 0.2, turb: 0, force: 0
    cube aura: 1.47
    cube rot: 1
    cam :cube
    roots_init
    vortex throttle: 0.0
    fx reverb: 1.00, tube: 0.60
    flop_cc motion: 0.30,  drive: 0.00
    flip_cc motion: 0.50, drive: 0.00
    glitch_cc tubes: 0.50, corode: 0.30
    roots swirl: 0.0, drag: 6.0, freq: 0.0, amp: 0.1
  end
end
