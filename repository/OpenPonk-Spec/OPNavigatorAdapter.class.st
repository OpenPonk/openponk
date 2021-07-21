"
I am a base class for DCNavigator adapters.

!! Collaborators

DCNavigator

!! Usage

Subclass me and implement mapping methods returning a dictionary.

The retrieval makes usage of object's model hierarchy (up to DCModelObject), so it is possible to add behavior directly to parent class, such as 
[ [ [
displayBlock
    ^ { DCModelObject -> [  :o | self myCustomNameFor: o ] }
] ] ]
Because this will affect all objects, it is recommended to also reimplement ==hasMappingFor:== method to specify whether the adapter is applicable for this particular object.
"
Class {
	#name : #OPNavigatorAdapter,
	#superclass : #Object,
	#instVars : [
		'iconMapping',
		'childrenMapping',
		'actionMapping',
		'displayMapping',
		'contextMenuMapping',
		'dependentMapping',
		'typesByDependency'
	],
	#category : #'OpenPonk-Spec-Utils'
}

{ #category : #testing }
OPNavigatorAdapter class >> isAbstract [
	^ self = OPNavigatorAdapter
]

{ #category : #registering }
OPNavigatorAdapter class >> registerAdapter: aNavigator [
	aNavigator registerAdapter: self new
]

{ #category : #'widget API' }
OPNavigatorAdapter >> actionFor: anObject [
	^ self retrieveActionMapping at: anObject
]

{ #category : #'widget API' }
OPNavigatorAdapter >> actionMapping [
	"by default no action is expected"
]

{ #category : #'widget API' }
OPNavigatorAdapter >> allChildrenFor: anObject [
	^ (self mappingFor: anObject in: self retrieveChildrenMapping)
		flatCollectAsSet: [ :each | (self allChildrenFor: each) , {each} ]
]

{ #category : #'widget API' }
OPNavigatorAdapter >> childrenFor: anObject [
	^ self mappingFor: anObject in: self retrieveChildrenMapping
]

{ #category : #'widget API' }
OPNavigatorAdapter >> childrenMapping [
	^ {}
]

{ #category : #'widget API' }
OPNavigatorAdapter >> contextMenuFor: anObject [
	^ self retrieveContextMenuMapping associations
		select: [ :pair | 
			pair key isBlock
				ifTrue: [ pair key value: anObject ]
				ifFalse: [ anObject isKindOf: pair key ] ]
		thenCollect: #value
]

{ #category : #accessing }
OPNavigatorAdapter >> contextMenuMapping [
	^ {(Object -> {('Inspect' -> [ :obj | obj inspect ])})}
]

{ #category : #private }
OPNavigatorAdapter >> cull: aSomething with: anObject [
	^ (aSomething isKindOf: Symbol) | (aSomething isKindOf: BlockClosure)
		ifTrue: [ aSomething cull: anObject ]
		ifFalse: [ aSomething ]
]

{ #category : #private }
OPNavigatorAdapter >> cull: aSomething with: anObject with: aRootModel [
	^ (aSomething isKindOf: Symbol) | (aSomething isKindOf: BlockClosure)
		ifTrue: [ aSomething cull: anObject cull: aRootModel ]
		ifFalse: [ aSomething ]
]

{ #category : #'widget API' }
OPNavigatorAdapter >> dependentFor: anObject in: aRootModel [
	^ self
		mappingFor: anObject
		inModel: aRootModel
		in: self retrieveDependentMapping
]

{ #category : #private }
OPNavigatorAdapter >> dependentMapping [
	^ self retrieveChildrenMapping
]

{ #category : #'widget API' }
OPNavigatorAdapter >> dependsTypeOf: firstObject on: secondObject in: aRootModel [
	| indexOfFirst indexOfSecond |
	indexOfFirst := self retrieveTypesByDependency
		indexOf: firstObject class.
	indexOfSecond := self retrieveTypesByDependency
		indexOf: secondObject class.
	^ indexOfFirst > indexOfSecond
]

{ #category : #'widget API' }
OPNavigatorAdapter >> displayFor: anObject [
	^ (self mappingFor: anObject in: self retrieveDisplayMapping)
		ifNil: [ anObject printString ]
		ifNotNil: [ :suffix | anObject name , (suffix ifNotEmpty: [ ' (' , suffix , ')' ]) ]
]

{ #category : #'widget API' }
OPNavigatorAdapter >> displayMapping [
	^ self subclassResponsibility
]

{ #category : #testing }
OPNavigatorAdapter >> hasMappingFor: anObject [
	^ false
]

{ #category : #private }
OPNavigatorAdapter >> hierarchyFor: anObject [
	^ (anObject allSuperclassesIncluding: Object)
		addFirst: anObject;
		yourself
]

{ #category : #'widget API' }
OPNavigatorAdapter >> iconFor: anObject [
	^ self mappingFor: anObject in: self retrieveIconMapping
]

{ #category : #'widget API' }
OPNavigatorAdapter >> iconMapping [
	^ self subclassResponsibility 
]

{ #category : #private }
OPNavigatorAdapter >> mappingFor: anObject in: aDictionary [
	| h |
	h := self hierarchyFor: anObject class.
	h
		do: [ :each | 
			aDictionary
				at: each
				ifPresent: [ :value | ^ self cull: value with: anObject ] ].
	^ #()
]

{ #category : #private }
OPNavigatorAdapter >> mappingFor: anObject inModel: aRootModel in: aDictionary [
	| h |
	h := self hierarchyFor: anObject class.
	h
		do: [ :each | 
			aDictionary
				at: each
				ifPresent: [ :value | 
					^ self
						cull:
							(value isSymbol
								ifTrue: [ [ :o | value cull: o ] ]
								ifFalse: [ value ])
						with: anObject
						with: aRootModel ] ].
	^ #()
]

{ #category : #private }
OPNavigatorAdapter >> retrieveActionMapping [
	^ actionMapping ifNil: [ actionMapping := self actionMapping asDictionary ]
]

{ #category : #private }
OPNavigatorAdapter >> retrieveChildrenMapping [
	^ childrenMapping
		ifNil: [ childrenMapping := self childrenMapping asDictionary ]
]

{ #category : #private }
OPNavigatorAdapter >> retrieveContextMenuMapping [
	^ contextMenuMapping ifNil: [ contextMenuMapping := self contextMenuMapping asDictionary ]
]

{ #category : #private }
OPNavigatorAdapter >> retrieveDependentMapping [
	^ dependentMapping
		ifNil: [ dependentMapping := self dependentMapping asDictionary ]
]

{ #category : #private }
OPNavigatorAdapter >> retrieveDisplayMapping [
	^ displayMapping ifNil: [ displayMapping := self displayMapping asDictionary ]
]

{ #category : #private }
OPNavigatorAdapter >> retrieveIconMapping [
	^ iconMapping ifNil: [ iconMapping := self iconMapping asDictionary ]
]

{ #category : #'as yet unclassified' }
OPNavigatorAdapter >> retrieveTypesByDependency [
	^ typesByDependency
		ifNil: [ typesByDependency := self typesByDependency
				flatCollect: [ :eachClass | eachClass withAllSubclasses ] ]
]

{ #category : #private }
OPNavigatorAdapter >> sort: modelObjects [
	^ modelObjects sorted: [ :a :b | a hash < b hash ]
]

{ #category : #'widget API' }
OPNavigatorAdapter >> typesByDependency [
	^ self subclassResponsibility
]
