loading
storeLoadUuid
	| location |
	location := FileLocator imageDirectory asFileReference / 'uuid.ston'.
	location exists
		ifFalse: [ location writeStreamDo: [ :stream | stream << (STON toStringPretty: UUID new) ] ].
	^ STON fromString: location contents