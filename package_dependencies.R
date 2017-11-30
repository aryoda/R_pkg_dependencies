library(data.table)

# ***************************************************************************
# Copyright (C) 2016 Juergen Altfeld (R@altfeld-im.de)
# ---------------------------------------------------------------------------
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# ***************************************************************************

# ================================================================================================
#
# This script generates a data.table in the variable "deps" containing all installed packages and
# 1. the required packages for each package (column "requires")
# 2. all packages that require a package (column "required_by")
#
# It also shows all packages that are installed in parallel (in different versions).
#
# The dependencies do consider all direct and indirect dependencies (dependency recursion).
#
# ================================================================================================

# Background information:
# https://stackoverflow.com/questions/38686427/determine-minimum-r-version-for-all-package-dependencies/38687310?noredirect=1#comment64767951_38687310
# https://stackoverflow.com/a/40009614/4468078
# https://stackoverflow.com/questions/14645363/listing-r-package-dependencies-without-installing-packages
# https://stackoverflow.com/questions/4090169/elegant-way-to-check-for-missing-packages-and-install-them?rq=1
# https://stackoverflow.com/questions/47582588/discover-all-installed-r-packages-with-a-java-dependency-for-security-reasons/47583165#47583165



# all installed packages
avail <- as.data.table(installed.packages())

# extract the relevant columns
deps <- avail[, .(Package, Version, Depends, Imports, Enhances, LinkingTo)]

# Show duplicated packages (same package installed in different versions)
duplicated.pkgs <- deps[duplicated(deps$Package), Package]
deps[Package %in% duplicated.pkgs]

# remove duplicated packages (due to different versions and multiple package locations)
# and order by package names
deps <- deps[order(-Version)][, utils::head(.SD, 1), by = .(Package)][order(Package)]   # [Package %in% c("colorspace", "RColorBrewer")]

# Returns a named vector of strings with all (reverse) dependent packages of a package name (vector)
get.deps <- function(package.names, db, reverse = FALSE) {
  dep.pkgs <- tools::package_dependencies(package.names,
                                          db,
                                          which = c("Depends", "Imports", "Enhances", "LinkingTo"),
                                          recursive = TRUE,
                                          reverse = reverse,
                                          verbose = TRUE)
  
  pretty.dep.pkgs <- unlist(lapply(dep.pkgs, function(x) {paste(x, collapse = ", " )}))
  
  return(pretty.dep.pkgs)
}

# Enrich all dependencies = all required packages (full recursion)
deps[, requires := get.deps(Package, avail)]
deps[, required_by := get.deps(Package, avail, reverse = TRUE)]


# "deps" does now contain the result


