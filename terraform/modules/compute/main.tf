
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "${var.vm_name}-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_network_security_group" "nsg" {
  name                = "${var.vm_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "ssh_rule" {
  name                        = "SSH"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}


resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.vm_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = "Standard_B2ms"
  admin_username                  = var.admin_username
  disable_password_authentication = false
  admin_password                  = var.admin_password

  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
resource "null_resource" "install_dependencies" {
  depends_on = [azurerm_linux_virtual_machine.vm]
  triggers = {
    vm_id = azurerm_linux_virtual_machine.vm.id
  }

  connection {
    type     = "ssh"
    host     = azurerm_public_ip.vm_public_ip.ip_address
    user     = var.admin_username
    password = var.admin_password
    timeout  = "5m"
  }

  provisioner "file" {
    source      = "setup_vm_dependencies.sh"
    destination = "/tmp/setup_vm_dependencies.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup_vm_dependencies.sh",
      "sudo /tmp/setup_vm_dependencies.sh"
    ]
  }
}

resource "null_resource" "setup_cluster" {
  depends_on = [null_resource.install_dependencies]
  triggers = {
    vm_id = azurerm_linux_virtual_machine.vm.id
  }

  connection {
    type     = "ssh"
    host     = azurerm_public_ip.vm_public_ip.ip_address
    user     = var.admin_username
    password = var.admin_password
    timeout  = "5m"
  }

  provisioner "file" {
    source      = "preparing_as_minikube_cluster.sh"
    destination = "/tmp/preparing_as_minikube_cluster.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/preparing_as_minikube_cluster.sh",
      "/tmp/preparing_as_minikube_cluster.sh"
    ]
  }
}

# Vm- public IP address
output "vm_public_ip" {
  description = "Public IP of the VM for SSH access"
  value       = azurerm_public_ip.vm_public_ip.ip_address
}
