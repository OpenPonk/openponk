Class {
	#name : 'OPTopLevelModelAdapter',
	#superclass : 'OPModelAdapter',
	#instVars : [
		'adapters',
		'adapterFactory'
	],
	#category : 'OpenPonk-Core-Adapters',
	#package : 'OpenPonk-Core',
	#tag : 'Adapters'
}

{ #category : 'adding' }
OPTopLevelModelAdapter >> adapterForModel: aModel ifPresent: aBlock [

	^ adapters at: aModel ifPresent: aBlock
]

{ #category : 'adding' }
OPTopLevelModelAdapter >> addAdapter: anAdapter [

	^ adapters at: anAdapter model put: anAdapter
]

{ #category : 'initialization' }
OPTopLevelModelAdapter >> buildAdapterFactory [

	^ OPControllerFactory new
]

{ #category : 'adding' }
OPTopLevelModelAdapter >> createAdapterForModel: aModel [

	^ self addAdapter: (self newAdapterForModel: aModel)
]

{ #category : 'adding' }
OPTopLevelModelAdapter >> ensureAdapterForModel: aModel [

	self adapterForModel: aModel ifPresent: [ :adapter | ^ adapter ].
	^ self createAdapterForModel: aModel
]

{ #category : 'testing' }
OPTopLevelModelAdapter >> hasSupportForModel: aModel [

	^ adapterFactory hasAdapterFor: aModel
]

{ #category : 'initialization' }
OPTopLevelModelAdapter >> initialize [

	super initialize.
	adapterFactory := self buildAdapterFactory.
	adapters := Dictionary new
]

{ #category : 'adding' }
OPTopLevelModelAdapter >> newAdapterForModel: aModel [

	^ adapterFactory newAdapterFor: aModel
]
