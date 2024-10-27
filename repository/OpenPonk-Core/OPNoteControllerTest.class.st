Class {
	#name : 'OPNoteControllerTest',
	#superclass : 'OPDiagramOnlyControllerTest',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'accessing' }
OPNoteControllerTest >> controllerClass [

	^ OPNoteController
]

{ #category : 'accessing' }
OPNoteControllerTest >> diagramControllerClass [

	^ OPTestDiagramController
]

{ #category : 'construction' }
OPNoteControllerTest >> diagramElementClass [

	^ OPNote
]

{ #category : 'accessing' }
OPNoteControllerTest >> diagramModelClass [

	^ OPTestContainerModel
]

{ #category : 'accessing' }
OPNoteControllerTest >> modelClass [

	^ self diagramElementClass
]
