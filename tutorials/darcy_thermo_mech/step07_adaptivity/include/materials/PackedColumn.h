/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*           (c) 2010 Battelle Energy Alliance, LLC             */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/
#ifndef PACKEDCOLUMN_H_
#define PACKEDCOLUMN_H_

#include "Material.h"

// A helper class from MOOSE that linear interpolates x,y data
#include "LinearInterpolation.h"

class PackedColumn;

template<>
InputParameters validParams<PackedColumn>();

/**
 * Material objects inherit from Material and override computeQpProperties.
 *
 * Their job is to declare properties for use by other objects in the
 * calculation such as Kernels and BoundaryConditions.
 */
class PackedColumn : public Material
{
public:
  PackedColumn(const InputParameters & parameters);

protected:
  /**
   * Necessary override.  This is where the values of the properties
   * are computed.
   */
  virtual void computeQpProperties() override;

  /// The radius of the balls in the column
  const Real & _ball_radius;

  /// Based on the paper this will
  LinearInterpolation _permeability_interpolation;

  /// The permeability (K)
  MaterialProperty<Real> & _permeability;

  /// The porosity (eps)
  MaterialProperty<Real> & _porosity;

  /// The viscosity of the fluid (mu)
  MaterialProperty<Real> & _viscosity;

  /// The bulk thermal conductivity
  MaterialProperty<Real> & _thermal_conductivity;

  /// The bulk heat capacity
  MaterialProperty<Real> & _heat_capacity;

  /// The bulk density
  MaterialProperty<Real> & _density;
};

#endif //PACKEDCOLUMN_H
