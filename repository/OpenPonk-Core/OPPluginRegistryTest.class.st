Class {
	#name : #OPPluginRegistryTest,
	#superclass : #TestCase,
	#instVars : [
		'registry'
	],
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #initialization }
OPPluginRegistryTest >> setUp [
	super setUp.
	registry := OPPluginRegistry new.
	registry add: OPTestPlugin new
]

{ #category : #initialization }
OPPluginRegistryTest >> testPluginFor [
	self assert: (registry pluginFor: OPTestContainerModel new) class equals: OPTestPlugin
]
