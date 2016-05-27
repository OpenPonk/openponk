reading
readProjectFrom: aFile
	| project dom |
	dom := XMLDOMParser parse: aFile readStream.
	project := DCProject new.
	project name: (dom xPath: '//project/name/text()') first string.
	^ project