Class {
	#name : #OPRSZoomableCanvasInteraction,
	#superclass : #RSZoomableCanvasInteraction,
	#category : #'OpenPonk-Roassal3-Interactions'
}

{ #category : #'events - processing' }
OPRSZoomableCanvasInteraction >> move: aCanvas evtPosition: evtPosition delta: delta [

	| camera dist scale position |
	self configuration hasZoomableAnimation ifTrue: [ 
		^ super move: aCanvas evtPosition: evtPosition delta: delta ].
	camera := aCanvas camera.
	scale := camera scale * delta x.
	scale = (self scaleFor: scale) ifFalse: [ ^ self ].
	dist := evtPosition - camera position.
	position := self
		            correctCameraPosition: aCanvas
		            inRectangle: (self expandedRectangle: aCanvas)
		            position: camera position + (dist * delta y)
		            scale: scale.
	camera
		scale: scale;
		translateTo: position.
	aCanvas signalUpdate
]
