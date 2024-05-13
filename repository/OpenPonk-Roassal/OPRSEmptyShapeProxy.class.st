Class {
	#name : 'OPRSEmptyShapeProxy',
	#superclass : 'Object',
	#instVars : [
		'shape'
	],
	#category : 'OpenPonk-Roassal-Markers',
	#package : 'OpenPonk-Roassal',
	#tag : 'Markers'
}

{ #category : 'accessing' }
OPRSEmptyShapeProxy >> color: aColor [

	shape borderColor: aColor
]

{ #category : 'reflective operations' }
OPRSEmptyShapeProxy >> doesNotUnderstand: aMessage [
	^ shape perform: aMessage selector withArguments: aMessage arguments
]

{ #category : 'accessing' }
OPRSEmptyShapeProxy >> paint: aPaint [

	aPaint isColor ifFalse: [ ^ self ].
	shape borderColor: aPaint
]

{ #category : 'accessing' }
OPRSEmptyShapeProxy >> shape: aShape [

	shape := aShape
]
