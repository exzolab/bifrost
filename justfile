set dotenv-load := true

# Show help
default:
    @{{ just_executable() }} --list --justfile "{{ justfile() }}"

# Runs ansible-lint against all roles in the playbook
lint:
    @ansible-lint site.yml

# Runs the playbook with the given list of tags on specified hosts
run tags="install-all" hosts="all":
    @ansible-playbook site.yml -l {{ hosts }} --tags "{{ tags }}"
