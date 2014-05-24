private 
writeOperations: aCollection to: aStream
	aCollection do: [ :op |
		self writeOperation: op to: aStream.
		 ]
	separatedBy: [ 
		aStream lf.
		 ]