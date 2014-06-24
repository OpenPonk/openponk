drawing
drawArrowOn:aCanvas
|path stroke vector angle angleTg| 
angle:=Float pi.

((self endPoint) >= (self neighbourPoint )) ifTrue: [ 
	angle:=0 .
	 ].
((self endPoint x) > (self neighbourPoint x) and: (self endPoint y) < (self neighbourPoint y))
ifTrue:[angle:=0 .].

((self endPoint) < (self neighbourPoint )) ifTrue: [ 
	angle:=Float pi.
	 ].

vector :=(self endPoint) - (self neighbourPoint ).
((vector x ~=0)) ifTrue: [  
	angleTg :=(vector y) / (vector x).
	].
	((vector x) = 0 ) ifTrue: [ 
		angleTg:=0.
		].
	
path:=self createSimpleArrow: aCanvas.


aCanvas pathTransform restoreAfter: [  
aCanvas setShape:path.
aCanvas pathTransform translateBy: ((endPoint position + ((endPoint radius/2) ) ) ) ; scaleBy: 2.

aCanvas pathTransform rotateByRadians:  ((angleTg arcTan )+ angle ). 

aCanvas setPaint: Color black; draw.
stroke := aCanvas setStrokePaint: Color black.
	stroke width: 2.
	
	aCanvas draw.
	].

