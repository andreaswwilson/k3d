.PHONY: deploy destroy

deploy:
	sudo -v && ansible-playbook ansible/playbook.yml --become

destroy:
	sudo -v && ansible-playbook ansible/cleanup.yml --become
