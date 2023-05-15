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
	#instVars : [
		'layouter'
	],
	#category : #'OpenPonk-Core-Plugin'
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
OPPlugin >> icon [
	^ OPCoreIcons opFsmDiagramIcon
]

{ #category : #testing }
OPPlugin >> isForController: aDiagramController [
	^ self diagramControllerClass = aDiagramController class
]

{ #category : #testing }
OPPlugin >> isPluginFor: aModel [
	^ self modelClass = aModel class
]

{ #category : #accessing }
OPPlugin >> layouterClass [
	"Create your own subclass of OPLayouter or use OPNoLayouter which does nothing"

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPPlugin >> mergeModels: aModelsCollection [

	self notYetImplemented
]

{ #category : #accessing }
OPPlugin >> modelClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPPlugin >> modelSerializerClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPPlugin >> name [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
OPPlugin >> newModel [
	^ self modelClass new
]

{ #category : #accessing }
OPPlugin >> serializer [
	^ OPMementoDirectorySerializer forPlugin: self
]

{ #category : #accessing }
OPPlugin >> simpleName [
	^ self name capitalized
		select: [ :each | each isLetter and: [ each asciiValue <= 127 ] ]
]

{ #category : #accessing }
OPPlugin >> singleStringSerializer [
	^ self serializer
]

{ #category : #testing }
OPPlugin >> supportsHidingElements [
	^ false
]

{ #category : #testing }
OPPlugin >> supportsMergingModels [
	^ false
]

{ #category : #accessing }
OPPlugin >> version [
	^ '0.0.0+unknown'
]
