%% build_system
% Run MaxwellFDS.

%%% Syntax
%  [osc, grid3d, s_factor_cell, eps_face_cell, mu_edge_cell, J_cell, E0_cell] = build_system(FREQ, DOMAIN, OBJ, SRC, [progmark])
%  [..., obj_array, src_array] = build_system(FREQ, DOMAIN, OBJ, SRC, [pragmark])
%  [..., eps_node_array, mu_node_array] = build_system(FREQ, DOMAIN, OBJ, SRC, [pragmark])


%%% Description
% |build_system(FREQ, DOMAIN, OBJ, SRC, [progmark])| constructs a system from
% given objects and sources.  The constructed system is typically used inside
% <maxwell_run.html maxwell_run>.
%
% Each of |FREQ|, |DOMAIN|, |OBJ|, and |SRC| represents a group of parameters.
% Each group supports several flexible expressions.  For more details, see the
% relevant sections about the input parameter groups in <maxwell_run.html
% |maxwell_run|>.
%
% An additional input parameter |progmark| is an instance of <ProgMark.html
% ProgMark>, which outputs the progress of the system build procedure as the
% standard output.  If it is not given, then it is created internally.
%
% |[osc, grid3d, s_factor_cell, eps_face_cell, mu_edge_cell, J_cell, E0_cell] =
% build_system(...)| returns
%
% * |osc|, an instance of <Oscillation.html Oscillation>
% * |grid3d|, an instance of <Grid3d.html Grid3d>, 
% * |s_factor_cell|, a cell array of PML s-factors: |{sx_array, sy_array,
% sz_array}|
% * |eps_face_cell|, a cell array of electric permittivity evaluated at the
% centers of the finite-difference grid faces: |{eps_xx_array, eps_yy_array,
% eps_zz_array}|
% * |mu_edge_cell|,  a cell array of magnetic permeability evaluated at the
% centers of the finite-difference grid edges: |{mu_xx_array, mu_yy_array,
% mu_zz_array}|
% * |J_cell|, a cell array of electric current sources: |{Jx_array, Jy_array,
% Jz_array}|
% * |E0_cell|, a cell array of initial guess electric fields of iterative
% solvers: |{E0x_array, E0y_array, E0z_array}|
% 
% |[..., obj_array, src_array] = build_system(...)| returns additionally arrays
% of instances of <Object.html |Object|> and <Source.html |Source|>.  The
% |Object| and |Source| elements represent the objects and sources placed in the
% simulation domain, so they can be used to visualize the simulation domain.
%
% |[..., eps_node, mu_node] = build_system(...)| returns additionally arrays of
% electric permittivity and magnetic permeability evaluated at the nodes of the
% finite-difference grid.


%%% Example
%   gray = [0.5 0.5 0.5];  % [r g b]
%   [E, H, obj_array, err] = build_system(1e-9, 1550, ...  % FREQ
%       {['Palik', filesep, 'SiO2'], 'none'}, [-700, 700; -600, 600; -200, 1700], 20, BC.p, 200, ...  % DOMAIN
%       {['Palik', filesep, 'SiO2'], 'none'}, Box([-50, 50; -50, 50; -200, 1700], [2, 2, 20]), ...  % OBJ1
%       {['Hagemann', filesep, 'Ag'], gray}, [Box([-700, -25; -25, 25; -200, 1700], 20), Box([25, 700; -25, 25; -200, 1700], 20)], ...  % OBJ2
%       PointSrc(Axis.x, [0, 0, 200]), ...  % SRC
%       );

