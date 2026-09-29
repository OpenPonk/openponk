"
Represents the camera configuration (scale and position) for a diagram, maintaining the viewport state independently of the underlying Roassal canvas.
"
Class {
	#name : 'OPDiagramCamera',
	#superclass : 'Object',
	#instVars : [
		'scale',
		'position'
	],
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'instance creation' }
OPDiagramCamera class >> newFrom: aCamera [

	^ self new
		  scale: aCamera scale;
		  position: aCamera position;
		  yourself
]

{ #category : 'comparing' }
OPDiagramCamera >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ scale = anObject scale and: [ position = anObject position ]
]

{ #category : 'comparing' }
OPDiagramCamera >> hash [
	^ scale hash bitXor: position hash
]

{ #category : 'accessing' }
OPDiagramCamera >> position [
	^ position
]

{ #category : 'accessing' }
OPDiagramCamera >> position: aPoint [

	position := aPoint
]

{ #category : 'accessing' }
OPDiagramCamera >> scale [
	^ scale
]

{ #category : 'accessing' }
OPDiagramCamera >> scale: aNumber [ 
	scale := aNumber
]

{ #category : 'roassal' }
OPDiagramCamera >> updateRoassalCamera: aRSCamera [

	scale ifNotNil: [ aRSCamera scale: scale ].
	self position ifNotNil: [ aRSCamera translateTo: position ].
	^ aRSCamera
]
