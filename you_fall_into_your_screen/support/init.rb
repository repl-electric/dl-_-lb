def init!
  $mode = -1
  unity "/camera/0",1.0
  unity "/alive/length",0.0
  unity "/logo/person", 0.0
  unity "/postfx",0.0
  shard 0.0
end

def panic(f=false)
  if !f
    unity "/logo/blank", 0.0
    unity "/logo/blank", 1.0
  else
    unity "/logo/re", 0.0
    unity "/logo/re", 1.0
  end
end

def shard(f=0.0)
  dviz shard: f
end
def spark(f=0.0)
  dviz shard: f
end

def spike(f=0.0)
  dviz :alive, shard: f
end

def focus(f=5.9,a=0.89)
  unity "/cam0/focus", f
  unity "/cam0/aperture", a
end

def breath(f=0.1)
  if f == 0.0
    dviz breath: 0.0
  else
    at{
      sleep 0.5
      viz breath: f
      sleep 0.125
      viz breath: 0.1
    }
  end
end

def alive(*args)
  at{
    sleep 0.5
    viz :alive, *args
  }
end

def console(msg)
  viz console: "> #{msg.to_s.split("/")[-1]}"
end

def whatisit?
  at{
    sleep 0.5
    viz :alive, rotate: 0.5
    terrain 1.0
    sleep 1.5
    viz :alive, rotate: 0.0
    terrain 0.0
    sleep 0.5
  }
end

def invcol(x=1.0)
  viz :glitch, invert: x
end
def alivecol(x=0.0)
  viz :alive, color: x
end

def electric(n=50)
  unity "/electric/#{n}"
end
def delectric(n=50)
  at{sleep 0.5; electric(n)}
end

def camlogo(*args)
  if $mode == -1
    opts = resolve_synth_opts_hash_or_array(args)
    if opts[:invert]
      unity "/glitch/invert",opts[:invert]
    end
    if opts[:rot]
      unity "/alive/rotate", opts[:rot]
    end
    if !opts[:off]
      if opts[:crazy]
        smp Mountain[/bowed/,/e_/,9]
        dviz shard: opts[:crazy]
      end
      unity "/breath", 1.0
      if opts[:logo]
        unity "/glitch/slidewidth", 0.005
        unity "/logo/person", 0.0
        unity "/logo/person", 1.0
        viz :sea, on: 0.0
      else
        unity "/glitch/slidewidth", 0.0
        unity "/logo/person", 0.0
      end
      unity "/camera/4",1.0
      unity "/alive/light", 0.3
      unity "/glitch/block",0.03
      unity "/glitch/slice",0.0
      viz :alive, color: 0.0, deform: 1.0, length: 0.4, thick: 0.01
      viz :alive, gravity: 1, amp: 1, freq: 1, speed: 1
    else
      $mode=0
      unity "/glitch/slidewidth", 0.005
      unity "/breath", 0.0
      unity "/shard", 0.0
      unity "/logo/person", 0.0
      #unity "/alive/rotate", 0.0
      unity "/alive/light", 0.0
      unity "/camera/0",1.0
      viz :sea, on: 1.0
      viz :alive, color: 0.0, deform: 0.0, length: 0.0, thick: 0.0
      viz :alive, gravity: 1, amp: 1, freq: 1, speed: 1
  end
  end
end

def dcamlogo(*args)
  at{
    sleep 0.5
    camlogo(*args)
  }
end
def camlogoold(r=nil)
  viz :alive, color: 0.0
  unity "/alive/light", 0.3
  unity "/logo/re",0.0
  unity "/logo/person", 0.0
  unity "/logo/person", 1.0
  unity "/camera/4",1.0
  unity "/glitch/block",0.03
  unity "/glitch/slice",0.0
  if r
    unity "/glitch/invert",0.0
  else
    unity "/glitch/invert",1.0
  end
  viz :sea, popcolor: 0.0
  viz :sea, popsize: 1.0
  if r
    unity "/alive/rotate", 20.0
  else
    unity "/alive/rotate", 0.0
  end
end

def logo(idx=0)
  x=[{dash: 1.0}, {dot: 1.0},{winkdot: 1.0},{dash: 1.0}, {star: 1.0}][idx]
  viz :logo, x
end

def camend(r=nil)
  alivecol -2.0
  unity "/alive/light", 0.6
  unity "/logo/re", 1.0
  #unity "/camera/4",1.0
  unity "/glitch/block",0.03
  unity "/glitch/slice",0.0
  unity "/alive/rotate", 0.0
  viz :alive, color: 0.0
  unity "/glitch/invert",0.0
  if r && r!=0
    unity "/glitch/invert",1.0
  else
    unity "/glitch/invert",0.0
  end
