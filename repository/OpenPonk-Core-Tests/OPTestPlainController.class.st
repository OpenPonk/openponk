"
Minimal concrete controller test double providing default no-op lifecycle hooks for unit testing.
"
Class {
	#name : 'OPTestPlainController',
	#superclass : 'OPController',
	#instVars : [
		'diagramController',
		'projectController',
		'deselectedCount',
		'shownCount',
		'focusedCount',
		'canBeTarget',
		'creationCommand'
	],
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
}

{ #category : 'accessing' }
OPTestPlainController >> canBeTarget: aBoolean [
	canBeTarget := aBoolean
]

{ #category : 'connecting' }
OPTestPlainController >> canBeTargetFor: aController [
	^ canBeTarget ifNil: [ false ]
]

{ #category : 'accessing' }
OPTestPlainController >> creationCommand: aCommand [
	creationCommand := aCommand
]

{ #category : 'creating' }
OPTestPlainController >> creationCommandIn: aParentModel andShowInDiagram: aDiagramController onPosition: aPoint [
	^ creationCommand
]

{ #category : 'accessing' }
OPTestPlainController >> deselectedCount [
	^ deselectedCount ifNil: [ 0 ]
]

{ #category : 'accessing' }
OPTestPlainController >> diagramController [
	^ diagramController
]

{ #category : 'accessing' }
OPTestPlainController >> diagramController: aDiagramController [
	diagramController := aDiagramController
]

{ #category : 'ui interaction' }
OPTestPlainController >> ensureDeselected [
	deselectedCount := self deselectedCount + 1
]

{ #category : 'accessing' }
OPTestPlainController >> focusedCount [
	^ focusedCount ifNil: [ 0 ]
]

{ #category : 'accessing' }
OPTestPlainController >> modelClass [
	^ OPTestEntityModel
]

{ #category : 'connecting' }
OPTestPlainController >> parentModelInTarget: aTargetController [
	^ nil
]

{ #category : 'accessing' }
OPTestPlainController >> projectController [
	^ projectController
]

{ #category : 'accessing' }
OPTestPlainController >> projectController: aProjectController [
	projectController := aProjectController
]

{ #category : 'construction' }
OPTestPlainController >> showWithoutDependentInDiagram: aDiagramController [
	shownCount := self shownCount + 1
]

{ #category : 'accessing' }
OPTestPlainController >> shownCount [
	^ shownCount ifNil: [ 0 ]
]

{ #category : 'accessing' }
OPTestPlainController >> source: aController [
	^ self
]

{ #category : 'accessing' }
OPTestPlainController >> target: aController [
	^ self
]

{ #category : 'event handling' }
OPTestPlainController >> updateAfterDiagramFocused [
	focusedCount := self focusedCount + 1
]

{ #category : 'accessing' }
OPTestPlainController >> viewModelClass [
	^ OPTestEntityViewModel
]
