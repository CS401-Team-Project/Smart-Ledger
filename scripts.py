from python_on_whales import docker
from pick import pick


def build():
    docker.compose.build()


def start():
    docker.compose.up()


def start_detached():
    docker.compose.up(detach=True)


options = {
    "Build": build,
    "Start": start,
    "Start Detached": start_detached
}

title = "What would you like to do?"

selected = pick(list(options.keys()), title, indicator='*', multiselect=True)

for key, index in selected:
    print("=" * 60)
    print(f"Running: {key}")
    options[key]()


list_of_containers = docker.compose.ps()
print(list_of_containers)
