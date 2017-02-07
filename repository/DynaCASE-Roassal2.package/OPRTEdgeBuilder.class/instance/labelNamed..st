private
labelNamed: aSymbol
	^ labels at: aSymbol ifAbsentPut: self newLabel.