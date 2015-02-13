import math

type
  Point* = object
    x*: int
    y*: int
  Rectangle* = object
    origin*: Point
    width*: int
    height*: int

proc newPoint*(x: int, y: int): Point =
  Point(x: x, y: y)

proc distance*(p1: Point, p2: Point): float =
  result = sqrt(float((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y)))

proc offsetX*(p: Point, offset: int): Point =
  Point(x: p.x + offset, y: p.y)

proc offsetY*(p: Point, offset: int): Point =
  Point(x: p.x, y: p.y + offset)

proc offset*(p: Point, offset: Point): Point =
  Point(x: p.x + offset.x, y: p.y + offset.y)
  
let offsets = @[Point(x: -1, y: -1), Point(x: 0, y: -1),
               Point(x: 1, y: -1), Point(x: -1, y: 0),
               Point(x: 1, y: 0), Point(x: -1, y: 1),
               Point(x: 0, y: 1), Point(x: 1, y: 1)]

proc adjacent*(p: Point): seq[Point] =
  result = map(offsets, proc(offset: Point): Point = p.offset(offset))

proc newRectangle*(x: int, y: int, w: int, h: int): Rectangle =
  Rectangle(origin: newPoint(x, y), width: w, height: h)

proc top*(r: Rectangle): int =
  r.origin.y

proc bottom*(r: Rectangle): int =
  r.origin.y + r.height

proc left*(r: Rectangle): int =
  r.origin.x

proc right*(r: Rectangle): int =
  r.origin.x + r.width

proc contains*(r: Rectangle, p: Point): bool =
  p.x >= r.left and p.x < r.right and p.y >= r.top and p.y < r.bottom

when isMainModule:
  doAssert(distance(Point(x: 0, y: 1), Point(x: 0, y: 1)) == 0)
  doAssert(distance(Point(x: 0, y: 1), Point(x: 0, y: 2)) == 1)
  doAssert(distance(Point(x: 1, y: 1), Point(x: 2, y: 2)) > 1.41)
  doAssert(distance(Point(x: 1, y: 1), Point(x: 2, y: 2)) < 1.42)

  var
    p1 = newPoint(0, 0)
    p2 = newPoint(1, 0)

  doAssert(offsetX(p1, 3) == Point(x: 3, y: 0))
  doAssert(offsetX(p2, -3) == Point(x: -2, y: 0))
  doAssert(offsetY(p1, 2) == Point(x: 0, y: 2))
  doAssert(offsetY(p2, -5) == Point(x: 1, y: -5))
  doAssert(offset(p1, p2) == Point(x: 1, y: 0))

  var adjPoints = p1.adjacent()
  for i, p in adjPoints:
    doAssert(p == offsets[i])
  
  var r = newRectangle(0, 0, 80, 50)
  doAssert(r.top == 0)
  doAssert(r.bottom == 50)
  doAssert(r.left == 0)
  doAssert(r.right == 80)

  doAssert(r.contains(newPoint(20, 20)) == true)
  doAssert(r.contains(newPoint(90, 90)) == false)
  doAssert(r.contains(p1) == true)
  doAssert(r.contains(newPoint(80, 50)) == false)
