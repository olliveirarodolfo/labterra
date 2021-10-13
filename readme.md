<h1 align="center">Azure terraform provisioning</h1>

<p align="center">Terraform infraestructure provisiong for Azure</p>

<h1 align="center">
    <a </a>
</h1>
<p align="center">🚀 This terraform codes creates the following Azure components:</p>

 <a href="#VMinstance">- Azure VM instances</a> </br>
 <a href="#Appgw">- Azure Application gateway</a> </br> 
 <a href="#Network">- Azure Virtual Network</a> </br>
 <a href="#VMSS">- Azure VM Scale Sets</a> </br>
 <a href="#DNSNSG">- NSGs and DNS zone</a> </br>
 <a href="#shell">- Shell script</a> </br>
 <a href="#shell">- Topology</a> 

 <a id="VMinstance">
Azure VM instances
====
</a>

The code app2.tf creates to virtual machines based on the variables defined at terraform.tfvars. All dependencies to create de VMs are defined and controled by depends on dependency controller. The VM uses the random_string function to generate passwords.

 <a id="Appgw">
Azure Application gateway
====
</a>
The Application gateway has two pools of resources, the fisrt pool consists of a Linux VMSS with a austoscale rule. the second pool consists of two VMs. The application gateway uses the path based rules to direct the traffic based on the url paths /app1 and /app2. The appgw.tf 

 <a id="Network">
Azure Virtual Network 
=
</a>
A VNET with three  subnets are provisioned to the subscription. They are defined at network.tf file.

 <a id="VMSS">
Virtual machine scale set.
====
</a>
A Linux virtual machine scale set are deployed and provisioned with app1.sh script. The VMSS has a simple autoscale rule based on CPU threshold. all VMSS definitions are under app1.tf file.

 <a id="DNSNSG">
NSGs and DNS 
====
</a>
All zone information and NSGs are defined under nsgs.tf and dns.tf respectively. The DNS zone and NSGs were put together with network resource group.

<a id="shell">
Shell script
==== 
</a>
The folders app1 and app2 has a shell script to provision the applications (apache server and php) for DB server and APP servers. The VMs and VMSS uses the Azure Script Extension in order to run the shell script.

<a id="shell">
Topology
==== 
</a>
<img src="https://raw.githubusercontent.com/olliveirarodolfo/labterra/main/topology.PNG"></img>
