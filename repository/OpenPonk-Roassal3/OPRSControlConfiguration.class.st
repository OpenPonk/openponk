Class {
	#name : #OPRSControlConfiguration,
	#superclass : #RSControlConfiguration,
	#instVars : [
		'hasZoomableAnimation',
		'keepCameraOnContent'
	],
	#category : #'OpenPonk-Roassal3-Interactions'
}

{ #category : #accessing }
OPRSControlConfiguration >> hasZoomableAnimation [

	^ hasZoomableAnimation
]

{ #category : #accessing }
OPRSControlConfiguration >> hasZoomableAnimation: anObject [

	hasZoomableAnimation := anObject
]

{ #category : #initialization }
OPRSControlConfiguration >> initialize [

	super initialize.
	self
		hasZoomableAnimation: super hasZoomableAnimation;
		keepCameraOnContent: super keepCameraOnContent
]

{ #category : #accessing }
OPRSControlConfiguration >> keepCameraOnContent [

	^ keepCameraOnContent
]

{ #category : #accessing }
OPRSControlConfiguration >> keepCameraOnContent: anObject [

	keepCameraOnContent := anObject
]
