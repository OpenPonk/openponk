Class {
	#name : #OPRTCanvasExporter,
	#superclass : #RTCanvasExporter,
	#category : #'OpenPonk-Roassal2'
}

{ #category : #accessing }
OPRTCanvasExporter class >> maxWidthAndHeight [

	^ 10000
]

{ #category : #private }
OPRTCanvasExporter >> scaleToMorphLimits [

	"scale down to estimated morph (maxWidthAndHeight) and exporter (maxArea) size limits"

	| scaledDown |
	scaledDown := false.
	self extent x > self class maxWidthAndHeight ifTrue: [ 
		scaledDown := true.
		self scale:
			self class maxWidthAndHeight / self extent x * self cameraScale ].
	self extent y > self class maxWidthAndHeight ifTrue: [ 
		scaledDown := true.
		self scale:
			self class maxWidthAndHeight / self extent y * self cameraScale ].
	scaledDown ifTrue: [ 
		GrowlMorph
			openWithLabel: 'Warning'
			contents: 'Image was forced to scale down to '
				, (self cameraScale * 100 printShowingDecimalPlaces: 0)
				, ' % zoom due to technical restrictions (max resolution).'
			backgroundColor: GrowlMorph theme warningBackgroundColor
			labelColor: GrowlMorph theme textColor ]
]
