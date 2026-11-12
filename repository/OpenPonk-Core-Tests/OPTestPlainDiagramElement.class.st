"
Minimal concrete diagram element test double for persistence and resolution tests.
"
Class {
	#name : 'OPTestPlainDiagramElement',
	#superclass : 'OPDiagramElement',
	#instVars : [
		'attachedShapes'
	],
	#category : 'OpenPonk-Core-Tests-DiagramElements',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'DiagramElements'
}

{ #category : 'accessing' }
OPTestPlainDiagramElement >> attachedShapes [
	^ attachedShapes ifNil: [ #() ]
]

{ #category : 'accessing' }
OPTestPlainDiagramElement >> attachedShapes: aCollection [
	attachedShapes := aCollection
]

{ #category : 'rendering' }
OPTestPlainDiagramElement >> renderBasicShape [
	^ RSBox new
		size: 40;
		yourself
]
