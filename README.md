# Managing Multiple DVWA Instances with Docker Compose

This project allows you to **deploy** and **remove** multiple instances of **DVWA (Damn Vulnerable Web Application)** on the same machine using **Docker Compose**.

## 🛠️ Prerequisites

Before using this script, make sure you have:

- **Docker** and **Docker Compose** installed on your machine.
- A Unix/Linux system or Windows with WSL.

## 🔄 Installation

Clone this repository or copy the **manage_dvwa.sh** file to your machine.

```bash
git clone https://github.com/0xR4ndom/dvwa-manager.git
cd dvwa-manager
chmod +x manage_dvwa.sh
```

## ⚡ Usage

### 1. Start 10 DVWA Instances

Run the following command to deploy **10 DVWA instances** on your machine with different ports:

```bash
./manage_dvwa.sh start
```

✅ **Expected Result**:
- Each DVWA instance will be available on a different port (e.g., `http://localhost:4280`, `http://localhost:4281`, etc.).
- Each instance will have its own database and network to avoid conflicts.

### 2. Stop and Remove All Instances

If you want to **stop and remove** all DVWA instances, execute:

```bash
./manage_dvwa.sh cleanup
```

✅ **Expected Result**:
- All DVWA containers and databases are stopped and deleted.
- All associated volumes and networks are removed.

## 🔍 Checking Running Instances

To see the running containers:
```bash
docker ps --format "table {{.ID}}	{{.Names}}	{{.Ports}}"
```

To list the associated Docker volumes and networks:
```bash
docker volume ls
docker network ls
```

## ❌ Full Cleanup (Optional)

If you want to remove everything from your machine (including other Docker containers), execute:
```bash
docker system prune -a --volumes
```
💡 **Warning**: This command deletes all Docker containers, images, and volumes on your machine.

## 🔧 Customization

If you want to change the number of instances to deploy, modify the `NUM_INSTANCES` variable in `manage_dvwa.sh`:

```bash
NUM_INSTANCES=5  # To start 5 instances instead of 10
```

## ✨ Contributions

Feel free to propose improvements via **Pull Requests** or report issues through **Issues**.

---
📚 **Author**: [Your Name]  
🛠️ **License**: MIT

