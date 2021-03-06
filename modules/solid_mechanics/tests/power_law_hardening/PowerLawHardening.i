# This is a test of the isotropic power law hardening constitutive model.
# In this problem, a single Hex 8 element is fixed at the bottom and pulled at the top
# at a constant rate of 0.1.
# Before yield, stress = strain (=0.1*t) as youngs modulus is 1.0.
# The yield stress for this problem is 0.25 ( as strength coefficient is 0.5 and strain rate exponent is 0.5).
# Therefore, the material should start yielding at t = 2.5 seconds and then follow stress = K *pow(strain,n) or
# stress ~ 0.5*pow(0.1*t,0.5).

[Mesh]
  file = 1x1x1cube.e
[]

[Variables]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]

  [./disp_y]
    order = FIRST
    family = LAGRANGE
  [../]

  [./disp_z]
    order = FIRST
    family = LAGRANGE
  [../]
[]


[AuxVariables]

  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./total_strain_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]


[Functions]
  [./top_pull]
    type = ParsedFunction
    value = t*(0.1)
  [../]
[]

[SolidMechanics]
  [./solid]
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
  [../]
[]


[AuxKernels]

  [./stress_yy]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_yy
    index = 1
  [../]

  [./total_strain_yy]
    type = MaterialTensorAux
    tensor = total_strain
    variable = total_strain_yy
    index = 1
  [../]
 []


[BCs]

  [./y_pull_function]
    type = FunctionPresetBC
    variable = disp_y
    boundary = 5
    function = top_pull
  [../]

  [./x_bot]
    type = PresetBC
    variable = disp_x
    boundary = 4
    value = 0.0
  [../]

  [./y_bot]
    type = PresetBC
    variable = disp_y
    boundary = 3
    value = 0.0
  [../]

  [./z_bot]
    type = PresetBC
    variable = disp_z
    boundary = 2
    value = 0.0
  [../]

[]

[Materials]
  [./vermont]
    type = SolidModel
    formulation = lINeaR
    block = 1
    youngs_modulus = 1.0
    poissons_ratio = 0.0
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
    constitutive_model = powerlaw
  [../]
  [./powerlaw]
    type = IsotropicPowerLawHardening
    block = 1
    strength_coefficient = 0.5 #K
    strain_hardening_exponent = 0.5 #n
  [../]

[]

[Executioner]
  type = Transient

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'


  petsc_options = '-ksp_snes_ew'
  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter'
  petsc_options_value = '201                hypre    boomeramg      4'


  line_search = 'none'


  l_max_its = 100
  nl_max_its = 100
  nl_rel_tol = 1e-12
  nl_abs_tol = 1e-10
  l_tol = 1e-9

  start_time = 0.0
  end_time = 7.4
  dt = 0.01
[]

[Postprocessors]
  [./stress_yy]
    type = ElementalVariableValue
    elementid = 0
    variable = stress_yy
  [../]
  [./strain_yy]
    type = ElementalVariableValue
    elementid = 0
    variable = total_strain_yy
  [../]
[]


[Outputs]
  [./out]
    type = Exodus
    elemental_as_nodal = true
  [../]
[]
