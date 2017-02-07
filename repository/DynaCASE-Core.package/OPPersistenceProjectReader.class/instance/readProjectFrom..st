reading
readProjectFrom: aFile
	| project dom |
	dom := XMLDOMParser parse: aFile readStream.
	project := OPProject new.
	project name: (dom xPath: '//project/name/text()') first string.
	project
		uuid: (UUID fromString: (dom xPath: '//project/uuid/text()') first string).
	project storageFolder: aFile parent.
	^ project