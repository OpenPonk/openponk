"
I am the base class for all DC plugins. Subclass me to specify your plugin.

!! Responsibility

Describe general info and access points of a plugin.

!! Collaborators

DCPluginRegistry
"
Class {
	#name : #OPPlugin,
	#superclass : #Object,
	#category : #'OpenPonk-Core'
}

{ #category : #accessing }
OPPlugin >> diagramClass [
	self
		deprecated: 'Use #modelClass'
		transformWith: '`@receiver diagramClass' -> '`@receiver modelClass'.
	^ self modelClass
]

{ #category : #accessing }
OPPlugin >> diagramControllerClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPPlugin >> gitCommit [
	^ ''
]

{ #category : #accessing }
OPPlugin >> icon [
	^ OPIcons current dcFsmDiagramIcon
]

{ #category : #testing }
OPPlugin >> isPluginFor: aModel [
	^ self modelClass = aModel class
]

{ #category : #accessing }
OPPlugin >> modelClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPPlugin >> name [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPPlugin >> serializerClass [
	^ OPNullSerializer
]

{ #category : #'as yet unclassified' }
OPPlugin >> supportsHidingElements [
	^ false
]

{ #category : #accessing }
OPPlugin >> version [
	^ '0.0.0+unknown'
]
