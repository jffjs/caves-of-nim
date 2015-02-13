import libtcod, math

type
  Point = object
    x: int
    y: int
  Bounds = object
    min: Point
    max: Point

proc distance(p1: Point, p2: Point): float =
  result = sqrt(float((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y)))
      
var
  width = 80
  height = 50
  renderer = RENDERER_SDL
  fullscreen = false
  exit = false

consoleInitRoot(width, height, "caves of nim", fullscreen, renderer)

while not (consoleIsWindowClosed() or exit):
  consoleClear(nil)
  consolePutChar(nil, 40, 25, '@', BKGND_SET)
  consoleFlush()
  var key = consoleWaitForKeypress(true);
  if key.vk == K_ESCAPE:
    exit = true
