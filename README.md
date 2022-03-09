# SIEMPack
Opensource SIEM and SOAR solution based on Wazuh and integrated with multiple components and extendable.

## Project Components and Structure
Each component is deployed in a docker container and the diagram below should be explaining how the workflow is done.

![SIEMPack](https://user-images.githubusercontent.com/48027449/157357854-e5dfab73-9113-424b-be4b-579f182ea032.jpg)

# Requirements

The minimum requirements to run the full stack:

| RAM | CPU | Disk |
|------|------|-----|
| 6 GB | 4 Cores | 100 GB |

- It can be used on Ubuntu and Centos operating systems.

# Installation
- First modify **.env** file which stores the credentials of the components and API tokens.
- Each component have its "reverse proxy"  local domain configured in nginx which is located at **nginx** directory.
	- **Kibana dashboard**: dashboard.opcenter.local
	- **TheHive**: main-operation.opcenter.local
	- **Cortex**: cortex.opcenter.local
	- **MISP**: intel.opcenter.local
- Start running `./deploy` script to initiate containers building, It might take some time depends in the resources and network connection.
	- After finishing make sure all containers are in **UP** status
- When the deployment is done you will need to generate API tokens for **MISP** and **Cortex** to be integrated with **TheHive**
	- For example the Generated tokens should be added in `cortex/application.conf` , `thehive/application.conf` for the two components.
