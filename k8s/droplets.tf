provider "digitalocean" {
  token = var.do_token
}

# Create a new SSH key
resource "digitalocean_ssh_key" "default" {
  name       = "renato-key-ssh"
  public_key = "${file(var.ssh_key)}"
}

resource "digitalocean_droplet" "node01" {
  image    = "ubuntu-18-04-x64"
  name     = "master"
  region   = "nyc3"
  size     = var.droplets_size
  ssh_keys = ["${digitalocean_ssh_key.default.fingerprint}"]

  provisioner "file" {
    source      = "k8s.conf"
    destination = "/etc/modules-load.d/k8s.conf"
  }
  provisioner "file" {
    source      = "install_k8s.sh"
    destination = "/tmp/install_k8s.sh"
  }
  provisioner "file" {
    source      = "install_master_k8s.sh"
    destination = "/tmp/install_master_k8s.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_k8s.sh",
      "/tmp/install_k8s.sh",
      "chmod +x /tmp/install_master_k8s.sh",
      "/tmp/install_master_k8s.sh",
    ]
  }
}

resource "digitalocean_droplet" "node02" {
  image    = "ubuntu-18-04-x64"
  name     = "node02"
  region   = "nyc3"
  size     = var.droplets_size
  ssh_keys = ["${digitalocean_ssh_key.default.fingerprint}"]

  provisioner "file" {
    source      = "k8s.conf"
    destination = "/etc/modules-load.d/k8s.conf"
  }
  provisioner "file" {
    source      = "install_k8s.sh"
    destination = "/tmp/install_k8s.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_k8s.sh",
      "/tmp/install_k8s.sh",
      "modprobe br_filter ip_vs_rr ip_vs_wrr ip_vs_sh nf_contrack_ipv4 ip_vs",

    ]
  }

}

resource "digitalocean_droplet" "node03" {
  image    = "ubuntu-18-04-x64"
  name     = "node03"
  region   = "nyc3"
  size     = var.droplets_size
  ssh_keys = ["${digitalocean_ssh_key.default.fingerprint}"]

  provisioner "file" {
    source      = "k8s.conf"
    destination = "/etc/modules-load.d/k8s.conf"
  }
  provisioner "file" {
    source      = "install_k8s.sh"
    destination = "/tmp/install_k8s.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_k8s.sh",
      "/tmp/install_k8s.sh",
      "modprobe br_filter ip_vs_rr ip_vs_wrr ip_vs_sh nf_contrack_ipv4 ip_vs",

    ]
  }
}
