local floor, setmetatable = math.floor, setmetatable

local function siftup( items, priorities, indices, init )
	local index = init
	local parentIndex = floor( 0.5 * index )
	while index > 1 and priorities[parentIndex] > priorities[index] do
		priorities[index], priorities[parentIndex] = priorities[parentIndex], priorities[index]
		items[index], items[parentIndex] = items[parentIndex], items[index]
		indices[items[index]], indices[items[parentIndex]] = index, parentIndex
		index = parentIndex
		parentIndex = floor( 0.5 * index )
	end
	return index
end

local function siftdown( items, priorities, indices, size, limit )
	for index = limit, 1, -1 do
		local leftIndex = index + index
		local rightIndex = leftIndex + 1
		while leftIndex <= size do
			local smallerChild = leftIndex
			if rightIndex <= size and priorities[leftIndex] > priorities[rightIndex] then
				smallerChild = rightIndex
			end
				
			if priorities[index] > priorities[smallerChild] then
				items[index], items[smallerChild] = items[smallerChild], items[index]
				priorities[index], priorities[smallerChild] = priorities[smallerChild], priorities[index]
				indices[items[index]], indices[items[smallerChild]] = index, smallerChild
			else
				break
			end
				
			index = smallerChild
			leftIndex = index + index
			rightIndex = leftIndex + 1
		end
	end
end

local IndirectBinaryHeapMt

local IndirectBinaryHeap = {}

function IndirectBinaryHeap.new( iparray_ )
	local self = setmetatable( {
		_items = {},
		_priorities = {},
		_indices = {},
		_size = 0,
		_batch = 0,
	}, IndirectBinaryHeapMt )
	
	if iparray_ then
		self:batchenq( iparray_ )
	end
	
	return self
end

function IndirectBinaryHeap:indexof( item )
	return self._indices[item]
end

function IndirectBinaryHeap:remove( item )
	local index = self:indexof( item )
	if index ~= nil then
		local items, priorities, indicies = self._items, self._priorities, self._indices
		local size = self._size
		items[index], priorities[index], indicies[items[size]] = items[size], priorities[size], index
		items[size], priorities[size], indicies[item] = nil, nil, nil
		
		size = size - 1
		self._size = size

		if size > 1 then
			local siftedindex = siftup( items, priorities, indicies, index )
			siftdown( items, priorities, indicies, size, siftedindex ) 
		end
		return true
	else
		return false
	end
end

function IndirectBinaryHeap:enqueue( item, priority )
	local items, priorities, indices = self._items, self._priorities, self._indices
	local oldindex = self:indexof( item )
	if oldindex then
		if priorities[oldindex] ~= priority then
			priorities[oldindex] = priority
			local siftedindex = siftup( item, priority, indices, oldindex )
			siftdown( items, priorities, indices, size, siftedindex )
		end
	else
		local size = self._size + 1
		self._size = size	
		items[size], priorities[size], indices[item] = item, priority, size
		siftup( items, priorities, indices, size )
	end
	return self
end

function IndirectBinaryHeap:dequeue()
	local size = self._size
	
	assert( size > 0, 'Heap is empty' )
	
	local items, priorities, indices = self._items, self._priorities, self._indices
	local item = items[1]

	items[1], priorities[1], indices[items[1]] = items[size], priorities[size], indices[items[size]]
	items[size], priorities[size], indices[items[size]] = nil, nil, nil
	
	size = size - 1
	self._size = size
	if size > 1 then
		siftdown( items, priorities, indices, size, 1 )
	end

	return item
end

function IndirectBinaryHeap:peek()
	return self._items[1]
end
	
function IndirectBinaryHeap:len()
	return self._size
end

function IndirectBinaryHeap:empty()
	return self._size <= 0
end

function IndirectBinaryHeap:batchenq( iparray )
	local items, priorities, indicies = self._items, self._priorities, self._indices
	local size = self._size
	for i = 1, #iparray, 2 do
		if not indicies[iparray[i]] then
			size = size + 1
			items[size], priorities[size], indicies[iparray[i]] = iparray[i], iparray[i+1], size
		end
	end
	self._size = size
	if size > 1 then
		siftdown( items, priorities, indicies, size, floor( 0.5 * size ))
	end
end

IndirectBinaryHeapMt = {
	__index = IndirectBinaryHeap,
	__len = IndirectBinaryHeap.len,
}
      
return setmetatable( IndirectBinaryHeap, {
	__call = function( _, ... )
		return IndirectBinaryHeap.new( ... )
	end
} )
