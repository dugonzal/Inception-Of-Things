# Inception-of-Things

A configuration-driven, scalable approach to building and operating this stack.

## Index
- [Summary](#summary)
- [Part 1](#part-1)
- [Part 2](#part-2)
- [Part 3](#part-3)
- [Conclusion](#conclusion)

## Summary
This repository contains a configuration-first stack we built to provision a lightweight Kubernetes (K3s) cluster, deploy applications, and optionally extend the platform with additional tooling. The work is split into three main parts (`p1`, `p2`, `p3`) plus optional extras.

We designed the repository to be scalable and maintainable:
- Centralized settings in configuration files (e.g., `p1\confs\config.json` and `p2\confs\config.json`).
- Ruby utilities (`lib\Utils.rb`, `lib\VagrantClusterConfigurator.rb`) that translate configuration into reproducible environments.
- Ansible roles and templates to declaratively define infrastructure and applications.

At a glance:
- `p1`: Base K3s cluster provisioning (Vagrant + Ansible, server/agent roles).
- `p2`: Application deployment via templated Kubernetes manifests (ConfigMap, Deployment, Service, Networking) and structured Ansible roles.
- `p3`: Installation/uninstallation scripts for day‑2 automation and cleanup.

## Part 1
### Goal
Provision a small K3s environment with Vagrant and configure nodes using Ansible (server and agent roles, common setup, connectivity).

### Where to look
- `p1\Vagrantfile`: Base machines and networking.
- `p1\confs\config.json`: Central configuration for cluster topology (node counts, resources, network).
- `p1\scripts\ansible\roles\{server,agent,common}`: Role tasks for installing K3s and preparing nodes.
- `lib\VagrantClusterConfigurator.rb`: Ruby helper that ties config files into the Vagrant provisioning process.

### Usage
Requirements: Vagrant, a supported provider (VirtualBox/Hyper‑V), and Ansible available for provisioning. On Windows, run commands from PowerShell in the repository root or the `p1` folder.

```powershell
# Navigate to Part 1
cd p1

# Adjust the configuration as needed
# Edit p1\confs\config.json to match your desired topology

# Bring up the environment
vagrant up

# Re-apply provisioning if needed
vagrant provision
```

### Scalability notes
`p1` reads from `config.json` and uses Ruby utilities to render the final setup. Scale the cluster up/down or tweak network and resources without rewriting code.

## Part 2
### Goal
Extend the cluster with application deployment using Ansible templates for Kubernetes manifests, following the same configuration‑driven approach.

### Where to look
- `p2\Vagrantfile` and `p2\confs\config.json`: Environment definition and customizable parameters.
- `p2\scripts\ansible\roles\server`: K3s installation and kubeconfig setup.
- `p2\scripts\ansible\roles\application`: Templated Kubernetes resources (`templates\*.j2`) and tasks to apply them (`tasks\*.yml`).
- `p2\scripts\ansible\inventory` and `group_vars`: Structured inventory for multi-node deployments.

### Usage
Requirements: Same as Part 1.

```powershell
# Navigate to Part 2
cd p2

# Adjust configuration and variables as needed
# Edit p2\confs\config.json and inventory/group_vars (e.g., app name, image, ports)

# Bring up the environment
vagrant up

# Re-apply provisioning if needed (applies application resources via Ansible roles)
vagrant provision
```

### Scalability notes
Application manifests are generated from Jinja2 templates using variables defined in Ansible vars files and `config.json`. Change images, replicas, ports, and labels across environments without editing raw YAML.

## Part 3
### Goal
Provide a thin layer of scripts to install or uninstall higher-level components in the cluster lifecycle.

### Where to look
- `p3\scripts\install.sh` and `p3\scripts\uninstall.sh`: Entry points for installing/uninstalling added components or demo applications.

### Usage
Run the scripts from a context that can reach your cluster (e.g., inside a provisioned control node or from your host if configured). Adjust any required environment variables before executing.

```bash
# Example (Linux/macOS shell); adapt for your environment
bash p3/scripts/install.sh
# ...later
bash p3/scripts/uninstall.sh
```

## Conclusion
This project is structured to be scalable through configuration files and Ruby utilities. By separating configuration (JSON and Ansible vars) from logic (Ruby helpers, Vagrantfiles, Ansible roles), we can:
- Reuse the same codebase for different topologies and environments.
- Adjust node counts, resources, and application parameters via config files.
- Layer additional components (via Helm/Helmfile) without rewriting manifests.

The result is a maintainable, real‑world infrastructure‑as‑code setup that is easy to operate and extend.
