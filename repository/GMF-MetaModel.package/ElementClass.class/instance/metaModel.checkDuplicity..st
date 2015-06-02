accessing
metaModel: aMetaModel checkDuplicity: aDuplicity
	metaModel isNil & aMetaModel notNil
		ifTrue: [
			metaModel := aMetaModel. 
			metaModel 
				addElement: self 
				checkDuplicity: aDuplicity];
		
		ifFalse: [self error: 'Error to adding this element to MetaModel. MetaModel is nill or this element is in another MetaModel']