file support
suggestedFileName
	fileName ifNotNil: [ :f | ^ f ].
	^ 'diagram.ston'