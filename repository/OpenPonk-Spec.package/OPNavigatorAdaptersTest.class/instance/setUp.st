running
setUp
	super setUp.
	adapters := OPNavigatorAdapters new.
	adapters adapters: { OPDefaultNavigatorAdapter new }.