This code is for the paper "Chevalley-Warning at the Boundary" by Pete L. Clark, Tyler Genao and Freddy Saia. It is written in Magma.

Given positive integer N and prime power q, the functions NonSurj(N,q) and NonSurjExamples(N,q) will determine whether there exists a homogeneous degree N polynomial F defined over F_q:=FiniteField(q) for which its induced evaluation map F:F_q^N -> F_q is not surjective.

In light of Corollary 4.1 of this paper, the projective locus of F in projective (N-1)-space over F_q will have size congruent to 1 mod q if the evaluation map is not surjective.

For the example searches in our paper, we let our code run in Sapelo2, UGA's cluster. 