function [osc, grid3d, s_factor_cell, eps_face_cell, mu_edge_cell, J_cell, E0_cell, obj_array, src_array, eps_node_array, mu_node_array] = build_system(varargin)
% 	fprintf('%s begins.\n', mfilename);
% 	pm = ProgMark();
	pm = varargin{end};
	if ~istypesizeof(pm, 'ProgMark')
		pm = ProgMark();
	end
	iarg = 0;
	
	% Set up a length unit and wavelength.
	iarg = iarg + 1; arg = varargin{iarg};
	chkarg((istypesizeof(arg, 'real') && arg > 0) || istypesizeof(arg, 'Oscillation'), ...
		'"argument %d should be either "L0" (positive) or "osc" (instance of Oscillation).', iarg);
	if istypesizeof(arg, 'real')
		L0 = arg;
		iarg = iarg + 1; wvlen = varargin{iarg};
		chkarg(istypesizeof(wvlen, 'real') && wvlen > 0, 'argument %d should be "wvlen" (positive).', iarg);
		unit = PhysUnit(L0);
		osc = Oscillation(wvlen, unit);
	else  % arg is instance of Oscillation
		osc = arg;
		unit = osc.unit;
	end
	
	% Set up a domain.
	function material = create_material(varargin)
		if nargin == 2
			material = Material.create(varargin{:}, osc);
		else
			material = Material(varargin{:});
		end
	end

	iarg = iarg + 1; arg = varargin{iarg};
	chkarg(iscell(arg) || istypesizeof(arg, 'Material') || istypesizeof(arg, 'Object'), ...
		'argument %d should be cell, instance of Material, or instance of Object.', iarg);
	if istypesizeof(arg, 'Object')
		obj_dom = arg;
		domain = obj_dom.shape;
		chkarg(istypesizeof(domain, 'Domain'), 'argument %d should be instance of Object with Domain as its shape.', iarg);
	else
		if iscell(arg)
			mat_dom = create_material(arg{:});
		else
			assert(istypesizeof(arg, 'Material'));
			mat_dom = arg;
		end
		
		iarg = iarg + 1; arg = varargin{iarg};
		chkarg(istypesizeof(arg, 'real', [Axis.count, Sign.count]) || istypesizeof(arg, 'Domain'), ...
			'argument %d should be either "box_dom" ([xmin xmax; ymin ymax; zmin zmax]) or "domain" (instance of Domain).', iarg);
		if istypesizeof(arg, 'real', [Axis.count, Sign.count])
			box_domain = arg;
			iarg = iarg + 1; dl_domain = varargin{iarg};
			chkarg(istypeof(dl_domain, 'real') && isexpandable2row(dl_domain, Axis.count), ...
				'"argument %d should be dl_domain (positive number or length-%d row vector of positive numbers).', iarg, Axis.count);
			domain = Domain(box_domain, expand2row(dl_domain, Axis.count));
		else  % arg is instance of Domain
			domain = arg;
		end
		obj_dom = Object(domain, mat_dom);
	end
	
	% Set up boundary conditions and PML thicknesses.
	iarg = iarg + 1; bc = varargin{iarg};
	chkarg(istypeof(bc, 'BC') && isexpandable2mat(bc, Axis.count, Sign.count), ...
		'argument %d should be "bc" (scalar, length-%d row vector, or %d-by-%d matrix with BC as elements).', iarg, Axis.count, Axis.count, Sign.count);
	iarg = iarg + 1; Lpml = varargin{iarg};
	chkarg(istypeof(Lpml, 'real') && isexpandable2mat(Lpml, Axis.count, Sign.count) && all(all(Lpml>=0)), ...
		'argument %d should be "Lpml" (scalar, length-%d row vector, or %d-by-%d matrix with nonnegative numbers as elements).', iarg, Axis.count, Axis.count, Sign.count);
	
	% Set up a flag to generate a grid dynamically.
	iarg = iarg + 1; arg = varargin{iarg};
	withuniformgrid = false;  % generate a grid dynamically by default.
	if istypesizeof(arg, 'logical')
		withuniformgrid = arg;
		iarg = iarg + 1; arg = varargin{iarg};
	end
	
	% Set up eps and mu
	shape_array = Shape.empty();
	obj_array = Object.empty();
	if istypesizeof(arg, 'complex', [0 0 0])
		isepsgiven = true;
		eps_node_array = arg;
		mu_node_array = ones(size(eps_node_array));
	else
		isepsgiven = false;
		% Set up objects.
% 		while ~istypesizeof(arg, 'Source', [1 0])
% 			chkarg(iscell(arg) || istypesizeof(arg, 'Material') || istypesizeof(arg, 'Object', [1 0]), ...
% 				'argument %d should be cell, instance of Material, or row vector with Object as elements.', iarg);
		while iscell(arg) || istypesizeof(arg, 'Material') || istypesizeof(arg, 'Object', [1 0])
			if istypesizeof(arg, 'Object', [1 0])
				objs = arg;
				obj_array = [obj_array(1:end), objs];
				for obj = objs
					shape_array = [shape_array(1:end), obj.shape];
				end
				iarg = iarg + 1; arg = varargin{iarg};
			else
				if iscell(arg)
					mat = create_material(arg{:});
				else
					assert(istypesizeof(arg, 'Material'));
					mat = arg;
				end

				iarg = iarg + 1; arg = varargin{iarg};
% 				while ~iscell(arg) && ~istypesizeof(arg, 'Material') && ~istypesizeof(arg, 'Source')
% 					chkarg(istypesizeof(arg, 'Shape', [1 0]), 'argument %d should be row vector with Shape as elements.', iarg);
				while istypesizeof(arg, 'Shape', [1 0])
					shapes = arg;
					shape_array = [shape_array(1:end), shapes];
					objs = Object(shapes, mat);
					obj_array = [obj_array(1:end), objs];
					iarg = iarg + 1; arg = varargin{iarg};
				end
			end
		end
	end
	obj_array = [obj_dom, obj_array];
	
	% Set up sources.
