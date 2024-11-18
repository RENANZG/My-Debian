# Installing Go (OSX)

**Description:** This entry describes how to install and configure Go on OSX

**Requirements:** brew (optional)

## Installation

* Install [Go](https://go.dev/doc/install)
* Install [Go All releases](https://go.dev/dl/)

```
$ sudo apt update && sudo apt upgrade
$ wget https://go.dev/dl/linux
$ sudo tar -C /usr/local -xzf *.tar.gz

```

Install golang using brew

```
echo "export PATH=/usr/local/go/bin:${PATH}" | sudo tee -a $HOME/.profile
source $HOME/.profile
go version
```

## References
* [Get Started](https://go.dev/learn/)
* [Go documentation](https://go.dev/doc/)
