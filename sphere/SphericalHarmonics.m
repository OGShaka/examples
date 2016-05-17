%% Spherical harmonics
% Alex Townsend and Grady Wright, May 2016

%%
% (Chebfun example spherefun)
% [Tags: #spherefun, #eigenfunctions, #fourier]

%% 1. Introduction
% <latex>
% Spherical harmonics are the spherical analogue of trigonometric
% polynomials on the interval. The degree $\ell\geq 0$, order $m$ ($-\ell \leq m
% \leq m$) spherical harmonic is typically denoted as
% $Y_{\ell}^{m}(\lambda,\theta)$, and can be expressed in real form as [1, Sec. 14.30]:
% \begin{equation}
% Y_{\ell}^{m}(\lambda,\theta) =
% \begin{cases}
% \sqrt{2} a_{\ell}^{m} P_{\ell}^{m}(\cos\theta)\cos(m\lambda) & m > 0,\\
% a_{\ell}^{0} P_{\ell}(\cos\theta) & m=0, \\
% \sqrt{2} a_{\ell}^{|m|} P_{\ell}^{|m|}(\cos\theta)\sin(m\lambda) & m < 0,
% \end{cases}
% \end{equation}
% where $a_{\ell}^{k}$, $0\leq k \leq \ell$, is a normalization factor
% and $P_{\ell}^{k}$, $0\leq k \leq \ell$, is the degree $\ell$ and
% order $k$ associated Legendre functions [1, Ch. 14].
% Here, we have used the following spherical coordinate parameterization 
% for a point on the unit sphere $\mathbf{x} = (x,y,z)$:
% % $$ x = \cos\lambda\sin\theta,\; y = \sin\lambda\sin\theta,\; z =
% \cos\theta,$$
% where $-\pi \leq lambda \leq \pi$ and $0 \leq \theta \leq \pi$.
% </latex>

%%
% <latex>
% Spherical harmonics can be derived by solving the eigenvalue problem
% for the surface Laplace (Laplace-Beltrami) operator on the sphere; for 
% an alternative derivation see [2, Ch.\ 2].
% This operator can be expressed in the spherical coordinates defined above
% as
% $$ \Delta = \frac{\partial^2}{\partial \theta^2}
% - \frac{\cos\theta}{\sin\theta}\frac{\partial}{\partial\theta} +
% \frac{1}{\sin^2\theta}\frac{\partial^2}{\partial\lambda^2}. $$
% Any degree $\ell\geq 0$ spherical harmonic has the property that 
% $\Delta Y_{\ell}^{m} = -\ell(\ell + 1) Y_{\ell}^{m}$, 
% $-m\leq \ell \leq m$.  So, there are 2\ell+1 eigenfunctions of $\Delta$ 
% with eigenvalue $-\ell(\ell+1)$. Spherical harmonics can also be
% expressed in Cartesian form as polynomials of $x$, $y$, and $z$ [2, Ch.
% 2]. When viewed in this way, one finds that these polynomials all 
% satisfy Laplace's equation in $\mathbb{R}^3$, i.e., they are _harmonic.
% This is where the name spherical harmonics originates and was first used
% by Thompson (Lord Kelvin) and Tait [3, Appendix B].
% </latex>

%%
% <latex>
% By choosing the normalization factors $a_{\ell}^{k}$ in (1) as 
% $$ a_{\ell}^{k} = \sqrt{\frac{(2\ell+1)(\ell-k)!}{4\pi(\ell+m)!}}, $$
% the set of spherical harmonics $\{Y_{\ell}^{m}\}$, $\ell=0,1,\ldots$, 
% $m = -\ell,\ldots,\ell$, is orthonormal, i.e., 
% $$ \int_{-\pi}^{\pi} \int_0^{\pi}
% Y_{ell}^{m}(\lambda,\theta)Y_{ell'}^{m'}(\lambda,\theta)
% \sin\theta\,d\theta d\lambda .$$
% Furthermore, it can be shown that they form a complete orthonormal basis
% for the set of all $L^{2}$ integrable functions on the sphere, 
% $L^{2}(\mathbb{S})$, [2, Sec. 2.8]. For any $f\inL^{2}(\mathbb{S})$, we
% have 
% \begin{equation}
% f(\lambda,\theta) = \sum_{\ell=0}^{\infty\sum_{m=-\ell}^\ell c_{\ell,m} Y_{\ell}^{m}(\lambda,\theta),
% \label{eq:sphHarmEx}
% \end{equation}
% where 
% \begin{equation}
% c_{\ell,m} = \int_{\mathbf{S}^2} f Y_{\ell}^{m}\,dS = \int_{-\pi}^{\pi} \int_0^{\pi}
% f(\lambda,\theta)Y_{ell}^{m}(\lambda,\theta)\,d\theta d\lambda,
% \label{eq:sphCoeffs}
% \end{equation}
% and equality in (\ref{eq:sphHarmEx}) is understood in the mean-square 
% sense. Truncating the outer sum of (\ref{eq:sphHarmEx}) to $N$ gives 
% the best degree in $N$ approximation of $f$ in the $L^2$ norm on the 
% sphere amongst all harmonic polynomials in $\mathbb{R}^3$ of degree 
% $N$ restricted to the sphere [2, Ch. 4].  A spherical harmonic expansion
% gives essentially uniform resolution of a function over the sphere.
% </latex>

%% 2. Spherical harmonics in Spherefun
% While spherical harmonics have many properties that make them 
% mathematically appealing to represent functions on the sphere, the
% technology behind Spherefun does not rely on them.  Instead, it combines
% the double Fourier Sphere sphere method with a low rank 
% approximation method (based on structure preserving Gaussian elimination) 
% for approximating functions on the sphere to approximately machine 
% precision [4]. This hybrid method allows for fast, highly adaptable
% discretizations based on the FFT, with no setup cost.  While fast
% spherical harmonic transforms are available [5], the precomputation cost
% for these algorithms is too high to meet the requirements of Spherefun.

%%
% Nevertheless, given the dominance of spherical harmonics in many
% applications, Spherefun provides several commands that can be used for
% computing with spherical harmonics.  In this and the next four sections
% we discuss some properties of spherical harmonics and show how 
% Spherefun can be used to easily verify them.

%%
% The command |sphharm| constructs a spherical harmonic of a
% given degree and order. For example, $Y_{17}^{13}$ can be constructed and 
% plotted as follows:
Y17 = spherefun.sphharm(17,13);
plot(Y17)

%%
% We can verify that this function is an eigenfunction of the surface 
% Laplacian with eigenvalue $-\ell(\ell+1) = 17(18)$:
norm(laplacian(Y17)-(-17*18)*Y17)

%%
% We can also verify the orthogonality of spherical harmonics on the sphere
% using |sum2|, which computes the integral of a function over the sphere: 
Y13 = spherefun.sphharm(13,7);
sum2(Y13.*Y17)
sum2(Y13.*Y13)
sum2(Y17.*Y17)

%% 
% Spherical harmonics become increasing oscillatory as their degree 
% increases, similar to trigonometric polynomials. 
% Here is a plot of the real spherical harmonics $Y_{\ell}^{m}$, 
% $\ell=0,\ldots,4$ and $0\leq m \leq \ell$, illustrating this feature.
% Black contour lines have been included to where the spherical harmonics
% are zero
N = 4;
for l = 0:N
    for m = 0:l
        Y = spherefun.sphharm(l,m);
        subplot(N+1,N+1,l*(N+1)+m+1), plot(Y), hold on 
        contour(Y,[0 0],'k-'), axis off, hold off
    end
end

%%
% The negative order real spherical harmonics are similar to the positve 
% order ones and only differ by a rotation about the north and 
% south poles.

%% 3. Computing spherical harmonic coefficients
% <latex>
% The computational cost of computing all the spherical harmonic
% coefficients up to degree $N$ of a function directly using an
% approximation of \ref{eq:sphCoeffs} scales like $O(N^4)$.  If $f$ is low
% rank, then the coefficients can be obtained in $O(N^3)$ operations using
% a fast multiplication algorithm and the |sum2| command in Spherefun. As
% noted above, fast $O(N^2\log N)$ algorithms are available for this task
% [5], but these are not yet available in Spherefun.

%%
% <latex>
% As an example, consider the restriction of a Gaussian function, 
% $$ f(x,y,z) = \exp\left(-\frac{(x-x_0)^2 + (y-y_0)^2 + (z-z_0)^2}{\sigma^2}\right),$$
% to the surface of the sphere.  Here we center the Gaussian at a 
% random point $\mathbf{x}_0 = (x_0,y_0,z_0)$ on the sphere:
rng(10)
x0 = 2*rand-1; y0 = sqrt(1-x0^2)*(2*rand-1); z0 = sqrt(1-x0^2-y0^2);
sig = 0.5;
f = spherefun(@(x,y,z) exp(-((x-x0).^2+(y-y0).^2+(z-z0).^2)/sig^2) )
plot(f), title('A Gaussian bump on the sphere')

%%
% The numerical rank of this function is only 21, so we consider it a low
% rank function. The spherical harmonic coefficients of $f$ up to degree 12
% can be computed as follows:
N = 12; k = 1;
coeffs = zeros((N+1)^2,3);
for l = 0:N
    for m = -l:l
        Y = spherefun.sphharm(l,m);
        coeffs(k,1) = sum2(f.*Y);
        coeffs(k,2:3) = [l m];
        k = k + 1;
    end
end
%%
% Since the Gaussian is analytic, the spherical harmonic coefficients decay
% exponentially fast with increasing $\ell$ [2], as the following figure
% illustrates:
stem3(coeffs(:,2),coeffs(:,3),abs(coeffs(:,1)),'filled'), ylim([-N N])
set(gca,'ZScale','log'), set(gca,'Xdir','reverse'), view([-13 18])
xlabel('$\ell$','Interpreter','Latex'), ylabel('m'), zlabel('|coeffs|')

%%
% Here is the degree seven spherical harmonic projection of the Gaussian 
% function given above
fproj = spherefun([]);
k = 1;
for l = 0:7
    for m = -l:l
        fproj = fproj + coeffs(k,1)*spherefun.sphharm(l,m);
        k = k + 1;
    end
end
plot(fproj), title('Degree 6 spherical harmonic projection of the Gaussian');

%%
% <latex>
% As mentioned above, this is the best least squares approximation of
% $f$ of degree 6. Here is what the difference between $f$ and the 
% projection looks like, followed by the $L^2(\mathbb{S}^2)$ norm of the 
% error
% </latex>
plot(f-fproj), colorbar, title('Error in the spherical harmonic projection')
norm(f-fproj)

%% 4. Zonal kernels and the Funk-Hecke formula
% <latex>
% A kernel $\Psi:\mathbf{S}^2 \times \mathbf{S}^2 \rightarrow \mathbf{R}$ is
% called a zonal kernel on the sphere if for any
% $\mathbf{x},\mathbf{y}\in\mathbf{S}^2$, the kernel can be expressed
% solely as a function of the inner product of $\mathbf{x}$ and $\mathbf{y}$, i.e.
% $$ \Psi(\mathbf{x},\mathbf{y}) = \psi(\mathbf{x}^T\mathbf{y}), $$
% where $\psi:[-1,1]\rightarrow\mathbf{R}$. For example, the Gaussian 
% kernel 
% $$ \Psi(\mathbf{x},\mathbf{y}) =
% \exp\left(-\frac{\|\mathbf{x}-\mathbf{y}\|_2^2}{\sigma^2}\right) $$
% restricted to the sphere is a zonal kernel since
% $$ \|\mathbf{x}-\mathbf{y}\|_2 = \sqrt{2-2\mathbf{x}^T\mathbf{y}}, $$
% for any points $\mathbf{x},\mathbf{y}\in\mathbf{S}^2$.  So, for the 
% Gaussian,
% \begin{equation}
% \psi(t) = \exp\left(-\frac{2(1-t)}{\sigma^2}\right).
% \label{eq:zonalGauss}
% \end{equation}
% </latex>

%%
% <latex>
% Zonal kernels have the beautiful property that, for a fixed
% $\mathbf{y}\in\mathbb{S}^2$, their spherical harmonic coefficients satsify
% \begin{equation}
% c_{\ell}^{m} = \int_{\mathbf{S}^2}
% \psi(\mathbf{x}^T\mathbf{y})Y_{\ell}^{m}(\mathbf{x})d\mathbf{x} = \frac{4\pi a_{\ell}}{2\ell+1} Y_{\ell}^{m}(\mathbf{y}),
% \label{eq:funkHecke}
% \end{equation}
% where $a_{\ell}$ are the coefficients in the Legendre series expansion of
% $\psi$, i.e.
% \begin{equation}
% f(t) = \sum_{\ell=0}^{\infty} a_{\ell} P_{k}(t),\;\text{where}\; 
% a_{\ell} = \frac{2\ell+1}{2}\int_{-1}^{1}\psi(t)P_{\ell}(t)dt.
% \end{equation}
% Here $P_{\ell}$ denotes the Legendre polynomial of degree $\ell$.  This
% property is known as the Funk-Hecke formula and holds for any $\psi \in
% L^1(-1,1)$ [2, Sec. 2.5].
% </latex>

%%
% <latex>
% Equation (\ref{eq:funkHecke}) implies that, for a fixed $\ell$, 
% $c_{\ell}^{m}/Y_{\ell}^{m}(\mathbf{y})$, for $-\ell \leq m \leq \ell$, 
% are equal. We can verify this is the case for the Gaussian by taking the
% spherical harmonic coefficients computed in Section 2 and scaling them 
% by the appropriate value of $Y_{\ell}^{m}(\mathbf{x}_0)$.
% </latex>
k = 1;
zonalCoeffs = zeros((N+1).^2,1);
for l = 0:N
    for m = -l:l
        Y = spherefun.sphharm(l,m);
        zonalCoeffs(k) = coeffs(k,1)/Y(x0,y0,z0);
        k = k+1;
    end
end
stem3(coeffs(:,2),coeffs(:,3),abs(zonalCoeffs),'filled')
set(gca,'ZScale','log'), set(gca,'Xdir','reverse'), view([-13 18])
xlabel('$\ell$','Interpreter','Latex'), ylabel('m'), zlabel('|coeffs|')

%%
% <latex>
% We can check the accuracy of the the computed spherical harmonic
% coefficients using the Legendre expansion for $\psi$ in
% (\ref{eq:zonalGauss}).  The coefficients in this expansion are computed
% in [6] and are given by
% $$ a_{\ell} =
% \frac{2\ell+1}{8\sigma}\sqrt{\pi}e^{-\sigma^2/2}I_{\ell+1/2}(2/\sigma^2),
% $$
% where $I$ denoes the modified Bessel function of the first kind.  The
% error in the computed spherical harmonic coefficients in Section 3 is
% then
% </latex>
k = 1;
coeffsExact = zeros((N+1).^2,1);
for l = 0:N
    for m = -l:l
        Y = spherefun.sphharm(l,m);
        a = (2*l+1)/(8*sig)*sqrt(pi)*exp(-2/sig^2).*besseli(l+1/2,2/sig^2);
        coeffsExact(k) = 4*pi/(2*l+1)*a*Y(x0,y0,z0);
        k = k+1;
    end
end
max(abs(coeffs(:,1)-coeffsExact))

%% 5. The Addition Theorem
% <latex>
% A related result to the Funk-Hecke formula is the Addition Theorem for
% spherical harmonics [2, Sec 2.2].  This theorem says the for any 
% $\mathbf{x},\mathbf{y}\in\mathbf{S}^2$, and for $\ell=0,1,\ldots$
% $$ \frac{4\pi}{2\ell + 1} \sum_{m=-\ell}^{\ell} 
% Y_{\ell}^m(\mathbf{x})Y_{\ell}^m(\mathbf{y}) = 
% P_{\ell}(\mathbf{x}^{T}\mathbf{y}) $$,
% where $P_{\ell}$ is the Legendre polynomial of degree $\ell$.  The
% left hand side of this equation for $\ell = 15$ can be constructed as 
% follows:
% </latex>
rng(13)
x0 = 2*rand-1; y0 = sqrt(1-x0^2)*(2*rand-1); z0 = sqrt(1-x0^2-y0^2);
lhs = spherefun([]);
l = 14;
for m=-l:l
    Y = spherefun.sphharm(l,m);
    lhs = lhs + Y.*Y(x0,y0,z0);
end
lhs = 4*pi/(2*l+1)*lhs;
plot(lhs)

%%
% The right hand side can be constructed using |legpoly|:
p15 = legpoly(l);
t = @(x,y,z) (x*x0 + y*y0 + z*z0);
rhs = spherefun(@(x,y,z) feval(p15,t(x,y,z)));
plot(rhs)

%%
% Is the theorem correct?
norm(lhs-rhs)

%% 6. Platonic solids
% Certain low order spherical harmonics can be combined so that they have
% the same rotational symmetries of certain platonic solids.  These
% combinations of spherical harmonics play a key role in the linear
% stability analysis of partial differential equations in spherical
% geometries; see, for example, the work of Busse on convection in
% spherical shells [7].  The combination with tetrahedral symmetry is 
% given by
Y = spherefun.sphharm(3,2);
plot(Y), colormap(jet(2))

%%
% The combination with octahedral symmetry is given by
Y = spherefun.sphharm(4,0) + sqrt(5/7)*spherefun.sphharm(4,4);
plot(Y)

%%
% And the combination with icosahedral symmetry is given by
Y = spherefun.sphharm(6,0) + sqrt(14/11)*spherefun.sphharm(6,5);
plot(Y)

%% References
% [1] F. W. Olver, D. W. Lozier, R. F. Boisver, and C. W. Clark, _NIST
% Handbook of Mathematical Functions_, Cambridge University Press, 2010.
%%
% [2] K. Atkinson and W. Han, _Spherical Harmonics and Approximations on the Unit Sphere: An
% Introduction_, Lecture Notes in Mathematics, Springer, 2012.
%%
% [3] W. Thomson and P. G. Tait. Treatise on Natural Philosophy. 2nd ed.
% Vol. 1, Cambridge: At the University press, 1888.
%%
% [4] A. Townsend, H. Wilber, and G. B. Wright, Computing with function in
% polar and spherical geometries I. The sphere, to appear in 
% _SIAM J. Sci. Comp._, 2016 
%%
% [5] M. Tygert, Fast algorithms for spherical harmonic expansions, III, _
% J. Comput. Phys._, 229 , 6181?6192, 2010.
%%
% [6] Hubbert, S. and Baxter, B., _Radial basis functions for the sphere_, 
% Progress in Multivariate Approximation, Volume 137 of the International
% Series of Numerical Mathematics, Birkhauser, 33-47, 2001.
%%
% [7] F. H. Busse, Patterns of convection in spherical shells. _J. Fluid
% Mech._, 72, 67-85, 1975.