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
		do: [ :each | 
			each isFile
				ifTrue:
					[ archive addFile: each as: (each relativeTo: aRoot path) fullName ] ].
	aZipFile
		ensureDelete;
		binaryWriteStreamDo: [ :stream | archive writeTo: stream ].
	archive close
]
