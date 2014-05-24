private 
writeAttributes: aCollection to: aStream
	aCollection do: [ :attr | self writeAttribute: attr to: aStream ] separatedBy: [ aStream lf ]