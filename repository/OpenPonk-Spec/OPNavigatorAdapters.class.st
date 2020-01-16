"
I hold a collection of navigator adapters applicable to a concrete editor.
"
Class {
	#name : #OPNavigatorAdapters,
	#superclass : #Object,
	#instVars : [
		'adapters'
	],
	#category : #'OpenPonk-Spec-Utils'
}

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

{ #category : #initialization }
OPNavigatorAdapters >> allAdapters [
	"Return default navigator last, because it has the lowest priority."

	^ OPNavigatorAdapter allSubclasses \ {OPDefaultNavigatorAdapter}
		, {OPDefaultNavigatorAdapter}
]

{ #category : #accessing }
OPNavigatorAdapters >> childrenFor: anObject [
	^ self adaptersFor: anObject detect: #childrenFor:
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
OPNavigatorAdapters >> displayFor: anObject [
	^ self adaptersFor: anObject detect: #displayFor:
]

{ #category : #accessing }
OPNavigatorAdapters >> iconFor: anObject [
	^ self adaptersFor: anObject detect: #iconFor:
]

{ #category : #initialization }
OPNavigatorAdapters >> initialize [
	super initialize.
	adapters := self allAdapters collect: #new
]
