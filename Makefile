.PHONY: deploy destroy rebuild tofu-apply tofu-destroy

deploy:
	sudo -v && ansible-playbook ansible/playbook.yml --become

destroy:
	sudo -v && ansible-playbook ansible/cleanup.yml --become

rebuild:
	docker build -t k3d-andreas-frontend:latest frontend && \
	k3d image import k3d-andreas-frontend:latest -c andreas && \
	kubectl rollout restart deployment/frontend -n andreas && \
	kubectl rollout status deployment/frontend -n andreas --timeout=60s

tofu-apply:
	cd tofu && tofu apply -auto-approve \
		-var="postgres_password=$$(grep -E '^POSTGRES_PASSWORD=' ../.env | cut -d= -f2-)" \
		-var="tls_cert_path=$$(cd .. && pwd)/certs/andreas.local.pem" \
		-var="tls_key_path=$$(cd .. && pwd)/certs/andreas.local-key.pem"

tofu-destroy:
	cd tofu && tofu destroy -auto-approve \
		-var="postgres_password=$$(grep -E '^POSTGRES_PASSWORD=' ../.env | cut -d= -f2-)" \
		-var="tls_cert_path=$$(cd .. && pwd)/certs/andreas.local.pem" \
		-var="tls_key_path=$$(cd .. && pwd)/certs/andreas.local-key.pem"
