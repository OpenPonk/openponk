"
Event announced on RSCanvas when a shape has been interactively resized via OPRSResizable handles.
"
Class {
	#name : 'OPRSShapeResizedEvent',
	#superclass : 'RSAbstractMouseEvent',
	#instVars : [
		'oldExtent',
		'newExtent',
		'oldPosition',
		'newPosition'
	],
	#category : 'OpenPonk-Roassal-Interactions',
	#package : 'OpenPonk-Roassal',
	#tag : 'Interactions'
}

{ #category : 'accessing' }
OPRSShapeResizedEvent >> newExtent [	^ newExtent
]

{ #category : 'accessing' }
OPRSShapeResizedEvent >> newExtent: anObject [	newExtent := anObject
]

{ #category : 'accessing' }
OPRSShapeResizedEvent >> newPosition [	^ newPosition
]

{ #category : 'accessing' }
OPRSShapeResizedEvent >> newPosition: anObject [	newPosition := anObject
]

{ #category : 'accessing' }
OPRSShapeResizedEvent >> oldExtent [	^ oldExtent
]

{ #category : 'accessing' }
OPRSShapeResizedEvent >> oldExtent: anObject [	oldExtent := anObject
]

{ #category : 'accessing' }
OPRSShapeResizedEvent >> oldPosition [	^ oldPosition
]

{ #category : 'accessing' }
OPRSShapeResizedEvent >> oldPosition: anObject [	oldPosition := anObject
]
