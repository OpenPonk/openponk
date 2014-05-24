private 
writeParameters: aCollection to: aStream
	aCollection do: [ :p | self writeParameter: p to: aStream ] separatedBy: [ aStream nextPutAll: ', ' ]