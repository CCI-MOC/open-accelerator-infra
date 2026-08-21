# Hardware and Network Configuration

## Networks

### OAC Networks

|     Network Name    | VLAN ID |      CIDR     |
| ------------------- | ------- | ------------- |
| Prod Infra          | 213     | 10.20.8.0/23 |
| Staging Workload    | 214     | 10.20.10.0/23 |
| Prod Workload       | 216     | 10.20.12.0/23 |
| PureStorage Infra   | 2311    | 10.9.1.0/24   |
| PureStorage Staging | 2312    | 10.9.2.0/24   |
| PureStorage Prod    | 2313    | 10.9.3.0/24   |

### Other Networks

|     Network Name    | VLAN ID |
| ------------------- | ------- |
| IPMI                | 911     |

## Nodes

### R440s

|     Node Name      | Resource Class | IPMI Address | Networking | Purpose                  |
| ------------------ | -------------- | ------------ | ---------- | ------------------------ |
| ?? R440-1 ??       | r440           | 10.3.10.114  | NIC1: 213  | Prod Infra Compute       |
| ?? R440-2 ??       | r440           | 10.3.10.115  | NIC1: 213  | Prod Infra Compute       |
| ?? R440-3 ??       | r440           | 10.3.10.116  | NIC1: 213  | Prod Infra Compute       |

### H100s

TBD

###  Rack R4PAC10

The nodes in rack R4PAC10 have been removed from ESI and dedicated to this project.

