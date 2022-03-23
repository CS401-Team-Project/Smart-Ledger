"""
Helper script for managing docker-compose containers.

Options:
1. Stop and Remove Containers
2. Build/Rebuild
3. Create Containers & Start
4. Print Logs
5. Inspect Containers
"""
import pick
from python_on_whales import docker
from functools import partial

def print_containers():
    """
    Print information about containers
    """
    # Print containers
    containers = docker.compose.ps()

    options = []
    for container in containers:
        options.append(container.name)

    title = "Select container to inspect (Enter for all, Space to select multiple):"
    selected = pick.pick(options, title, indicator='+', multiselect=True)

    if len(selected) != 0:
        containers = [containers[i] for name, i in selected]

    if len(containers) == 0:
        print("No containers available")
        return

    for i, container in enumerate(containers):
        print("-" * 80)
        exit_code = f" {container.state.exit_code}" if container.state.status == 'exited' else ''
        print(f"{i + 1}. [{container.state.status.upper()}{exit_code}] "
              f"Name: \"{container.name}\" "
              f"Image: {container.config.image}")
        print(f"\t- ID: {container.id}")
        print(f"\t- Args: {container.args}")
        print(f"\t- Command: {container.config.cmd}")
        print(f"\t- Entrypoint: {container.config.entrypoint}")
        print(f"\t- Working Dir: {container.config.working_dir}")
        print(f"\t- Domain Name: {container.config.domainname}")
        print('\t- Exposed Ports:')
        for port in container.config.exposed_ports:
            print(f"\t\t- {port}")
        print('\t- Volumes:')
        for vol in container.config.volumes:
            print(f"\t\t- {vol}")
        print('\t- Environment:')
        for env in container.config.env:
            print(f"\t\t- {env}")


def down():
    """
    Stop and remove containers
    """
    print("Stop and remove containers, networks, images, and volumes")

    title = "INFO:\n" \
            "Default (Enter):\n" \
            "  - Removes containers for services defined in the Compose file, networks defined in " \
            "the networks section, and the default network, if one is used.\n" \
            "Remove all images:\n" \
            "  - Removes all images used by any service in the docker-compose file\n" \
            "Remove volumes:\n" \
            "  - Removes named volumes declared in the `volumes` section of the Compose file and " \
            "anonymous volumes attached to containers.\n" \
            "Remove orphans:\n" \
            "  - Removes containers for services not defined in the docker-compose file.\n\n" \
            "(Use Enter for Default or Space to select additional options)."

    options = {
        "Remove all images": {
            "remove_images": "all"
        },
        "Remove volumes": {
            "volumes": True
        },
        "Remove orphans": {
            "remove_orphans": True
        }}

    selected = pick.pick(list(options.keys()), title, indicator='+', multiselect=True)

    if len(selected) == 0:
        docker.compose.down()
    else:
        args = {}
        for option, _ in selected:
            args.update(options[option])
        print(args)
        docker.compose.down(**args)


def build():
    """
    Build/Rebuild services
    """
    print("Build or rebuild services")
    docker.compose.build()


def up_detached():
    """
    Start containers in detached state
    """
    print("Up detached")
    docker.compose.up(detach=True)


def rebuild_restart(service_name):
    """
    Rebuild and restart a service
    """
    print(f"Rebuild and restart service: {service_name}")
    docker.compose.build([service_name])
    docker.compose.restart([service_name])


def prune():
    """
    Prune docker
    """
    print("Prune docker")
    docker.system.prune(all=True, volumes=True)


def print_logs():
    """
    Print logs of the containers as a stream
    """
    docker.compose.logs()


def main():
    """
    Main function
    """
    options = {
        "Stop and Remove Containers": down,
        "Build/Rebuild All Images": build,
        "Start All Containers": up_detached,
        "Inspect Containers": print_containers,
        "Logs": print_logs,
        "Prune": prune,
    }

    if docker.compose.is_installed():
        title = f"{docker.compose.version()}\n"
    else:
        title = "WARNING: Docker Compose is not installed.\n"
        title += "See: https://docs.docker.com/compose/install/)\n"

    running_serv = docker.compose.ps()
    if len(running_serv) > 0:
        title += 'CONTAINERS:\n'
        for container in running_serv:
            exit_code = f" {container.state.exit_code}" if container.state.status == 'exited' else ''
            title += f"  [{container.state.status.upper()}{exit_code}] \"{container.name}\"\n"

        for service in docker.compose.config().services:
            options[f"Rebuild & Restart {service.upper()}"] = partial(rebuild_restart, service)

        df = docker.system.disk_free()
        title += "DISK USAGE:\n" + \
                 "  {0:<2} {1:<12} {2: >8} MB {3: >6} MB Reclaimable\n".format(df.images.active,
                                                                               "Images",
                                                                               round(df.images.size * 1e-6, 2),
                                                                               round(df.images.reclaimable * 1e-6, 2)) + \
                 "  {0:<2} {1:<12} {2: >8} MB {3: >6} MB Reclaimable\n".format(df.containers.active,
                                                                               "Containers",
                                                                               round(df.containers.size * 1e-6, 2),
                                                                               round(df.containers.reclaimable * 1e-6, 2)) + \
                 "  {0:<2} {1:<12} {2: >8} MB {3: >6} MB Reclaimable\n".format(df.volumes.active,
                                                                               "Volumes",
                                                                               round(df.volumes.size * 1e-6, 2),
                                                                               round(df.volumes.reclaimable * 1e-6, 2)) + \
                 "  {0:<2} {1:<12} {2: >8} MB {3: >6} MB Reclaimable\n".format(df.build_cache.active,
                                                                               "Build Caches",
                                                                               round(df.build_cache.size * 1e-6, 2),
                                                                               round(df.build_cache.reclaimable * 1e-6, 2))

    else:
        title += "No Containers\n"

    title += "\n"
    title += "What would you like to do? (Use Space to select 1 or more)"

    selected = pick.pick(list(options.keys()), title, indicator='*', multiselect=True, min_selection_count=1)

    print("=" * 80)
    if len(selected) == 0:
        print("Nothing selected")

    for i, (key, _) in enumerate(selected):
        if i != 0:
            print("-" * 60)

        print(f"Running: {key}")
        options[key]()

    print("=" * 80)
    print("Done!")


if __name__ == "__main__":
    main()
