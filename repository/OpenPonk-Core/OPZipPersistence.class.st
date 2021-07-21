"
I store a MemoryStore into a specified zip file and vice versa.
"
Class {
	#name : #OPZipPersistence,
	#superclass : #Object,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #'load and saving' }
OPZipPersistence >> loadFrom: aZipFile [
	| root |
	root := FileSystem memory root.
	(ZipArchive new readFrom: aZipFile binaryReadStream) extractAllTo: root.
	^ root
]

{ #category : #'load and saving' }
OPZipPersistence >> save: aRoot to: aZipFile [
	| archive |
	archive := ZipArchive new.
	aRoot allChildren
		select: #isFile
		thenDo:
			[ :each | archive addFile: each as: (each relativeTo: aRoot path) fullName ].
	[ aZipFile exists and: [ aZipFile isWritable not ] ]
		whileTrue: [ (FileWriteError fileName: aZipFile name)
				signal:
					'File ' , aZipFile name
						,
							' cannot be overwritten. It might be open in another program or Pharo might not have sufficient permissions.' ].
	aZipFile ensureDelete.
	archive writeToFile: aZipFile.
	archive close
]
