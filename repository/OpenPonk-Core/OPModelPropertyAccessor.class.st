"
Magritte accessor that extends MAPluggableAccessor with selector metadata, reading and writing through the OPViewModel property gateway by default while remaining fully compatible with custom read/write blocks.
"
Class {
	#name : 'OPModelPropertyAccessor',
	#superclass : 'MAPluggableAccessor',
	#instVars : [
		'selector'
	],
	#category : 'OpenPonk-Core-ViewModels',
	#package : 'OpenPonk-Core',
	#tag : 'ViewModels'
}

{ #category : 'as yet unclassified' }
OPModelPropertyAccessor class >> isAbstract [
	"Answer false since OPModelPropertyAccessor is a concrete accessor class."
	^ false
]

{ #category : 'as yet unclassified' }
OPModelPropertyAccessor class >> on: aSymbol [
	"Instantiate a new property accessor bound to the given selector."
	^ self new
		selector: aSymbol;
		yourself
]

{ #category : 'comparing' }
OPModelPropertyAccessor >> = anObject [
	^ self species = anObject species and: [ self selector = anObject selector ]
]

{ #category : 'testing' }
OPModelPropertyAccessor >> canRead: aTarget [
	"Answer whether the target can be read through this accessor."
	aTarget ifNil: [ ^ false ].
	readBlock ifNotNil: [ ^ true ].
	^ (aTarget respondsTo: #propertyNamed:)
		or: [ aTarget respondsTo: selector ]
]

{ #category : 'testing' }
OPModelPropertyAccessor >> canWrite: aTarget [
	"Answer whether the target property can be written through this accessor."
	aTarget ifNil: [ ^ false ].
	writeBlock ifNotNil: [ ^ true ].
	(aTarget respondsTo: #propertyNamed:put:) ifTrue: [ ^ true ].
	^ aTarget respondsTo: (self mutatorSelectorFor: selector)
]

{ #category : 'processing' }
OPModelPropertyAccessor >> defaultReadBlock [
	"Default read block accessing target via property gateway if supported."
	^ [ :target |
		target ifNotNil: [
			(target respondsTo: #propertyNamed:)
				ifTrue: [ target propertyNamed: selector ]
				ifFalse: [ target perform: selector asSymbol ] ] ]
]

{ #category : 'processing' }
OPModelPropertyAccessor >> defaultWriteBlock [
	"Default write block mutating target via property gateway if supported."
	^ [ :target :value |
		target ifNotNil: [
			(target respondsTo: #propertyNamed:put:)
				ifTrue: [ target propertyNamed: selector put: value ]
				ifFalse: [
					| mutator |
					mutator := (selector endsWith: ':')
						ifTrue: [ selector asSymbol ]
						ifFalse: [ (selector , ':') asSymbol ].
					target perform: mutator with: value ] ] ]
]

{ #category : 'comparing' }
OPModelPropertyAccessor >> hash [
	^ self species hash bitXor: self selector hash
]

{ #category : 'testing' }
OPModelPropertyAccessor >> isAbstract [
	"Polymorphic check returning false on instance side."
	^ self class isAbstract
]

{ #category : 'processing' }
OPModelPropertyAccessor >> mutatorSelectorFor: aSymbol [
	^ (aSymbol endsWith: ':')
		ifTrue: [ aSymbol asSymbol ]
		ifFalse: [ (aSymbol , ':') asSymbol ]
]

{ #category : 'accessing' }
OPModelPropertyAccessor >> name [
	^ selector ifNil: [ super name ] ifNotNil: [ selector asString ]
]

{ #category : 'printing' }
OPModelPropertyAccessor >> printOn: aStream [
	super printOn: aStream.
	selector ifNotNil: [
		aStream nextPut: $(; nextPutAll: selector asString; nextPut: $) ]
]

{ #category : 'accessing' }
OPModelPropertyAccessor >> readBlock [
	"Answer the read block, lazily initialized to defaultReadBlock."
	^ readBlock ifNil: [ readBlock := self defaultReadBlock ]
]

{ #category : 'accessing' }
OPModelPropertyAccessor >> selector [
	"Answer the property selector managed by this accessor."
	^ selector
]

{ #category : 'accessing' }
OPModelPropertyAccessor >> selector: aSymbol [
	selector := aSymbol asSymbol
]

{ #category : 'accessing' }
OPModelPropertyAccessor >> writeBlock [
	"Answer the write block, lazily initialized to defaultWriteBlock."
	^ writeBlock ifNil: [ writeBlock := self defaultWriteBlock ]
]
