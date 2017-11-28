load and saving
save: aRoot to: aZipFile
	| archive |
	archive := ZipArchive new.
	aRoot allChildren
		do: [ :each | 
			each isFile
				ifTrue: [ each
						readStreamDo: [ :readStream | archive addString: readStream contents as: each fullName ] ] ].
	aZipFile
		ensureDelete;
		writeStreamDo: [ :stream | archive writeTo: stream ].
	archive close