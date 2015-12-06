as yet unclassified
updateRecentList
	^ recentList
		items: DCProjectStorage default projects;
		updateList