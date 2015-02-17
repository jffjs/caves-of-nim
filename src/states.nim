import libtcod, actor, geom, windows, world

type
  State* {.pure.} = enum
    Attack,
    Exit,
    Messages,
    Movement,
  GameState* = ref object of RootObj
    wMap*: Map
    state*: State

method update*(this: GameState, mobs: var seq[Actor], player: var Actor, key: TKey): State =
  echo "this is running"
  this.state
method render*(this: GameState, mobs: seq[Actor], player: Actor) =
  echo "override this"

type MovementState*  = ref object of GameState
  
proc newMovementState*(wmap: Map): MovementState =
  MovementState(wMap: wmap, state: State.Movement)
  
method update*(this: MovementState, mobs: var seq[Actor], player: var Actor, key: TKey): State =
  echo key.c
  case key.c:
    of 'q':
      result = State.Exit
    else:
      result = State.Movement
      player.update(this.wMap, key)
      for i in 0..high(mobs):
        mobs[i].update(this.wMap, key)
    
method render*(this: MovementState, mobs: seq[Actor], player: Actor) = 
  this.wMap.render(windows.mapWindow.bounds, player.position)
  player.render(this.wMap.viewOrigin)
  for m in mobs:
    m.render(this.wMap.viewOrigin)
  let menu = """
a - Attack
q - Quit
"""
  windows.menuWindow.render(menu)
