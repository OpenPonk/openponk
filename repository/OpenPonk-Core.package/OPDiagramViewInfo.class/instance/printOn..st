printing
printOn: aStream
	super printOn: aStream.
	aStream << '(' << self viewName printString << '@' << self modelName printString << '-'
		<< self modelVersion printString << ')'