
# NEAR Protocol Validator Node Setup for Microsoft Azure

NEAR Stakewars Episode III challenge 05 contribution

This article is a step-by-step guide on how to create a validator node for NEAR protocol, based on the challenges 01-04 of the [NEAR Stakewars Episode 3](https://github.com/near/stakewars-iii/). The network used is shardnet.

There are two environments that are used in this guide:

1. The actual server where the validator node is running ("node")
2. The machine used to control and manage the node ("manager")

The virtual machine the node is running on is created on Microsoft Azure.

## Create wallet

Using a web browser on the manager, create a new account on the network with a unique id and seed phrase.

### Select a new account id

![screenshot](img/01/01_reserve_account_id.png)

### Choose secret key as security method

![screenshot](img/01/02_choose_security_method.png)

### Secure your account with a passphrase

![screenshot](img/01/03_passphrase.png)

### Verify your passphrase

![screenshot](img/01/04_verify_phrase.png)

### Assert that your wallet has been created

![screenshot](img/01/05_wallet.png)

## Install NEAR command line utility

On the command line on the manager, install the NEAR command line utilities to retrieve information from the network and make calls to smart contracts.

### Install near-cli

![screenshot](img/01/06_install_near-cli.png)

## Executing near-cli commands

### Get proposals for next epoch

![screenshot](img/01/07_near_proposals.png)

### Get current validators

![screenshot](img/01/08_validators_current.png)

### Get validators for next epoch

![screenshot](img/01//09_validators_next.png)

## Create a virtual server on Microsoft Azure

Using a Microsoft Azure account and subscription, create a virtual machine to host the node.

### Load the Azure Dashboard in a web browser

![screenshot](img/02/01_azure_start.png)

### Create a new Linux virtual machine

![screenshot](img/02/02_azure_create_virtual_machine.png)

Set up the virtual machine with the settings displayed in the following screenshot.

![screenshot](img/02/03_azure_new_machine.png)

### Create a new disk

For storing the digital ledger data, create a new disk to connect to the virtual machine.

![screenshot](img/02/04_azure_create_new_disk.png)

Add the disk to the virtual machine setup.

![screenshot](img/02/05_azure_add_disk.png)

### Adjust remaining virtual machine settings

![screenshot](img/02/06_azure_networking.png)

![screenshot](img/02/07_azure_management.png)

![screenshot](img/02/08_azure_advanced.png)

![screenshot](img/02/09_azure_tags.png)

### Review settings and create virtual machine

![screenshot](img/02/10_azure_review_and_create.png)

### 

![screenshot](img/02/11_azure_create.png)

![screenshot](img/02/11_azure_create.png)

### Download the key file used to connect to the virtual machine via ssh

![screenshot](img/02/12_azure_download_key.png)

### Wait until the virtual machine has been created

![screenshot](img/02/13_azure_in_progress.png)

![screenshot](img/02/14_azure_resource_ready.png)

### Go to resource and identify IP of virtual machine

![screenshot](img/02/15_azure_view_resource.png)

### Connect to virtual machine from manager

![screenshot](img/02/16_ssh_into_server.png)

### Check if virtual server supports neard

![screenshot](img/02/17_check_supported.png)

### Install Rust

![screenshot](img/02/18_install_rust.png)

### Install required packages

![screenshot](img/02/19_install_packages.png)

### Mount the disk to hold the digital ledger data

![screenshot](img/02/20_mount_datadrive.png)

### Clone the nearcore repository to get the near source code

![screenshot](img/02/21_get_source_code.png)

### Initialize the working directory

![screenshot](img/02/22_initialize_working_directory.png)

### Open Firewall

For RPC calls, open port 3030 for the virtual machine

![screenshot](img/02/23_azure_nerworking_add_port.png)

![screenshot](img/02/24_azure_add_port.png)

![screenshot](img/02/25_azure_added_port.png)

### Start the neard process

As soon as you start the node it will start downloading headers and blocks. If you stop here the node will act as a regular node, receiving RPC calls. Adding a validator key will turn it into a Validator Node.

![screenshot](img/02/26_start_node.png)

## Add validator key to node

### Login to NEAR shardnet on manager

Since near-cli is only installed on the manager for security reasons, you need to create the `validator_key.json` file on the manager and then copy it securely to the node. 

![screenshot](img/02/28_near_login_for_validator_terminal.png)

![screenshot](img/02/29_near_login_for_validator_key.png)

![screenshot](img/02/30_login.png)

![screenshot](img/02/31_login.png)

![screenshot](img/02/32_logged_in.png)

### Create validator key file

![screenshot](img/02/33_create_file.png)

Create the file as per the screenshot above and then edit it:

- Edit `account_id` => xx.factory.shardnet.near, where xx is your account id name. The account id must match the staking pool contract name or you will not be able to sign blocks.
- Change `private_key` to `secret_key`

File content must be in the following pattern:

```
{
  "account_id": "xxx",
  "public_key": "yyy",
  "secret_key": "zzz"
}
```

### Run node as validator

![screenshot](img/02/34_run_after_installed_validator_key.png)

The node will try to become a validator. The proposal still needs to be triggered by a `ping` call to the staking contract (see below).

### Create service

For your convenience, run `neard` as a `systemd` service. Create a service file and enable and activate the service.

![screenshot](img/02/35_create_service.png)

![screenshot](img/02/36_systemd.png)

![screenshot](img/02/37_system_service.png)

### Check logs

Check the logs using `journalctl`.

![screenshot](img/02/38_journalctl.png)

## Deploy and activate staking contract 

Using near-cli on the manager, deploy a staking contract for your node. Stake some NEAR with it and then activate the Validator seat application process.

### Deploy staking contract

![screenshot](img/03/01_create_smart_contract.png)

### Check that node is listed in the list of validators

You can always check the current state of your validator node in the explorer.

![screenshot](img/03/02_validator_list.png)

### Update reward fee if needed

![screenshot](img/03/03_update_reward_fee.png)

### Stake NEAR with the contract

![screenshot](img/03/04_stake_100_near.png)

### View staked balance

![screenshot](img/03/05_view_staked_balance.png)

### Call ping method to start proposing as validator

![screenshot](img/03/06_ping.png)

To become a validator, your node must meet the following criteria

* The node must be fully synced
* The `validator_key.json` file must be in place
* The contract must be initialized with the `public_key` in `validator_key.json`
* `account_id` in the `validator_key.json` file must be set to the staking pool contract id
* There must be enough delegations to meet the minimum seat price.
* A proposal must be submitted by pinging the contract
* Once a proposal is accepted a validator must wait 2-3 epoch to enter the validator set
* Once in the validator set the validator must produce great than 90% of assigned blocks

## Monitoring and checking node status

### Check node version

![screenshot](img/04/01_check_node_version.png)

### Check produced blocks and chunks

![screenshot](img/04/02_check_produced_blocks.png)

### View delegation info

![screenshot](img/04/03_view_staking_accounts.png)

### View reason for node being kicked out of the validator set

![screenshot](img/04/04_view_kicked_reason.png)

### Show number of produced and expected chunks

![screenshot](img/04/05_get_produced_and_expected_chunks.png)
