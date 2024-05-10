data "cloudinit_config" "jumpbox_config" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/cloud-config"
    content = file("${path.module}/configure_jumpbox-cloud-init.yml")
  }
}