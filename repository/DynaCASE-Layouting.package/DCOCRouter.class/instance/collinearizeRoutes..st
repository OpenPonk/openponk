as yet unclassified
collinearizeRoutes: routes
	^ routes collect: [ :each | self class collinearizeRoute: each ]