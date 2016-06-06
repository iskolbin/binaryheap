Binary Min Heap
===============

Lua implementation of *priority queue* using *binary min heap*. Note that you can use it as *max heap* -- simply pass negative priorities to the **enqueue** function. If you need efficient removing and changing priorities consider using *indirect binary heap* (see below). 

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
Dequeue from the heap. If the heap is empty then an **error** will raise. Returns an item with minimal priority. Time complexity is *O(logn)*.

peek()
------
Returns the item with minimal priority or **nil** if the heap is empty.

len()
-----
Returns items count. Also you can use **#** operator for the same effect.

empty()
-------
Returns **true** if the heap has no items and **false** otherwise.

batchenq( iparray )
-------------------
Efficiently enqueues list of item-priority pairs into the heap. *Note that this is efficient only when the amount of inserting elements greater or equal than the current length*. Time complexity of this operation in *O(n)* while sequential approach is *O(nlogn)*.


Indirect Binary Heap
====================
If you need to change priority or remove specific item from the heap efficiently you should use this implementation. It's slighthly slower and consumes more memory than direct approach, but allows fast removal and updating priorities by saving the indices of the elements in the heap. *Note that this implementations doesn't allow repeating items*. It has the same methods as direct binary heap and adds follow:

indexof( item )
---------------
Returns index of the **item** in the heap or **nil** otherwise. It can be used for checking does the heap contain the **item**.

remove( item )
--------------
Removes the **item** from the heap. Returns **true** if **item** was in the heap and **false** otherwise.

enqueue( item, priority )
-------------------------
Same as *BinaryHeap.enqueue* but you are not allowed to enqueue the same items and if the heap already contains the **item** then it change it's **priority**.

batchenq( iparray )
-------------------
Same as **BinaryHeap.batchenq** but you are not allowed to enqueue the same items. If the same items are in the **iparray** then it takes the *first priority encountered*.
