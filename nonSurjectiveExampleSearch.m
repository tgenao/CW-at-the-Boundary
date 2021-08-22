// This code is for the paper "Chevalley-Warning at the Boundary" by Pete L. Clark, Tyler Genao and Freddy Saia. It is written in Magma.
// Given positive integer N and prime power q, the functions NonSurj(N,q) and NonSurjExamples(N,q) will determine whether there exists a homogeneous degree N polynomial F defined over F_q:=FiniteField(q) for which its induced evaluation map F:F_q^N -> F_q is not surjective.
// In light of Corollary 4.1 of this paper, the projective locus of F in projective (N-1)-space over F_q will have size congruent to 1 mod q if the evaluation map is not surjective. 

NonSurj:=function(N,q)
	found:=false;
	F<a>:=GF(q);
	R:=PolynomialRing(F, N);
	NTuples:=CartesianPower([0..N],N);
	// The first step of this code computes all possible binary (coefficients 0,1) monomials of degree N over F_q.
	BinaryMonomials:=[];
	for tuple in NTuples do
		sumOfTerms:=0;
		for term in tuple do
			sumOfTerms:=sumOfTerms+term;
		end for;
		if sumOfTerms eq N then
			monomial:=1;
			for i in [1..N] do
				monomial:=monomial*R.i^(tuple[i]);
			end for;
			Append(~BinaryMonomials,monomial);
		end if;
	end for;
	// Next, we look through all possible linear combinations of our set of binary monomials and see if any one combination has a solution over F_q^N.
	fieldNTuples:={x:x in CartesianPower(F, N)};
	tuplesFromCoeffs:=CartesianPower(F,#BinaryMonomials);
	for coeffs in tuplesFromCoeffs do
		Polynomial:=0;
		for i in [1..#BinaryMonomials] do
			Polynomial:=Polynomial+coeffs[i]*BinaryMonomials[i];
		end for;
		if (Polynomial ne 0) then
			hit:=[];
			for tuple in fieldNTuples do
				value:=Evaluate(Polynomial, tuple);
				if (value in hit) eq false then
					Append(~hit, value);
				end if;
			end for;
			if #hit lt q then
				found:=true;
				break;
			end if;
		end if;
	end for;
	return found;
end function;

// Here's a variant of NonSurj which outputs non-surjective examples into a list. The output list can be empty.
NonSurjExamples:=function(N,q)
	F<a>:=GF(q);
	R:=PolynomialRing(F, N);
	NTuples:=CartesianPower([0..N],N);
	Monomials:=[];
	for tuple in NTuples do
		sumOfTerms:=0;
		for term in tuple do
			sumOfTerms:=sumOfTerms+term;
		end for;
		if sumOfTerms eq N then
			monomial:=1;
			for i in [1..N] do
				monomial:=monomial*R.i^(tuple[i]);
			end for;
			Append(~Monomials,monomial);
		end if;
	end for;
	fieldNTuples:={x:x in CartesianPower(F, N)};
	tuplesFromCoeffs:=CartesianPower(F,#Monomials);
	for coeffs in tuplesFromCoeffs do
		Polynomial:=0;
		for i in [1..#Monomials] do
			Polynomial:=Polynomial+coeffs[i]*Monomials[i];
		end for;
		if (Polynomial ne 0) then
			hit:=[];
			for tuple in fieldNTuples do
				value:=Evaluate(Polynomial, tuple);
				if (value in hit) eq false then
					Append(~hit, value);
				end if;
			end for;
			if #hit lt q then
				SetOutputFile("exampleList.txt");
				Polynomial,",";
				//Append(~nonSurj,[*Polynomial, hit, hitCount*]);
				UnsetOutputFile();
			end if;
		end if;
	end for;
	return 0;
end function;

// E.g. NonSurjExample would be accompanied by code which let it run in the background. As an example, take (N,q)=(3,7).
// NonSurjExample takes a long time to finish running (relatively speaking) for (N,q)=(3,7).
// For the example searches in our paper, we let NonSurjExample (or a variant thereof) run in Sapelo2, UGA's cluster. 
SetOutputFile("exampleList.txt");
"nonSurjList:= [";
UnsetOutputFile();
N:=3;
q:=7;
NonSurjExamples(N,q);
SetOutputFile("exampleList.txt");
"];";
UnsetOutputFile();


// A question for you, the reader. If we let N>2 be an integer with \gcd(N,q-1)>1 there are examples of degree N homogeneous polynomials in N variables which are not surjective, such as the N'th power monomials X_i^N. The converse is not true: if \gcd(N,q-1)=1, then there may be examples of homogeneous degree N polynomials over F_q which are not surjective. Examples were found for (N,q)=(3,2),(4,2),(5,2),(5,3),(6,2),(7,2),(8,2). On the other hand, an exhaustive search shows that there are no non-surjective examples when (N,q)=(2,2),(2,4),(2,8),(2,16),(2,32),(2,64),(2,128),(2,256),(2,512),(2,1024),(2,2048),(3,3),(3,5),(3,8),(3,9),(3,11). So I ask the following, for fun: given an integer N>0, for sufficiently large q with respect to N, does one have that all homogeneous degree N polynomials over F_q have surjective evaluation map iff \gcd(N,q-1)=1?