load and saving
loadFrom: aZipFile
	| root |
	root := FileSystem memory root.
	(ZipArchive new readFrom: aZipFile binaryReadStream) extractAllTo: root.
	^ root