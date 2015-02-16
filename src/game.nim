import libtcod, actor, geom, states, world, worldGen

type
  Game* = object
    exit*: bool
    bounds*: Rectangle
    player*: Actor
    mobs*: seq[Actor]
    worldMap*: Map
    
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

  Game(bounds: bounds, exit: false, player: player, mobs: mobs, worldMap: worldMap)

proc render*(game: var Game) =
  consoleClear(nil)
  game.worldMap.render(game.bounds, game.player.position)
  game.player.render(game.worldMap.viewOrigin)
  for m in game.mobs:
    m.render(game.worldMap.viewOrigin)
  consoleFlush()

proc update*(game: var Game, key: TKey) =
  game.player.update(game.worldMap, key)
  for i in 0..high(game.mobs):
    game.mobs[i].update(game.worldMap, key)
