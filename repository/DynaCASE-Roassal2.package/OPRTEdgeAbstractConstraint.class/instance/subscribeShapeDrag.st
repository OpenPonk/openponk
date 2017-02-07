private
subscribeShapeDrag
	self unSubscribeShapeDrag.
	subscription
		announcer: shape announcer;
		valuable: [ self fix ].
	shape announcer basicSubscribe: subscription