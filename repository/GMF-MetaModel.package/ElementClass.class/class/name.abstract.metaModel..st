instance creation
name: xName abstract: xAbstract metaModel: xMetaModel

	^ (super new initialize)
		name: 			xName;
		abstract: 		xAbstract;
		metaModel: 	xMetaModel;
		yourself