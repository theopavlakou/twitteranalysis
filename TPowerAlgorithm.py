from numpy import * 
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
    u = zeros(len(v))
    sortedIndices = list(reversed(argsort(abs(v))))
    vRestricted = v[sortedIndices[0:k]]
    u[sortedIndices[0:k]] = double(vRestricted)/norm(vRestricted)
    u = csc_matrix(u)
    return u
    
