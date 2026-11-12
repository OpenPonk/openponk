"
Mock implementation of a diagram element used exclusively for OpenPonk unit and integration tests.
"
Class {
	#name : 'OPTestDiagramElement',
	#superclass : 'OPBoundNode',
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
}

{ #category : 'rendering' }
OPTestDiagramElement >> renderBasicShape [
	^ RSBox new
		size: 50;
		yourself
]
