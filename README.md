# AWS Pedralbes | Instal·lació Wordpress
## INDEX
Fases:
* Crear security group
* Crear Key Pairs
* Cloud9
* Instal·lar Terraform
* Clonació GIT
* Executar Terraform

---
### Security group


### Key Pairs




### Cloud9
AWS Search Line --> Cloud9 --> Create enviroment

![image](https://hackmd.io/_uploads/H1enpax0a.png)


* Nom --> Els que es vulgui
* Platform --> Ubuntu Server 22.04 LTS
* Connection --> SSH

![image](https://hackmd.io/_uploads/Hk9ECalRa.png)

Open Cloud9 IDE
![image](https://hackmd.io/_uploads/SkbSxRg0p.png)
![image](https://hackmd.io/_uploads/S1J2e0lAa.png)



---
### Credencials AWS
AWS details --> 
AWS CLI
### Instal·lar Terraform
Instal·lem els paquets "gnupg, software-properties-common i curl".

```
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
```

Instal·lem la clau GPG del proveidor HasiCorp.
```
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
```

(Opcional) Verificar clau instal·lada.
```
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
```

Afegim el repositori al nostre sistema.
```
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
```

Actualitzem el nou repositori "hashicorp" i instal·lem Terraform.
```
sudo apt update && sudo apt-get install terraform -y
```

(Opcional) Verifiquem la instal·lació de Terraform
```
terraform -version
```

---

### GIT CLONE


#### AWS Credentials