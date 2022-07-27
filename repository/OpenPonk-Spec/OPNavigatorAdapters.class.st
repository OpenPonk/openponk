"
I hold a collection of navigator adapters applicable to a concrete editor.
"
Class {
	#name : #OPNavigatorAdapters,
	#superclass : #Object,
	#instVars : [
		'adapters',
		'typeToAdapterMapping'
	],
	#classInstVars : [
		'default'
	],
	#category : #'OpenPonk-Spec-Utils'
}

{ #category : #accessing }
OPNavigatorAdapters class >> default [

	<script: 'self default inspect'>
	^ default ifNil: [ default := self new ]
]

{ #category : #accessing }
OPNavigatorAdapters class >> reset [
	<script>
	^ default := self new
]

{ #category : #'accessing - private' }
OPNavigatorAdapters >> adapterFor: aModelObject [

	^ typeToAdapterMapping at: aModelObject class ifAbsentPut: [ 
		  adapters
			  detect: [ :each | each hasMappingFor: aModelObject ]
			  ifNone: [ 
			  self error: 'No adapter found for ' , aModelObject printString ] ]
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

	^ OPNavigatorAdapter allSubclasses sortedAs: #priority
]

{ #category : #accessing }
OPNavigatorAdapters >> allChildrenFor: anObject [
	^ (self adapterFor: anObject) allChildrenFor: anObject
]

{ #category : #accessing }
OPNavigatorAdapters >> childrenFor: anObject [
	^ (self adapterFor: anObject) childrenFor: anObject
]

{ #category : #accessing }
OPNavigatorAdapters >> contextMenuFor: anObject projectController: aProjectController in: aMenuPresenter [

	| contextMenuGroups |
	contextMenuGroups := OrderedCollection new.
	adapters
		select: [ :each | each hasMappingFor: anObject ]
		thenDo: [ :each | 
			(each contextMenuFor: anObject) do: [ :eachGroup | 
				(eachGroup reject: [ :eachItemPair | 
					 contextMenuGroups anySatisfy: [ :anyGroup | 
						 anyGroup anySatisfy: [ :anyItemPair | 
							 anyItemPair key = eachItemPair key ] ] ]) ifNotEmpty: [ 
					:filteredGroup | contextMenuGroups add: filteredGroup ] ] ].
	contextMenuGroups do: [ :eachGroup | 
		aMenuPresenter addGroup: [ :group | 
			eachGroup do: [ :eachItemPair | 
				aMenuPresenter addItem: [ :item | 
					item
						name: eachItemPair key;
						action: [ eachItemPair value value: anObject ] ] ] ] ].
	((aProjectController hasModel: anObject) and: [ 
		 aProjectController project models size > 1 ]) ifFalse: [ 
		^ aMenuPresenter ].
	aMenuPresenter addItem: [ :item | 
		item
			name: 'Delete from project';
			action: [ 
				SpConfirmDialog new
					title: 'Delete model from project?';
					label:
						'Do you want to delete the model, including its contents and diagrams?';
					acceptLabel: 'Yes, delete it';
					cancelLabel: 'Cancel';
					onAccept: [ aProjectController removeModel: anObject ];
					openDialog ] ].
	^ aMenuPresenter
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

{ #category : #accessing }
OPNavigatorAdapters >> initialSetupFor: anObject [

	^ (self adapterFor: anObject) initialSetupFor: anObject
]

{ #category : #initialization }
OPNavigatorAdapters >> initialize [

	super initialize.
	adapters := self allAdapters collect: #new.
	typeToAdapterMapping := Dictionary new
]

{ #category : #sorting }
OPNavigatorAdapters >> sort: modelObjects [
	modelObjects ifEmpty: [ ^ modelObjects ].
	^ (self adapterFor: modelObjects anyOne) sort: modelObjects
]
