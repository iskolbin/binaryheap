Binary Heap
===========

Lua implementation of *priority queue* data structure using *binary heap*. There are 4 modules: *BinaryMinHeap*, *BinaryMaxHeap*, *IndirectBinaryMinHeap* and *IndirectBinaryMaxHeap*.
*Min* and *Max* implementations differ only in ordering. Indirect heaps offer efficient removal and updating priority operations.

BinaryHeap.new( [iparray] )
---------------------------
Create new binary heap. You can pass **iparray** to initialize heap with *O(n)* complexity (implemented with **batchenq**, see below).

```lua
local heap = BinaryHeap.new()
```

```lua
local heap = BinaryHeap()
```

```lua
local security = BinaryHeap{ 
	'high', 1, 
	'low', 10, 
	'moderate', 5, 
	'moderate-', 7, 
	'moderate+', 3}
```

enqueue( item, priority )
-------------------------
Enqueue the **item** with the **priority** to the heap. The **priority** must be comparable, i.e. it must be either number or string or a table with metatable with **__lt** metamethod defined. Time complexity is *O(logn)*.

dequeue()
---------
Dequeue from the heap. If the heap is empty then an **error** will raise. Returns an item with minimal priority for BinaryMinHeap(maximal for BinaryMaxHeap). Time complexity is *O(logn)*.

peek()
------
Returns the item with minimal priority for BinaryMinHeap(maximal for BinaryMaxHeap) or **nil** if the heap is empty.

len()
-----
Returns items count. Also you can use **#** operator for the same effect.

empty()
-------
Returns **true** if the heap has no items and **false** otherwise.

batchenq( iparray )
-------------------
Efficiently enqueues list of item-priority pairs into the heap. *Note that this is efficient only when the amount of inserting elements greater or equal than the current length*. Time complexity of this operation in *O(n)* while sequential approach is *O(nlogn)*.

contains( item )
---------------
Checking that heap contains the **item**. This operation is *O(n)* for direct binary heaps.

remove( item )
--------------
Removes the **item** from the heap. Returns **true** if **item** was in the heap and **false** otherwise. This operation is *O(n)* for direct binary heaps.

update( item, priority )
------------------------
Changes **item** **priority**. Returns **true** if **item** was in the heap (even if priority not changed) and **false** otherwise. This operation is *O(n)* for direct binary heaps, internally it's just **remove** followed by **enqueue**.

Indirect Binary Heap
====================
If you need to change priority or remove specific item from the heap efficiently you should use this implementation. It's slighthly slower and consumes more memory than direct approach, but allows fast removal and updating priorities by saving the indices of the elements in the heap. *Note that this implementations doesn't allow repeating items*. It has the same methods, but has some differences in their behavior:

enqueue( item, priority )
-------------------------
Same as **BinaryHeap.enqueue** but you are not allowed to enqueue the same items and if the heap already contains the **item** then error is thrown.

batchenq( iparray )
-------------------
Same as **BinaryHeap.batchenq** but you are not allowed to enqueue the same items. If the same items are in the **iparray** then error is thrown.

contains( item )
----------------
Has *O(1)* performance.

remove( item )
--------------
Has *O(logn)* performance.

update( item, priority )
------------------------
Has *O(logn)* performance.
