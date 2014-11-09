private 
subscribeShape: aShape edge: anEdge whenDragOnce: shapeBlock whenMove: edgeBlock
	| callbacks subscription error |
	callbacks := Bag with: TRTranslationCallback new with: TRExtentCallback new.
	subscription := AnnouncementSubscription new
		announcer: aShape announcer;
		announcementClass: TRMouseDragEnd;
		yourself.
	callbacks
		do: [ :each | 
			each block: edgeBlock.
			anEdge from addCallback: each.
			anEdge to addCallback: each ].
	error := [ self error: 'this callback should have removed itself before' ].
	subscription
		valuable: [ 
			shapeBlock value.
			callbacks
				do: [ :each | 
					anEdge from trachelShape removeCallback: each ifAbsent: error.
					anEdge to trachelShape removeCallback: each ifAbsent: error ].
			aShape announcer removeSubscription: subscription ].
	aShape announcer basicSubscribe: subscription