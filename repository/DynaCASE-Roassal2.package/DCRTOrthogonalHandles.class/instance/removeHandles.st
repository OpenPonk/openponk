hooks
removeHandles
	edge shape handleList: nil.
	handles do: #remove.
	handles removeAll.
	self resetHandles.
	edge update.
	edge signalUpdate