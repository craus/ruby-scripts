def f x, y
  throw 'e' if x+y == 0
  return 0 if x+y == 1
	return 1 if y == 0
	return [fun(