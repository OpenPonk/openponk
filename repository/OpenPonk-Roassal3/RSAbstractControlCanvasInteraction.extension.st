Extension { #name : #RSAbstractControlCanvasInteraction }

{ #category : #'*OpenPonk-Roassal3' }
RSAbstractControlCanvasInteraction >> correctCameraPosition: aCanvas inRectangle: rectangle position: position scale: scale [

	| canvasRect x y p |
	self configuration keepCameraOnContent ifFalse: [ ^ position ].
	p := position.
	canvasRect := Rectangle floatCenter: p extent: aCanvas extent / scale.
	x := rectangle width <= canvasRect width
		     ifTrue: [ 
			     rectangle origin x < canvasRect origin x
				     ifTrue: [ p x - (canvasRect origin x - rectangle origin x) ]
				     ifFalse: [ 
					     rectangle corner x < canvasRect corner x
						     ifTrue: [ p x ]
						     ifFalse: [ 
						     p x - (canvasRect corner x - rectangle corner x) ] ] ]
		     ifFalse: [ 
			     canvasRect origin x < rectangle origin x
				     ifTrue: [ p x - (canvasRect origin x - rectangle origin x) ]
				     ifFalse: [ 
					     rectangle corner x < canvasRect corner x
						     ifTrue: [ p x - (canvasRect corner x - rectangle corner x) ]
						     ifFalse: [ p x ] ] ].
	y := rectangle height <= canvasRect height
		     ifTrue: [ 
			     rectangle origin y < canvasRect origin y
				     ifTrue: [ p y - (canvasRect origin y - rectangle origin y) ]
				     ifFalse: [ 
					     rectangle corner y < canvasRect corner y
						     ifTrue: [ p y ]
						     ifFalse: [ 
						     p y - (canvasRect corner y - rectangle corner y) ] ] ]
		     ifFalse: [ 
			     canvasRect origin y < rectangle origin y
				     ifTrue: [ p y - (canvasRect origin y - rectangle origin y) ]
				     ifFalse: [ 
					     rectangle corner y < canvasRect corner y
						     ifTrue: [ p y - (canvasRect corner y - rectangle corner y) ]
						     ifFalse: [ p y ] ] ].
	^ x @ y
]
