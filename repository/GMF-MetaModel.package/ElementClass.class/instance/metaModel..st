accessing
metaModel: xMetaModel 
	metaModel isNil & xMetaModel notNil
		ifTrue: [metaModel := xMetaModel. 
			metaModel addElement: self];
		
		ifFalse: [self error: 'Error to adding this element to MetaModel. MetaModel is nill or this element is in another MetaModel']