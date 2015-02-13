import libtcod, actor, geom

type
  Game = object
    exit: bool
    bounds: Rectangle
    player: Actor
    
proc newGame(): Game =
  let
    bounds = newRectangle(0, 0, 80, 50)
    fullscreen = false
    renderer = RENDERER_SDL
  consoleInitRoot(bounds.width, bounds.height, "caves of nim", fullscreen, renderer)

  var
    player = newActor(40, 25, '@', WHITE)
  Game(bounds: bounds, exit: false, player: player)

proc render(game: Game) =
  consoleClear(nil)
  game.player.render()
  consoleFlush()

proc update(game: var Game, key: TKey) =
  game.player.update(game.bounds, key)

var game = newGame()

game.render()
while not (consoleIsWindowClosed() or game.exit):
  var key = consoleWaitForKeypress(true);
  if key.vk == K_ESCAPE:
    game.exit = true

  game.update(key)
  game.render()
