forms
descriptionAccessor: aSymbol
	^ MAPluggableAccessor
		read: [ :me | me model perform: aSymbol ]
		write: [ :me :newValue | 
			me model perform: (aSymbol , ':') asSymbol with: newValue.
			self figure ifNotNil: [ self refreshFigure ] ]