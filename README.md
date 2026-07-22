# Open Accelerator Infrastructure

The Open Accelerator (OA) environment will be used to host projects that do not require specific compliance certification. This document represents a high-level view of the infrastructure. See CCI-MOC/moc-issues#301 for a granular task breakdown.

## Project tracking

All issues related to this project live in the [moc-issues repository](https://github.com/CCI-MOC/MOC-issues/issues). You can track the progress of individual components via the [milestones](https://github.com/CCI-MOC/moc-issues/milestones).

## The plan in brief

There are two major phases to our deployment plan:

1. Stage 1 builds -- in this phase, we will be performing preliminary deployments onto ESI-managed hardware. Our goal is to validate (or not) the tooling and architecture presented by RH consulting.

2. Stage 2 builds -- these will be the "production" builds. Hardware will be allocated from the new RHOSO18 environment, if it's available. If RHOSO18 is not available we will use OpenShift's native bare metal support and will manage networking out-of-band.

The goal is to have the stage 2 environment running by September 1.

## Operational standards

As we move forward with this project, we should ensure that everything we do is:

- Automated -- We should ensure that whenever possible our deployment and configuration processes are driven by automated workflows. If there are situations that require manual intervention in order to complete them in a timely fashion, we should document them as problems that need to be corrected in the future.
- Repeatable -- It should be (relatively) easy to tear down and rebuild each component of the infrastructure.
- Reviewed -- There should be at least two sets of eyes (and ideally more) on any configuration or code involved in this project.

## IDP

The identity provider (IDP) for this environment will be a Keycloak instance hosted in AWS.

## DNS

We will use Amazon Route53 as our DNS service for registering new domain records and for responding to ACME DNS-01 challenges. We will rely on the MOC firewall for outbound DNS service.

## Storage

Primary storage will come from the MOC (Ever)Pure storage appliance.

## Secrets

We will be using AWS SecretsManager as our secret store. Whenever possible, utilize authentication mechanisms that do not require storing a static access key id and secret.

## VPN

Internal network ranges will be accessible via the MOC wireguard VPN.

## External network access

For the stage 1 builds, external access will be via ESI-managed floating ips.

For the stage 2 builds, external access will be via either the RHOSO18 environment or the MOC firewall.

## Hosts

### Bastion host

| Description  | Machine type | Count |
| ------------ | ------------ | ----- |
| Bastion host | fc430        | 1     |

While most systems will be directly addressable via the VPN, having a bastion host provides a common location from which to run administrative tooling is convenient. The bastion host will have an interface on the BMC network for access to host management controllers.

## Logging and monitoring

We want:

- To collect hardware, operating system and cluster logs at a central location
- To collection hardware, operating system, and cluster metrics at a central location
- To generate alerts based on log message content or metric values

## Clusters

We will deploy each cluster on a separate VLAN. We will implement appropriate firewall configuration such that managed clusters are able to reach the management cluster, and to expose the console interface for the production cluster on a public endpoint.

### RHOSO Cluster

| Description             | Machine type | Count |
| ----------------------- | ------------ | ----- |
| OpenShift control plane | fc430        | 3     |

The RHOSO cluster will provide the underlying hardware API through which we
manage bare metal nodes and networking in the MOC 2.0 environment.

### Open Accelerator Infra Cluster

| Description             | Machine type | Count |
| ----------------------- | ------------ | ----- |
| OpenShift control plane | r440         | 3     |

The OA infra cluster will run tooling (ACM, ArgoCD) for installing and managing
other clusters. It will host the control planes for clusters deployed using
Hosted Control Planes. We're using the R440s for the infra nodes in order to
provide NVME storage for the hosted `etcd` instances.

#### Special hardware requirements

The compute nodes should have NVME drives for supporting `etcd` for hosted clusters.

### Open Accelerator Production Cluster

| Description             | Machine type | Count |
| ----------------------- | ------------ | ----- |
| OpenShift compute       | fc830        | 3     |
| OpenShift GPU           | h100         | 3     |

The OA production cluster will host Open Accelerator residents.

### Open Accelerator Staging Cluster

| Description             | Machine type | Count |
| ----------------------- | ------------ | ----- |
| OpenShift compute       | fc830        | 3     |

This will be a testing ground for configuration intended for the production cluster.

## Infra notes

We're using the `open-accelerator` project in ESI to acquire hardware for the preliminary cluster installs.
