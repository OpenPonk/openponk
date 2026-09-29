"
A secondary test plugin registered in unit tests to verify multi-plugin workbench interactions.
"
Class {
	#name : 'OPTestSecondaryPlugin',
	#superclass : 'OPTestPlugin',
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPTestSecondaryPlugin >> name [
	^ 'Secondary Test Plugin'
]
