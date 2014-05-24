private 
writeStereotype: aStereotype to: aStream
	aStereotype == ''
		ifFalse: [ 
			aStream
				nextPutAll: '<<';
				nextPutAll: aStereotype;
				nextPutAll: '>>' ]