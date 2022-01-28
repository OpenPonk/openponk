Extension { #name : #Pragma }

{ #category : #'*OpenPonk-Pharo8SysExtensions' }
Pragma class >> addToCache: aPragma [
	"when a method is added to a class, the Pragma is added to the cache"

	self pragmaCache
		at: aPragma selector
		ifAbsentPut: [ WeakIdentitySet new ].
	(self pragmaCache at: aPragma selector) add: aPragma
]

{ #category : #'*OpenPonk-Pharo8SysExtensions' }
Pragma class >> all [
	"all pragmas whose methods are currently installed in the system"

	^ self pragmaCache values flattened
		select: [ :each | each method isInstalled ]
]

{ #category : #'*OpenPonk-Pharo8SysExtensions' }
Pragma class >> allNamed: aSymbol [
	"Answer a collection of all pragmas whose selector is aSymbol."

	| pragmas |
	pragmas := self pragmaCache at: aSymbol ifAbsent: [ ^ #() ].
	"if there are none, we can remove the entry in the cache"
	pragmas
		ifEmpty: [ self pragmaCache removeKey: aSymbol ifAbsent: [  ] ].
	"we check if the pragma is really from an installed method 
	(others will be cleaned up by the gc when the method is garbadge collected)"
	^ (pragmas select: [ :each | each method isInstalled ]) asArray
]

{ #category : #'*OpenPonk-Pharo8SysExtensions' }
Pragma class >> pragmaCache [
	^ OPPragmaCache pragmaCache
]
