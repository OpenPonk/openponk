as yet unclassified
updateRecentList
	^ recentList
		items: OPProjectStorage default projects;
		updateList