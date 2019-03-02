start: vagrant_exists checkout_core
	vagrant up opnsense

vagrant_exists:
	@command -v vagrant >/dev/null 2>&1 || { echo >&2 "Please install vagrant https://www.vagrantup.com/downloads.html"; exit 1; }

stop:
	vagrant stop

checkout_core:
	-p mkdir vendor
	( [[ -d vendor/core ]] && cd vendor/core && git pull ) || git clone https://github.com/eugenmayer/core  --single-branch --branch feature/openvpn-ldap-cso-mapping vendor/core

rm:	
	vagrant destroy -f

sync_plugin:
	vagrant rsync
	vagrant ssh -c "cd /root/plugins/net/openvpn && make upgrade"

fetch_dist:
	vagrant scp opnsense:/root/plugins/net/openvpn/work/pkg/'*.txz' ./dist/

install_dependencies:
	brew install xmlstarlet
	chef exec vagrant plugin install vagrant-scp
