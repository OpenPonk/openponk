"
I hold a collection of navigator adapters applicable to a concrete editor.
"
Class {
	#name : #OPNavigatorAdapters,
	#superclass : #Object,
	#instVars : [
		'adapters',
		'modelToAdapterMapping'
	],
	#classInstVars : [
		'default'
	],
	#category : #'OpenPonk-Spec-Utils'
}

{ #category : #accessing }
OPNavigatorAdapters class >> default [
	^ default ifNil: [ default := self new ]
]

{ #category : #'accessing - private' }
OPNavigatorAdapters >> adapterFor: aModelObject [
	^ modelToAdapterMapping
		at: aModelObject
		ifAbsentPut: [ adapters
				detect: [ :each | each hasMappingFor: aModelObject ]
				ifNone: [ self error: 'No adapter found for ' , aModelObject printString ] ]
]

{ #category : #accessing }
OPNavigatorAdapters >> adapters: aCollection [
	adapters := aCollection
]

{ #category : #'accessing - private' }
OPNavigatorAdapters >> adaptersFor: anObject detect: aOneArgSymbol [
	adapters
		do: [ :each | 
			(each hasMappingFor: anObject)
				ifTrue: [ (each perform: aOneArgSymbol with: anObject) ifNotNil: [ :v | ^ v ] ] ]
]

{ #category : #'accessing - private' }
OPNavigatorAdapters >> adaptersFor: anObject in: aRootModel detect: aTwoArgSymbol [
	adapters
		do: [ :each | 
			(each hasMappingFor: anObject)
				ifTrue: [ (each perform: aTwoArgSymbol with: anObject with: aRootModel)
						ifNotNil: [ :v | ^ v ] ] ]
]

{ #category : #initialization }
OPNavigatorAdapters >> allAdapters [
	"Return default navigator last, because it has the lowest priority."

	^ OPNavigatorAdapter allSubclasses \ {OPDefaultNavigatorAdapter}
		, {OPDefaultNavigatorAdapter}
]

{ #category : #accessing }
OPNavigatorAdapters >> childrenFor: anObject [
	^ (self adapterFor: anObject) childrenFor: anObject
]

{ #category : #accessing }
OPNavigatorAdapters >> contextMenuFor: anObject in: aMenu [
	| builder |
	builder := OPMenuBuilder new.
	builder menu: aMenu.
	((adapters select: [ :each | each hasMappingFor: anObject ])
		collect: [ :each | each contextMenuFor: anObject ]) flattened
		do: [ :pair | builder addItem: pair key action: [ pair value value: anObject ] ]
]

{ #category : #accessing }
OPNavigatorAdapters >> dependentFor: anObject in: aRootModel [
	^ (self adapterFor: anObject) dependentFor: anObject in: aRootModel
]

{ #category : #accessing }
OPNavigatorAdapters >> dependsTypeOf: firstObject on: secondObject in: aRootModel [
	^ (self adapterFor: firstObject)
		dependsTypeOf: firstObject
		on: secondObject
		in: aRootModel
]

{ #category : #accessing }
OPNavigatorAdapters >> displayFor: anObject [
	^ (self adapterFor: anObject) displayFor: anObject
]

{ #category : #accessing }
OPNavigatorAdapters >> iconFor: anObject [
	^ (self adapterFor: anObject) iconFor: anObject
]

{ #category : #initialization }
OPNavigatorAdapters >> initialize [
	super initialize.
	adapters := self allAdapters collect: #new.
	modelToAdapterMapping := Dictionary new
]