% 	assert(istypesizeof(arg, 'Source', [1 0]));
% 	src_array = arg;
% 	iarg = iarg + 1; arg = varargin{iarg};
	src_array = [];
	if ~istypesizeof(varargin{iarg}, 'Source', [1 0])
		warning('FDS:buildSys', 'No source is given.');
	end
	
	while iarg <= nargin && istypesizeof(varargin{iarg}, 'Source', [1 0])
		src_array = [src_array(1:end), arg];
		iarg = iarg + 1; arg = varargin{iarg};
	end
	
% % 	tol = 1e-6;
% % 	maxit = 1e5;
% % 	inspect_only = false;
% 	if iarg <= nargin && ~istypesizeof(varargin{iarg}, 'logical')
% 		tol = varargin{iarg};
% 		chkarg(istypesizeof(tol, 'real') && tol > 0, ...
% 			'argument %d should be "tol_iter" (positive).', iarg);
% 		iarg = iarg + 1;
% 	end
% 
% 	if iarg <= nargin && ~istypesizeof(varargin{iarg}, 'logical')
% 		maxit = varargin{iarg};
% 		chkarg(istypesizeof(maxit, 'real') && maxit > 0, ...
% 			'argument %d should be "max_niter" (positive).', iarg);
% 		iarg = iarg + 1;
% 	end
% 
% 	if iarg <= nargin
% 		inspect_only = varargin{iarg};
% 		chkarg(istypesizeof(inspect_only, 'logical'), ...
% 			'argument %d should be "inspect_only" (logical).', iarg);
% 		iarg = iarg + 1;
% 	end
	chkarg(iarg <= nargin, 'more arguments than expected.');
	pm.mark('initial setup');

	% Generate a grid.
	[lprim, Npml] = generate_lprim3d(domain, Lpml, shape_array, src_array, withuniformgrid);
	grid3d = Grid3d(unit, lprim, Npml, bc);
	if withuniformgrid
		pm.mark('uniform grid generation');
	else
		pm.mark('dynamic grid generation');
	end		

	% Construct material parameters.
	if ~isepsgiven
		[eps_node_array, mu_node_array] = assign_material_node(grid3d, obj_array);
	end
	eps_face_cell = harmonic_mean_eps_node(eps_node_array);
	mu_edge_cell = arithmetic_mean_mu_node(mu_node_array);

	% Construct PML s-factors.
	s_factor_cell = generate_s_factor(osc.in_omega0(), grid3d);
	pm.mark('eps and mu assignment');
		
	% Solve for modes.
	for src = src_array
		if istypesizeof(src, 'DistributedSrc')
			distsrc = src;
			prep_distsrc(osc, grid3d, eps_face_cell, mu_edge_cell, s_factor_cell, distsrc);

			[h, v, n] = cycle(distsrc.normal_axis);
			grid2d = Grid2d(grid3d, n);

			Jh2d = array2scalar(distsrc.Jh, PhysQ.J, grid2d, h, GK.dual, osc, distsrc.intercept);
			Jv2d = array2scalar(distsrc.Jv, PhysQ.J, grid2d, v, GK.dual, osc, distsrc.intercept);
			cmax = max(abs([Jh2d.array(:); Jv2d.array(:)]));
			
			opts.withabs = true;
			opts.cmax = cmax;
			figure;
			set(gcf, 'units','normalized','position',[0 0.5 0.5 0.5]);			
			vis2d(Jh2d, obj_array, opts);
			drawnow;

			figure;
			set(gcf, 'units','normalized','position',[0.5 0.5 0.5 0.5]);			
			vis2d(Jv2d, obj_array, opts);
			drawnow;

			neff = distsrc.neff;
			beta = 2*pi*neff / osc.in_L0();
			pm.mark('mode calculation');
			fprintf('\tbeta = %e, n_eff = %e\n', beta, neff);
		end
	end

	% Construct sources.
	J_cell = assign_source(grid3d, src_array);
	pm.mark('J assignment');

	% Construct a random initial E-field.
	E0_cell = cell(1, Axis.count);
	for w = Axis.elems
% 		Ew0 = rand(grid3d.N) + 1i*rand(grid3d.N);
% 		Ew0 = Ew0 / norm(Ew0(:));
		Ew0 = zeros(grid3d.N);
		E0_cell{w} = Ew0;
	end
	pm.mark('E0 assignment');
end
