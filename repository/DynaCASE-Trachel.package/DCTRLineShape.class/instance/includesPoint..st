as yet unclassified
includesPoint: aPoint
	^ ((aPoint dist: (aPoint nearestPointOnLineFrom: from to: to)) < 6)