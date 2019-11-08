# Development environment

Abbreviations used here:
| abbreviation | description |
|--------------|-------------|
| UL | Unix, Local |
| UR | Unix, Remote |
| WL | Windows, Local |
| sash | Streaming At Scale Helpers |

Three operating systems may be involved here: 
- [WL] Windows Local client. I use Windows 10
- [UL] Unix Local Client (I use Windows subsystem for Linux / WSL, Ubuntu)
- [UR] Unix Remote Client - Ubuntu on Azure

Another setup that can also work is
- [UL] Unix Local Client: MacOS
- [UR] Unix Remote Client - Ubuntu on Azure

The code in this folder assume you start from [UL]. 
It will create [UR] and copy the configuration so that you can work from [UR] or [UL].
Tools in [UR] are provided thru the scripts installation. You have to install the tools you need on [UL].

Reasons to work from [UR] or [UL] include:
- tools available (e.g. I don't have docker on [UL])
- power ([UL] can be as a big as your wallet allows)
- Internet access: [UL] is available whereever you are, [UL] has high bandwidth with Internet!

Here is a list of scripts and what you can use them for:
| script | run from | modifies | description |
|--------|----------|----------|-------------|
| `init-config.sh` | [UL] | [UL] | initializes a set of variables from which all others will be derived. Please update default values by going to `$HOME/$homeConfigFolder/config |
| `setup-dev-vm` | [UL] | [UR] | creates [UR] from [UL] |
| `start-dev-vm.sh` | [UL] | [UR] | start the development VM |
| `ssh-dev-vm.sh` | [UL] | | connect to the development VM |
| `stop-dev-vm.sh` | [UL] | [UR] | stop the development VM |
| `config-help-x2go.sh` | [UL] | [WL] | Copies your keys to the configured Windows folder so that you can connect to [UR] thru X2Go |
| `setup-event-hubs-kafka.sh` | [UL] or [UR] | | creates an EventHubs namespace with topics (event hubs) |
| `reset-eventhubskafka-topics.sh` | [UL] or [UR] | | drop/recreates the topics to empty them |
| `delete-event-hubs-kafka.sh` | [UL] or [UR] | | delete the EventHubs namespace |
| `setup-hdInsight-cluster.sh` | [UL] or [UR] | | creates an HDInsight cluster in the same VNet as the development VM |
| `delete-hdInsight-cluster.sh` | [UL] or [UR] | | delete the HDInsight cluster |
| `run-streaming-at-scale-workload.sh` | [UL] or [UR] | | runs selected streaming at scale scenarios |
| `show-streaming-at-scale-aks-web-ui.sh` | [UL] or [UR] | | when a streaming at scale scenario with Azure Kubernetes Services was started, show the Web UI. If [UR] is used, you want to have a UI available as thru an X2Go session |
| `delete-streaming-at-scale-workload.sh` | [UL] or [UR] | | delete the resource group that was created for the streaming at scale scenario |
| `delete-devenv.sh` | [UL] | [UR] | deletes the resource group where the development VM was created |

incl_* scripts are meant to be sourced. They are mainly used from the other scripts.
You may still want to use them from you current session. 

e.g. `source ./incl_init-vars.sh` would provide you with environment variables inside your session.

