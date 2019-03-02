start: vagrant_exists checkout_core
	echo "starting our docker ldap service as our auth db"
	docker-compose up -d
	echo "starting opnsense"
	vagrant up opnsense

vagrant_exists:
	@command -v vagrant >/dev/null 2>&1 || { echo >&2 "Please install vagrant https://www.vagrantup.com/downloads.html"; exit 1; }

stop:
	vagrant stop

checkout_core:
	mkdir -p vendor
	( [[ -d vendor/core ]] && cd vendor/core && git pull ) || git clone https://github.com/eugenmayer/core  --single-branch --branch feature/openvpn-ldap-cso-mapping vendor/core

clean:
	vagrant destroy -f

sync:
	vagrant rsync
	# double mount for fixing a bug https://github.com/opnsense/core/issues/3276
	vagrant ssh -c "cd /root/core && (make mount || true ) && make mount"

fetch_dist:
	vagrant scp opnsense:/root/plugins/net/openvpn/work/pkg/'*.txz' ./dist/

install_dependencies:
	brew install xmlstarlet
	chef exec vagrant plugin install vagrant-scp
