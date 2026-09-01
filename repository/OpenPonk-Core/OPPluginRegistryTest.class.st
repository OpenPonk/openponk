"
Unit tests for OPPluginRegistry. 
Verifies the initialization, discovery, and retrieval of OpenPonk plugins based on given parameters or controllers.
"
Class {
	#name : 'OPPluginRegistryTest',
	#superclass : 'TestCase',
	#instVars : [
		'registry'
	],
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'running' }
OPPluginRegistryTest >> setUp [
	super setUp.
	registry := OPPluginRegistry new.
	registry add: OPTestPlugin new
]

{ #category : 'initialization' }
OPPluginRegistryTest >> testPluginFor [
	self assert: (registry pluginFor: OPTestContainerModel new) class equals: OPTestPlugin
]
