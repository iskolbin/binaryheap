-- Binary min heap.
--
-- coded by Ilya Kolbin ( iskolbin@gmail.com )

local floor, setmetatable = math.floor, setmetatable

local function siftup( items, priorities, size )
	local index = size
	local parentIndex = floor( 0.5 * index )
	while index > 1 and priorities[parentIndex] > priorities[index] do
		priorities[index], priorities[parentIndex] = priorities[parentIndex], priorities[index]
		items[index], items[parentIndex] = items[parentIndex], items[index]
		index = parentIndex
		parentIndex = floor( 0.5 * index )
	end
end

local function siftdown( items, priorities, size, limit )
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
			else
				break
			end
				
			index = smallerChild
			leftIndex = index + index
			rightIndex = leftIndex + 1
		end
	end
end

local BinaryMinHeapMt

local BinaryMinHeap = {}

function BinaryMinHeap.new( iparray_ )
	local self = setmetatable( {
		_items = {},
		_priorities = {},
		_size = 0,
		_batch = 0,
	}, BinaryMinHeapMt )
	
	if iparray_ then
		self:batchenq( iparray_ )
	end
	
	return self
end

function BinaryMinHeap:enqueue( item, priority )
	local size = self._size + 1
	local items, priorities = self._items, self._priorities
	self._size = size	
	items[size], priorities[size] = item, priority
	siftup( items, priorities, size ) 
	return self
end

function BinaryMinHeap:dequeue()
	local size = self._size
	
	assert( size > 0, 'Heap is empty' )
	
	local items, priorities = self._items, self._priorities
	local item = items[1]

	items[1], priorities[1] = items[size], priorities[size]
	items[size], priorities[size] = nil, nil
	
	size = size - 1
	self._size = size
	if size > 1 then
		siftdown( items, priorities, size, 1 )
	end

	return item
end

function BinaryMinHeap:peek()
	return self._items[1]
end
	
function BinaryMinHeap:len()
	return self._size
end

function BinaryMinHeap:empty()
	return self._size <= 0
end

function BinaryMinHeap:batchenq( iparray )
	local items, priorities = self._items, self._priorities
	local size = self._size
	for i = 1, #iparray, 2 do
		size = size + 1
		items[size], priorities[size] = iparray[i], iparray[i+1]
	end
	self._size = size
	if size > 1 then
		siftdown( items, priorities, size, floor( 0.5 * size ))
	end
end

BinaryMinHeapMt = {
	__index = BinaryMinHeap,
	__len = BinaryMinHeap.len,
}
      
return setmetatable( BinaryMinHeap, {
	__call = function( _, ... )
		return BinaryMinHeap.new( ... )
	end
} )
