local BinaryMinHeap = require 'BinaryMinHeap'
local BinaryMaxHeap = require 'BinaryMaxHeap'
local IndirectBinaryMinHeap = require 'IndirectBinaryMinHeap'
local IndirectBinaryMaxHeap = require 'IndirectBinaryMaxHeap'

local cases = {
	length = function()
		local bh = BinaryMinHeap()
		bh:enqueue( 'a', 2 )
		bh:enqueue( 'b', 4 )
		bh:enqueue( 'c', 1 )
		bh:enqueue( 'd', 6 )
		local bhx = BinaryMaxHeap()
		bhx:enqueue( 'a', 2 )
		bhx:enqueue( 'b', 4 )
		bhx:enqueue( 'c', 1 )
		bhx:enqueue( 'd', 6 )
		return #bh == 4 and bh:len() == 4 and bhx:len() == 4 and #bhx == 4
	end,

	enq_deq = function()
		local bh = BinaryMinHeap()
		bh:enqueue( 'a', 2 )
		bh:enqueue( 'b', 4 )
		bh:enqueue( 'c', 1 )
		bh:enqueue( 'd', 6 )
		local bhx = BinaryMaxHeap()
		bhx:enqueue( 'a', 2 )
		bhx:enqueue( 'b', 4 )
		bhx:enqueue( 'c', 1 )
		bhx:enqueue( 'd', 6 )
		return bh:dequeue() == 'c' and bh:dequeue() == 'a' and bh:dequeue() == 'b' and bh:dequeue() == 'd' and bhx:dequeue() == 'd' and bhx:dequeue() == 'b' and bhx:dequeue() == 'a' and bhx:dequeue() == 'c'
	end,

	batch_enq = function()
		local bh = BinaryMinHeap.new()
		bh:batchenq{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		local bhx = BinaryMaxHeap.new()
		bhx:batchenq{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		return bh:dequeue() == 'c' and bh:dequeue() == 'a' and bh:dequeue() == 'b' and bh:dequeue() == 'd' and bhx:dequeue() == 'd' and bhx:dequeue() == 'b' and bhx:dequeue() == 'a' and bhx:dequeue() == 'c'
	end,

	new_batch = function()
		local bh = BinaryMinHeap.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		local bhx = BinaryMaxHeap.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		return bh:dequeue() == 'c' and bh:dequeue() == 'a' and bh:dequeue() == 'b' and bh:dequeue() == 'd' and bhx:dequeue() == 'd' and bhx:dequeue() == 'b' and bhx:dequeue() == 'a' and bhx:dequeue() == 'c'
	end,

	empty = function()
		local bh = BinaryMinHeap.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		local bh2 = BinaryMinHeap.new()
		local bhx = BinaryMaxHeap.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		local bhx2 = BinaryMaxHeap.new()
		return not bh:empty() and bh:dequeue() == 'c' and bh:dequeue() == 'a' and bh:dequeue() == 'b' and bh:dequeue() == 'd' and bh:empty() and bh2:empty() and
			not bhx:empty() and bhx:dequeue() == 'd' and bhx:dequeue() == 'b' and bhx:dequeue() == 'a' and bhx:dequeue() == 'c' and bhx2:empty()
	end,
	
	peek = function()
		local bh = BinaryMinHeap.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		local bhx = BinaryMaxHeap.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
		return bh:peek() == 'c' and bh:dequeue() == 'c' and bh:peek() == bh:dequeue() and bhx:peek() == 'd' and bhx:dequeue() == 'd' and bhx:peek() == 'b'
	end,

	heapsort = function()
		local bh = BinaryMinHeap()
		local bhx = BinaryMaxHeap()
		local array = {}
		for i = 1, 1000 do
			array[i] = math.random()
			bh:enqueue( array[i], array[i] )
			bhx:enqueue( array[i], -array[i] )
		end
		table.sort( array )
		for i = 1, #bh do
			if bh:dequeue() ~= array[i] or bhx:dequeue() ~= array[i] then
				return false
			end
		end

		return true
	end,

	simulation = function()
		local items = {}
		local bh = BinaryMinHeap()
		local bhx = BinaryMaxHeap()

		for i = 1, 1000 do
			if #items == 0 or math.random() < 0.5 then
				local item = math.random()
				bh:enqueue( item, item )
				bhx:enqueue( item, -item )
				table.insert( items, item )
				table.sort( items )
			else
				local item = bh:dequeue()
				if item ~= table.remove( items, 1 ) or item ~= bhx:dequeue() then
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
		local _BinaryMinHeap = BinaryMinHeap
		local _BinaryMaxHeap = BinaryMaxHeap
		BinaryMinHeap = IndirectBinaryMinHeap
		BinaryMaxHeap = IndirectBinaryMaxHeap
		local result = v()
		BinaryMinHeap = _BinaryMinHeap
		BinaryMaxHeap = _BinaryMaxHeap
		return result
	end
end

for k, v in pairs( indircases ) do
	cases[k] = v
end

cases.indir_existence = function()
	local ibh = IndirectBinaryMinHeap.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
	local ibhx = IndirectBinaryMaxHeap.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
	return ibh:contains('a') and ibh:contains('b') and ibh:contains('c') and ibh:contains('d') and
	(not ibh:contains('z')) and (not ibh:contains('x')) and (not ibh:contains('y')) and (not ibh:contains('q'))
	and ibhx:contains('a') and ibhx:contains('b') and ibhx:contains('c') and ibhx:contains('d') and
	(not ibhx:contains('z')) and (not ibhx:contains('x')) and (not ibhx:contains('y')) and (not ibhx:contains('q'))
end

cases.indir_remove = function()
	local ibh = IndirectBinaryMinHeap.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
	local ibhx = IndirectBinaryMaxHeap.new{ 'a', 2, 'b', 4, 'c', 1, 'd', 6 }
	return ibh:contains('a') and (not ibh:remove('z')) and ibh:len() == 4 and #ibh == 4 and ibh:remove('a') and (not ibh:contains('a')) and ibh:len() == 3 and ibh:remove('b') and ibh:remove('d') and ibh:remove('c') and ibh:empty()
		--and ibhx:contains('a') and (not ibhx:remove('z')) and ibhx:len() == 4 and #ibhx == 4 and ibhx:remove('a') and (not ibhx:contains('a')) and ibhx:len() == 3 and ibhx:remove('b') and ibhx:remove('d') and ibhx:remove('c') and ibhx:empty()
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

print( 'Testing binary min/max heap, direct and indirect' )
local passed, failed = runCases( cases )

if failed > 0 then
	error( 'Failed tests: ' .. failed )
else
	print( 'All passed' )
end
