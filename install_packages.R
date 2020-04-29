# Install the relevant R packages (and Hugo)

# Change this to TRUE to run the setup process
run_setup <- TRUE

if(run_setup == TRUE) {
  
  # tidyverse & blog down
  install.packages("tidyverse")
  install.packages("blogdown")
  install.packages("kableExtra") #package helps with table customisation 

  # install slumdown from github
  install.packages("remotes")
  remotes::install_github("djnavarro/slumdown")
  
  # to run addins
  install.packages("xtable")
  install.packages("sourcetools")
  install.packages("shiny")
  install.packages("miniUI")
  
  # initial installation of Hugo
  blogdown::install_hugo()
  
}

# load all packages 
library("tidyverse")
library("blogdown")
library("kableExtra")
library("remotes")
library("slumdown")
library("xtable")
library("sourcetools")
library("shiny")
library("miniUI")