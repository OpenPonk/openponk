"
I am plugin used for testing.

DO NOT SUBCLASS DCPlugin.
Instead set & reset the default of DCPluginRegistry.
"
Class {
	#name : #OPTestPlugin,
	#superclass : #Object,
	#category : 'OpenPonk-Core-Tests'
}

{ #category : #accessing }
OPTestPlugin >> diagramControllerClass [
	^ OPTestDiagramController
]

{ #category : #accessing }
OPTestPlugin >> gitCommit [
	^ OPVersion gitCommit
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
OPTestPlugin >> name [
	^ 'Plugin for testing'
]

{ #category : #accessing }
OPTestPlugin >> serializerClass [
	^ OPStonSerializer
]

{ #category : #accessing }
OPTestPlugin >> version [
	^ '0.1.0-beta.2'
]
