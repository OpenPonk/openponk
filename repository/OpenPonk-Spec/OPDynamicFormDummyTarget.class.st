"
Helper class for form tests
"
Class {
	#name : 'OPDynamicFormDummyTarget',
	#superclass : 'Object',
	#instVars : [
		'announcer'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'building' }
OPDynamicFormDummyTarget >> buildEditorForm: aForm [
	"Stub method for dynamic form building"
]

{ #category : 'accessing' }
OPDynamicFormDummyTarget >> formEventsAnnouncer [
	^ announcer
]

{ #category : 'initialization' }
OPDynamicFormDummyTarget >> initialize [
	super initialize.
	announcer := Announcer new
]
