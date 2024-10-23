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

{ #category : 'accessing' }
OPDiagramCamera >> position [
	^ position
]

{ #category : 'accessing' }
OPDiagramCamera >> position: aPoint [

	position := aPoint
]

{ #category : 'accessing' }
OPDiagramCamera >> scale: aNumber [ 
	scale := aNumber
]

{ #category : 'roassal' }
OPDiagramCamera >> updateRoassalCamera: aRSCamera [

	scale ifNotNil: [ aRSCamera scale: scale ].
	self position ifNotNil: [ :position | 
		aRSCamera translateTo: position ].
	^ aRSCamera
]
