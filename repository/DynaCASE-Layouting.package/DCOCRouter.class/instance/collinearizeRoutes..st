as yet unclassified
collinearizeRoutes: routes
	^ routes collect: [ :each | self collinearizeRoute: each ]