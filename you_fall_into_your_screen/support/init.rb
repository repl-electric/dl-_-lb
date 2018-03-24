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
def modlogo(r=nil)
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

def modend(r=nil)
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

def mod0
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
end

def mod1
  unity "/alive/light", 0.7
  unity "/alive/rotate", 0.0
  unity "/alive/thick",0.0144
  unity "/alive/length",0.06
  unity "/glitch/block",0.0
  unity "/sea/spacex", 0.2
  unity "/sea/height", 1.3
  unity "/sea/noise", 20.0
  #viz :alive, deformrate: 0.0
  #dviz :alive, deform: 100.0
end

def mod2
  viz :alive, light: 0.6
  viz camera: 1
  #viz :alive, deform: 300.0
end

def mod3
  viz :alive, light: 0.6
  viz camera: 3
  unity "/alive/thick",0.0144
  unity "/alive/length",0.06
  #viz :alive, deform: 300.0
end

def mod4
  $mode = 4
  viz :alive, light: 0.6
  viz camera: 4
  unity "/alive/thick",0.0144
  unity "/alive/length",0.06
  viz :glitch, color: 0.0
  @thick = 0.01
  #viz :alive, deform: 300.0
end

#mode0

#viz shard: 0.1

#viz :sea, popcolor: 0.0
#viz :sea, popsize: 1.0

#dviz :alive, deform: 100.0
#viz :alive, deformrate: 0.0
#viz :alive, rotate: 0.2
#viz postfx: 1.0
#viz postfx: 0.0

#p

#viz camera: 0

#viz :alive, deform: 100.0
#sleep 0.5
#live_loop :go do
#  tick
  #dviz :alive, deform: 0.02
  #kick_machine K1, accent: 1.0, def: 0.3# if spread(1,3).look
  #smp Mountain[/subkick/,0]
  #dviz :postfx, color: (line 0.0,1.0,4).look
  #dviz :postfx, color: 0.0
  #dviz :sea, popsize: rand(1.5)

  #dviz :alive, deformrate: 0.2
  #smp Mountain[/subkick/,0]
  #dviz :alive, deformrate: 0.1
  #dviz :alive, deformrate: 0.0
#  sleep 2
#end

#modelogo
#viz :alive, deform: rand()+0.1

#viz :alive, deform: 100.0
#viz :alive, deform: 200.0
#viz :alive, sine: 0.9

#bitsea_on :cs4

#bitsea_cc motion: 0.19
#bitsea_cc octave: 0.56
