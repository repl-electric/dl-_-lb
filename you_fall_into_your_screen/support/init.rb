# unity "/alive/light", 0.5
#unity "/sea/spacex", 0.1
#unity "/sea/noise", 20.0
# #unity "/alive/light",0.8
# unity "/logo/person", 1.0
# unity "/camera/4",1.0
# unity "/glitch/block",0.05
# unity "/glitch/slice",0.0
# unity "/glitch/invert",1.0
# #unity "/alive/length", 0.1

# unity "/alive/thick",0.0144
# unity "/alive/length",0.06
#unity "/alive/spring", 200.0
#unity "/alive/damp", 30.0
#unity "/alive/maxtime", 0.006
unity "/postfx",0.0
def camlogo(r=nil)
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
  unity "/alive/light", 0.6
  unity "/logo/re", 1.0
  unity "/camera/4",1.0
  unity "/glitch/block",0.03
  unity "/glitch/slice",0.0
  unity "/alive/rotate", 0.0
  if r && r!=0
    unity "/glitch/invert",1.0
  else
    unity "/glitch/invert",0.0
  end
end
def dcamend(r=nil)
  at{sleep 0.5; modeend(r)}
end

def cam0
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

def cam1
  $mode = 1
  unity "/alive/light", 0.7
  unity "/alive/rotate", 0.0
  unity "/alive/thick",0.0144
  unity "/alive/length",0.06
  unity "/glitch/block",0.0
  unity "/sea/spacex", 0.2
  unity "/sea/height", 1.3
  unity "/sea/noise", 20.0
  unity "/postfx/color",0.0
  #viz :alive, deformrate: 0.0
  #dviz :alive, deform: 100.0
end

def cam2
  $mode = 2
  viz :alive, light: 0.6
  viz camera: 1
  #viz :alive, deform: 300.0
end

def cam3
  $mode = 3
  @light=0.6
  viz :alive, color: 0.0
  viz :alive, light: 0.6
  viz camera: 3
  unity "/alive/thick",0.0144
  unity "/alive/length",0.06
  viz :glitch, width: 0.005
  viz :glitch, density: 1.6
  viz :glitch, crash: 0.8
  #viz :alive, deform: 300.0
end

def crashcam3(factor=0.0)
  viz :glitch, width: 0.5*factor
  viz :glitch, density: 50.0*factor
  viz :glitch, crash: 0.85*factor
end

def terrain(height=0.0)
  if height
    viz :alive, terrain: 1.0
    viz :alive, height: height
    viz :alive, x: 15.49
    viz :alive, z: 9.79
  else
    viz :alive, terrain: 0.0
  end
end

def cam4
  $mode = 4
  viz :alive, gravity: 1, amp: 1, freq: 1, speed: 1
  viz :alive, light: 0.6
  viz camera: 4
  unity "/alive/thick",0.0144
  unity "/alive/length",0.06
  viz :sea, on: 0.0
  viz :glitch, color: 0.0
  @thick = 0.01
  viz :logo, blank: 1.0
  #viz :alive, deform: 300.0
end

def dcam4
  at{
    sleep 0.5
    cam4
  }
end
def dcam3
  at{
    sleep 0.5
    cam3
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
