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
def create_aura(n=0.0)
  unity "/aura",n
end

def init!
  create_tree -1
  create_sea -1
  create_island -1
  create_light 1
  create_light 0
  create_bird -1
  create_cube -2
  create_aura -5
end
