# Identify R package dependencies

Identifies the full package dependencies of all installed R packages



# Overview

The script in the file `package_dependencies.R` generates a `data.table`
in the variable `deps` containing the **dependencies of all installed packages**

1. the required packages for each package (column "requires")
2. all packages that require a package (column "required_by")

It also shows all packages that are installed in parallel (in different versions).

The dependencies do consider all direct and indirect dependencies (dependency recursion).



# How to use it

Just source the R script file and view the results in the variable `deps`:

`source("package_dependencies.R")`



# Use cases

## Estimate the impact before uninstalling package

## Find out why a package was installed implicitly

## Try to find out if you use this package at all (directly or indirectly)



# License

This R script file is published under the
GNU LESSER GENERAL PUBLIC LICENSE Version 3, 29 June 2007.

For details see the contained `LICENSE` text file.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
