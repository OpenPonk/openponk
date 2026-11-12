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
	#category : 'OpenPonk-Core-Tests-Plugin',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Plugin'
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

{ #category : 'tests' }
OPPluginRegistryTest >> testPluginRegistryQueriesAndTestingHelpers [
	| visited controller plugin |
	plugin := registry plugins anyOne.
	self assert: (registry hasPluginFor: OPTestContainerModel new)
		description: 'Registry should have plugin for OPTestContainerModel'.
	self deny: (registry hasPluginFor: Object new)
		description: 'Registry should not have plugin for arbitrary Object'.
	controller := OPTestDiagramController new.
	self assert: (registry pluginForController: controller) identicalTo: plugin.
	visited := OrderedCollection new.
	registry pluginsDo: [ :each | visited add: each ].
	self assert: visited asArray equals: { plugin }.
	self assert: (plugin isForController: controller)
		description: 'OPTestPlugin should recognize OPTestDiagramController'.
	self assert: plugin supportsHidingElements
		description: 'OPPlugin supportsHidingElements should default to true'.
	self assert: plugin layouterClass identicalTo: OPNoLayouter.
	self assert: plugin modelSerializerClass isNotNil
		description: 'OPTestPlugin should provide a modelSerializerClass'.
	[
		OPPluginRegistry setDefaultForTesting.
		self assert: (OPPluginRegistry default hasPluginFor: OPTestContainerModel new)
			description: 'Default registry for testing should support OPTestContainerModel'.
		self denyEmpty: OPPluginRegistry withAllForTesting plugins
	] ensure: [ OPPluginRegistry resetDefault ]
]
