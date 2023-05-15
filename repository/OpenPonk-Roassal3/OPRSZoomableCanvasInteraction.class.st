Class {
	#name : #OPRSZoomableCanvasInteraction,
	#superclass : #RSZoomableCanvasInteraction,
	#category : #'OpenPonk-Roassal3-Interactions'
}

{ #category : #events }
OPRSZoomableCanvasInteraction class >> zoomMove: aCanvas newScale: newScale [

	| scale camera position morphPosition newPosition zero |
	(aCanvas
		 propertyAt: RSCanvasController
		 ifAbsent: [ ^ super zoomMove: aCanvas newScale: newScale ])
		configuration hasZoomableAnimation ifTrue: [
		^ super zoomMove: aCanvas newScale: newScale ].
	camera := aCanvas camera.
	scale := camera scale.

	morphPosition := aCanvas morph lastMousePosition
	                 - aCanvas morph bounds origin.
	position := camera fromPixelToSpace: morphPosition.

	"this method call a loadIdentity in the camera matrix"
	camera scale: newScale.
	newPosition := camera fromSpaceToPixel: position.
	zero := camera fromSpaceToPixel: 0 @ 0.
	camera matrix translation: morphPosition - (newPosition - zero)
		- (camera originMode gapDistance: camera).
	aCanvas signalUpdate
]
