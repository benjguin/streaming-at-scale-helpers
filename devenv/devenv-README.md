# Development environment

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