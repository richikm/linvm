variable "location"{
    type = string
    default = "northeurope"
}

variable "address_space" {
    type = list
    default = ["10.0.0.0/16"]
}
variable "address_prefix" {
    type = list
    default = ["10.0.0.0/24"]
}
