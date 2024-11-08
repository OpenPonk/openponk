Extension { #name : 'StFileSystemItemWrapper' }

{ #category : '*OpenPonk-Core' }
StFileSystemItemWrapper class >> roots [

	self flag: 'Remove (let it be replaced by NewTools version) in Pharo 13'.
	^ Smalltalk os isWindows
		  ifTrue: [
			  FileSystem root directories
				  select: [ :each | each exists and: [ each isReadable ] ]
				  thenCollect: [ :each | StRootDriveWrapper on: each ] ]
		  ifFalse: [
		  Array with: (StRootDirectoryWrapper on: FileSystem root) ]
]
