printing
printOn: aStream
	super printOn: aStream.
	aStream << '(' << self name printString << '@' << self modelName printString << '-'
		<< self modelVersion printString << ')'