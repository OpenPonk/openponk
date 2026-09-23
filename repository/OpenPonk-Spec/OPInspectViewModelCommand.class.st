Class {
	#name : 'OPInspectViewModelCommand',
	#superclass : 'OPProjectTreeCommand',
	#category : 'OpenPonk-Spec-Commands-ProjectTree',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-ProjectTree'
}

{ #category : 'testing' }
OPInspectViewModelCommand >> canBeExecuted [
	^ OPWorkbench isDevelopmentMode and: [ self selectedViewModel isNotNil ]
]

{ #category : 'executing' }
OPInspectViewModelCommand >> execute [
	self selectedViewModel inspect
]

{ #category : 'accessing' }
OPInspectViewModelCommand >> iconName [
	"Answer the icon name for inspecting the ViewModel instance."
	^ #glamorousInspect
]

{ #category : 'initialization' }
OPInspectViewModelCommand >> initialize [
	super initialize.
	self name: 'Inspect ViewModel'
]
