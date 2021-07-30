Class {
	#name : #OPPluginSelection,
	#superclass : #Object,
	#instVars : [
		'plugin',
		'radioButton'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #'as yet unclassified' }
OPPluginSelection class >> withPlugin: aPlugin radioButton: aRadioButton [
	^ self new
		plugin: aPlugin;
		radioButton: aRadioButton;
		yourself
]

{ #category : #accessing }
OPPluginSelection >> plugin [
	^ plugin
]

{ #category : #accessing }
OPPluginSelection >> plugin: anObject [
	plugin := anObject
]

{ #category : #accessing }
OPPluginSelection >> radioButton [
	^ radioButton
]

{ #category : #accessing }
OPPluginSelection >> radioButton: anObject [
	radioButton := anObject
]
