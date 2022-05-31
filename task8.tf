provider "random" {
}

resource "random_string" "password" {
  count = length(var.devs)
  length           = 16
  special          = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "_%@"
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "REBRAIN" {
  name = "REBRAIN.SSH.PUB.KEY"
}

resource "digitalocean_ssh_key" "garrysama" {
  name       = "garrysama_at_yandex_ru"
  public_key = var.garrysama_pub_key
}

resource "digitalocean_droplet" "do_droplet" {
    count = length(var.devs)
    image = "ubuntu-20-04-x64"
    name = "${element(local.preffix,count.index)}"
    region = "nyc3"
    size = "s-1vcpu-1gb"
    tags = ["devops","garrysama_at_yandex_ru"]
    ssh_keys = [data.digitalocean_ssh_key.REBRAIN.fingerprint,digitalocean_ssh_key.garrysama.fingerprint]

    provisioner "remote-exec" {
      connection {
        host = self.ipv4_address
        type     = "ssh"
        user     = "root"
        private_key = "${file(var.private_key)}"
      }
      inline = [
        "echo 'root:${element(random_string.password.*.result,count.index)}' | chpasswd",
      ]
  }
}

locals {
  do_droplet_ipv4 = digitalocean_droplet.do_droplet.*.ipv4_address
  suffix = split("\n",replace(join("\n", var.devs),"/\\S+-/",""))
  preffix = split("\n",replace(join("\n", var.devs),"/-\\S+/",""))
}

provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = "eu-west-1"
    }

data "aws_route53_zone" "selected" {
  name         = "devops.rebrain.srwx.net"
  private_zone = false
}

resource "aws_route53_record" "do_droplet_dns" {
    count = length(var.devs)
    zone_id = data.aws_route53_zone.selected.zone_id
    name = "${element(local.suffix,count.index)}-${element(local.preffix,count.index)}.${data.aws_route53_zone.selected.name}"
    type = "A"
    ttl = "300"
    records = ["${element(local.do_droplet_ipv4,count.index)}"]
}

data "template_file" "output" {
  count = length(var.devs)
  template = "${file("${path.module}/out.tpl")}"
  vars = {
    count = "${count.index + 1}"
    fqdns = "${element(aws_route53_record.do_droplet_dns[*].fqdn,count.index)}"
    ip_addrs = "${element(digitalocean_droplet.do_droplet[*].ipv4_address,count.index)}"
    pass = "${element(random_string.password[*].result,count.index)}"      
  }
}

resource "local_file" "output_txt" {
  content  = join("",data.template_file.output.*.rendered)
  filename = "${path.module}/out.txt"
}
