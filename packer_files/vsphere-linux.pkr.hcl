# Image
source "vsphere-iso" "example" {
  CPUs                 = 1
  RAM                  = 1024
  RAM_reserve_all      = true
  boot_command         = ["<enter><wait><f6><wait><esc><wait>", "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>", "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>", "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>", "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>", "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>", "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>", "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>", "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>", "<bs><bs><bs>", "/install/vmlinuz", " initrd=/install/initrd.gz", " priority=critical", " locale=en_US", " file=/media/preseed.cfg", "<enter>"]
  disk_controller_type = ["pvscsi"]
  #floppy_files         = ["{{template_dir}}/preseed.cfg"]
  guest_os_type        = "ubuntu64Guest"
  host                 = "esxi-1.vsphere65.test"
  insecure_connection  = true
  iso_paths            = ["file:///tmp/ubuntu.iso"]
  password             = "jetbrains"
  ssh_password         = "jetbrains"
  ssh_username         = "jetbrains"
  username             = "root"
  vcenter_server       = "whatsaranjit.com"
  vm_name              = "example-ubuntu"

  network_adapters {
    network_card = "vmxnet3"
  }

  storage {
    disk_size             = 32768
    disk_thin_provisioned = true
  }
}
build {
  sources = ["source.vsphere-iso.example"]
}