end
def dcamend(r=nil)
  at{sleep 0.5; camend(r)}
end

def cam0(f=false)
  if $mode != 0
    $mode = 0
    viz :alive, color: 0.108
    unity "/alive/light", 0.9
    unity "/sea/spacex", 0.1
    unity "/sea/height", 1.3
    unity "/sea/noise", 0.01
    unity "/logo/person",0.0
    unity "/camera/0",1.0
    unity "/glitch/block",0.0
    unity "/glitch/slice",0.0
    unity "/glitch/invert",0.0
    unity "/alive/rotate", 0.0
    unity "/postfx/color",1.0
    viz :alive, deform: 1.0
    viz postfx: 0.0
    viz :alive, length: 0.4
    viz :alive, thick: 0.05
    viz :sea, color: 0.0
    viz :sea, size: 1.0
    viz :alive, deformrate: 0.0
    viz :alive, gravity: 1, amp: 1, freq: 1, speed: 1
  end
end

def cam1(f=false)
  if $mode !=1 || f
    $mode = 1
    unity "/camera/0",1.0
    unity "/alive/light", 0.7
    unity "/alive/rotate", 0.0
    unity "/alive/thick",0.0144
    unity "/alive/length",0.06
    unity "/glitch/block",0.0
    unity "/sea/spacex", 0.2
    unity "/sea/height", 1.3
    unity "/sea/noise", 20.0
    unity "/postfx/color",0.0
    unity "/cam0/color",0.0
    viz :cam0, blur: 0.0
    #viz :alive, deformrate: 0.0
    #dviz :alive, deform: 100.0
  end
end

def cam2(f=false)
  $mode = 2
  viz :alive, light: 0.6
  viz camera: 1
  #viz :alive, deform: 300.0
end

def cam3(f=false)
  if $mode != 3 || f
    $mode = 3
    @light=0.6
    viz :alive, color: 0.0
    viz :alive, light: 0.6
    viz camera: 3
    viz :glitch, width: 0.005
    viz :glitch, density: 1.6
    viz :glitch, crash: 0.8
    terrain 0.01
    viz :sea, on: 1.0
    viz :sea, noise: 10.001
    viz :sea, spacex: 0.201
    viz :alive, length: 0.06
    viz :alive, thick: 0.0144
    viz :sea, color: 0.0
    viz :sea, size: 1.0
    viz :alive, deformrate: 0.0
    viz :alive, gravity: 1, amp: 1, freq: 1, speed: 1
    viz breath: 0.0
    #viz :alive, deform: 300.0
  end
end

def crashcam3(factor=0.0)
  viz :glitch, width: 0.5*factor
  viz :glitch, density: 50.0*factor
  viz :glitch, crash: 0.85*factor
end

def terrain(height=0.0)
  if height
    $height=height
    $z = 9.79 * (rand*0.25)
    viz :alive, terrain: 1.0
    viz :alive, height: height
    viz :alive, x: 15.49
    viz :alive, z: $z
  else
    viz :alive, terrain: 0.0
  end
end

def dterrain(height=0.0)
  at{
    sleep 0.5
    terrain height
  }
end

def deterrain(height=0.0)
  at{
    sleep 0.5
    terrain height
  }
end

def cam4(f=false)
  if $mode != 4 || f
    $mode = 4
    viz :alive, gravity: 1, amp: 1, freq: 1, speed: 1
    viz :alive, light: 0.6
    unity "/glitch/block",0.0
    unity "/glitch/slice",0.0
    viz camera: 4
    unity "/alive/thick",0.0144
    unity "/alive/length",0.35
    viz :sea, on: 0.0
    viz :glitch, color: 0.0
    viz :glitch, invert: 0.0
    @thick = 0.01
    viz :logo, blank: 1.0
    terrain 0.01
    #viz :alive, deform: 300.0
    unity "/logo/blank", 1.0
    unity "/logo/blank", 0.0
    at{
      unity "/glitch/block",1.0
      unity "/shard", 1.0
      sleep 0.125
      unity "/glitch/block",0.0
      sleep 0.5
      viz breath: 0.0
      unity "/shard", 0.0
    }
  end
end

def dcam(n)
  if n == 4
    dcam4
  end
  if n == 3
    dcam3
  end
  if n == 2
    dcam2
  end
  if n == 1
    dcam1
  end
end

def dcam4(*args)
  at{
    sleep 0.5
    cam4(*args)
  }
end
def dcam3(*args)
  at{
    sleep 0.5
    cam3(*args)
  }
end
def dcam2
  at{
    sleep 0.5
    cam2
  }
end
def dcam1
  at{
    sleep 0.5
    cam1
  }
end
def dcam0
  at{
    sleep 0.5
    cam0
  }
end
