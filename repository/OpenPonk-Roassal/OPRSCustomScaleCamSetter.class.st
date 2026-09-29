"
Camera positioning strategy that zooms and centers the view to fit the current shapes while applying a specific scale and padding.
"
Class {
	#name : 'OPRSCustomScaleCamSetter',
	#superclass : 'RSZoomToShapesSetter',
	#instVars : [
		'scale',
		'padding'
	],
	#category : 'OpenPonk-Roassal-Exports',
	#package : 'OpenPonk-Roassal',
	#tag : 'Exports'
}

{ #category : 'accessing' }
OPRSCustomScaleCamSetter class >> scale: aNumber [

	^ self new
		  scale: aNumber;
		  yourself
]

{ #category : 'hooks' }
OPRSCustomScaleCamSetter >> extent [

	^ canvas encompassingRectangle extent * self scale + self padding
]

{ #category : 'initialization' }
OPRSCustomScaleCamSetter >> initialize [

	super initialize.
	scale := 1.
	padding := 25
]

{ #category : 'accessing' }
OPRSCustomScaleCamSetter >> padding [

	^ padding
]

{ #category : 'accessing' }
OPRSCustomScaleCamSetter >> padding: aNumber [

	padding := aNumber
]

{ #category : 'accessing' }
OPRSCustomScaleCamSetter >> scale [

	^ scale
]

{ #category : 'accessing' }
OPRSCustomScaleCamSetter >> scale: aScale [

	scale := aScale
]

{ #category : 'hooks' }
OPRSCustomScaleCamSetter >> setCamera [

	| rect |
	rect := canvas encompassingRectangle.
	canvas camera
		privateScale: self scale;
		position: (canvas camera positionFromSpace: rect floatCenter)
]
