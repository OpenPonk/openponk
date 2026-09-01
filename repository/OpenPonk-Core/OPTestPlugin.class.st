"
Mock implementation of an OpenPonk plugin used exclusively for testing the plugin architecture and project loading mechanisms.
"
Class {
	#name : 'OPTestPlugin',
	#superclass : 'OPPlugin',
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'testing' }
OPTestPlugin class >> isTestingOnly [

	^ true
]

{ #category : 'accessing' }
OPTestPlugin >> diagramControllerClass [
	^ OPTestDiagramController
]

{ #category : 'accessing' }
OPTestPlugin >> diagramSerializerClass [
	^ OPStonDiagramSerializer
]

{ #category : 'accessing' }
OPTestPlugin >> layouterClass [
	"Create your own subclass of OPLayouter or use OPNoLayouter which does nothing"

	^ OPNoLayouter
]

{ #category : 'accessing' }
OPTestPlugin >> modelClass [
	^ OPTestContainerModel
]

{ #category : 'accessing' }
OPTestPlugin >> modelSerializerClass [
	^ OPStonModelSerializer
]

{ #category : 'accessing' }
OPTestPlugin >> name [
	^ 'Plugin for testing'
]

{ #category : 'accessing' }
OPTestPlugin >> version [
	^ '0.1.0-beta.2'
]
