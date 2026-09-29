"
Helper class for form tests
"
Class {
	#name : 'OPPropertiesFormDummyViewModel',
	#superclass : 'Object',
	#instVars : [
		'announcer',
		'value',
		'target'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'building' }
OPPropertiesFormDummyViewModel >> buildEditorForm: aForm [
	"Stub method for dynamic form building"
]

{ #category : 'accessing' }
OPPropertiesFormDummyViewModel >> formEventsAnnouncer [
	^ announcer
]

{ #category : 'initialization' }
OPPropertiesFormDummyViewModel >> initialize [
	super initialize.
	announcer := Announcer new
]

{ #category : 'initialization' }
OPPropertiesFormDummyViewModel >> modelChanged [

	announcer announce: OPModelChanged new
]

{ #category : 'accessing' }
OPPropertiesFormDummyViewModel >> target [
	^ target
]

{ #category : 'accessing' }
OPPropertiesFormDummyViewModel >> target: aTarget [

	target := aTarget
]

{ #category : 'evaluating' }
OPPropertiesFormDummyViewModel >> value [
	^ value
]

{ #category : 'accessing' }
OPPropertiesFormDummyViewModel >> value: aValue [
	value := aValue
]
