from TPowerAlgorithm import * 
tp = TPowerAlgorithm()
"""
# Test the truncateOperator() method works
v = array([2.0, 8.0, 5.0, 7.0, 1.0])
tp = TPowerAlgorithm()
u = tp.truncateOperator(v, 2)
print("--- Result of Truncate Operator --- ")
print(u)
"""
# Test the getSparsePC algorithm works
V = zeros((10, 2))
V[0,0] = 5
V[1,0] = 2
V[8,1] = 9
V[9,1] = 8
L = diag([20, 10])
intermediate = dot(V, L)
A = dot(intermediate, transpose(V))
print("=== Printing A ====")
print(A.shape)
print(A)
[x, f] = tp.getSparsePC(A, 2)
print("=== Printing Results ===")
print(x)
print(f)
