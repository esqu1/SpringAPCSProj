public class Container<E> {
  // because I'm too cool for ArrayList...
  private E[] elements;
  private int capacity, size;
  @SuppressWarnings("unchecked")
  public Container(int c) {
    elements = (E[]) new Object[c];
    capacity = c;
  }
  public int size() {
    return size;
  }
  public E get(int pos) {
    return elements[pos];
  }
  public void add(E e) {
    elements[size++] = e;
  }
  public E remove(int pos) {
    E result = elements[pos];
    for (int i = pos; i < size - 1;)
      elements[i] = elements[++i];
    size--;
    return result;
  }
}
