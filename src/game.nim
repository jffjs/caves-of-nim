import libtcod, actor, geom, states, world, worldGen

type
  Game* = object
    exit*: bool
    bounds*: Rectangle
    player*: Actor
    mobs*: seq[Actor]
    worldMap*: Map
    state: GameState
    
proc newGame*(): Game =
  let
    bounds = newRectangle(0, 0, 80, 50)
    worldBounds = newRectangle(0, 0, 200, 200)
    fullscreen = false
    renderer = RENDERER_SDL
  consoleInitRoot(bounds.width, bounds.height, "caves of nim", fullscreen, renderer)

  var
    worldMap = Map(bounds: worldBounds, viewOrigin: newPoint(40, 25), tiles: caves(worldBounds, 4))
    player = newActor(worldMap.findEmptyTile(newPoint(40, 25)), '@', WHITE, Player())
    dog = newActor(worldMap.findEmptyTile(newPoint(10, 10)), 'd', DARK_AMBER, Wanderer())
    mobs = @[dog]
    state = newMovementState(worldMap)

  Game(bounds: bounds, exit: false, player: player, mobs: mobs, worldMap: worldMap, state: state)

proc render*(game: var Game) =
  consoleClear(nil)
  game.state.render(game.mobs, game.player)
  consoleFlush()

proc update*(game: var Game, key: TKey) =
  let nextState  = game.state.update(game.mobs, game.player, key)
  case nextState:
    of State.Exit:
      game.exit = true
    of State.Movement:
      game.state = newMovementState(game.worldMap)
    else:
      game.state = newMovementState(game.worldMap)
