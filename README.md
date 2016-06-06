Binary Min Heap
===============

Lua implementation of **Priority Queue** using **Binary Min Heap**. Note that you can use it as **Max Heap** -- simply pass negative priorities to **enqueue** function. If you need efficient removing and changing priorities consider using **Indirect Binary Heap**. 

BinaryHeap.new( [iparray] )
---------------------------
Create new binary heap. You can pass iparray to initialize heap with _O(n)_ complexity(implemented with **batchenq**, see below).

enqueue( item, priority )
-------------------------
Enqueue the **item** with the **priority** to the heap. The **priority** must be comarable, i.e. it must be either number or string or a table with metatable with **__lt** metamethod defined. Time complexity is _O(logn)_.

dequeue()
---------
Dequeue from the heap. If the heap is empty **error** called. Returns an item with minimal priority. Time complexity is _O(logn)_.

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
Efficiently enqueues list of item-priority pairs into the heap. *Note that this is efficient only when the amount of inserting elements greater or equal than the current length*. Time complexity of this operation in _O(n)_ while sequential approach is _O(nlogn)_.


Indirect Binary Heap
====================
If you need to change priority or remove specific item for the heap efficiently you should use this implementation. It's slighthly slower and consumes more memory than direct approach, but allows fast removal and updating priorities by saving of locations of elements in the heap. _Note that this implementations doesn't allow repeating items_. It has the same methods as common binary heap and adds follow:

indexof( item )
---------------
Returns index of the **item** in the heap or **nil** otherwise. It can be used for checking is the heap contains the **item**.

remove( item )
--------------
Removes the **item** from the heap. Returns **true** if **item** was in the heap and **false** otherwise.

enqueue( item, priority )
-------------------------
Same as _BinaryHeap.enqueue_ but you are not allowed to enqueue the same items and if the heap already contains the **item** then it change it's **priority**.

batchenq( iparray )
-------------------
Same as _BinaryHeap.batchenq_ but you are not allowed to enqueue the same items. If the same items are in the **iparray** then it takes the _first priority encountered_.
