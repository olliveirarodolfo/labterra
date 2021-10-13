provider "azurerm" {
  version = "2.71.0"
  features {}
  #Set subscription context 
  subscription_id = var.subscription_context
}


#random string function just to generate passwords
resource "random_string" "password_string" {
  length            = 10
  special           = true
  override_special  = "!@#&*()-_+[]{}<>:?"
  min_special       = "2"
  min_lower         = "3"
  min_numeric       = "2"
  min_upper         = "2"
  }
