"
I am plugin used for testing.

DO NOT SUBCLASS DCPlugin.
Instead set & reset the default of DCPluginRegistry.
"
Class {
	#name : #OPTestPlugin,
	#superclass : #Object,
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #accessing }
OPTestPlugin >> diagramControllerClass [
	^ OPTestDiagramController
]

{ #category : #accessing }
OPTestPlugin >> diagramSerializerClass [
	^ OPStonDiagramSerializer
]

{ #category : #accessing }
OPTestPlugin >> isPluginFor: aModel [
	^ self modelClass = aModel class
]

{ #category : #accessing }
OPTestPlugin >> modelClass [
	^ OPTestContainerModel
]

{ #category : #accessing }
OPTestPlugin >> modelSerializerClass [
	^ OPStonModelSerializer
]

{ #category : #accessing }
OPTestPlugin >> name [
	^ 'Plugin for testing'
]

{ #category : #accessing }
OPTestPlugin >> serializer [

	^ OPMementoDirectorySerializer forPlugin: self
]

{ #category : #testing }
OPTestPlugin >> supportsHidingElements [

	^ false
]

{ #category : #testing }
OPTestPlugin >> supportsMergingModels [

	^ false
]

{ #category : #accessing }
OPTestPlugin >> version [
	^ '0.1.0-beta.2'
]
