Class {
	#name : #OPRSCustomScaleCamSetter,
	#superclass : #RSZoomToShapesSetter,
	#instVars : [
		'scale',
		'padding'
	],
	#category : #'OpenPonk-Roassal3-Exports'
}

{ #category : #accessing }
OPRSCustomScaleCamSetter class >> scale: aNumber [

	^ self new
		  scale: aNumber;
		  yourself
]

{ #category : #accessing }
OPRSCustomScaleCamSetter >> extent [

	^ canvas encompassingRectangle extent * self scale + self padding
]

{ #category : #initialization }
OPRSCustomScaleCamSetter >> initialize [

	super initialize.
	scale := 1.
	padding := 25
]

{ #category : #accessing }
OPRSCustomScaleCamSetter >> padding [

	^ padding
]

{ #category : #accessing }
OPRSCustomScaleCamSetter >> padding: aNumber [

	padding := aNumber
]

{ #category : #accessing }
OPRSCustomScaleCamSetter >> scale [

	^ scale
]

{ #category : #accessing }
OPRSCustomScaleCamSetter >> scale: aScale [

	scale := aScale
]

{ #category : #initialization }
OPRSCustomScaleCamSetter >> setCamera [

	super setCamera.
	canvas camera scale: self scale
]
