import libtcod, actor, geom, world

type
  State* {.pure.} = enum
    Attack,
    Exit,
    Messages,
    Movement,
  GameState* = ref object of RootObj
    wMap*: Map
    state*: State

method update*(this: GameState, mobs: seq[Actor], player: Actor, key: TKey): State =
  this.state
method render*(this: GameState, mobs: seq[Actor], player: Actor) =
  echo "override this"

type MovementState*  = ref object of GameState
  mapWindow: Rectangle
  
method update*(this: MovementState, mobs: var seq[Actor], player: var Actor, key: TKey): State =
  case key.c:
    of 'q':
      result = State.Exit
    else:
      result = State.Movement
      player.update(this.wMap, key)
      for i in 0..high(mobs):
        mobs[i].update(this.wMap, key)
    
method render*(this: MovementState, mobs: seq[Actor], player: Actor) = 
  this.wMap.render(this.mapWindow, player.position)
  player.render(this.wMap.viewOrigin)
  for m in mobs:
    m.render(this.wMap.viewOrigin)
  
