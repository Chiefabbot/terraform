variable "do_token" {
  type        = string
  description = "Digital ocean acces token"    
}
variable "garrysama_pub_key" {
  type        = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDjlLoZKdvR+Ni2SJ16yoXxfJ/ghzocSkCwmuhK+Vt/Bnelpcgpc+/iFOGZ7RBCU9K3Bw7yPYDM+PKpN1lvnhge98DGmyKz6KsxbB7x09xp93xofBYMsUBJV1QfqrNmKmLldyWSmOhbD/f04o+hsr2pmJr+cuZ1s5qQmaPqHY9CdX52fccd88ZizeSNHdoN5XLZpzSZbxuMyILEhoWYUCm/LGyW75JUY7ZSn39BlAEX/b/tjwKqbJy4oODuDW8fY4VoVJQp1vcIN1+T6ys5Ob1y+EFhnqDVNm4SrjzpUQWGIgvzS1bVbVK/sPj0/yEAkABlF8WGWxCWTQx9s2JWq6SxlUZ9kTJT4JubnLFG+muKOFSYdfJemBPis96M7Vz0rE27t9f//13RxLovyfVLCgvwpchsnafziKM8vZ6I29WlNu+mbsuA4Ll4qbV/zxw6hSIZHGrpdnRw++hH9vls7d/JQR6xKUogmGpjxOSbZxFo1CRfxKhST5/5zBJBKdiKHa0= user@DESKTOP-CFSTPPH"
  description = "ssh key for garrysama@yandex.ru"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key"   
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key"   
}

variable "private_key" {
  type = string
  description = "Path to private key"
  default = "/home/user/.ssh/id_rsa"
}

variable "devs" {
  type    = list(string)
  default = [
    "lb-garrysama" ,
    "app1-garrysama",
    "app2-garrysama"
    ]
}



