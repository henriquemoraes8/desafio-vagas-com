class PriorityQueue
  def initialize
    @queue = [nil]
  end

  def <<(element)
    @queue << element
    heapify_up(@queue.size - 1)
  end

  def pop
    return nil if @queue.size == 1
    swap(1, @queue.size - 1)

    max = @queue.pop()
    heapify_down(1)

    max
  end

  def size
    @queue.size - 1
  end

  private

  def heapify_up(index)
    parent_index = (index / 2)

    return if index <= 1

    return if @queue[parent_index] >= @queue[index]

    swap(index, parent_index)

    heapify_up(parent_index)
  end

  def heapify_down(index)
    left = index * 2
    right = index * 2 + 1

    return if left > @queue.size - 1

    if @queue[left] > @queue[index] && @queue[left] > @queue[right]
      swap(left, index)
      heapify_down(left)
    elsif !@queue[right].nil? && @queue[right] > @queue[index] && @queue[right] > @queue[left]
      swap(right, index)
      heapify_down(right)
    end
  end

  def swap(element1, element2)
    @queue[element1], @queue[element2] = @queue[element2], @queue[element1]
  end

end