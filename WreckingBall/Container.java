public class Container<E> {
  // because I'm too cool for ArrayList...
  private E[] elements;
  private int capacity, size;
  @SuppressWarnings("unchecked")
  public Container(int c) {
    elements = (E[]) new Object[c];
    capacity = c;
  }
  @SuppressWarnings("unchecked")
  public Container() {
    elements = (E[]) new Object[1];
    capacity = 1;
  }
  public int size() {
    return size;
  }
  public E get(int pos) {
    return elements[pos];
  }
  @SuppressWarnings("unchecked")
  public void add(E e) {
    if (size == capacity) {
      capacity *= 2;
      E[] temp = (E[]) new Object[capacity];
      for (int i = 0; i < size; i++)
        temp[i] = elements[i];
      elements = temp;
    }
    elements[size++] = e;
  }
  public E remove(int pos) {
    E result = elements[pos];
    for (int i = pos; i < size - 1;)
      elements[i] = elements[++i];
    size--;
    return result;
  }
  public void remove(E e) {
    int i;
    for (i = size - 1; i > -1 ; i--)
      if (elements[i].equals(e))
        break;
    if (i > -1) {
      while (i < size - 1)
        elements[i] = elements[++i];
      size--;
    }
  }
}
