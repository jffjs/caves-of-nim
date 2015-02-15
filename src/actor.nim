import libtcod, geom, math, world

type Behavior* = ref object of RootObj
method update(this: Behavior, pos: Point, wMap: Map, key: TKey): Point =
  pos

type Wanderer* = ref object of Behavior
method update(this: Wanderer, pos: Point, wMap: Map, key: TKey): Point =
  result = pos
  randomize()
  var
    offset = pos
    offX = random(3) - 1
    offY = random(3) - 1
  offset = offset.offset(newPoint(offX, offY))

  if wMap.bounds.contains(offset):
    if not wMap.getTile(offset).solid:
      result = offset
  
type Player* = ref object of Behavior
method update(this: Player, pos: Point, wMap: Map, key: TKey): Point =
  result = pos
  var offset = pos
  offset = case key.vk:
    of K_UP: offset.offsetY(-1)
    of K_DOWN: offset.offsetY(1)
    of K_LEFT: offset.offsetX(-1)
    of K_RIGHT: offset.offsetX(1)
    else: offset

  if wMap.bounds.contains(offset):
    if not wMap.getTile(offset).solid:
      result = offset
  
type Actor* = object
  position*: Point
  glyph*: char
  color*: TColor
  behavior*: Behavior

proc newActor*(pos: Point, glyph: char, color: TColor, behavior: Behavior): Actor =
  Actor(position: pos, glyph: glyph, color: color, behavior: behavior)

proc newActor*(x, y: int, glyph: char, color: TColor, behavior: Behavior): Actor =
  newActor(newPoint(x, y), glyph, color, behavior)

proc render*(actor: Actor, viewOrigin: Point) =
  let position = newPoint(actor.position.x - viewOrigin.x,
                          actor.position.y - viewOrigin.y)
  if position.x >= 0 and position.y >= 0:
    consolePutCharEx(nil, position.x, position.y, actor.glyph, actor.color, BLACK)

proc update*(actor: var Actor, wMap: Map, key: TKey) =
  var position = actor.behavior.update(actor.position, wMap, key)
  actor.position = position
