import numpy as np

class QP_Solver():
	def __init__(self, x_0, Q, q, AE, AI, b_e, b_i):
	self.x_0 = x_0
	self.Q = Q
	self.q = q
	self.AE = AE
	self.AI = AI
	self.b_e = b_e
	self.b_i = b_i

	def run(self):
		x_t = self.x_0
		b_e_out = np.dot(self.AE, x_t)
		assert b_e_out == self.b_e

		b_i_out = np.dot(self.AI, x_t)
		assert b_i_out >= self.b_i
		while not stop:
			A = np.append(self.AE, self.AI[b_i_out==self.b_i], axis=0)

			qp_mat = np.append(np.append(Q, -A.T, axis=1). np.append(A,\
				np.zeros((A.shape[0], A.shape[0])), axis=1), axis=0)

			q_prime = np.dot(Q, x_t)+q
			sol = np.dot(np.linalg.inv(qp_mat), np.append(-q_prime,\
				np.zeros((A.shape[0]))))
			d = sol[:Q.shape[0]]
			langrange = sol[Q.shape[0]:]

			tmp = np.dot( self.AI[b_i_out> self.b_i], d)
			unfeasible = tmp < 0

			alpha = min(1, np.min(np.divide(self.b_i-np.dot(self.AI[b_i_out>self.b_i], x_t), tmp[unfeasible])))

			if np.dot(d, d) < 1e-6:
				if np.all(langrange) >=0:
					stop = True
				else:
					# Buscar el multiplicador infactible
			else:
				x_t += (alpha*d)

