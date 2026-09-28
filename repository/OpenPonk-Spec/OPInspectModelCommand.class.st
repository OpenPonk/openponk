"
A project tree contextual command that opens a system inspector on the underlying domain model of the selected element.
"
Class {
	#name : 'OPInspectModelCommand',
	#superclass : 'OPProjectTreeCommand',
	#category : 'OpenPonk-Spec-Commands-ProjectTree',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-ProjectTree'
}

{ #category : 'testing' }
OPInspectModelCommand >> canBeExecuted [
	^ self selectedViewModel isNotNil
]

{ #category : 'executing' }
OPInspectModelCommand >> execute [
	self selectedViewModel model inspect
]

{ #category : 'accessing' }
OPInspectModelCommand >> iconName [
	"Answer the icon name for inspecting the underlying domain model."
	^ #glamorousInspect
]

{ #category : 'initialization' }
OPInspectModelCommand >> initialize [
	super initialize.
	self name: 'Inspect Model'
]
