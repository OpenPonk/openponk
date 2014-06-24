drawing
drawOn: aCanvas

| pnt|

super drawOn:aCanvas.
endPoint fillColor: (Color white);drawOn:aCanvas.
self drawArrowOn: aCanvas.
pnt := self subnodes middle center.
pnt setX: pnt x setY: pnt y + 20.
self caption position:((pnt - (caption font getPreciseAscent))); drawOn:  aCanvas.