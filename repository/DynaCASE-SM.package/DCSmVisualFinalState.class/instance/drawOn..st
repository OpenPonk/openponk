as yet unclassified
drawOn: aCanvas
|coords|
super drawOn: aCanvas.
coords:=((self borderCircle width) - (self innerCircle width))/2.
self innerCircle position:( self position + (coords@coords)); drawOn: aCanvas.
