Class {
	#name : 'OPLegacyProjectLoadTestGenerator',
	#superclass : 'Object',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'generating' }
OPLegacyProjectLoadTestGenerator class >> generateAllForVersion: aCollection [

	<script: 'self generateAllForVersion: ''410'''>
	OPLegacyProjectLoadTestGenerator allSubclasses
		reject: [ :each | each isAbstract ]
		thenDo: [ :each | each generateForVersion: aCollection ]
]

{ #category : 'generating' }
OPLegacyProjectLoadTestGenerator class >> generateForVersion: aCollection [

	self new generateForVersion: aCollection
]

{ #category : 'generating' }
OPLegacyProjectLoadTestGenerator >> classNameForVersion: aCollection [

	| versionString |
	versionString := (String streamContents: [ :s |
		                  aCollection asStringOn: s delimiter: '' ])
		                 select: [ :each | each isDigit ].
	^ Symbol streamContents: [ :s |
		  s << 'OP' << self pluginName.
		  aCollection asStringOn: s delimiter: ''.
		  s << 'oppProjectLoadTest' ]
]

{ #category : 'generating' }
OPLegacyProjectLoadTestGenerator >> createClassForVersion: aCollection [

	| className |
	className := self classNameForVersion: aCollection.
	(Smalltalk hasClassNamed: className) ifTrue: [
		self notify: 'Class ' , className
			, ' already exists - you may Proceed to overwrite' ].
	^ (OPLegacyProjectLoadTest << className asSymbol)
		  tag: self tagName;
		  package: self packageName;
		  install
]

{ #category : 'generating' }
OPLegacyProjectLoadTestGenerator >> createMethodIn: aClass [

	^ aClass compile: (String streamContents: [ :s |
			   s << 'base64ProjectZip

^'''.
			   self putBase64On: s.
			   s nextPut: $' ])
]

{ #category : 'generating' }
OPLegacyProjectLoadTestGenerator >> createModel [

	^ self model
]

{ #category : 'generating' }
OPLegacyProjectLoadTestGenerator >> createProject [

	| project |
	project := OPProject named: ''.
	project addModel: self createModel.
	^ project
]

{ #category : 'generating' }
OPLegacyProjectLoadTestGenerator >> createWorkbench [

	| workbench |
	workbench := self createProject open.
	workbench showAllElementsInAllDiagrams.
	^ workbench
]

{ #category : 'generating' }
OPLegacyProjectLoadTestGenerator >> generateForVersion: aString [

	| class |
	class := self createClassForVersion: aString.
	self createMethodIn: class.
	self
		assert: (class run: #testLoad) hasPassed
		description:
		'Class ' , class name , ' was generated, but its test failed'
]

{ #category : 'hooks' }
OPLegacyProjectLoadTestGenerator >> model [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPLegacyProjectLoadTestGenerator >> packageName [

	^ self class packageName
]

{ #category : 'hooks' }
OPLegacyProjectLoadTestGenerator >> pluginName [

	^ (self class name allButFirst: 2) copyUpToSubstring: 'Legacy'
]

{ #category : 'generating' }
OPLegacyProjectLoadTestGenerator >> putBase64On: aStringStream [

	^ self zipByteArrayStreamDo: [ :byteArrayStream |
		  ZnBase64Encoder new encode: byteArrayStream to: aStringStream ]
]

{ #category : 'generating' }
OPLegacyProjectLoadTestGenerator >> saveProjectTo: aFile [

	| workbench |
	workbench := self createWorkbench.
	workbench projectController saveProjectTo: aFile.
	workbench close
]

{ #category : 'hooks' }
OPLegacyProjectLoadTestGenerator >> tagName [

	^ self class packageTagName
]

{ #category : 'generating' }
OPLegacyProjectLoadTestGenerator >> zipByteArrayStreamDo: aBlock [

	| store file |
	store := FileSystem memory root.
	file := store asFileReference / self className , 'opp'.
	self saveProjectTo: file.
	^ file binaryReadStreamDo: [ :s | aBlock cull: s ]
]