|     Node Name      | Resource Class | IPMI Address |      Networking       | Purpose                  |
| ------------------ | -------------- | ------------ | --------------------- | ------------------------ |
| MOC-R4PAC10U37-S1A | fc430          | 10.2.13.191  | NIC1: 213, NIC2: 911  | Bastion                  |
| MOC-R4PAC10U37-S1B | fc430          | 10.2.13.192  |                       |                          |
| MOC-R4PAC10U37-S1C | fc430          | 10.2.13.193  |                       |                          |
| MOC-R4PAC10U37-S1D | fc430          | 10.2.13.194  |                       |                          |
| MOC-R4PAC10U37-S3C | fc430          | 10.2.13.197  | NIC1: 213, NIC2: 2311 | Prod Infra Control Plane |
| MOC-R4PAC10U35-S1A | fc430          | 10.2.13.181  |                       |                          |
| MOC-R4PAC10U35-S1B | fc430          | 10.2.13.182  |                       |                          |
| MOC-R4PAC10U35-S1C | fc430          | 10.2.13.183  |                       |                          |
| MOC-R4PAC10U35-S1D | fc430          | 10.2.13.184  |                       |                          |
| MOC-R4PAC10U35-S3B | fc430          | 10.2.13.186  | NIC1: 213, NIC2: 2311 | Prod Infra Control Plane |
| MOC-R4PAC10U35-S3C | fc430          | 10.2.13.187  |                       |                          |
| MOC-R4PAC10U35-S3D | fc430          | 10.2.13.188  |                       |                          |
| MOC-R4PAC10U33-S1A | fc430          | 10.2.13.171  | NIC1: 213, NIC2: 2311 | Prod Infra Control Plane |
| MOC-R4PAC10U33-S1B | fc430          | 10.2.13.172  |                       |                          |
| MOC-R4PAC10U33-S1C | fc430          | 10.2.13.173  |                       |                          |
| MOC-R4PAC10U33-S1D | fc430          | 10.2.13.174  |                       |                          |
| MOC-R4PAC10U33-S3A | fc430          | 10.2.13.175  |                       |                          |
| MOC-R4PAC10U33-S3B | fc430          | 10.2.13.176  |                       |                          |
| MOC-R4PAC10U33-S3C | fc430          | 10.2.13.177  |                       |                          |
| MOC-R4PAC10U33-S3D | fc430          | 10.2.13.178  |                       |                          |
| MOC-R4PAC10U31-S1A | fc430          | 10.2.13.161  |                       |                          |
| MOC-R4PAC10U31-S1B | fc430          | 10.2.13.162  |                       |                          |
| MOC-R4PAC10U31-S1C | fc430          | 10.2.13.163  |                       |                          |
| MOC-R4PAC10U31-S1D | fc430          | 10.2.13.164  |                       |                          |
| MOC-R4PAC10U31-S3A | fc430          | 10.2.13.165  |                       |                          |
| MOC-R4PAC10U31-S3B | fc430          | 10.2.13.166  |                       |                          |
| MOC-R4PAC10U31-S3C | fc430          | 10.2.13.167  |                       |                          |
| MOC-R4PAC10U31-S3D | fc430          | 10.2.13.168  |                       |                          |
| MOC-R4PAC10U29-S1  | fc830-nvme     | 10.2.13.151  | NIC1: 214, NIC2: 2312 | Staging Workload Compute |
| MOC-R4PAC10U29-S3  | fc830          | 10.2.13.152  | NIC1: 216, NIC2: 2313 | Prod Workload Compute    |
| MOC-R4PAC10U27-S1  | fc830          | 10.2.13.141  | NIC1: 214, NIC2: 2312 | Staging Workload Compute |
| MOC-R4PAC10U27-S3  | fc830          | 10.2.13.142  | NIC1: 216, NIC2: 2313 | Prod Workload Compute    |
| MOC-R4PAC10U25-S1  | fc830          | 10.2.13.131  | NIC1: 214, NIC2: 2312 | Staging Workload Compute |
| MOC-R4PAC10U25-S3  | fc830          | 10.2.13.132  | NIC1: 216, NIC2: 2313 | Prod Workload Compute    |
| MOC-R4PAC10U23-S1  | fc830          | 10.2.13.121  |                       |                          |
| MOC-R4PAC10U23-S3  | fc830          | 10.2.13.122  |                       |                          |
| MOC-R4PAC10U21-S1  | fc830          | 10.2.13.111  |                       |                          |
| MOC-R4PAC10U21-S3  | fc830          | 10.2.13.112  |                       |                          |
| MOC-R4PAC10U19-S1  | fc830          | 10.2.13.101  |                       |                          |
| MOC-R4PAC10U19-S3  | fc830          | 10.2.13.102  |                       | ? RHOSO18 ?              |
| MOC-R4PAC10U17-S3  | fc830          | 10.2.13.92   |                       | ? RHOSO18 ?              |
| MOC-R4PAC10U15-S1  | fc830          | 10.2.13.81   |                       | ? RHOSO18 ?              |
| MOC-R4PAC10U15-S3  | fc830          | 10.2.13.82   |                       | ? RHOSO18 ?              |
| MOC-R4PAC10U13-S1  | fc830          | 10.2.13.71   |                       | ? RHOSO18 ?              |
| MOC-R4PAC10U13-S3  | fc830          | 10.2.13.72   |                       |                          |
| MOC-R4PAC10U11-S1  | fc830          | 10.2.13.61   |                       |                          |
| MOC-R4PAC10U11-S3  | fc830          | 10.2.13.62   |                       |                          |
| MOC-R4PAC10U09-S1  | fc830-nvme     | 10.2.13.51   |                       |                          |
| MOC-R4PAC10U09-S3  | fc830          | 10.2.13.52   |                       |                          |
| MOC-R4PAC10U07-S1  | fc830          | 10.2.13.41   |                       |                          |
| MOC-R4PAC10U07-S3  | fc830          | 10.2.13.42   |                       |                          |
| MOC-R4PAC10U05-S1  | fc830          | 10.2.13.31   |                       |                          |
| MOC-R4PAC10U05-S3  | fc830          | 10.2.13.32   |                       |                          |
| MOC-R4PAC10U03-S1  | fc830          | 10.2.13.21   |                       |                          |
| MOC-R4PAC10U03-S3  | fc830          | 10.2.13.22   |                       |                          |
