"
Unit tests for OPLabel. 
Verifies the default behaviors, properties, and constraints of basic text labels on the canvas.
"
Class {
	#name : 'OPLabelTest',
	#superclass : 'OPAbstractLabelTest',
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'instance creation' }
OPLabelTest >> modelClass [

	^ Mock
]
