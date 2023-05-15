Class {
	#name : #OPDICamera,
	#superclass : #Object,
	#instVars : [
		'scale',
		'position'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #'instance creation' }
OPDICamera class >> newFrom: aCamera [

	^ self new
		  scale: aCamera scale;
		  position: aCamera position;
		  yourself
]

{ #category : #accessing }
OPDICamera >> position [
	^ position
]

{ #category : #accessing }
OPDICamera >> position: aPoint [

	position := aPoint
]

{ #category : #accessing }
OPDICamera >> scale: aNumber [ 
	scale := aNumber
]

{ #category : #roassal }
OPDICamera >> updateRoassalCamera: aRSCamera [

	scale ifNotNil: [ aRSCamera scale: scale ].
	self position ifNotNil: [ :position | 
		aRSCamera translateTo: position ].
	^ aRSCamera
]
