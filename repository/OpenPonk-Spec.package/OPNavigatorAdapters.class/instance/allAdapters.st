initialization
allAdapters
	"Return default navigator last, because it has the lowest priority."

	^ OPNavigatorAdapter allSubclasses \ {OPDefaultNavigatorAdapter}
		, {OPDefaultNavigatorAdapter}