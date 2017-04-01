library(devtools)
library(roxygen2)

  folder<-"C:/Users/stubbsrw/Documents/us_counties_stubbs_gitrepo/"
  package_name<-"MapSuite"

# What do you want to do to this package?
  create<-F
  update_documentation<-T
  install_package<-T
  load_package<-T

# Create/initialize package
  if(create){
    if(!dir.exists(paste0(folder,package_name))){
      print("Making the Package")
      setwd(folder)
      create(package_name)
    }else {
      stop("There's already a folder with that name in your working directory/folder designated above.")
    }
  }

# Document the package:
  document(paste0(folder,package_name))

# Install the Package:
  # You will want to install this package into the directory you call all of the other packages from.
  if(install_package){
  setwd(folder)
  install(package_name)
  }

# Load the package
  if(load_package){
  library(MapSuite)
  }