terraform {
  backend "remote" {
    organization = "galfdata"

    workspaces {
      name = "galf-k3"
    }
  }
}