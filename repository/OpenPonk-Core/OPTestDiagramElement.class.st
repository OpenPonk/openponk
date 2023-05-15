Class {
	#name : #OPTestDiagramElement,
	#superclass : #OPDiagramElement,
	#category : #'OpenPonk-Core-Controllers - Tests'
}

{ #category : #rendering }
OPTestDiagramElement >> renderBasicShape [

	^ RSBox new
		  size: 50;
		  yourself
]
