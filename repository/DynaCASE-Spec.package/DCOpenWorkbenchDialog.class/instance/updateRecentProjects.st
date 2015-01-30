as yet unclassified
updateRecentProjects
	self recentProjectsList items: (self class RecentProjects collect: [ :each | each key, ': ', each value]).
	self recentProjectsList updateList