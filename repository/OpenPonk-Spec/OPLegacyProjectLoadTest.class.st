Class {
	#name : 'OPLegacyProjectLoadTest',
	#superclass : 'TestCase',
	#instVars : [
		'workbench'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'generating' }
OPLegacyProjectLoadTest class >> generateFromDesktopProjects [

	<script>
	FileLocator desktop asFileReference files
		select: [ :each | each extension = 'opp' ]
		thenDo: [ :file | self generateFromProjectFile: file ]
]

{ #category : 'generating' }
OPLegacyProjectLoadTest class >> generateFromProjectFile: file [

	| pluginName version modelName base64 className |
	pluginName := (file basename copyUpToLast: $-) capitalized.
	version := (file basename copyAfterLast: $-) reject: [ :each |
		           each = $. ].
	modelName := pluginName , version.

	file binaryReadStreamDo: [ :s | base64 := s upToEnd base64Encoded ].
	base64 ifNil: [ self error ].

	className := ('OP' , modelName , 'ProjectLoadTest') asSymbol.

	(OPLegacyProjectLoadTest << className)
		tag: 'Tests';
		package: 'OpenPonk-Spec';
		install.

	(Smalltalk at: className) compile: 'base64ProjectZip

^''' , base64 , '''
'
]

{ #category : 'testing' }
OPLegacyProjectLoadTest class >> isAbstract [

	^ self = OPLegacyProjectLoadTest
]

{ #category : 'files' }
OPLegacyProjectLoadTest >> base64ProjectZip [

	^ self subclassResponsibility
]

{ #category : 'files' }
OPLegacyProjectLoadTest >> file [

	^ FileSystem memory root / 'testLegacyProject.opp'
]

{ #category : 'files' }
OPLegacyProjectLoadTest >> projectZip [

	| file |
	file := self file.
	file ensureDelete.
	file binaryWriteStreamDo: [ :s |
		s nextPutAll: self base64ProjectZip base64Decoded ].
	file exists ifFalse: [
		self error: 'Failed to save the base64 as file in memory' ].
	file size isZero ifTrue: [
		self error: 'File with base64 content is empty' ].
	^ file
]

{ #category : 'running' }
OPLegacyProjectLoadTest >> tearDown [

	self file ensureDelete.
	workbench ifNotNil: [ workbench close ].
	super tearDown
]

{ #category : 'tests' }
OPLegacyProjectLoadTest >> testLoad [

	| project |
	project := OPProjectController fromFile: self projectZip.
	workbench := project open.
	self assert: workbench focusedEditor isNotNil.
	self assert:
		workbench focusedEditor canvasPresenter canvas shapes isNotEmpty
]
