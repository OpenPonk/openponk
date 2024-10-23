Class {
	#name : 'OPTestDiagramElement',
	#superclass : 'OPDiagramElement',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'rendering' }
OPTestDiagramElement >> renderBasicShape [

	^ RSBox new
		  size: 50;
		  yourself
]
