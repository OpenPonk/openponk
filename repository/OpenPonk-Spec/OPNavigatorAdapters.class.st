"
I hold a collection of navigator adapters applicable to a concrete editor.
"
Class {
	#name : 'OPNavigatorAdapters',
	#superclass : 'Object',
	#instVars : [
		'adapters',
		'modelToAdapterMapping'
	],
	#category : 'OpenPonk-Spec-Utils',
	#package : 'OpenPonk-Spec',
	#tag : 'Utils'
}

{ #category : 'accessing - private' }
OPNavigatorAdapters >> adapterFor: aModelObject [

	^ self adapterFor: aModelObject in: (OPProject new uuid: UUID nilUUID)
]

{ #category : 'accessing - private' }
OPNavigatorAdapters >> adapterFor: aModelObject in: aModel [

	^ modelToAdapterMapping
		  at: (Association key: aModelObject value: aModel)
		  ifAbsentPut: [ 
			  adapters
				  detect: [ :each | each hasMappingFor: aModelObject in: aModel ]
				  ifNone: [ 
					  self error:
						  'No adapter found for ' , aModelObject printString , ' in '
						  , aModel printString ] ]
]

{ #category : 'accessing' }
OPNavigatorAdapters >> adapters: aCollection [
	adapters := aCollection
]

{ #category : 'initialization' }
OPNavigatorAdapters >> allAdapters [

	"Return default navigator last, because it has the lowest priority."

	^ OPNavigatorAdapter allSubclasses sortedAs: #priority
]

{ #category : 'accessing' }
OPNavigatorAdapters >> allChildrenFor: anObject [

	^ (self adapterFor: anObject) allChildrenFor: anObject
]

{ #category : 'accessing' }
OPNavigatorAdapters >> childrenFor: anObject [

	^ (self adapterFor: anObject) childrenFor: anObject
]

{ #category : 'accessing' }
OPNavigatorAdapters >> contextMenuFor: anObject projectController: aProjectController inside: aMenuPresenter [

	| contextMenuGroups |
	contextMenuGroups := OrderedCollection new.
	adapters
		select: [ :each | each hasMappingFor: anObject in: OPProject new ]
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

{ #category : 'accessing' }
OPNavigatorAdapters >> dependentFor: anObject in: aModel [

	^ (self adapterFor: anObject in: aModel)
		  dependentFor: anObject
		  in: aModel
]

{ #category : 'accessing' }
OPNavigatorAdapters >> dependsTypeOf: firstObject on: secondObject in: aModel [

	^ (self adapterFor: firstObject in: aModel)
		  dependsTypeOf: firstObject
		  on: secondObject
		  in: aModel
]

{ #category : 'accessing' }
OPNavigatorAdapters >> displayFor: anObject [

	^ (self adapterFor: anObject) displayFor: anObject
]

{ #category : 'accessing' }
OPNavigatorAdapters >> iconFor: anObject [

	^ (self adapterFor: anObject) iconFor: anObject
]

{ #category : 'accessing' }
OPNavigatorAdapters >> initialSetupFor: anObject in: aDiagramController [

	^ (self adapterFor: anObject in: aDiagramController model)
		  initialSetupFor: anObject
		  in: aDiagramController
]

{ #category : 'initialization' }
OPNavigatorAdapters >> initialize [

	super initialize.
	adapters := self allAdapters collect: #new.
	modelToAdapterMapping := Dictionary new
]

{ #category : 'sorting' }
OPNavigatorAdapters >> sort: modelObjects [

	modelObjects ifEmpty: [ ^ modelObjects ].
	^ (self adapterFor: modelObjects anyOne) sort: modelObjects
]
