local BinaryHeap = require 'BinaryHeap'
local IndirectBinaryHeap =require 'IndirectBinaryHeap'

local cases = {
	length = function()
		local bh = BinaryHeap()
		bh:enqueue( 'a', 2 )
		bh:enqueue( 'b', 4 )
		bh:enqueue( 'c', 1 )
		bh:enqueue( 'd', 6 )
		return #bh == 4 and bh:len() == 4
	end,

	enq_deq = function()
		local bh = BinaryHeap()
		bh:enqueue( 'a', 2 )
		bh:enqueue( 'b', 4 )
		bh:enqueue( 'c', 1 )
		bh:enqueue( 'd', 6 )
		return bh:dequeue() == 'c' and bh:dequeue() == 'a' and bh:dequeue() == 'b' and bh:dequeue() == 'd'
	end,

	batch_enq = function()
		local bh = BinaryHeap.new()
		bh:batchenq{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		return bh:dequeue() == 'c' and bh:dequeue() == 'a' and bh:dequeue() == 'b' and bh:dequeue() == 'd'
	end,

	new_batch = function()
		local bh = BinaryHeap.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		return bh:dequeue() == 'c' and bh:dequeue() == 'a' and bh:dequeue() == 'b' and bh:dequeue() == 'd'
	end,

	empty = function()
		local bh = BinaryHeap.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		local bh2 = BinaryHeap.new()
		return not bh:empty() and bh:dequeue() == 'c' and bh:dequeue() == 'a' and bh:dequeue() == 'b' and bh:dequeue() == 'd' and bh:empty() and bh2:empty()
	end,
	
	peek = function()
		local bh = BinaryHeap.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		return bh:peek() == 'c' and bh:dequeue() == 'c' and bh:peek() == bh:dequeue() 
	end,

	heapsort = function()
		local bh = BinaryHeap()
		local array = {}
		for i = 1, 1000 do
			array[i] = math.random()
			bh:enqueue( array[i], array[i] )
		end
		table.sort( array )
		for i = 1, #bh do
			if bh:dequeue() ~= array[i] then
				return false
			end
		end

		return true
	end,

	simulation = function()
		local items = {}
		local bh = BinaryHeap()

		for i = 1, 1000 do
			if #items == 0 or math.random() < 0.5 then
				local item = math.random()
				bh:enqueue( item, item )
				table.insert( items, item )
				table.sort( items )
			else
				local item = bh:dequeue()
				if item ~= table.remove( items, 1 ) then
					return false
				end
			end
		end

		return true
	end,
}

local indircases = {}
for k, v in pairs( cases ) do
	indircases['indir_' .. k] = function()
		local _BinaryHeap = BinaryHeap
		BinaryHeap = IndirectBinaryHeap
		local result = v()
		BinaryHeap = _BinaryHeap
		return result
	end
end

for k, v in pairs( indircases ) do
	cases[k] = v
end

cases.indir_existence = function()
	local ibh = IndirectBinaryHeap.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
	return ibh:indexof('a') and ibh:indexof('b') and ibh:indexof('c') and ibh:indexof('d') and
	(not ibh:indexof('z')) and (not ibh:indexof('x')) and (not ibh:indexof('y')) and (not ibh:indexof('q'))
end

cases.indir_remove = function()
	local ibh = IndirectBinaryHeap.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
	return ibh:indexof('a') and (not ibh:remove('z')) and ibh:len() == 4 and #ibh == 4 and ibh:remove('a') and (not ibh:indexof('a')) and ibh:len() == 3 and ibh:remove('b') and ibh:remove('d') and ibh:remove('c') and ibh:empty()
end

local function runCases( cs )
	local count, passed = 0, 0
	for name, case in pairs( cs ) do
		count = count + 1
		local pass = case()
		if pass then
			passed = passed + 1
		end
		print( name, '=>', pass and 'OK' or 'FAIL' )
	end
	local failed = count - passed
	print( 'Summary:')
	print( 'Passed:', passed )
	print( 'Failed:', failed )
	return passed, failed
end

print( 'Testing binary heap, direct and indirect' )
local passed, failed = runCases( cases )

if failed > 0 then
	error( 'Failed tests: ' .. failed )
else
	print( 'All passed' )
end
