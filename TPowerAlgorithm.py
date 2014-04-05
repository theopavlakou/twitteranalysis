from numpy import dot 
from numpy import array
from scipy import * 
from numpy.linalg import *
from scipy.sparse import *

class TPowerAlgorithm:
  """ A class to perform the TPower algorithm. """
  def truncateOperator(self, v, k):
    """ Performs the truncate operation for a vector in the TPower
    algorithm. 
    Inputs:
      v:      The vector to truncate
      k:      The number of elements of the vector to keep
    Outputs:
      u:      The v vector zeroed apart from the k highest elements.
    """
    print("--- Truncate Operator ---")
    u = zeros(v.shape[0])
    print("--- Printing v --- ")
    print(v)
    # TODO make reversed
    #sortedIndices = array(list(reversed(argsort(abs(v), axis=0))))
    sortedIndices = argsort(abs(v), axis=0)
    sortedIndices = fliplr(sortedIndices.T).T
    print("Sorted: ")
    print(sortedIndices)
    vRestricted = v[sortedIndices[0:k],0]
    normV = 0
    if isinstance(vRestricted, csc_matrix):
      normV = norm(vRestricted.todense())
    else:
      normV = norm(vRestricted)
    if normV == 0:
      return csc_matrix(zeros(v.shape[0]))
    a = array(double(vRestricted))/normV
    print("Printing a")
    print(a)
    print(a.shape)

    print(sortedIndices)
    u[sortedIndices[0:k]] = a[0:k, 0]
    print(a[0:k, 0])
    print(u)
    u = csc_matrix(u)
    return u
    
  def getSparsePC(self, A, k):
    
    tolerance = 0.0000001
    maxIterations = 50
    # Initialisation
    # TODO
    # This initialises the first element to 1.
    # Should be fixed.
    x0 = zeros(A.shape[0])
    x0[0] = 1

    x = csc_matrix(x0)

    # Power step
    s = dot(A, transpose(x.todense()))
    print("--- s vector is ----")
    print(s)
    g = 2*s
    print("--- Calculating f ---")
    f = dot(x.todense(), s)
    print("--- Printing f ---")
    print(f)

    # Truncate step
    x = self.truncateOperator(g, k)
    fOld = f
    i = 1

    # Main Loop
    while i <= maxIterations:
      s = dot(A, transpose(x.todense()))
      g = 2*s
      x = self.truncateOperator(g, k)
      print("--- Printing x ----")
      print(x)
      f = dot(x.todense(), s)

      if (abs(f - fOld) < tolerance):
        print("=== Breaking ===")
        break

      fOld = f
      i += 1

    return x, f


      
