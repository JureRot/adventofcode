Queue = {}

function Queue.new()
	return { first = 0, last = -1 }
end

function Queue.pushleft(q, value)
	local first = q.first - 1

	q.first = first -- update queues first index one to the left
	q[first] = value -- set the value at that indes to input value
end

function Queue.pushright(q, value)
	local last = q.last + 1

	q.last = last -- update queues last index one to the right
	q[last] = value -- set the value at that indes to input value
end

function Queue.popleft(q)
	local first = q.first

	-- check if queue is empty by comparing first and last indexes
	if (first > q.last) then
		error("queue is empty")
	end

	local value = q[first] -- get value at current first (most left) location
	q[first] = nil -- set that value to null (to allow garbage collection)
	q.first = first + 1 -- update the first index to one to the right
	return value
end

function Queue.popright(q)
	local last = q.last

	-- check if queue is empty by comparing first and last indexes
	if (last < q.first) then
		error("queue is empty")
	end

	local value = q[last] -- get value at current last (most right) location
	q[last] = nil -- set that value to null (to allow garbage collection)
	q.last = last - 1 -- update the last index to one to the left
	return value
end

function Queue.add(q, value)
	return Queue.pushright(q, value)
end

function Queue.remove(q)
	return Queue.popleft(q)
end

function Queue.count(q)
	return q.last - q.first + 1
end

return Queue
