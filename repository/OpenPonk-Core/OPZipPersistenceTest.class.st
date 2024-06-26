Class {
	#name : 'OPZipPersistenceTest',
	#superclass : 'TestCase',
	#instVars : [
		'persistence'
	],
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'initialization' }
OPZipPersistenceTest >> setUp [
	super setUp.
	persistence := OPZipPersistence new
]

{ #category : 'tests' }
OPZipPersistenceTest >> testNonASCII [
	| root loaded zipFile |
	root := FileSystem memory root.
	root / 'file.txt'
		writeStreamDo: [ :stream | stream << 'ěščřžýáíéůú' ].
	zipFile := (FileSystem memory / 'project.zip') ensureCreateFile.
	persistence save: root to: zipFile.
	loaded := persistence loadFrom: zipFile.
	self assert: (loaded / 'file.txt') isFile.
	self assert: (loaded / 'file.txt') contents equals: 'ěščřžýáíéůú'
]

{ #category : 'tests' }
OPZipPersistenceTest >> testRoundTrip [
	| root loaded zipFile |
	root := FileSystem memory root.
	(root / 'dir') ensureCreateDirectory.
	root / 'dir' / 'file.txt' writeStreamDo: [ :stream | stream << 'hello' ].
	zipFile := (FileSystem memory / 'project.zip') ensureCreateFile.
	persistence save: root to: zipFile.
	loaded := persistence loadFrom: zipFile.
	self assert: (loaded / 'dir') isDirectory.
	self assert: (loaded / 'dir' / 'file.txt') isFile.
	self assert: (loaded / 'dir' / 'file.txt') contents equals: 'hello'
]
