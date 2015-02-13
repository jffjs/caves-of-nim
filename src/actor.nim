import libtcod, geom

type
  Behavior = ref object of RootObj
  Player = ref object of Behavior

method update(this: Behavior, pos: Point, bounds: Rectangle, key: TKey): Point =
  pos

method update(this: Player, pos: Point, bounds: Rectangle, key: TKey): Point =
  var offset = pos
  offset = case key.vk:
    of K_UP: offset.offsetY(-1)
    of K_DOWN: offset.offsetY(1)
    of K_LEFT: offset.offsetX(-1)
    of K_RIGHT: offset.offsetX(1)
    else: offset

  if bounds.contains(offset):
    offset
  else:
    pos
  
type Actor* = object
  position*: Point
  glyph*: char
  color*: TColor
  behavior*: Behavior

proc newActor*(x, y: int, glyph: char, color: TColor): Actor =
  Actor(position: newPoint(x, y), glyph: glyph, color: color, behavior: Player())

proc render*(actor: Actor) =
  consolePutCharEx(nil, actor.position.x, actor.position.y, actor.glyph, actor.color, BLACK)

proc update*(actor: var Actor, bounds: Rectangle, key: TKey) =
  var position = actor.behavior.update(actor.position, bounds, key)
  actor.position = position
