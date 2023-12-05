<!-- markdownlint-disable-next-line -->
[![CD Pipeline](https://github.com/linuxpolska/ezd-rp/actions/workflows/)](https://github.com/linuxpolska/ezd-rp/actions/workflows/pages/pages-build-deployment)

# The LP Package for EZD RP application!

Set of applications, provided by [Linux Polska](https://linuxpolska.com), ready to launch on Kubernetes using [Kubernetes Helm](https://github.com/helm/helm)..



## Table of content

- [Code of conduct](CODE_OF_CONDUCT.md)
- [License](LICENSE)
- [Troubleshooting](TROUBLESHOOTING.md)
- [Quickstart](quickstart.md)


## Getting Started


The best way to get started is with the ["Quickstart"](quickstart.md)
section in the documentation.


## TL;DR

```bash
helm repo add linuxpolska https://qwiatu-linuxpolska.github.io/ezd/
helm repo update
helm upgrade --install ezd-crd -n default linuxpolska/ezd-crd --wait=true
helm upgrade --install --create-namespace ezd-backend -n ezdrp linuxpolska/ezd-backend --wait=true
```

## Before you begin

### Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

### Setup a Kubernetes Cluster

The quickest way to setup a Kubernetes cluster to install LP Charts is following the "Get Started" guides for the different services:

- [Get Started with LP Charts using RKE2 Kubernetes](https://docs.rke2.io/install/quickstart)

For setting up Kubernetes on other cloud platforms or bare-metal servers refer to the Kubernetes [getting started guide](https://kubernetes.io/docs/getting-started-guides/).

### Install Helm
 
Helm is a tool for managing Kubernetes charts. Charts are packages of pre-configured Kubernetes resources.

To install Helm, refer to the [Helm install guide](https://github.com/helm/helm#install) and ensure that the `helm` binary is in the `PATH` of your shell.

### Using Helm

Once you have installed the Helm client, you can deploy a LP Helm Chart into a Kubernetes cluster.

Please refer to the [Quick Start guide](https://helm.sh/docs/intro/quickstart/) if you wish to get running in just a few commands, otherwise the [Using Helm Guide](https://helm.sh/docs/intro/using_helm/) provides detailed instructions on how to use the Helm client to manage packages on your Kubernetes cluster.

Useful Helm Client Commands:

- Install a chart: `helm install my-release linuxpolska/<chart>`
- Upgrade your application: `helm upgrade my-release linuxpolska/<chart>`

### PV Provisioner

The quickest way to setup CSI is go to [CSI page](https://kubernetes-csi.github.io/docs/drivers.html) 


## Package versioning

In this repository, all packages specify the `version` field in the `package.yaml`. The charts follow this versioning X.Y.P 
X.Y.Z is the upstream chart's major.minor.patch.

The X.Y.P versioning scheme roughly corresponds to the following rules (with exceptions):
- **Major Version**: represents the minor version these charts are being released to.
- **Minor Version**: represents a release line of a given chart within a minor version. Functionality in a backward compatible manner
- **Patch Version**: represents a patch to a given release line of a chart within a minor version. Make backward compatible bug fixes


## Communications

- [Github Discussions](https://github.com/linuxpolska/ezd-rp/discussions)

## Resources

- [Website](https://linuxpolska.com)

