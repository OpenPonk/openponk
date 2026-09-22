"
Base class for all OpenPonk plugins. Subclass me to specify your plugin, describing its general information and providing access points.

!! Responsibility

Provide plugin metadata (such as name, version, and icon) and integration hooks (such as serializers and layout engines).

!! Collaborators

OPPluginRegistry
"
Class {
	#name : 'OPPlugin',
	#superclass : 'Object',
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#category : 'OpenPonk-Core-Plugin',
	#package : 'OpenPonk-Core',
	#tag : 'Plugin'
}

{ #category : 'testing' }
OPPlugin class >> isTestingOnly [

	^ false
]

{ #category : 'comparing' }
OPPlugin >> < aComparable [
	"Answer whether the receiver is less than the argument."

	^ self name < aComparable name
]

{ #category : 'comparing' }
OPPlugin >> = aComparable [
	"Compare the receiver with the argument and answer with true if the
	receiver is equal to the argument. Otherwise answer false."

	^ self name = aComparable name and: [
		  self modelClass = aComparable modelClass ]
]

{ #category : 'templates' }
OPPlugin >> defaultProjectTemplates [
	"Answers standard empty model templates for this plugin."

	^ { (OPProjectTemplate
			named: 'Empty ' , self name
			icon: self icon
			modelFactory: [ self newModel ]
			isExample: false) }
]

{ #category : 'accessing' }
OPPlugin >> diagramClass [
	self
		deprecated: 'Use #modelClass'
		transformWith: '`@receiver diagramClass' -> '`@receiver modelClass'.
	^ self modelClass
]

{ #category : 'accessing' }
OPPlugin >> diagramControllerClass [
	^ self subclassResponsibility
]

{ #category : 'templates' }
OPPlugin >> exampleProjectTemplates [
	"Subclasses or extension packages override this to provide demo models."

	^ #(  )
]

{ #category : 'comparing' }
OPPlugin >> hash [
	"Hash must be redefined whenever = is redefined."

	^ self name hash
]

{ #category : 'accessing' }
OPPlugin >> icon [
	^ OPCoreIcons opFsmDiagramIcon
]

{ #category : 'testing' }
OPPlugin >> isForController: aDiagramController [
	^ self diagramControllerClass = aDiagramController class
]

{ #category : 'testing' }
OPPlugin >> isPluginFor: aModel [
	^ self modelClass = aModel class
]

{ #category : 'accessing' }
OPPlugin >> layouterClass [
	"Create your own subclass of OPLayouter or use OPNoLayouter which does nothing"

	^ self subclassResponsibility
]

{ #category : 'model updates' }
OPPlugin >> mergeModels: aModelsCollection [

	self notYetImplemented
]

{ #category : 'accessing' }
OPPlugin >> modelClass [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPPlugin >> modelSerializerClass [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPPlugin >> name [
	^ self subclassResponsibility
]

{ #category : 'instance creation' }
OPPlugin >> newModel [
	^ self modelClass new
]

{ #category : 'templates' }
OPPlugin >> projectTemplates [
	"Answers all project templates supported by this plugin, including empty models and examples."

	^ self defaultProjectTemplates , self exampleProjectTemplates
]

{ #category : 'accessing' }
OPPlugin >> serializer [
	^ OPMementoDirectorySerializer forPlugin: self
]

{ #category : 'accessing' }
OPPlugin >> simpleName [
	^ self name capitalized
		select: [ :each | each isLetter and: [ each asciiValue <= 127 ] ]
]

{ #category : 'accessing' }
OPPlugin >> singleStringSerializer [
	^ self serializer
]

{ #category : 'testing' }
OPPlugin >> supportsHidingElements [
	^ false
]

{ #category : 'testing' }
OPPlugin >> supportsMergingModels [
	^ false
]

{ #category : 'accessing' }
OPPlugin >> version [
	^ '0.0.0+unknown'
]
